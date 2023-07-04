# Advanced-MySQL-BI
eCommerce retail 

The database contains six related tables with eCommerce data about:

Website Activity
Products
Orders

Overview Database

![image](https://github.com/Beto-Amaral/MySQL_eCommerce/assets/46849631/7fe66ad2-654b-4f42-a24f-e24462c476bf)

The provided SQL code includes several queries for data analysis of an eCommerce website. 

1. Bounce rate analysis:

- Analyzes the percentage of visitors who leave the website after viewing a single page without further interaction.
- Calculates the bounce rate by dividing the number of bounced sessions by the total number of sessions.

2. Seasonal analysis:

- Extracts information such as time, weekday, quarter, month, date, and week from website sessions.
- Useful for identifying seasonal patterns and trends.

3. Date functions:

- Demonstrates the use of date functions like YEAR, WEEK, QUARTER, MONTH, DATE to extract specific information from session dates.

4. Conversion rate calculation:

- Calculates the conversion rate from sessions to orders.
- Counts the number of distinct sessions and distinct orders and calculates the conversion rate by dividing the orders by sessions.

5. Trending one source per week:

- Extracts information about sessions started in each week for a specific traffic source.
- Groups sessions by the week they started and counts the number of sessions in each week.

This summary provides a concise overview of the SQL code and the respective analyses performed on the eCommerce website data.

Based on the data analysis below, there is a noticeable increase in sales during the months of November and December every year across all products. This trend is likely attributed to the holiday season.

![image](https://github.com/Beto-Amaral/MySQL_eCommerce/assets/46849631/fc54eaed-2863-4748-9d13-9cf4317b393a)



