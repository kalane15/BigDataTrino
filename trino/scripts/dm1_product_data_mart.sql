-- dm1_product_data_mart.sql
-- Топ-10 самых продаваемых продуктов
DROP TABLE IF EXISTS clickhouse.default.dm1_top_10_products;
CREATE TABLE clickhouse.default.dm1_top_10_products AS
SELECT
    p.product_name,
    p.product_price,
    SUM(f.sale_quantity) AS total_quantity_sold,
    SUM(f.sale_total_price) AS total_revenue
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_product p ON f.sale_product_id = p.sale_product_id
GROUP BY p.product_name, p.product_price
ORDER BY total_revenue DESC
LIMIT 10;

-- Общая выручка по категориям продуктов
DROP TABLE IF EXISTS clickhouse.default.dm1_revenue_by_category;
CREATE TABLE clickhouse.default.dm1_revenue_by_category AS
SELECT
    p.product_category AS category_name,
    SUM(f.sale_total_price) AS total_revenue
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_product p ON f.sale_product_id = p.sale_product_id
GROUP BY p.product_category
ORDER BY category_name;

-- Средний рейтинг и количество отзывов для каждого продукта
DROP TABLE IF EXISTS clickhouse.default.dm1_product_rating_reviews;
CREATE TABLE clickhouse.default.dm1_product_rating_reviews AS
SELECT
    product_name,
    product_price,
    AVG(product_rating) AS avg_rating,
    SUM(product_reviews) AS total_reviews
FROM clickhouse.default.dim_product
GROUP BY product_name, product_price;