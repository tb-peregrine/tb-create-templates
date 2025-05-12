# Build a Clickstream Analytics API with Tinybird

In the realm of web analytics, understanding user behavior through their clicks, page views, and navigation paths is crucial for enhancing the user experience and optimizing website content. A clickstream analytics API serves as a powerful tool for tracking and analyzing these user interactions in real time. This tutorial will guide you through building such an API using Tinybird, a data analytics backend designed for software developers. Tinybird facilitates the creation of real-time analytics APIs by handling the underlying infrastructure, allowing you to focus on leveraging your data to its fullest potential. Through data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes), Tinybird transforms raw clickstream data into insightful analytics that can power your applications or websites. ## Understanding the data

Imagine your data looks like this:

```json
{
  "event_id": "ev_14742",
  "user_id": "user_742",
  "session_id": "sess_4742",
  "event_type": "page_view",
  "page_url": "https://example.com/contact",
  "page_title": "Contact Page",
  "referrer": "https://google.com",
  "timestamp": "2025-05-07 11:02:40",
  "device_type": "desktop",
  "browser": "Safari",
  "properties": "{\"browser_version\":\"13.0\", \"screen_size\":\"1766x1010\"}"
}
```

This data represents a single event captured in a user's journey, detailing the action (like a page view or click), the page they interacted with, the referring site, and the timestamp of the interaction, along with device and browser information. To store this data, you would create a Tinybird data source using the following schema:

```json
DESCRIPTION >
    Raw clickstream events from the website/application

SCHEMA >
    `event_id` String `json:$.event_id`,
    `user_id` String `json:$.user_id`,
    `session_id` String `json:$.session_id`,
    `event_type` String `json:$.event_type`,
    `page_url` String `json:$.page_url`,
    `page_title` String `json:$.page_title`,
    `referrer` String `json:$.referrer`,
    `timestamp` DateTime `json:$.timestamp`,
    `device_type` String `json:$.device_type`,
    `browser` String `json:$.browser`,
    `properties` String `json:$.properties`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "timestamp, user_id, session_id"
```

This schema defines the structure of your clickstream events data, including types and ingestion keys, optimized for querying performance. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This facilitates real-time data capture with minimal latency. Here’s how you can ingest an event:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=clickstream_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{ /* event data */ }'
```

Besides the Events API, Tinybird supports other ingestion methods. For streaming data, the Kafka connector can be highly beneficial due to its ability to handle high volumes of data efficiently. For batch or file data, the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector are excellent choices, enabling bulk ingestion of historical data or periodic dumps. ## Transforming data and publishing APIs

In Tinybird, pipes are the building blocks for transforming data and publishing APIs. They can perform batch transformations, create real-time [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views), and establish API endpoints. ### Materialized Views

Though our example doesn’t include materialized views, it’s worth noting that they are used to pre-aggregate data and speed up query performance. They are especially useful in clickstream analytics for summarizing user activities or session information. ### API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints)

Each endpoint pipe transforms raw event data into actionable information. Let's explore the provided pipes:


#### User Journey

```sql
DESCRIPTION >
    Retrieve the journey of a specific user across sessions

NODE get_user_journey_node
SQL >
    %
    SELECT 
        user_id,
        session_id,
        timestamp,
        event_type,
        page_url,
        page_title,
        referrer,
        device_type,
        browser
    FROM clickstream_events
    WHERE user_id = {{String(user_id, '')}}
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    ORDER BY timestamp ASC

TYPE endpoint
```

This pipe creates an API endpoint that retrieves a user's journey across sessions. The SQL query filters events by `user_id`, `start_date`, and `end_date`, ordering the results by `timestamp` for chronological analysis. #### Session Events

```sql
DESCRIPTION >
    Retrieve all events for a specific session

NODE get_session_events_node
SQL >
    %
    SELECT 
        event_id,
        user_id,
        timestamp,
        event_type,
        page_url,
        page_title,
        referrer,
        device_type,
        browser,
        properties
    FROM clickstream_events
    WHERE session_id = {{String(session_id, '')}}
    ORDER BY timestamp ASC

TYPE endpoint
```

This endpoint focuses on a single session, providing detailed insights into the user's actions within that session. #### Popular Pages

```sql
DESCRIPTION >
    Get the most popular pages based on pageview count

NODE get_popular_pages_node
SQL >
    %
    SELECT 
        page_url,
        page_title,
        count() AS view_count
    FROM clickstream_events
    WHERE event_type = 'pageview'
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
    GROUP BY page_url, page_title
    ORDER BY view_count DESC
    LIMIT {{Int32(limit, 10)}}

TYPE endpoint
```

This pipe creates an API to identify the most popular pages, useful for content and marketing strategy adjustments. To call these endpoints, you’d use `curl` commands with the appropriate parameters, as shown in the original README. ## Deploying to production

Deploying your project to Tinybird's cloud is straightforward with the command `tb --cloud deploy`. This process makes your API endpoints production-ready and scalable, meeting any demand. Tinybird treats all resources as code, facilitating integration with CI/CD pipelines for automated deployments and version control. You’ll secure these APIs using token-based authentication, ensuring that only authorized users can access the data. ```bash
curl -X GET "https://api.tinybird.co/v0/pipes/get_user_journey.json?token=$TB_ADMIN_TOKEN&user_id=usr_abc123"
```


## Conclusion

Throughout this tutorial, you've learned how to build a Clickstream Analytics API using Tinybird, covering data ingestion, transformation, and API endpoint creation. Tinybird enables efficient handling of clickstream data, providing real-time insights into user behavior and website performance. By leveraging Tinybird, you can focus on deriving value from your data, without the overhead of managing the infrastructure. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.