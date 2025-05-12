# Build a Real-Time Library Checkout Analytics API with Tinybird

In this tutorial, we'll guide you through creating a real-time API to analyze library book checkout patterns. This solution addresses the need to track book checkout events, providing insights into trends, popular books, and overdue items, all in real-time. It's a practical example of how to architect an analytics backend for situations requiring immediate data processing and availability. Tinybird, a data analytics backend for software developers, enables building real-time analytics APIs effortlessly. With Tinybird, you can focus on developing your application without worrying about the underlying data infrastructure. It facilitates working with data sources and [pipes](https://www.tinybird.co/docs/forward/work-with-data/pipes) to ingest, transform, and expose your data through highly performant APIs. This tutorial will showcase how to leverage Tinybird's capabilities to solve our library analytics challenge. ## Understanding the data

Imagine your data looks like this, represented in a `.ndjson` file from our fixtures:

```json
{"checkout_id": "chk_58541", "book_id": "book_8541", "book_title": "The Great Gatsby", "author": "George Orwell", "genre": "History", "user_id": "user_541", "checkout_date": "2025-02-20 17:51:45", "due_date": "2025-06-02 17:51:45", "return_date": null, "is_returned": 1}
```

This data represents individual book checkout events at a library, capturing details such as book IDs, titles, authors, genres, user IDs, checkout dates, due dates, return dates, and whether the book has been returned. To store this data, we create a Tinybird data source with a schema tailored to our needs, as shown in the `book_checkouts.datasource` file:

```json
DESCRIPTION >
    Records all book checkout events at the library

SCHEMA >
    `checkout_id` String `json:$.checkout_id`,
    `book_id` String `json:$.book_id`,
    `book_title` String `json:$.book_title`,
    `author` String `json:$.author`,
    `genre` String `json:$.genre`,
    `user_id` String `json:$.user_id`,
    `checkout_date` DateTime `json:$.checkout_date`,
    `due_date` DateTime `json:$.due_date`,
    `return_date` DateTime `json:$.return_date`,
    `is_returned` UInt8 `json:$.is_returned`

ENGINE "MergeTree"
ENGINE_PARTITION_KEY "toYYYYMM(checkout_date)"
ENGINE_SORTING_KEY "checkout_date, book_id, user_id"
```

The choice of column types and sorting keys enhances query performance, crucial for real-time analytics. For data ingestion, Tinybird's [Events API](https://www.tinybird.co/docs/forward/get-data-in/events-api) allows you to stream JSON/NDJSON events from your application frontend or backend with a simple HTTP request:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=book_checkouts" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "checkout_id": "c123456",
       "book_id": "b789012",
       "book_title": "The Great Gatsby",
       "author": "F. Scott Fitzgerald",
       "genre": "Fiction",
       "user_id": "u456789",
       "checkout_date": "2023-05-15 14:30:00",
       "due_date": "2023-05-29 23:59:59",
       "return_date": "2023-05-27 10:15:00",
       "is_returned": 1
     }'
```

This real-time nature and low latency make it ideal for applications requiring immediate data updates. Alternative ingestion methods include the Kafka connector for event/streaming data and the [Data Sources API](https://www.tinybird.co/docs/api-reference/datasource-api) or S3 connector for batch/file data. ## Transforming data and publishing APIs

Tinybird's pipes facilitate both batch and real-time transformations. They also enable the creation of API [Endpoints](https://www.tinybird.co/docs/forward/work-with-data/publish-data/endpoints) to expose transformed data. Let's explore the `checkout_trends.pipe`, which analyzes checkout trends over time:

```sql
DESCRIPTION >
    Analyze checkout trends over time by day or genre

NODE checkout_trends_node
SQL >
    %
    SELECT 
        {% if defined(group_by) and group_by == 'genre' %}
            genre,
            toStartOfDay(checkout_date) AS day,
            count() AS checkout_count
        {% else %}
            toStartOfDay(checkout_date) AS day,
            count() AS checkout_count
        {% end %}
    FROM book_checkouts
    WHERE 1=1
    ... TYPE endpoint
```

This pipe's SQL logic counts checkout events, optionally grouping them by genre. Query parameters increase flexibility, allowing users to tailor the API response to their needs. Here's how to call this API endpoint with different parameters:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/checkout_trends.json?token=$TB_ADMIN_TOKEN&group_by=genre&start_date=2023-03-01 00:00:00&end_date=2023-03-31 23:59:59"
```

The same approach applies to creating endpoints for `popular_books` and `overdue_books`, each with its specific SQL logic and query parameters. ## Deploying to production

Deploy your project to Tinybird Cloud using:

```bash
tb --cloud deploy
```

This command creates scalable, production-ready API endpoints. Tinybird manages resources as code, facilitating integration with CI/CD pipelines and ensuring secure, token-based API access. Here’s an example curl command to call your deployed endpoint:

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_books.json?token=$TB_ADMIN_TOKEN"
```


## Conclusion

Throughout this tutorial, you've learned to ingest, transform, and expose real-time library checkout data using Tinybird. From the initial data source setup to deploying production-ready API endpoints, you've seen how Tinybird simplifies data analytics workflows, enabling you to focus on building your application. [Sign up for Tinybird](https://cloud.tinybird.co/signup) to build and deploy your first real-time data APIs in a few minutes. Begin with Tinybird today to leverage real-time analytics in your projects, free to start, with no time limit and no credit card required.