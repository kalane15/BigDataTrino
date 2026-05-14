-- Топ-5 магазинов с наибольшей выручкой
DROP TABLE IF EXISTS clickhouse.default.dm4_top_stores_by_revenue;
CREATE TABLE clickhouse.default.dm4_top_stores_by_revenue AS
SELECT
    s.store_name,
    s.store_email,
    SUM(f.sale_total_price) AS total_revenue
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_store s ON f.sale_store_id = s.sale_store_id
GROUP BY s.store_name, s.store_email
LIMIT 5;

-- Распределение продаж по городам
DROP TABLE IF EXISTS clickhouse.default.dm4_sales_by_city;
CREATE TABLE clickhouse.default.dm4_sales_by_city AS
SELECT
    s.store_city AS city,
    SUM(f.sale_total_price) AS total_sales,
    SUM(f.sale_quantity) AS total_quantity
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_store s ON f.sale_store_id = s.sale_store_id
GROUP BY s.store_city;

-- Распределение продаж по странам
DROP TABLE IF EXISTS clickhouse.default.dm4_sales_by_country;
CREATE TABLE clickhouse.default.dm4_sales_by_country AS
SELECT
    s.store_country AS country,
    SUM(f.sale_total_price) AS total_sales,
    SUM(f.sale_quantity) AS total_quantity
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_store s ON f.sale_store_id = s.sale_store_id
GROUP BY s.store_country;

-- Средний чек для каждого магазина
DROP TABLE IF EXISTS clickhouse.default.dm4_avg_check_by_store;
CREATE TABLE clickhouse.default.dm4_avg_check_by_store AS
SELECT
    s.store_name,
    s.store_email,
    AVG(f.sale_total_price) AS avg_check_amount
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_store s ON f.sale_store_id = s.sale_store_id
GROUP BY s.store_name, s.store_email;