SELECT
    concat('chk_', toString(rand() % 100000)) AS checkout_id,
    concat('book_', toString(rand() % 10000)) AS book_id,
    concat('The ', arrayElement(['Secret Garden', 'Great Gatsby', 'Hobbit', 'Alchemist', 'Chronicles', 'Whispers', 'Lost City', 'Dark Forest', 'Silent River', 'Golden Mountain'], rand() % 10 + 1)) AS book_title,
    arrayElement(['J.K. Rowling', 'Stephen King', 'Jane Austen', 'Mark Twain', 'Agatha Christie', 'George Orwell', 'Ernest Hemingway', 'Leo Tolstoy'], rand() % 8 + 1) AS author,
    arrayElement(['Fiction', 'Mystery', 'Science Fiction', 'Fantasy', 'Biography', 'History', 'Self-Help', 'Romance'], rand() % 8 + 1) AS genre,
    concat('user_', toString(rand() % 1000)) AS user_id,
    now() - toIntervalDay(rand() % 90) AS checkout_date,
    now() + toIntervalDay(rand() % 30) AS due_date,
    if(rand() % 2 = 0, now() - toIntervalDay(rand() % 30), NULL) AS return_date,
    rand() % 2 AS is_returned
FROM numbers(10)
