-- Топ-5 поставщиков с наибольшей выручкой
DROP TABLE IF EXISTS clickhouse.default.dm5_top_suppliers_by_revenue;
CREATE TABLE clickhouse.default.dm5_top_suppliers_by_revenue AS
SELECT
    sup.supplier_name,
    SUM(f.sale_total_price) AS total_revenue
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_product p ON f.sale_product_id = p.sale_product_id
JOIN clickhouse.default.dim_supplier sup ON p.product_supplier_id = sup.product_supplier_id
GROUP BY sup.supplier_name
LIMIT 5;

-- Средняя цена товаров от каждого поставщика
DROP TABLE IF EXISTS clickhouse.default.dm5_avg_price_by_supplier;
CREATE TABLE clickhouse.default.dm5_avg_price_by_supplier AS
SELECT
    sup.supplier_name,
    sup.supplier_email,
    AVG(p.product_price) AS avg_product_price
FROM clickhouse.default.dim_product p
JOIN clickhouse.default.dim_supplier sup ON p.product_supplier_id = sup.product_supplier_id
GROUP BY sup.supplier_name, sup.supplier_email;

-- Распределение продаж по странам поставщиков
DROP TABLE IF EXISTS clickhouse.default.dm5_sales_by_supplier_country;
CREATE TABLE clickhouse.default.dm5_sales_by_supplier_country AS
SELECT
    sup.supplier_country AS country,
    SUM(f.sale_total_price) AS total_sales,
    SUM(f.sale_quantity) AS total_quantity
FROM clickhouse.default.fact_sales f
JOIN clickhouse.default.dim_product p ON f.sale_product_id = p.sale_product_id
JOIN clickhouse.default.dim_supplier sup ON p.product_supplier_id = sup.product_supplier_id
GROUP BY sup.supplier_country;