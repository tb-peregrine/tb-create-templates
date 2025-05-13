# Build a Real-Time Shipment Tracking API with Tinybird

Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. In this tutorial, you'll learn how to leverage Tinybird to create a real-time API for tracking shipments, including insights into shipment statuses, late deliveries, and product-specific shipment summaries. By employing Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), you'll be able to handle and analyze shipment data and product information efficiently, enabling you to expose this data through scalable APIs. 

## Understanding the data

Imagine your data looks like this:

```json
{"shipment_id": "SHIP-12749", "product_id": "PROD-3749", "origin_location": "New York", "destination_location": "San Francisco", "quantity": 426, "shipment_timestamp": "2025-03-24 16:53:37", "estimated_delivery_timestamp": "2025-05-31 16:53:37", "actual_delivery_timestamp": "2025-06-10 16:53:37", "status": "Cancelled"}
```

This sample represents a shipment from New York to San Francisco that was unfortunately cancelled. You'll store this data in Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), which are essentially tables optimized for real-time analytics. To begin, you'll create two data sources in Tinybird: `product_catalog` and `raw_shipments`. Here's how you define the `product_catalog` data source:

```json
DESCRIPTION >
    Product catalog with product details. SCHEMA >
    `product_id` String `json:$.product_id`,
    `product_name` String `json:$.product_name`,
    `category` String `json:$.category`,
    `unit_price` Float32 `json:$.unit_price`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "category"
ENGINE_SORTING_KEY "product_id"
```

And the `raw_shipments` data source:

```json
DESCRIPTION >
    Raw shipment data ingested from a source like Kafka or S3. SCHEMA >
    `shipment_id` String `json:$.shipment_id`,
    `product_id` String `json:$.product_id`,
    `origin_location` String `json:$.origin_location`,
    `destination_location` String `json:$.destination_location`,
    `quantity` UInt32 `json:$.quantity`,
    `shipment_timestamp` DateTime `json:$.shipment_timestamp`,
    `estimated_delivery_timestamp` DateTime `json:$.estimated_delivery_timestamp`,
    `actual_delivery_timestamp` DateTime `json:$.actual_delivery_timestamp`,
    `status` String `json:$.status`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(shipment_timestamp)"
ENGINE_SORTING_KEY "shipment_timestamp, product_id, origin_location, destination_location"
```

These schemas highlight thoughtful design choices, such as using the MergeTree engine for efficient querying and sorting keys to optimize query performance. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This feature is crucial for real-time data processing, offering low latency. Here's how you'd send data to the `raw_shipments` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=raw_shipments&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"shipment_id":"shipment456","product_id":"product123","origin_location":"New York","destination_location":"Los Angeles","quantity":10,"shipment_timestamp":"2024-01-01 10:00:00","estimated_delivery_timestamp":"2024-01-05 18:00:00","actual_delivery_timestamp":"2024-01-05 17:00:00","status":"Delivered"}'
```

Additionally, for event or streaming data, you might consider using the Kafka connector for its robustness, and for batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector are valuable. 

## Transforming data and publishing APIs

Tinybird's pipes are at the heart of data transformation and API publication. They allow for batch transformations, real-time transformations, and creating API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Let's dive into the endpoints you'll be creating. 

### Late shipments

The `late_shipments` endpoint identifies shipments delivered past their estimated delivery date:

```sql
DESCRIPTION >
    Endpoint to get a list of late shipments. NODE late_shipments_node
SQL >
    SELECT
        shipment_id,
        product_id,
        origin_location,
        destination_location,
        estimated_delivery_timestamp,
        actual_delivery_timestamp
    FROM raw_shipments
    WHERE actual_delivery_timestamp > estimated_delivery_timestamp

TYPE endpoint
```

The SQL logic is straightforward: it selects shipments where the actual delivery timestamp is later than the estimated one. 

### Shipment status counts

Next, the `shipment_status_counts` endpoint:

```sql
DESCRIPTION >
    Endpoint to get the count of shipments by status. NODE shipment_status_counts_node
SQL >
    SELECT
        status,
        count() AS shipment_count
    FROM raw_shipments
    GROUP BY status

TYPE endpoint
```

This pipe groups shipments by their status and counts them, useful for quickly assessing the overall distribution of shipment states. 

### Product shipment summary

Finally, the `product_shipment_summary` endpoint provides detailed summaries:

```sql
DESCRIPTION >
    Endpoint to get shipment summary by product. NODE product_shipment_summary_node
SQL >
    SELECT
        rs.product_id,
        pc.product_name,
        pc.category,
        sum(rs.quantity) AS total_quantity_shipped,
        count() AS total_shipments,
        avg(rs.actual_delivery_timestamp - rs.shipment_timestamp) AS avg_delivery_time
    FROM raw_shipments rs
    JOIN product_catalog pc ON rs.product_id = pc.product_id
    WHERE pc.category = {{String(product_category, "Electronics")}}
    GROUP BY rs.product_id, pc.product_name, pc.category

TYPE endpoint
```

By joining the `raw_shipments` and `product_catalog` data sources, this endpoint calculates the total quantity shipped, total shipments, and average delivery time for products, optionally filtered by category. 

## Deploying to production

To deploy these resources to the Tinybird Cloud, use the Tinybird CLI:

```bash
tb --cloud deploy
```

This command prepares your data sources and pipes, making them ready for scalable, real-time access. Tinybird manages these resources as code, facilitating integration with CI/CD pipelines and ensuring your data analytics backend is production-ready. To secure your APIs, Tinybird employs token-based authentication. Here's how you might call the deployed `late_shipments` endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/late_shipments.json?token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, you've built a real-time shipment tracking API using Tinybird, covering data ingestion, transformation, and API publication. Tinybird empowers developers to handle real-time data analytics at scale, without the overhead of managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.