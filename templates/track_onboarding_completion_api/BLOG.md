# Build a User Onboarding Analytics API with Tinybird

Tracking and analyzing user onboarding flows is crucial for improving user experience and engagement. Whether you're looking to understand step completion rates or identify bottlenecks within your onboarding funnel, having the right tools and processes can significantly streamline these efforts. In this tutorial, we'll dive into how to leverage Tinybird, a data analytics backend for software developers, to build a highly efficient, real-time analytics API focused on user onboarding analytics. Tinybird allows you to build real-time analytics APIs without having to worry about setting up or managing the underlying infrastructure, making it an ideal choice for developers looking to implement scalable data solutions quickly. We'll cover how to create data sources for storing user events, transform this data into insightful metrics, and finally, how to deploy these transformations as API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints). By the end of this tutorial, you'll have a working analytics API that can track user progress through onboarding steps, calculate completion rates, and provide insights into the overall onboarding funnel performance. ## Understanding the data

Imagine your data looks like this:

```json
{
  "user_id": "user_345",
  "step_id": "step_1",
  "step_name": "Profile Creation",
  "completed": 1,
  "timestamp": "2025-05-07 00:56:30"
}
```

This record represents a single event where a user has completed a step in the onboarding process. To store and query this data efficiently, we'll create two Tinybird [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources): `onboarding_steps` and `user_onboarding_events`. ### Creating data sources

For `onboarding_steps`, we define a schema that includes step IDs, names, descriptions, their sequence in the onboarding process, and whether each step is required. Here's how you can define it in a `.datasource` file:

```json
{
  "DESCRIPTION": "Reference table for all onboarding steps with their sequence and details",
  "SCHEMA": [
    {"name": "step_id", "type": "String"},
    {"name": "step_name", "type": "String"},
    {"name": "step_description", "type": "String"},
    {"name": "step_order", "type": "UInt16"},
    {"name": "is_required", "type": "UInt8"}
  ],
  "ENGINE": "MergeTree",
  "ENGINE_SORTING_KEY": "step_order, step_id"
}
```

For `user_onboarding_events`, the schema captures user IDs, the steps completed, and the timestamp of each event:

```json
{
  "DESCRIPTION": "Stores user onboarding events with step completion data",
  "SCHEMA": [
    {"name": "user_id", "type": "String"},
    {"name": "step_id", "type": "String"},
    {"name": "step_name", "type": "String"},
    {"name": "completed", "type": "UInt8"},
    {"name": "timestamp", "type": "DateTime"}
  ],
  "ENGINE": "MergeTree",
  "ENGINE_PARTITION_KEY": "toYYYYMM(timestamp)",
  "ENGINE_SORTING_KEY": "user_id, step_id, timestamp"
}
```


### Data ingestion

Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency make it ideal for tracking user interactions as they occur. Here's an example of how you can send data to the `user_onboarding_events` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_onboarding_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{"user_id":"u123","step_id":"welcome","step_name":"Welcome Step","completed":1,"timestamp":"2023-09-01 14:30:00"}'
```

For different types of data ingestion:
- **Event/streaming data:** The Kafka connector can be used for high-volume event streams, offering robust integration with existing Kafka pipelines. - **Batch/file data:** The [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector facilitate batch uploads, suitable for historical data or bulk ingestion tasks. ## Transforming data and publishing APIs

Tinybird transforms data through "pipes," which can execute batch transformations, real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views)), and serve as API endpoints. ### Batch transformations and real-time transformations

Assuming we've set up materialized views within our [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) to optimize query performance, here's an example:

```sql
WITH step_stats AS (
    SELECT 
        s.step_id,
        s.step_name,
        s.step_order,
        count(DISTINCT e.user_id) AS users_reached,
        sum(e.completed) AS users_completed
    FROM onboarding_steps s
    LEFT JOIN user_onboarding_events e ON s.step_id = e.step_id
    WHERE e.timestamp BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2024-12-31 23:59:59')}}
    GROUP BY s.step_id, s.step_name, s.step_order
)
SELECT 
    step_id,
    step_name,
    step_order,
    users_reached,
    users_completed,
    round(users_reached / (SELECT count FROM total_users), 2) AS reach_rate,
    round(users_completed / users_reached, 2) AS completion_rate,
    round(users_completed / (SELECT count FROM total_users), 2) AS overall_completion_rate
FROM step_stats
ORDER BY step_order
```

This code snippet would be part of a pipe that creates an endpoint to show the overall onboarding funnel performance. ### Endpoint pipes

Let's look at the `step_completion_rate` endpoint:

```sql
SELECT
    e.step_id,
    s.step_name,
    s.step_order,
    count(DISTINCT e.user_id) AS total_users,
    sum(e.completed) AS completed_users,
    round(sum(e.completed) / count(DISTINCT e.user_id), 2) AS completion_rate
FROM user_onboarding_events e
JOIN onboarding_steps s ON e.step_id = s.step_id
WHERE e.timestamp BETWEEN {{DateTime(start_date, '2023-01-01 00:00:00')}} AND {{DateTime(end_date, '2024-12-31 23:59:59')}}
GROUP BY e.step_id, s.step_name, s.step_order
ORDER BY s.step_order
```

This pipe calculates the completion rate for each onboarding step. The SQL logic groups events by step, then calculates the total and completed users per step, finally computing the completion rate. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/step_completion_rate.json?start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&token=$TB_ADMIN_TOKEN"
```


## Deploying to production

Deploying your Tinybird project to production is as simple as running `tb --cloud deploy` in your terminal. This command uploads your data sources, pipes, and any other resources to the Tinybird Cloud, making them scalable and ready for production use. Resources are managed as code, allowing for seamless integration with your CI/CD pipeline. To secure your APIs, Tinybird provides token-based authentication. Here’s how you can call the deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_completion_status.json?user_id=u123&token=$TB_ADMIN_TOKEN"
```


## Conclusion

In this tutorial, we've covered how to use Tinybird to build an analytics API for tracking and analyzing user onboarding flows. By creating data sources, transforming this data, and deploying API endpoints, you can gain valuable insights into your onboarding process, identify bottlenecks, and improve user experience. Tinybird's ability to handle real-time data and provide scalable, secure endpoints makes it an ideal choice for developers looking to implement robust analytics solutions. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.