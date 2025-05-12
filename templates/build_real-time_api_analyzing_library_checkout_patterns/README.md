# Library Checkout Analytics API

## Tinybird

### Overview
This project provides a real-time API for analyzing library book checkout patterns. It tracks all book checkout events and offers insights into checkout trends, popular books, and overdue books.

### Data sources

#### book_checkouts
Records all book checkout events at the library, including details about books checked out, users, checkout dates, and return information.

**Ingest sample data:**
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

### Endpoints

#### checkout_trends
Analyzes checkout trends over time, with options to group by day or genre.

**Example usage:**
```bash
# Get daily checkout trends
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/checkout_trends.json?token=$TB_ADMIN_TOKEN"

# Get checkout trends by genre for a specific date range
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/checkout_trends.json?token=$TB_ADMIN_TOKEN&group_by=genre&start_date=2023-03-01 00:00:00&end_date=2023-03-31 23:59:59"

# Get checkout trends for a specific genre
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/checkout_trends.json?token=$TB_ADMIN_TOKEN&genre=Mystery"
```

#### popular_books
Identifies the most popular books based on checkout count, with options to filter by genre and date range.

**Example usage:**
```bash
# Get top 10 most popular books
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_books.json?token=$TB_ADMIN_TOKEN"

# Get top 20 most popular Science Fiction books in Q1 2023
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_books.json?token=$TB_ADMIN_TOKEN&genre=Science%20Fiction&start_date=2023-01-01 00:00:00&end_date=2023-03-31 23:59:59&limit=20"
```

#### overdue_books
Retrieves a list of currently overdue books, with options to filter by minimum days overdue and genre.

**Example usage:**
```bash
# Get all overdue books
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/overdue_books.json?token=$TB_ADMIN_TOKEN"

# Get books overdue by at least 7 days
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/overdue_books.json?token=$TB_ADMIN_TOKEN&min_days_overdue=7"

# Get Fiction books that are overdue, limited to 50 results
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/overdue_books.json?token=$TB_ADMIN_TOKEN&genre=Fiction&limit=50"
```
