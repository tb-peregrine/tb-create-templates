
# Real-time Patient Monitoring API

## Tinybird

### Overview
This project provides a real-time API for monitoring and analyzing patient vital signs data. The system ingests continuous patient measurements including heart rate, blood pressure, temperature, and oxygen levels, enabling healthcare providers to monitor patient status in real-time, identify critical cases, and analyze historical trends.

### Data Sources

#### `patient_vitals`
This data source stores real-time vital sign measurements from patient monitoring devices. Each record contains a patient identifier, device information, timestamp, and key vital signs.

**Sample data ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=patient_vitals" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "patient_id": "P123456",
    "device_id": "DEV0012",
    "timestamp": "2023-11-15 14:30:00",
    "heart_rate": 78.5,
    "systolic_bp": 120.0,
    "diastolic_bp": 80.0,
    "temperature": 37.2,
    "oxygen_level": 98.0,
    "department": "Cardiology",
    "is_critical": 0
  }'
```

### Endpoints

#### `patient_vitals_history`
Retrieves historical vital signs for a specific patient over a configurable time range. This endpoint enables healthcare providers to analyze trends in a patient's condition over time.

**Parameters:**
- `patient_id`: The ID of the patient (required)
- `start_time`: Starting timestamp for the data range (optional, defaults to 24 hours ago)
- `end_time`: Ending timestamp for the data range (optional, defaults to current time)

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/patient_vitals_history.json?patient_id=P123456&start_time=2023-11-14%2014:00:00&token=$TB_ADMIN_TOKEN"
```

#### `critical_patients`
Returns a list of patients with critical vital signs in the last hour, optionally filtered by department. This endpoint helps medical staff quickly identify patients requiring immediate attention.

**Parameters:**
- `department`: Filter by hospital department (optional)

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/critical_patients.json?department=Cardiology&token=$TB_ADMIN_TOKEN"
```

#### `patient_current_status`
Retrieves the most recent vital sign readings for a specific patient, providing their current health status.

**Parameters:**
- `patient_id`: The ID of the patient (required)

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/patient_current_status.json?patient_id=P123456&token=$TB_ADMIN_TOKEN"
```
