SELECT
    concat('bid_', toString(rand() % 10000)) AS bid_id,
    concat('auction_', toString(1 + rand() % 20)) AS auction_id,
    concat('bidder_', toString(1 + rand() % 100)) AS bidder_id,
    round(100 + rand() % 9900, 2) AS bid_amount,
    now() - toIntervalSecond(rand() % 86400) AS timestamp,
    ['pending', 'accepted', 'rejected', 'outbid'][(rand() % 4) + 1] AS status,
    concat('item_', toString(1 + rand() % 50)) AS item_id
FROM numbers(10)