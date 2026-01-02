# Yelp Reviews Analytics Pipeline

Scalable ETL pipeline processing 6.9 million Yelp reviews across 150K+ businesses using AWS S3, Snowflake, and Python for automated sentiment analysis and business insights.

## Project Overview

This project analyzes Yelp's open dataset to extract customer sentiment patterns and business insights. The pipeline processes large-scale JSON data, performs sentiment classification, and provides actionable analytics across 1,416 cities and 1,311 business categories.

**Dataset Source:** [Yelp Open Dataset](https://www.yelp.com/dataset)

## Architecture

![Architecture Diagram](images/architecture.png)

**Data Flow:**
1. JSON data ingestion from Yelp dataset (5GB reviews, 100MB businesses)
2. Python chunking and preprocessing
3. AWS S3 storage
4. Snowflake data warehouse with flattened tables
5. Python UDF for sentiment analysis
6. SQL-based analytics and insights

## Key Results

- Processed 6.9 million reviews across 150,000+ businesses
- Analyzed data from 1,416 cities and 1,311 business categories
- Achieved 94.5% positive sentiment classification
- Identified Restaurants category leading with 4.7 million reviews
- Built automated sentiment analysis using Snowflake Python UDF

## Technologies Used

- **Cloud Storage:** AWS S3
- **Data Warehouse:** Snowflake
- **Programming:** Python
- **Analytics:** SQL
- **Data Format:** JSON
- **Sentiment Analysis:** Python UDF (Natural Language Processing)
