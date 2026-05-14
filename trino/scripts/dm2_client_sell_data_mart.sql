-- Распределение клиентов по странам
DROP TABLE IF EXISTS clickhouse.default.dm2_customers_by_country;
CREATE TABLE clickhouse.default.dm2_customers_by_country AS
SELECT
    customer_country AS country_name,
    COUNT(*) AS customer_count
FROM clickhouse.default.dim_customer
WHERE customer_country IS NOT NULL
GROUP BY customer_country;

-- Топ-10 клиентов с наибольшей общей суммой покупок
DROP TABLE IF EXISTS clickhouse.default.dm2_top_10_customers_by_total;
CREATE TABLE clickhouse.default.dm2_top_10_customers_by_total AS
SELECT
    c.customer_email,
    CONCAT(c.customer_first_name, ' ', c.customer_last_name) AS customer_name,
    SUM(f.sale_total_price) AS total_spent
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_customer c ON f.sale_customer_id = c.sale_customer_id
GROUP BY c.customer_email, c.customer_first_name, c.customer_last_name
LIMIT 10;

-- Средний чек для каждого клиента
DROP TABLE IF EXISTS clickhouse.default.dm2_avg_check_per_customer;
CREATE TABLE clickhouse.default.dm2_avg_check_per_customer AS
SELECT
    c.customer_email,
    CONCAT(c.customer_first_name, ' ', c.customer_last_name) AS customer_name,
    AVG(f.sale_total_price) AS avg_check
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_customer c ON f.sale_customer_id = c.sale_customer_id
GROUP BY c.customer_email, c.customer_first_name, c.customer_last_name;