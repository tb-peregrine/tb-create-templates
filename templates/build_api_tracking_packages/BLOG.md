# Build a Real-time Package Tracking API with Tinybird

Tracking packages across different carriers and understanding their delivery statuses in real-time can be a complex data engineering challenge. This tutorial will guide you through creating a real-time package tracking API that provides current status information, full delivery history, and carrier performance analytics. We'll use Tinybird, a data analytics backend for software developers. Tinybird helps you build real-time analytics APIs without the hassle of setting up or managing the underlying infrastructure. It leverages data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) to ingest, transform, and serve your data through fast, scalable APIs. By the end of this tutorial, you'll know how to ingest package tracking data, transform this data to derive meaningful insights, and publish APIs that allow real-time tracking of packages. Let's get started. ## Understanding the data

Imagine your data looks like this:

```json
{"package_id": "PKG-3556", "event_timestamp": "2025-05-06 05:45:57", "status": "Picked up", "location": "Miami, FL", "carrier": "UPS", "notes": "Package in transit to next facility", "updated_by": "agent_856"}
{"package_id": "PKG-2603", "event_timestamp": "2025-04-28 22:45:57", "status": "In transit", "location": "Houston, TX", "carrier": "DHL", "notes": "No additional notes", "updated_by": "agent_803"}
... ```

This data represents package delivery events from different carriers. Each event includes a unique package ID, timestamp of the event, status, location, carrier, notes on the event, and who updated the event. To store this data in Tinybird, we create a data source designed to efficiently query and manage the delivery events. Here's how you define the `package_events` data source in Tinybird:

```json
DESCRIPTION >
    Stores package delivery events with status updates

SCHEMA >
    `package_id` String `json:$.package_id`,
    `event_timestamp` DateTime `json:$.event_timestamp`,
    `status` String `json:$.status`,
    `location` String `json:$.location`,
    `carrier` String `json:$.carrier`,
    `notes` String `json:$.notes`,
    `updated_by` String `json:$.updated_by`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(event_timestamp)"
ENGINE_SORTING_KEY "package_id, event_timestamp"
```

In this schema, we've chosen types and keys to optimize query performance. The `ENGINE_SORTING_KEY` on `package_id` and `event_timestamp` allows for efficient filtering and ordering of package events. To ingest data into this data source, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) enables streaming of JSON/NDJSON events from your application frontend or backend with a simple HTTP request. It's designed for real-time, low latency ingestion. Here's how you can ingest data into the `package_events` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=package_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
        "package_id": "PKG12345678", 
        "event_timestamp": "2023-11-23 14:30:00", 
        "status": "in_transit", 
        "location": "Chicago Distribution Center", 
        "carrier": "UPS", 
        "notes": "Package processed at sorting facility", 
        "updated_by": "system"
    }'
```

For event/streaming data, the Kafka connector is also an option that offers benefits like robust integration with existing Kafka pipelines. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector facilitate bulk ingestion. ## Transforming data and publishing APIs

Tinybird transforms data through pipes, which can perform batch transformations or real-time transformations, and even publish these transformations as API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). ### Real-time status and history APIs

Let's start with the `package_status` endpoint, which retrieves the most recent status of a package:

```sql
DESCRIPTION >
    Get the current status of a package by its ID

NODE package_status_node
SQL >
    SELECT 
        package_id,
        argMax(status, event_timestamp) as current_status,
        argMax(location, event_timestamp) as current_location,
        argMax(event_timestamp, event_timestamp) as last_updated,
        carrier
    FROM package_events
    WHERE package_id = {{String(package_id, '')}}
    GROUP BY package_id, carrier

TYPE endpoint
```

This SQL query uses `argMax` to find the latest status and location based on the `event_timestamp`. The `{{String(package_id, '')}}` is a parameter that allows you to query the API with a specific package id. To get the full history of a package's updates, the `package_history` pipe looks like this:

```sql
DESCRIPTION >
    Get the full history of a package's status updates

NODE package_history_node
SQL >
    SELECT 
        package_id,
        event_timestamp,
        status,
        location,
        carrier,
        notes,
        updated_by
    FROM package_events
    WHERE package_id = {{String(package_id, '')}}
    ORDER BY event_timestamp DESC

TYPE endpoint
```

The SQL query simply orders the events by `event_timestamp` in descending order, providing a complete timeline of the package's journey. ### Carrier performance summary

The `carrier_status_summary` endpoint aggregates delivery statuses by carrier:

```sql
DESCRIPTION >
    Get a summary of package delivery statuses by carrier

NODE carrier_status_summary_node
SQL >
    SELECT 
        carrier,
        status,
        count() as package_count
    FROM (
        SELECT 
            package_id,
            carrier,
            argMax(status, event_timestamp) as status
        FROM package_events
        {% if defined(carrier) %}
        WHERE carrier = {{String(carrier, 'all')}}
        {% end %}
        GROUP BY package_id, carrier
    )
    GROUP BY carrier, status
    ORDER BY carrier, package_count DESC

TYPE endpoint
```

This pipe demonstrates the use of conditional templating (`{% if defined(carrier) %}`) to optionally filter results by a specific carrier. To call these APIs, you can use the `curl` command with the appropriate parameters:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/package_status.json?token=$TB_ADMIN_TOKEN&package_id=PKG12345678"
```


## Deploying to production

Deploying your Tinybird project to production is straightforward with the `tb --cloud deploy` command. This command creates scalable, production-ready API endpoints in the Tinybird Cloud. Here's an example:

```bash
tb --cloud deploy
```

Tinybird manages resources as code, making it easy to integrate with CI/CD pipelines for automated deployments. Furthermore, token-based authentication secures your APIs. Here's how you might call a deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/package_status.json?token=YOUR_PRODUCTION_TOKEN&package_id=PKG12345678"
```


## Conclusion

This tutorial walked you through setting up a real-time package tracking API using Tinybird. We covered how to ingest event data, transform it through pipes, and publish APIs for tracking package status, history, and carrier performance. Tinybird enables developers to build and deploy real-time data APIs at scale, without worrying about infrastructure. Whether you're handling package tracking or any other real-time data use case, Tinybird provides the tools you need to deliver fast, reliable insights. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.