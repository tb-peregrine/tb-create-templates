# Build a Real-time Auction Bidding API with Tinybird

In today's digital era, real-time data processing and analytics are crucial for applications like online auctions, where bids are made and updated continuously. Developers often face the challenge of building scalable, real-time APIs to handle this data efficiently. This tutorial will guide you through creating a real-time API for managing and analyzing auction bidding data, using Tinybird as the backbone technology. Tinybird is a data analytics backend for software developers. You use Tinybird to build real-time analytics APIs without needing to set up or manage the underlying infrastructure. Tinybird offers a local-first development workflow, git-based deployments, resource definitions as code, and features for AI-native developers. By leveraging Tinybird's data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), you can ingest, transform, and serve your auction data in real-time, making it possible to track bids, monitor bidder activity, and retrieve auction statistics on the fly. Let's dive into how you can utilize Tinybird to implement a real-time auction bidding API, covering data ingestion, transformation, and API endpoint creation. 

## Understanding the data

Imagine your data looks like this:
```json
{"bid_id": "bid_9115", "auction_id": "auction_16", "bidder_id": "bidder_16", "bid_amount": 4715, "timestamp": "2025-05-12 09:41:32", "status": "outbid", "item_id": "item_16"}
```
This sample represents a bid in an auction system, with attributes like bid ID, auction ID, bidder ID, bid amount, timestamp, bid status, and item ID. To store this data in Tinybird, you would first create a data source. A `.datasource` file describes the schema for your data and how it should be stored. Here's an example for the auction bids data:

```json
DESCRIPTION >
    Stores real-time auction bidding data including bid amount, auction ID, bidder ID, and timestamp

SCHEMA >
    `bid_id` String `json:$.bid_id`,
    `auction_id` String `json:$.auction_id`,
    `bidder_id` String `json:$.bidder_id`,
    `bid_amount` Float64 `json:$.bid_amount`,
    `timestamp` DateTime `json:$.timestamp`,
    `status` String `json:$.status`,
    `item_id` String `json:$.item_id`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(timestamp)"
ENGINE_SORTING_KEY "auction_id, timestamp, bidder_id"
```
The schema design and sorting keys are crucial for optimizing query performance, especially for time-series data typical in auction systems. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request. It's designed for low latency to support real-time applications effectively. Here's how you would ingest a new auction bid:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=auction_bids&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "bid_id": "bid_12345",
           "auction_id": "auction_789",
           "bidder_id": "user_456",
           "bid_amount": 150.75,
           "timestamp": "2023-04-15 14:30:45",
           "status": "active",
           "item_id": "item_101"
         }'
```
Other ingestion methods include the Kafka connector for event/streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) and S3 connector for batch/file data, offering flexibility depending on your application's architecture. 

## Transforming data and publishing APIs

Tinybird's pipes feature enables batch transformations, real-time transformations (through [Materialized views](https://www.tinybird.co/docs/forward/work-with-data/optimize/materialized-views?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV)), and the creation of API endpoints. Let's explore how to publish APIs for auction data. For example, to create an endpoint to retrieve recent bids, define a pipe like so:

```sql
DESCRIPTION >
    Returns recent bids for a specific auction or all auctions, with optional pagination

NODE recent_bids_node
SQL >
    SELECT 
        bid_id,
        auction_id,
        bidder_id,
        bid_amount,
        timestamp,
        status,
        item_id
    FROM auction_bids
    WHERE 1=1
    {%if defined(auction_id)%}
        AND auction_id = {{String(auction_id, '')}}
    {%end%}
    {%if defined(status)%}
        AND status = {{String(status, 'active')}}
    {%end%}
    ORDER BY timestamp DESC
    LIMIT {{Int32(limit, 100)}}
    OFFSET {{Int32(offset, 0)}}

TYPE endpoint
```
This pipe creates an API endpoint to fetch recent bids, with the logic to filter by auction ID, status, limit, and offset for pagination. Notice how SQL templating is used to make the API flexible. To call this deployed endpoint, use a `curl` command like:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recent_bids.json?limit=50&offset=50&token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Deploying to production

Deploying your project to Tinybird Cloud is straightforward with the `tb --cloud deploy` command. This command makes your API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) production-ready and scalable. Tinybird manages resources as code, facilitating integration with CI/CD pipelines for automated deployments. Here's an example command to deploy your APIs:

```bash
tb --cloud deploy
```
To secure your APIs, Tinybird employs token-based authentication, ensuring that only authorized users can access your endpoints. Here's how you might call a deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recent_bids.json?token=%24TB_ADMIN_TOKEN&utm_source=DEV&utm_campaign=tb+create+--prompt+DEV"
```


## Conclusion

Throughout this tutorial, you've seen how to build a real-time auction bidding API using Tinybird. By defining [data sources](https://www.tinybird.co/docs/forward/get-data-in/data-sources?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV), transforming data with pipes, and deploying scalable API endpoints, Tinybird streamlines the process of managing real-time data for auction systems. Whether you're tracking bids, monitoring bidder activity, or summarizing auction statistics, Tinybird provides the tools you need. [Sign up for Tinybird](https://cloud.tinybird.co/signup?utm_source=DEV&utm_campaign=tb+create+--prompt+DEV) to build and deploy your first real-time data APIs in a few minutes. Starting is free, with no time limit and no credit card required, enabling you to explore the full potential of real-time data analytics and API management.