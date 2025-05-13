# Build a Real-Time Restaurant Reservation Analytics API with Tinybird

Managing a restaurant's reservations efficiently requires a deep understanding of patterns and trends within the reservation data. Whether it's identifying the busiest hours, tracking the status of reservations, or optimizing staffing based on guest volume, having access to real-time analytics can significantly improve operations. This tutorial will guide you through building a real-time API to analyze restaurant reservation patterns using Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), we can ingest, transform, and serve real-time analytics through powerful APIs. Let's dive into how we can utilize Tinybird to create an API for restaurant reservation analytics, covering data ingestion, transformation, and API publication. 

## Understanding the data

Imagine your data looks like this:

```json
{"reservation_id": "res_40575", "restaurant_id": "rest_26", "customer_id": "cust_575", "reservation_time": "2025-05-15 16:46:43", "party_size": 12, "status": "confirmed", "created_at": "2025-04-18 18:46:43", "special_requests": "", "table_number": "6"}
```

This data includes essential details about restaurant reservations, such as reservation ID, restaurant ID, customer ID, reservation time, party size, status, and more. To store and query this data efficiently, we need to create a Tinybird data source. Here's how you define the `reservations` data source in Tinybird:

```json
DESCRIPTION >
    Stores restaurant reservation data including customer information, reservation time, and party size

SCHEMA >
    `reservation_id` String `json:$.reservation_id`,
    `restaurant_id` String `json:$.restaurant_id`,
    `customer_id` String `json:$.customer_id`,
    `reservation_time` DateTime `json:$.reservation_time`,
    `party_size` UInt8 `json:$.party_size`,
    `status` String `json:$.status`,
    `created_at` DateTime `json:$.created_at`,
    `special_requests` String `json:$.special_requests`,
    `table_number` String `json:$.table_number`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(reservation_time)"
ENGINE_SORTING_KEY "restaurant_id, reservation_time"
```

This schema defines the structure and types of the data we're ingesting, with thoughtful considerations for query performance, such as partitioning by month (`toYYYYMM(reservation_time)`) and sorting by `restaurant_id` and `reservation_time`. To ingest data into this data source, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) is a perfect fit for streaming JSON/NDJSON events from your application frontend or backend with a simple HTTP request. It's designed for low latency and real-time data ingestion:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=reservations&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "reservation_id": "res12345",
       "restaurant_id": "rest123",
       "customer_id": "cust789",
       "reservation_time": "2023-05-15 19:30:00",
       "party_size": 4,
       "status": "confirmed",
       "created_at": "2023-05-10 14:22:00",
       "special_requests": "Window table preferred",
       "table_number": "A12"
     }'
```

For different ingestion needs, Tinybird also supports Kafka connectors for event/streaming data, and [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connectors for batch/file data. 

## Transforming data and publishing APIs

Once our data is ingested into Tinybird, we can create pipes to transform this data and publish APIs to expose real-time analytics. 

### Batch Transformations and Real-time Transformations

Tinybird pipes allow for both batch and real-time transformations. Batch transformations are ideal for processing historical data, while real-time transformations, such as [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), are perfect for continuously updating data based on incoming streams. 

### Creating API Endpoints

To expose our analytics as APIs, we define endpoint pipes in Tinybird. Here's an example of a pipe that shows daily occupancy patterns for a restaurant:

```sql
DESCRIPTION >
    Shows daily occupancy patterns for a restaurant, with the total reservations and guests by day

NODE restaurant_daily_occupancy_node
SQL >
    %
    SELECT 
        restaurant_id,
        toDate(reservation_time) AS date,
        count() AS total_reservations,
        sum(party_size) AS total_guests,
        max(party_size) AS largest_party
    FROM reservations
    WHERE 
        restaurant_id = {{String(restaurant_id, 'rest123')}}
        {% if defined(start_date) %}
        AND toDate(reservation_time) >= {{Date(start_date, '2023-01-01')}}
        {% end %}
        {% if defined(end_date) %}
        AND toDate(reservation_time) <= {{Date(end_date, '2023-12-31')}}
        {% end %}
        AND status = 'confirmed'
    GROUP BY restaurant_id, date
    ORDER BY date DESC

TYPE endpoint
```

This pipe calculates the total reservations, guests, and the largest party size for each day, grouping and sorting the results accordingly. It uses a templating logic for flexible date filtering, making the API adaptable to different query requirements. To call this API, use the following curl command:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/restaurant_daily_occupancy.json?token=%24TB_ADMIN_TOKEN&restaurant_id=rest123&start_date=2023-01-01&end_date=2023-12-31&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Deploying to production

Deploying your Tinybird project to production is straightforward with the `tb --cloud deploy` command. This command deploys all your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes to the Tinybird Cloud, making your APIs accessible and scalable. Tinybird treats your data analytics resources as code, allowing for seamless integration with CI/CD pipelines and ensuring that your analytics backend is version-controlled and reproducible. For securing your APIs, Tinybird employs token-based authentication. Here's an example of calling a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/restaurant_daily_occupancy.json?token=%24TB_PROD_TOKEN&restaurant_id=rest123&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

By following this tutorial, you've learned how to ingest, transform, and publish real-time analytics APIs for restaurant reservation data using Tinybird. This solution enables efficient management of reservations, helping restaurants optimize their operations and improve customer service. The technical benefits of using Tinybird for this use case include real-time data analytics, scalable API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), and streamlined deployment and security practices. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Tinybird is free to start, with no time limit and no credit card required.