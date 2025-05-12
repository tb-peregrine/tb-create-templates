# Build a Real-Time Energy Consumption Tracking API with Tinybird

Tracking and analyzing energy consumption across different devices and locations is crucial for optimizing energy usage and reducing costs. In this tutorial, we'll walk through building an API that helps monitor energy consumption patterns by device, leveraging Tinybird. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By the end of this tutorial, you'll have a scalable, real-time API ready to provide insights into energy consumption trends. ## Understanding the data

Imagine your data looks like this:

```json
{"timestamp": "2025-04-30 10:11:21", "device_id": "device_7", "energy_consumed": 3106278102, "location": "Living Room"}
{"timestamp": "2025-04-19 09:13:16", "device_id": "device_2", "energy_consumed": 906623972, "location": "Living Room"}
... ```

This data represents energy consumption readings collected from various devices, detailing when the reading was taken (`timestamp`), the device identifier (`device_id`), the amount of energy consumed (`energy_consumed`), and the device's location (`location`). To store this data, we'll create a Tinybird datasource. The schema for our `energy_consumption` datasource looks like this:

```json
DESCRIPTION >
    This datasource stores energy consumption data for various devices. SCHEMA >
    `timestamp` DateTime `json:$.timestamp`,
    `device_id` String `json:$.device_id`,
    `energy_consumed` Float64 `json:$.energy_consumed`,
    `location` String `json:$.location`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, device_id"
```

In this schema, we've chosen types that best represent our data, such as `DateTime` for timestamps and `Float64` for energy consumption values. The sorting key is set to `timestamp` and `device_id`, optimizing query performance by timestamp and device. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request, offering real-time data updates with low latency. Here's how you can ingest data into the `energy_consumption` datasource:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=energy_consumption" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-11-15 08:30:00",
       "device_id": "device_123",
       "energy_consumed": 0.75,
       "location": "kitchen"
     }'
```

Additionally, for event/streaming data, the Kafka connector can be used for benefits like higher throughput and fault tolerance. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector are recommended. These methods ensure efficient data ingestion into Tinybird, suitable for various use cases. ## Transforming data and publishing APIs

In Tinybird, pipes are used for transforming data and publishing APIs. Pipes can perform batch transformations, create real-time [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views), and serve as API endpoints. ### Batch transformations and materialized views

For our project, we'll focus on the API endpoint. However, if materialized views were used, they would optimize the data pipeline by pre-aggregating data, significantly speeding up query performance. ### API endpoint

The API endpoint we're creating is designed to calculate the total energy consumption for each device. The complete pipe code for our endpoint, `energy_consumption_by_device`, looks like this:

```sql
DESCRIPTION >
    Calculates the total energy consumption for each device. NODE energy_consumption_by_device_node
SQL >
    SELECT
        device_id,
        SUM(energy_consumed) AS total_energy_consumed
    FROM energy_consumption
    GROUP BY device_id

TYPE endpoint
```

This SQL query groups the data by `device_id` and calculates the total energy consumed using `SUM(energy_consumed)`. By setting the `TYPE` to `endpoint`, Tinybird exposes this transformation as an API endpoint, enabling us to query the total energy consumption by device in real-time. Here's an example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes)/energy_consumption_by_device.json?token=$TB_ADMIN_TOKEN"
```

This call returns a JSON response listing each device and its total energy consumption, providing valuable insights into which devices are the most energy-intensive. ## Deploying to production

To deploy your project to Tinybird Cloud, use the following command:

```bash
tb --cloud deploy
```

This command deploys your datasources and pipes, making your API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) production-ready and scalable. Tinybird manages these resources as code, allowing for integration with CI/CD pipelines and ensuring a smooth deployment process. For securing your APIs, Tinybird uses token-based authentication. Here's an example of how to call your deployed endpoint:

```bash
curl -X GET "https://api.tinybird.co/v0/pipes/energy_consumption_by_device.json?token=$TB_PROD_TOKEN"
```


## Conclusion

In this tutorial, we've built a real-time API for tracking and analyzing energy consumption across various devices and locations using Tinybird. We've covered everything from data ingestion and schema design to creating and deploying API endpoints. Tinybird's capabilities enable developers to quickly implement scalable, real-time analytics without managing infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. With a free-to-start model, no time limit, and no credit card required, it's the perfect platform to bring your real-time data applications to life.