# Build a Real-Time Analytics API for Ride-Sharing Services with Tinybird

When managing a ride-sharing service, understanding various metrics like ride details, driver performance, and usage patterns is crucial for optimizing operations and enhancing customer experience. A real-time analytics API can provide these insights efficiently, enabling quick decision-making and improvements. This tutorial will guide you through building such an API using Tinybird, a data analytics backend designed for software developers. Tinybird facilitates the creation of real-time analytics APIs without the hassle of setting up or managing the underlying infrastructure. It leverages data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to ingest, transform, and expose your data through fast, scalable APIs. 

## Understanding the data

Imagine your data looks like this:

```json
{
  "ride_id": "ride_34832",
  "driver_id": "driver_832",
  "user_id": "user_4832",
  "pickup_time": "2025-05-12 09:06:23",
  "dropoff_time": "2025-05-12 17:06:23",
  "pickup_location": "Queens",
  "dropoff_location": "Queens",
  "distance_km": 1062334835,
  "duration_minutes": 47,
  "fare_amount": 1062334869,
  "rating": 3,
  "status": "in_progress",
  "platform": "Web",
  "city": "Los Angeles",
  "timestamp": "2025-05-10 17:38:23"
}
```

This data represents a single ride in a ride-sharing service, including identifiers for the ride, driver, and user, timestamps for pickup and dropoff, locations, distance, duration, fare amount, rating, status, and more. To store this data in Tinybird, you create a data source with a schema tailored to your data's structure. Here's how you define a data source for rides:

```json
DESCRIPTION >
    Stores ride-sharing service data including ride details, driver information, and customer feedback

SCHEMA >
    `ride_id` String `json:$.ride_id`,
    `driver_id` String `json:$.driver_id`,
    `user_id` String `json:$.user_id`,
    `pickup_time` DateTime `json:$.pickup_time`,
    `dropoff_time` DateTime `json:$.dropoff_time`,
    `pickup_location` String `json:$.pickup_location`,
    `dropoff_location` String `json:$.dropoff_location`,
    `distance_km` Float32 `json:$.distance_km`,
    `duration_minutes` Int32 `json:$.duration_minutes`,
    `fare_amount` Float32 `json:$.fare_amount`,
    `rating` Int8 `json:$.rating`,
    `status` String `json:$.status`,
    `platform` String `json:$.platform`,
    `city` String `json:$.city`,
    `timestamp` DateTime `json:$.timestamp`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "city, driver_id, timestamp"
```

In this schema, you define the data types and ingestion paths for each attribute. The `ENGINE` settings, such as the partition and sorting keys, optimize query performance by organizing data in a way that aligns with your query patterns. To ingest data into this data source, Tinybird offers various options, including the [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV). Here's how you can use it to stream JSON events:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=rides&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "ride_id": "r123456",
    "driver_id": "d789012",
    "user_id": "u345678",
    "pickup_time": "2023-05-15 14:30:00",
    "dropoff_time": "2023-05-15 15:00:00",
    "pickup_location": "Downtown",
    "dropoff_location": "Airport",
    "distance_km": 12.5,
    "duration_minutes": 30,
    "fare_amount": 25.75,
    "rating": 5,
    "status": "completed",
    "platform": "mobile",
    "city": "New York",
    "timestamp": "2023-05-15 14:30:00"
  }'
```

The Events API is designed for real-time, low-latency data ingestion from your application's frontend or backend. Other ingestion methods include Kafka connectors for event/streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) or S3 connectors for batch/file data. 

## Transforming data and publishing APIs

With the data ingested, the next step is to transform it and publish APIs. Tinybird's pipes facilitate this process. 

### Batch transformations and real-time transformations

Pipes in Tinybird can be used for batch transformations (copies) or real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)). They serve as the building blocks for creating flexible and efficient data pipelines. 

### Creating API endpoints

Each endpoint in Tinybird is built using a pipe, enabling you to expose specific data transformations as RESTful APIs. Here are examples of three [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV): Driver Performance, Hourly Ride Trends, and Ride Statistics. 

#### Driver Performance

This endpoint tracks individual driver performance metrics with filtering options. The SQL logic aggregates data by driver, calculating total rides, average rating, duration, earnings, and distance. ```sql
SELECT 
    driver_id,
    city,
    COUNT(*) as total_rides,
    AVG(rating) as avg_rating,
    AVG(duration_minutes) as avg_duration,
    SUM(fare_amount) as total_earnings,
    AVG(distance_km) as avg_distance
FROM rides
WHERE 1=1
{% if defined(driver_id) %}
    AND driver_id = {{String(driver_id, '')}}
{% end %}
{% if defined(start_date) %}
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
{% end %}
{% if defined(end_date) %}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
{% end %}
{% if defined(city) %}
    AND city = {{String(city, 'New York')}}
{% end %}
GROUP BY driver_id, city
ORDER BY total_rides DESC
LIMIT {{Int32(limit, 100)}}
```


#

### Hourly Ride Trends

This endpoint aggregates rides by hour to identify peak times. The SQL query groups data by hour and city, calculating total rides, average fare, and duration. ```sql
SELECT 
    toHour(timestamp) as hour_of_day,
    city,
    COUNT(*) as total_rides,
    AVG(fare_amount) as avg_fare,
    AVG(duration_minutes) as avg_duration
FROM rides
WHERE 1=1
{% if defined(start_date) %}
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
{% end %}
{% if defined(end_date) %}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
{% end %}
{% if defined(city) %}
    AND city = {{String(city, 'New York')}}
{% end %}
{% if defined(platform) %}
    AND platform = {{String(platform, 'mobile')}}
{% end %}
GROUP BY hour_of_day, city
ORDER BY hour_of_day ASC
```


#

### Ride Statistics

This endpoint provides overall ride statistics, including total rides, average duration, distance, fare, rating, and counts of completed and cancelled rides. ```sql
SELECT 
    city,
    COUNT(*) as total_rides,
    AVG(duration_minutes) as avg_duration,
    AVG(distance_km) as avg_distance,
    AVG(fare_amount) as avg_fare,
    AVG(rating) as avg_rating,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_rides,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled_rides
FROM rides
WHERE 1=1
{% if defined(start_date) %}
    AND timestamp >= {{DateTime(start_date, '2023-01-01 00:00:00')}}
{% end %}
{% if defined(end_date) %}
    AND timestamp <= {{DateTime(end_date, '2023-12-31 23:59:59')}}
{% end %}
{% if defined(city) %}
    AND city = {{String(city, 'New York')}}
{% end %}
GROUP BY city
ORDER BY total_rides DESC
```


## Deploying to production

Deploying your project to Tinybird Cloud is straightforward. Use the `tb --cloud deploy` command to deploy all your [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and pipes to production. This command creates production-ready, scalable API endpoints. Tinybird manages resources as code, making it easy to integrate with CI/CD pipelines for automated deployments. To secure your APIs, Tinybird uses token-based authentication. Here's how you can call one of your deployed endpoints:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/driver_performance.json?token=%24TB_ADMIN_TOKEN&driver_id=d789012&start_date=2023-01-01+00%3A00%3A00&end_date=2023-12-31+23%3A59%3A59&city=New+York&limit=10&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

In this tutorial, you've learned how to ingest, transform, and expose ride-sharing service data using Tinybird. We covered creating data sources, transforming data with pipes, and publishing scalable, real-time analytics APIs. Tinybird's infrastructure simplifies the process, enabling developers to focus on building and deploying powerful data-driven solutions quickly. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes.