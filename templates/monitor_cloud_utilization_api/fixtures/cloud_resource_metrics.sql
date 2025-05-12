SELECT
    now() - rand() % 86400 AS timestamp,
    concat('r-', toString(rand() % 10000)) AS resource_id,
    ['ec2', 'rds', 's3', 'lambda', 'dynamodb'][(rand() % 5) + 1] AS resource_type,
    concat(['db-', 'app-', 'storage-', 'func-', 'cache-'][(rand() % 5) + 1], toString(rand() % 100)) AS resource_name,
    ['cpu_utilization', 'memory_usage', 'disk_space', 'network_in', 'network_out'][(rand() % 5) + 1] AS metric_name,
    round(rand() * 100, 2) AS metric_value,
    ['us-east-1', 'us-west-2', 'eu-west-1', 'ap-northeast-1', 'sa-east-1'][(rand() % 5) + 1] AS region,
    concat('acc-', toString(rand() % 1000)) AS account_id,
    ['production', 'staging', 'development', 'testing'][(rand() % 4) + 1] AS environment
FROM numbers(10)