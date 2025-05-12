# Build a Real-Time Analytics API for Real Estate Market Trends with Tinybird

Today, we're diving into how to leverage Tinybird for building a real-time analytics API focusing on real estate market trends. This tutorial covers the ingestion of property listing data and the steps to expose [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) for analyzing average prices by location, summarizing market activity, and tracking price trends over time. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. It offers a local-first development workflows, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and pipes, developers can efficiently process and analyze large volumes of data in real-time, providing valuable insights into the real estate market. ## Understanding the data

Imagine your data looks like this:

```json
{
  "listing_id": "L17125",
  "price": 647250,
  "bedrooms": 1,
  "bathrooms": 1.5,
  "sqft": 1925,
  "property_type": "House",
  "city": "Philadelphia",
  "state": "PA",
  "zip_code": "17125",
  "listing_date": "2025-01-27 17:43:37",
  "status": "Sold",
  "days_on_market": 45
}
```

This data represents property listings with details such as price, size, type, and location. To store this data, you first need to create a Tinybird datasource. Here's how the `.datasource` file for `property_listings` might look:

```json
DESCRIPTION >
    Contains property listing data with price, location, and property details

SCHEMA >
    `listing_id` String `json:$.listing_id`,
    `price` Float64 `json:$.price`,
    `bedrooms` Int32 `json:$.bedrooms`,
    `bathrooms` Float32 `json:$.bathrooms`,
    `sqft` Int32 `json:$.sqft`,
    `property_type` String `json:$.property_type`,
    `city` String `json:$.city`,
    `state` String `json:$.state`,
    `zip_code` String `json:$.zip_code`,
    `listing_date` DateTime `json:$.listing_date`,
    `status` String `json:$.status`,
    `days_on_market` Int32 `json:$.days_on_market`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(listing_date)"
ENGINE_SORTING_KEY "listing_date, city, state, property_type"
```

In the schema, note the strategic choice of column types to optimize for query performance, such as using `Float64` for prices to accommodate large numbers and `DateTime` for listing dates to enable time-based queries. Sorting keys are chosen to improve query performance for common queries by location and date. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. This real-time nature and low latency make it ideal for continuously updating datasets. Here's an example of how to ingest data using the Events API:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=property_listings" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"listing_id":"12345", "price":500000.0, "bedrooms":3, "bathrooms":2.0, "sqft":1500, "property_type":"Single Family", "city":"San Francisco", "state":"CA", "zip_code":"94101", "listing_date":"2024-01-15 12:00:00", "status":"active", "days_on_market":10}'
```

Additionally, for event/streaming data, the Kafka connector is beneficial for integrating with existing Kafka streams. For batch/file data, Tinybird's [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) and S3 connector provide flexible options for bulk data ingestion. ## Transforming data and publishing APIs

Tinybird's pipes are used for batch transformations (copies), real-time transformations ([Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views)), and creating API endpoints (TYPE endpoint). These pipes process and analyze your data, making it accessible via RESTful endpoints. ### Average Price by Location

Let's start with the endpoint that calculates the average property prices by location:

```sql
DESCRIPTION >
    Calculates average property prices by location with filtering options

NODE avg_price_by_location_node
SQL >
    SELECT 
        city,
        state,
        property_type,
        AVG(price) AS avg_price,
        COUNT(*) AS listing_count,
        AVG(sqft) AS avg_sqft,
        AVG(price / sqft) AS avg_price_per_sqft
    FROM property_listings
    WHERE 1=1
    AND state = '{{String(state, 'CA')}}'
    AND city = '{{String(city, 'San Francisco')}}'
    AND property_type = '{{String(property_type, 'Single Family')}}'
    AND listing_date >= '{{DateTime(start_date, '2023-01-01 00:00:00')}}'
    AND listing_date <= '{{DateTime(end_date, '2023-12-31 23:59:59')}}'
    GROUP BY city, state, property_type
    ORDER BY avg_price DESC

TYPE endpoint
```

This pipe aggregates data to calculate the average price, count, and square footage of listings, filterable by location, property type, and date range. Query parameters make the API flexible for different user needs. ### Deploying to production

Deploy your project to Tinybird Cloud using the command `tb --cloud deploy`. This command creates production-ready, scalable API endpoints. Tinybird treats resources as code, enabling integration with CI/CD pipelines and offering token-based authentication to secure your APIs. Example API call:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/[pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes)/avg_price_by_location.json?token=$TB_ADMIN_TOKEN&state=CA&city=San Francisco&property_type=Single Family&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```


## Conclusion

Throughout this tutorial, we've built a real-time analytics API for real estate market trends using Tinybird. We covered data ingestion, transformation, and API publication, emphasizing the seamless process of deploying production-ready endpoints. Tinybird's approach enables developers to focus on data analysis and API design, rather than infrastructure management. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes.