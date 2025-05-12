
# Healthcare Monitoring System Real-time API

## Tinybird

### Overview
This project provides a real-time API for healthcare monitoring systems, allowing medical professionals to track and access patient vital signs. The API enables monitoring of critical health metrics such as heart rate, blood pressure, oxygen saturation, and body temperature in real-time.

### Data Sources

#### patient_vitals
Stores patient vital sign measurements collected from monitoring devices.

Example of how to ingest data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=patient_vitals" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "patient_id": "patient_123",
    "timestamp": "2024-01-01 00:15:00",
    "heart_rate": 72.5,
    "blood_pressure_systolic": 120,
    "blood_pressure_diastolic": 80,
    "oxygen_saturation": 98.2,
    "temperature": 36.7
  }'
```

### Endpoints

#### patient_vitals_range
Returns vital signs for a specific patient within a time range, enabling medical staff to track changes in patient condition over time.

Example usage:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/patient_vitals_range.json?patient_id=patient_123&start_time=2024-01-01%2000:00:00&end_time=2024-01-01%2001:00:00&token=$TB_ADMIN_TOKEN"
```

Note: DateTime parameters must be formatted as YYYY-MM-DD HH:MM:SS, or the query will fail.

#### latest_vitals
Returns the most recent vital signs for a specific patient, providing an up-to-date snapshot of the patient's condition.

Example usage:
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/latest_vitals.json?patient_id=patient_123&token=$TB_ADMIN_TOKEN"
```
