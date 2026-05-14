-- dm3_time_data_mart.sql
-- ћес€чные и годовые тренды продаж (сравнение выручки)
DROP TABLE IF EXISTS clickhouse.default.dm3_revenue_comparsion;
CREATE TABLE clickhouse.default.dm3_revenue_comparsion AS
SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(sale_total_price) AS total_revenue,
    AVG(sale_total_price) AS avg_order_value
FROM clickhouse.default.fact_sales
WHERE sale_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
ORDER BY year, month;

-- —равнение выручки за разные периоды (с предыдущим мес€цем)
DROP TABLE IF EXISTS clickhouse.default.dm3_trends;
CREATE TABLE clickhouse.default.dm3_trends AS
WITH monthly AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(sale_total_price) AS total_revenue
    FROM clickhouse.default.fact_sales
    WHERE sale_date IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
)
SELECT
    year,
    month,
    total_revenue,
    LAG(total_revenue, 1) OVER (ORDER BY year, month) AS prev_revenue,
    (total_revenue - LAG(total_revenue, 1) OVER (ORDER BY year, month)) / LAG(total_revenue, 1) OVER (ORDER BY year, month) * 100 AS revenue_change_percent
FROM monthly
ORDER BY year, month;

-- —редний размер заказа по мес€цам
DROP TABLE IF EXISTS clickhouse.default.dm3_monthly_avg_order_value;
CREATE TABLE clickhouse.default.dm3_monthly_avg_order_value AS
SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(sale_total_price) AS avg_order_value
FROM clickhouse.default.fact_sales
WHERE sale_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
ORDER BY year, month;