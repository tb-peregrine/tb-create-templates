# Network Traffic Security Monitoring API

This project provides a real-time API for monitoring network traffic with advanced security analysis capabilities.

## Tinybird

### Overview

This Tinybird project offers a comprehensive solution for monitoring and analyzing network traffic for security purposes. It provides various endpoints to detect potential security threats, analyze traffic patterns, and identify suspicious activities in your network.

### Data sources

#### network_traffic

This datasource stores raw network traffic data collected from various network devices, including IP addresses, ports, protocols, and traffic metrics.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=network_traffic" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-05-15 08:30:45",
       "source_ip": "192.168.1.100",
       "destination_ip": "203.0.113.45",
       "source_port": 58432,
       "destination_port": 443,
       "protocol": "TCP",
       "bytes_sent": 2560,
       "bytes_received": 4096,
       "packets_sent": 12,
       "packets_received": 15,
       "connection_duration_ms": 350,
       "status_code": 200,
       "device_id": "router-01",
       "is_internal": 1
     }'
```

### Endpoints

#### traffic_overview

Provides a filtered overview of network traffic data, allowing you to investigate specific time periods, protocols, or devices.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/traffic_overview.json?token=$TB_ADMIN_TOKEN&start_date=2023-05-01%2000:00:00&end_date=2023-05-15%2023:59:59&protocol=TCP&limit=50"
```

#### traffic_patterns

Analyzes network traffic patterns over time (hourly or daily intervals) to establish baselines and identify abnormal behavior.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/traffic_patterns.json?token=$TB_ADMIN_TOKEN&interval=hour&start_date=2023-05-01%2000:00:00&end_date=2023-05-15%2023:59:59&protocol=TCP"
```

#### port_scan_detection

Detects potential port scanning activities by identifying sources connecting to multiple ports in a short timeframe.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/port_scan_detection.json?token=$TB_ADMIN_TOKEN&min_ports=25&max_timespan=180&limit=50"
```

#### ip_geolocation

Provides geographical information for IPs in the network traffic, useful for identifying traffic from unusual locations.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ip_geolocation.json?token=$TB_ADMIN_TOKEN&ip_type=source&ip_filter=192.168.%&limit=50"
```

#### suspicious_connections

Identifies potentially suspicious network connections based on various security indicators like remote access attempts, large data transfers, DNS tunneling, and scanning activity.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/suspicious_connections.json?token=$TB_ADMIN_TOKEN&bytes_threshold=5000000&threat_type=Large%20Data%20Transfer&limit=50"
```

#### top_traffic_by_ip

Identifies the top IPs by traffic volume, useful for detecting unusual bandwidth consumption patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/top_traffic_by_ip.json?token=$TB_ADMIN_TOKEN&group_by=source&protocol=TCP&limit=20"
```
