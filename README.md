# Transaction & Fraud Analysis

An end-to-end **Data Analyst project** analyzing 250,000 financial transactions to understand customer behavior, card usage, merchant performance, transaction trends, and fraud risk.

## Project Overview

This project analyzes financial transaction data using **Python, SQL, and Power BI** to turn raw data into business-focused insights.

The analysis covers four related datasets:

* Customers
* Cards
* Merchants
* Transactions

### Project Workflow

**Raw Data → Python Data Cleaning → SQL Analysis → Power BI Dashboard → Business Insights & Recommendations**

## Tools & Technologies

* **Python** — Pandas, data cleaning, and data quality checks
* **MySQL / SQL** — Data analysis, joins, aggregations, CTEs, and window functions
* **Power BI** — Interactive dashboards and KPI reporting
* **GitHub** — Project documentation and version control

## Key Business Questions

* Which customers generate the highest transaction value and frequency?
* Which age groups and card types contribute the most transaction value?
* Which merchants and merchant categories generate the highest transaction value?
* What is the overall fraud rate?
* Which merchant categories and transaction channels have higher fraud rates?
* How does transaction value change over time?
* Which customers show repeated or inactive transaction behaviour?

## Key Findings

* **250K** total transactions
* **₹4.15bn** total transaction amount
* **91.13%** successful transactions
* **5.39%** overall fraud rate
* **₹16.61K** average transaction value
* **46–60** is the highest-value age group
* **Gold** is the highest-value card type
* **POS** is the largest transaction channel by transaction amount
* **Entertainment** has the highest displayed merchant-category fraud rate
* **Mobile App** has the highest displayed transaction-channel fraud rate
* **Platinum** is the leading customer segment by transaction amount

## Project Structure

```text
transaction-fraud-analysis/
│
├── data/
│   ├── cards_data.csv
│   ├── customer_data.csv
│   ├── merchant_table.csv
│   └── transaction_data_250k.csv
│
├── python/
│   └── data_cleaning.py
│
├── sql/
│   └── transaction_fraud_analysis.sql
│
├── powerbi/
│   ├── transaction_fraud_dashboard.pbix
│   ├── overall_dashboard.png
│   ├── monthly_analysis.png
│   ├── customer_analysis.png
│   └── fraud_analysis.png
│
├── report/
│   └── Transaction_Fraud_Analysis.pdf
│
└── README.md
```

## Python Data Cleaning

Python/Pandas was used for initial data quality checks and cleaning, including:

* Loading the four datasets
* Missing-value checks
* Duplicate checks
* Primary-key validation
* Text standardization using lowercase and strip operations
* Column-name standardization
* Summary statistics
* Data-type inspection
* Exporting cleaned datasets

## SQL Analysis

SQL was used as the main analytical layer to answer customer, card, merchant, fraud, and time-based business questions.

The analysis includes:

* Aggregations and `GROUP BY`
* Filtering and `HAVING`
* Joins
* CTEs
* `DENSE_RANK()`
* `ROW_NUMBER()`
* `LAG()`
* Customer analysis
* Card analysis
* Merchant analysis
* Fraud analysis
* Time-based analysis
* RFM base metrics
* Customer activity analysis

## Power BI Dashboard

The Power BI report contains four main pages:

1. **Overall / Overview** — KPIs and transaction overview
2. **Monthly Analysis** — transaction trends, channels, and transaction status
3. **Customer Analysis** — customer value, age groups, and customer segments
4. **Fraud Analysis** — fraud trends, categories, merchants, and channels

### Dashboard Screenshots

#### Overall Dashboard

#### Monthly Analysis

#### Customer Analysis

#### Fraud Analysis

**Power BI Dashboard:** `powerbi/transaction_fraud_dashboard.pbix`

## Business Recommendations

Based on the analysis:

* Strengthen fraud monitoring for higher-risk channels and merchant categories.
* Investigate the decline in transaction value after the peak month.
* Focus retention strategies on high-value customers.
* Develop targeted strategies for high-value customer segments.
* Maintain POS reliability while evaluating digital-channel growth.
* Evaluate merchant performance together with fraud risk rather than transaction value alone.

## Project Report

The detailed project report contains:

* Project overview
* Data preparation
* SQL analysis and insights
* Power BI dashboard analysis
* Business insights
* Business recommendations
* Analyst methodology
* Project explanation
* Technical notes and improvements

**Report:** `report/Transaction_Fraud_Analysis.pdf`

## How to Use This Project

### 1. Explore the Data

The original datasets are available in the `data/` folder.

### 2. Run the Python Cleaning Script

The Python script performs data-quality checks and creates cleaned datasets.

```text
python/data_cleaning.py
```

### 3. Explore the SQL Analysis

The SQL queries used for the project are available in:

```text
sql/transaction_fraud_analysis.sql
```

### 4. Explore the Power BI Dashboard

Open:

```text
powerbi/transaction_fraud_dashboard.pbix
```

to explore the interactive dashboard.

## Disclaimer

This project is created for **portfolio and learning purposes** using a transaction dataset. The findings represent analysis of the available dataset and should not be interpreted as real-world financial or fraud statistics.

## Author & Contact

**Himanshu Kumar**

**[shk23223@gamil.com](mailto:shk23223@gamil.com)**

Aspiring Data Analyst | SQL • Excel • Power BI • Python
