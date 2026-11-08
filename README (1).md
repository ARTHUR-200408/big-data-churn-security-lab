# Telco Customer Churn: Big Data Analytics and Security Lab

An end-to-end Big Data project built on a single-node Hadoop and Spark cluster in Kali Linux. I took a raw customer dataset through ingestion, discovery, distributed analytics, machine learning, a NoSQL-backed web app and a dashboard, then secured the platform.

**Full report:** [Big_Data_Security_Lab_Report.pdf](Big_Data_Security_Lab_Report.pdf)

## Overview

| | |
|---|---|
| **Dataset** | Telco Customer Churn (Kaggle), 7,043 customers, 21 attributes |
| **Question** | Which customers are most likely to leave, and why? |
| **Environment** | Kali Linux VM in VirtualBox (4 GB RAM, 2 vCPUs) |
| **Stack** | Hadoop 3.3.6 (HDFS, YARN), Spark 3.5.9 (PySpark), R and R Shiny, MongoDB 4.4 (Docker), Flask, Java 21 |

## What I did

1. **Data acquisition and ingestion.** Profiled the raw CSV from the command line, created a second JSON source and ingested both into HDFS.
2. **Data discovery.** Used PySpark to inspect the schema and statistics. I found 11 missing values hidden as blank strings that a standard null check did not detect.
3. **Distributed analytics.** Ran Spark filters and aggregations, and converted the data to Parquet (about 83% smaller than the CSV).
4. **Enterprise architecture.** Designed a cost-efficient six-layer Big Data architecture with security across every layer.
5. **Machine learning and dashboard.** Trained a random forest churn model in R (79% accuracy, 50% recall) and built an interactive R Shiny dashboard.
6. **NoSQL web application.** Modelled customers as MongoDB documents and built a Flask app to look up churn risk.
7. **Security.** Applied HDFS permissions and ACLs, enabled MongoDB authentication with a least-privilege account, restricted network exposure to localhost, encrypted data at rest with AES-256, and reviewed GDPR and NDPA 2023 compliance.

## Key findings

- Month-to-month customers churn at **42.7%**, compared with **2.8%** on two-year contracts.
- Fiber optic customers and electronic check payers have the highest churn.
- New customers are the most likely to leave: restricting tenure to 12+ months drops churn from 26.5% to 17.5%.
- Accuracy alone was misleading. Because of class imbalance, recall was the more honest measure of the model.
- Insecure defaults were common: MongoDB had no authentication and HDFS was world-readable until I configured them.

## Skills demonstrated

Linux administration · Hadoop and HDFS · Apache Spark · Data cleaning and EDA · Machine learning (R) · Dashboard development · MongoDB · Flask · Access control · Encryption · Data protection compliance · Troubleshooting

## Author

**Ita Arthur Oluwapelumi** · BSc Cybersecurity student
[LinkedIn](https://linkedin.com/in/arthur-ita-317952382) · [Portfolio](https://arthur-200408.github.io)
