# 🚖 Uber Data Warehouse Implementation – End-to-End Guide

A complete data warehousing project for Uber-style ride data, designed and deployed in **Google BigQuery**, with mock data generation and full analytical coverage of key business metrics.

---

## 📌 1. Project Overview

This project implements a **star schema–based data warehouse** for Uber operations using Google BigQuery. It supports real-time and historical analytics for the following business use cases:

- 🚗 Ride duration and distance analysis  
- 💰 Revenue by city and by driver  
- ⏰ Peak time and surge pricing insights  
- 📍 Popular pickup/drop-off route tracking  
- 🌟 Driver/rider rating metrics  
- ❌ Ride cancellation rate monitoring  
- 🌧️ Weather impact on ride performance  
- 🧑‍🤝‍🧑 Rider loyalty and churn metrics  

---

## 🛠️ 2. Key Technologies

| Tool                | Purpose                          |
|---------------------|----------------------------------|
| **Google BigQuery** | Cloud data warehouse             |
| **Python 3.9+**      | Scripting and orchestration      |
| **Faker**            | Realistic mock data generation   |
| **Pandas**           | Data wrangling and DataFrames    |

---

## 🗃️ 3. Schema Design

This project uses a **star schema** structure, with centralized fact tables and connected dimension tables.

### 📦 Dimension Tables
- `drivers`
- `riders`
- `locations`
- `cities`
- `dates`
- `weather`

### 📊 Fact Tables
- `rides`
- `ride_status`

---

## ⚙️ 4. Setup Instructions

### 📌 1. Google Cloud Setup
1. Create a GCP Project
2. Enable the **BigQuery API**
3. Create a **Service Account** with `BigQuery Admin` role
4. Download the service account key (JSON)
5. Set the environment variable:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
````

> On Windows:

```cmd
set GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\service-account.json"
```

---

### 🐍 2. Python Environment

```bash
# Create virtual environment
python -m venv uber-dwh-env
source uber-dwh-env/bin/activate  # or .\uber-dwh-env\Scripts\activate on Windows

# Install dependencies
pip install pandas faker google-cloud-bigquery pyarrow
```

---

## 🧪 5. Data Generation & Loading

Run the mock data generation + BigQuery loading script:

```bash
python uber_mock_data_load_to_BQ.py
```

This will generate realistic drivers, riders, trips, and weather entries, and load them into your `uber_dw` BigQuery dataset.

---

## 📊 6. Business Insights on Tables

Once data is loaded, run SQL queries in BigQuery like:

* Top 5 cities by total revenue
* Avg ride duration by time of day
* Most frequent pickup-dropoff location pairs
* Driver ratings and loyalty score correlations
* Weather-wise ride volume comparison

> You can also schedule these queries using **BigQuery Scheduled Queries** or external tools like **Data Studio** or **Looker**.

---

## ☁️ 7. Deployment Architecture (Optional for Production)

For a production setup:

* 🐳 **Containerize** the pipeline using Docker
* 📅 **Automate daily loads** using Cloud Scheduler + Cloud Functions
* 🔁 **CI/CD pipelines** with Cloud Build + GitHub Actions
* 📈 **Monitoring** via Google Cloud Monitoring & Alerting

---

## 🧠 Author

Built by Pankaj as part of a hands-on data engineering portfolio.

---

