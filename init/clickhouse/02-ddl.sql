-- =========================
-- DIMENSION TABLES
-- =========================

-- Таблица измерений "питомец клиента"
CREATE TABLE IF NOT EXISTS dim_customer_pet (
    customer_pet_id UInt64,
    customer_pet_type Nullable(String),
    customer_pet_name Nullable(String),
    customer_pet_breed Nullable(String)
) ENGINE = MergeTree()
ORDER BY customer_pet_id;

-- Таблица измерений "клиент"
CREATE TABLE IF NOT EXISTS dim_customer (
    sale_customer_id UInt64,
    customer_first_name Nullable(String),
    customer_last_name Nullable(String),
    customer_age Nullable(Int32),
    customer_email Nullable(String),
    customer_country Nullable(String),
    customer_postal_code Nullable(String),
    customer_pet_id Nullable(UInt64),
    pet_category Nullable(String)
) ENGINE = MergeTree()
ORDER BY sale_customer_id;

-- Таблица измерений "продавец"
CREATE TABLE IF NOT EXISTS dim_seller (
    sale_seller_id UInt64,
    seller_first_name Nullable(String),
    seller_last_name Nullable(String),
    seller_email Nullable(String),
    seller_country Nullable(String),
    seller_postal_code Nullable(String)
) ENGINE = MergeTree()
ORDER BY sale_seller_id;

-- Таблица измерений "поставщик"
CREATE TABLE IF NOT EXISTS dim_supplier (
    product_supplier_id UInt64,
    supplier_name Nullable(String),
    supplier_contact Nullable(String),
    supplier_email Nullable(String),
    supplier_phone Nullable(String),
    supplier_address Nullable(String),
    supplier_city Nullable(String),
    supplier_country Nullable(String)
) ENGINE = MergeTree()
ORDER BY product_supplier_id;

-- Таблица измерений "товар"
CREATE TABLE IF NOT EXISTS dim_product (
    sale_product_id UInt64,
    product_supplier_id Nullable(UInt64),
    product_name Nullable(String),
    product_category Nullable(String),
    product_price Nullable(Decimal(10,2)),
    product_quantity Nullable(Int32),
    product_weight Nullable(Decimal(10,2)),
    product_color Nullable(String),
    product_size Nullable(String),
    product_brand Nullable(String),
    product_material Nullable(String),
    product_description Nullable(String),
    product_rating Nullable(Decimal(3,1)),
    product_reviews Nullable(Int32),
    product_release_date Nullable(String),
    product_expiry_date Nullable(String)
) ENGINE = MergeTree()
ORDER BY sale_product_id;

-- Таблица измерений "магазин"
CREATE TABLE IF NOT EXISTS dim_store (
    sale_store_id UInt64,
    store_name Nullable(String),
    store_location Nullable(String),
    store_city Nullable(String),
    store_state Nullable(String),
    store_country Nullable(String),
    store_phone Nullable(String),
    store_email Nullable(String)
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
    sale_quantity Nullable(Int32),
    sale_total_price Nullable(Decimal(10,2)),
    sale_date Nullable(Date)
) ENGINE = MergeTree()
ORDER BY (sale_date, id)
SETTINGS allow_nullable_key = 1;