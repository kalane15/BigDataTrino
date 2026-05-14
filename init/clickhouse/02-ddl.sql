-- =========================
-- DIMENSION TABLES
-- =========================

-- Таблица измерений "питомец клиента"
CREATE TABLE IF NOT EXISTS dim_customer_pet (
    customer_pet_id UInt64,
    customer_pet_type String,
    customer_pet_name String,
    customer_pet_breed String
) ENGINE = MergeTree()
ORDER BY customer_pet_id;

-- Таблица измерений "клиент"
CREATE TABLE IF NOT EXISTS dim_customer (
    sale_customer_id UInt64,
    customer_first_name String,
    customer_last_name String,
    customer_age Int32,
    customer_email String,
    customer_country String,
    customer_postal_code String,
    customer_pet_id UInt64,
    pet_category String
) ENGINE = MergeTree()
ORDER BY sale_customer_id;

-- Таблица измерений "продавец"
CREATE TABLE IF NOT EXISTS dim_seller (
    sale_seller_id UInt64,
    seller_first_name String,
    seller_last_name String,
    seller_email String,
    seller_country String,
    seller_postal_code String
) ENGINE = MergeTree()
ORDER BY sale_seller_id;

-- Таблица измерений "поставщик"
CREATE TABLE IF NOT EXISTS dim_supplier (
    product_supplier_id UInt64,
    supplier_name String,
    supplier_contact String,
    supplier_email String,
    supplier_phone String,
    supplier_address String,
    supplier_city String,
    supplier_country String
) ENGINE = MergeTree()
ORDER BY product_supplier_id;

-- Таблица измерений "товар"
CREATE TABLE IF NOT EXISTS dim_product (
    sale_product_id UInt64,
    product_supplier_id UInt64,
    product_name String,
    product_category String,
    product_price Decimal(10,2),
    product_quantity Int32,
    product_weight Decimal(10,2),
    product_color String,
    product_size String,
    product_brand String,
    product_material String,
    product_description String,
    product_rating Decimal(3,1),
    product_reviews Int32,
    product_release_date String,
    product_expiry_date String
) ENGINE = MergeTree()
ORDER BY sale_product_id;

-- Таблица измерений "магазин"
CREATE TABLE IF NOT EXISTS dim_store (
    sale_store_id UInt64,
    store_name String,
    store_location String,
    store_city String,
    store_state String,
    store_country String,
    store_phone String,
    store_email String
) ENGINE = MergeTree()
ORDER BY sale_store_id;

-- =========================
-- ФАКТОВАЯ ТАБЛИЦА
-- =========================
CREATE TABLE IF NOT EXISTS fact_sales (
    id UInt64,
    sale_product_id UInt64,
    sale_seller_id UInt64,
    sale_customer_id UInt64,
    sale_store_id UInt64,
    sale_quantity Int32,
    sale_total_price Decimal(10,2),
    sale_date Date
) ENGINE = MergeTree()
ORDER BY (sale_date, id);