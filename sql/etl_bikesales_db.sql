CREATE DATABASE IF NOT EXISTS BikeSales_DB;
CREATE SCHEMA IF NOT EXISTS BikeSales_DB.BikeSalesSchema;
USE DATABASE BIKESALES_DB;
USE SCHEMA BIKESALES_DB.BikeSalesSchema;

//EXTRACT + LOAD

CREATE OR REPLACE TABLE SALES_STAGING AS
SELECT * FROM BIKE_SALES__SAMPLE_DASHBOARD_SYNTHETIC_DATA.BIKES_SALES."1_SALES";

DESCRIBE TABLE SALES_STAGING;
SELECT * FROM SALES_STAGING;

CREATE OR REPLACE TABLE PRODUCTS_STAGING AS
SELECT * FROM BIKE_SALES__SAMPLE_DASHBOARD_SYNTHETIC_DATA.BIKES_SALES."11_PRODUCTS";

DESCRIBE TABLE PRODUCTS_STAGING;
SELECT * FROM PRODUCTS_STAGING;

CREATE OR REPLACE TABLE CUSTOMERS_STAGING AS
SELECT * FROM BIKE_SALES__SAMPLE_DASHBOARD_SYNTHETIC_DATA.BIKES_SALES."2_CUSTOMERS";

DESCRIBE TABLE CUSTOMERS_STAGING;
SELECT * FROM CUSTOMERS_STAGING;

CREATE OR REPLACE TABLE GEOGRAPHY_STAGING AS
SELECT * FROM BIKE_SALES__SAMPLE_DASHBOARD_SYNTHETIC_DATA.BIKES_SALES."3_GEOGRAPHY";

DESCRIBE TABLE GEOGRAPHY_STAGING;
SELECT * FROM GEOGRAPHY_STAGING;

CREATE OR REPLACE TABLE PRODUCTSUBCATEGORY_STAGING AS
SELECT * FROM BIKE_SALES__SAMPLE_DASHBOARD_SYNTHETIC_DATA.BIKES_SALES."5_PRODUCTSUBCATEGORY";

DESCRIBE TABLE PRODUCTSUBCATEGORY_STAGING;
SELECT * FROM PRODUCTSUBCATEGORY_STAGING;

//TRANSFORM 

CREATE OR REPLACE TABLE dim_date AS
SELECT DISTINCT
    TO_CHAR(TO_DATE(orderdate), 'YYYYMMDD') AS date_id,
    TO_DATE(orderdate) AS date,
    YEAR(orderdate) AS year,
    MONTH(orderdate) AS month,
    DAY(orderdate) AS day,
    QUARTER(orderdate) AS quarter,
    CASE DAYNAME(orderdate)
        WHEN 'Mon' THEN 'Monday'
        WHEN 'Tue' THEN 'Tuesday'
        WHEN 'Wed' THEN 'Wednesday'
        WHEN 'Thu' THEN 'Thursday'
        WHEN 'Fri' THEN 'Friday'
        WHEN 'Sat' THEN 'Saturday'
        WHEN 'Sun' THEN 'Sunday' END AS weekday
FROM sales_staging;

SELECT * FROM dim_date;

CREATE OR REPLACE TABLE dim_time AS
SELECT DISTINCT
    TIME(s.ordertimestamp)::TIME(0) AS time_id,
    TIME(s.ordertimestamp)::TIME(0) AS time,
    HOUR(s.ordertimestamp) AS hour,
    MINUTE(s.ordertimestamp) AS minute,
    SECOND(s.ordertimestamp) AS second,
    CASE 
        WHEN HOUR(s.ordertimestamp) < 12 THEN 'am' 
        ELSE 'pm' 
    END AS am_pm
FROM sales_staging s;

SELECT * FROM dim_time;

CREATE OR REPLACE TABLE dim_geography AS
SELECT DISTINCT
    geographykey AS geography_id,
    city,
    stateprovincecode AS state_province_code,
    stateprovincename AS state_province,
    customer_country,
    postalcode AS postal_code
FROM geography_staging;

SELECT * FROM dim_geography;

CREATE OR REPLACE TABLE dim_customers AS
SELECT DISTINCT
    customerkey AS customers_id,
    geographykey AS geography_id,
    name,
    birthdate AS birth_date,
    maritalstatus AS marital_status,
    gender,
    yearlyincome AS yearly_income,
    numberchildrenathome AS number_children_at_home,
    occupation,
    houseownerflag AS house_owner_flag,
    numbercarsowned AS number_cars_owned,
    addressline1 AS address_line_1,
    addressline2 AS address_line_2,
    phone,
    datefirstpurchase AS date_first_purchase,
    currentstatus AS current_status
FROM customers_staging;

SELECT * FROM dim_customers;

CREATE OR REPLACE TABLE dim_products AS
SELECT DISTINCT
    p.productkey AS products_id,
    p.productname AS product_name,
    p.standardcost AS standard_cost,
    p.color AS color,
    p.listprice AS list_price,
    p.sizerange AS size_range,
    p.weight AS weight,
    p.daystomanufacture AS days_to_manufacture,
    p.productline AS product_line,
    p.dealerprice AS dealer_price,
    p.class AS product_class,
    p.modelname AS model_name,
    p.description AS description,
    p.startdate AS start_date,
    p.enddate AS end_date,
    p.status AS status,
    p.currentstock AS current_stock,
    ps.product_subcategory AS category
FROM products_staging p
JOIN productsubcategory_staging ps ON ps.productsubcategorykey = p.productsubcategorykey;


SELECT * FROM dim_products;


CREATE OR REPLACE TABLE fact_sales AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY s.salesordernumber, s.salesorderlinenumber
    ) AS sales_id,
    t.time_id,
    d.date_id,
    c.customers_id,
    p.products_id,
    g.geography_id,
    s.salesordernumber AS order_number,
    s.salesorderlinenumber AS order_line_number,
    s.orderquantity AS order_quantity,
    s.unitprice AS unit_price,
    s.discountamount AS discount_amount,
    s.productstandardcost AS product_standard_cost,
    s.totalproductcost AS total_product_cost,
    s.salesamount AS sales_amount,
    s.taxamt AS tax_amount,
    s.freight AS freight_amount,
    //celková hodnota objednávky
    SUM(s.salesamount) OVER (
        PARTITION BY s.salesordernumber
    ) AS order_total_sales_amount,
    //kumulatívna hodnota zákazníka
    SUM(s.salesamount) OVER (
        PARTITION BY s.customerkey
        ORDER BY s.orderdate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS customer_running_sales_amount
FROM sales_staging s
JOIN dim_date d ON d.date_id = TO_CHAR(TO_DATE(s.orderdate), 'YYYYMMDD')
JOIN dim_time t ON t.time_id = TIME(s.ordertimestamp)::TIME(0)
JOIN dim_customers c ON c.customers_id = s.customerkey
JOIN dim_products p ON p.products_id = s.productkey
JOIN dim_geography g ON g.geography_id = c.geography_id;

SELECT COUNT(*) FROM fact_sales;

DROP TABLE IF EXISTS SALES_STAGING;
DROP TABLE IF EXISTS PRODUCTS_STAGING;
DROP TABLE IF EXISTS CUSTOMERS_STAGING;
DROP TABLE IF EXISTS GEOGRAPHY_STAGING;
DROP TABLE IF EXISTS PRODUCTSUBCATEGORY_STAGING;

