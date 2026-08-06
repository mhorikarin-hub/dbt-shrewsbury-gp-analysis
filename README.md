# Shrewsbury GP Practice & Healthcare Analytics (dbt + BigQuery)

An end-to-end analytics engineering pipeline built with **dbt Cloud** and **Google BigQuery** to analyze healthcare accessibility, appointment metrics, workforce capacity, and demographic distribution across GP practices in **Shrewsbury, UK**.

---

## 📌 Project Overview

This project consolidates disparate open healthcare and geographic datasets into a unified analytical data mart (`marts_gp_joined`). It enables detailed exploratory analysis of:
* **Healthcare Access & Proximity:** Mapping postcodes to local GP practices and evaluating patient distribution.
* **Workforce Capacity:** Monitoring clinical staff levels, practice roles, and workload strain.
* **Appointment Demand:** Tracking appointment waiting times, attendance patterns, and cancellation rates.

---

## 🏗️ Architecture & Data Lineage

The project follows standard dbt staging and mart layering principles:

[ raw_gp_practices ]   ──► [ stg_shrewsbury_gp_practices ] ──┐
[ raw_gp_workforce ]   ──► [ stg_gp_workforce ]            ──┼──► [ marts_gp_joined ]
[ raw_gp_appointments] ──► [ stg_gp_appointments ]         ──┘


### Key Models
* **`stg_shrewsbury_gp_practices`**: Cleaned practice location master restricted to Shrewsbury catchments.
* **`stg_gp_workforce`**: Standardized staff metrics (GPs, nurses, admin) per practice.
* **`stg_gp_appointments`**: Consolidated appointment volumes, lead times, and no-show rates.
* **`marts_gp_joined`**: The primary analytical master table joining spatial, workforce, and service metrics.

---

## 🛠️ Tech Stack & Tools

* **Data Warehouse:** Google BigQuery
* **Data Transformation & Modeling:** dbt Cloud (Fusion / v1.8+)
* **Version Control:** GitHub
* **BI & Visualization:** Looker Studio

---

## 📂 Project Structure

```text
.
├── models/
│   ├── staging/      # Raw source cleaning and standardization
│   └── marts/        # Joined business-ready analytics layers
├── seeds/            # Reference lookup tables (Postcodes, Practice mapping)
├── macros/           # Reusable SQL logic and transformations
├── schema.yml        # Model definitions, column descriptions, and tests
└── dbt_project.yml   # Project configuration

📊 Business & Analytical Insights
Spatial Distance Analysis: Measures accessibility gaps by evaluating patient distances to nearest GP practices.

Capacity vs. Demand: Highlights practices experiencing high appointment cancellation rates alongside constrained workforce capacity.
Spatial Distance Analysis: Measures accessibility gaps by evaluating patient distances to nearest GP practices.

Capacity vs. Demand: Highlights practices experiencing high appointment cancellation rates alongside constrained workforce capacity.
