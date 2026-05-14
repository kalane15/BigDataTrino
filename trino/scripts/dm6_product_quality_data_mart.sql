-- dm6_product_quality_data_mart.sql
-- Продукты с наивысшим рейтингом
DROP TABLE IF EXISTS clickhouse.default.dm6_highest_rated_products;
CREATE TABLE clickhouse.default.dm6_highest_rated_products AS
SELECT
    product_name,
    product_price,
    product_rating
FROM clickhouse.default.dim_product
WHERE product_rating = (SELECT MAX(product_rating) FROM clickhouse.default.dim_product)
ORDER BY product_rating DESC;

-- Продукты с наименьшим рейтингом
DROP TABLE IF EXISTS clickhouse.default.dm6_lowest_rated_products;
CREATE TABLE clickhouse.default.dm6_lowest_rated_products AS
SELECT
    product_name,
    product_price,
    product_rating
FROM clickhouse.default.dim_product
WHERE product_rating = (SELECT MIN(product_rating) FROM clickhouse.default.dim_product)
ORDER BY product_rating ASC;

-- Корреляция между рейтингом и объемом продаж (коэффициент Пирсона)
DROP TABLE IF EXISTS clickhouse.default.dm6_rating_sales_correlation;
CREATE TABLE clickhouse.default.dm6_rating_sales_correlation AS
WITH sales_agg AS (
    SELECT
        sale_product_id,
        SUM(sale_quantity) AS total_sales_volume
    FROM clickhouse.default.fact_sales
    GROUP BY sale_product_id
)
SELECT
    CORR(p.product_rating, sa.total_sales_volume) AS correlation_value,
    'Pearson correlation between product_rating and total_sales_volume' AS description
FROM clickhouse.default.dim_product p
LEFT JOIN sales_agg sa ON p.sale_product_id = sa.sale_product_id;

-- Продукты с наибольшим количеством отзывов (топ-5)
DROP TABLE IF EXISTS clickhouse.default.dm6_most_reviewed_products;
CREATE TABLE clickhouse.default.dm6_most_reviewed_products AS
SELECT
    product_name,
    product_reviews,
    product_rating
FROM clickhouse.default.dim_product
WHERE product_reviews IS NOT NULL
ORDER BY product_reviews DESC, product_rating DESC
LIMIT 5;