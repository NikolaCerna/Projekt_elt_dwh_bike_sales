-- Graf 1: Tržby podľa mesiacov
SELECT d.month, SUM(f.sales_amount) AS total_sales_amount FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.month
ORDER BY d.month;


-- Graf 2: vývoj tržieb v čase (podľa rokov)
SELECT d.year, SUM(f.sales_amount) AS total_sales_amount FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year
ORDER BY d.year;

-- Graf 3: Top 10 najpredávanejších produktov
SELECT p.product_name, SUM(order_quantity) AS total_quantity FROM fact_sales f
JOIN dim_products p ON f.products_id = p.products_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

-- Graf 4: Top 8 hodín s najvyšším počtom predaných kusov
SELECT t.hour, SUM(f.order_quantity) AS total_quantity_sold FROM fact_sales f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.hour
ORDER BY total_quantity_sold DESC
LIMIT 8;

-- Graf 5: Nákup cestných bicyklov podľa pohlavia
SELECT c.gender, SUM(f.order_quantity) AS total_quantity_sold FROM fact_sales f
JOIN dim_customers c ON f.customers_id = c.customers_id
JOIN dim_products p ON p.products_id=f.products_id
WHERE p.category LIKE 'Road Bikes'
GROUP BY c.gender
ORDER BY total_quantity_sold DESC;

-- Graf 6: Počet predaných produktov podľa regiónov
SELECT  g.customer_country, SUM(f.order_quantity) AS total_quantity_sold FROM fact_sales f
JOIN dim_geography g ON f.geography_id = g.geography_id
GROUP BY g.customer_country
ORDER BY total_quantity_sold DESC;
