TRUNCATE TABLE clickhouse.default.dim_customer_pet;
TRUNCATE TABLE clickhouse.default.dim_supplier;
TRUNCATE TABLE clickhouse.default.dim_seller;
TRUNCATE TABLE clickhouse.default.dim_store;
TRUNCATE TABLE clickhouse.default.dim_product;
TRUNCATE TABLE clickhouse.default.dim_customer;
TRUNCATE TABLE clickhouse.default.fact_sales;



INSERT INTO clickhouse.default.dim_customer_pet (customer_pet_id, customer_pet_type, customer_pet_name, customer_pet_breed)
WITH combined AS (
    SELECT customer_pet_type, customer_pet_name, customer_pet_breed
    FROM postgresql.public.mock_data
    WHERE customer_pet_type IS NOT NULL
    UNION ALL
    SELECT customer_pet_type, customer_pet_name, customer_pet_breed
    FROM clickhouse.default.mock_data
    WHERE customer_pet_type IS NOT NULL
),
distinct_pets AS (
    SELECT DISTINCT customer_pet_type, customer_pet_name, customer_pet_breed
    FROM combined
)
SELECT
    ROW_NUMBER() OVER () AS customer_pet_id,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
FROM distinct_pets;



INSERT INTO clickhouse.default.dim_supplier (
    product_supplier_id, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
)
WITH combined AS (
    SELECT supplier_name, supplier_contact, supplier_email, supplier_phone,
           supplier_address, supplier_city, supplier_country
    FROM postgresql.public.mock_data
    WHERE supplier_name IS NOT NULL
    UNION ALL
    SELECT supplier_name, supplier_contact, supplier_email, supplier_phone,
           supplier_address, supplier_city, supplier_country
    FROM clickhouse.default.mock_data
    WHERE supplier_name IS NOT NULL
),
distinct_suppliers AS (
    SELECT DISTINCT supplier_name, supplier_contact, supplier_email, supplier_phone,
           supplier_address, supplier_city, supplier_country
    FROM combined
)
SELECT
    ROW_NUMBER() OVER () AS product_supplier_id,
    supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
FROM distinct_suppliers;



INSERT INTO clickhouse.default.dim_seller (
    sale_seller_id, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code
)
WITH combined AS (
    SELECT seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code
    FROM postgresql.public.mock_data
    WHERE seller_email IS NOT NULL
    UNION ALL
    SELECT seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code
    FROM clickhouse.default.mock_data
    WHERE seller_email IS NOT NULL
),
distinct_sellers AS (
    SELECT DISTINCT seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code
    FROM combined
)
SELECT
    ROW_NUMBER() OVER () AS sale_seller_id,
    seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code
FROM distinct_sellers;



INSERT INTO clickhouse.default.dim_store (
    sale_store_id, store_name, store_location, store_city, store_state,
    store_country, store_phone, store_email
)
WITH combined AS (
    SELECT store_name, store_location, store_city, store_state,
           store_country, store_phone, store_email
    FROM postgresql.public.mock_data
    WHERE store_name IS NOT NULL
    UNION ALL
    SELECT store_name, store_location, store_city, store_state,
           store_country, store_phone, store_email
    FROM clickhouse.default.mock_data
    WHERE store_name IS NOT NULL
),
distinct_stores AS (
    SELECT DISTINCT store_name, store_location, store_city, store_state,
           store_country, store_phone, store_email
    FROM combined
)
SELECT
    ROW_NUMBER() OVER () AS sale_store_id,
    store_name, store_location, store_city, store_state,
    store_country, store_phone, store_email
FROM distinct_stores;



INSERT INTO clickhouse.default.dim_product (
    sale_product_id, product_supplier_id, product_name, product_category,
    product_price, product_quantity, product_weight, product_color, product_size,
    product_brand, product_material, product_description, product_rating,
    product_reviews, product_release_date, product_expiry_date
)
WITH combined AS (
    SELECT
        m.product_name, m.product_category, m.product_price, m.product_quantity,
        m.product_weight, m.product_color, m.product_size, m.product_brand,
        m.product_material, m.product_description, m.product_rating, m.product_reviews,
        m.product_release_date, m.product_expiry_date,
        m.supplier_name, m.supplier_email
    FROM postgresql.public.mock_data m
    WHERE m.product_name IS NOT NULL
    UNION ALL
    SELECT
        m.product_name, m.product_category, m.product_price, m.product_quantity,
        m.product_weight, m.product_color, m.product_size, m.product_brand,
        m.product_material, m.product_description, m.product_rating, m.product_reviews,
        m.product_release_date, m.product_expiry_date,
        m.supplier_name, m.supplier_email
    FROM clickhouse.default.mock_data m
    WHERE m.product_name IS NOT NULL
),
distinct_products AS (
    SELECT DISTINCT
        product_name, product_category, product_price, product_quantity,
        product_weight, product_color, product_size, product_brand,
        product_material, product_description, product_rating, product_reviews,
        product_release_date, product_expiry_date,
        supplier_name, supplier_email
    FROM combined
)
SELECT
    ROW_NUMBER() OVER () AS sale_product_id,
    s.product_supplier_id,
    dp.product_name, dp.product_category, dp.product_price, dp.product_quantity,
    dp.product_weight, dp.product_color, dp.product_size, dp.product_brand,
    dp.product_material, dp.product_description, dp.product_rating, dp.product_reviews,
    dp.product_release_date, dp.product_expiry_date
FROM distinct_products dp
JOIN clickhouse.default.dim_supplier s
    ON dp.supplier_name = s.supplier_name AND dp.supplier_email = s.supplier_email;



INSERT INTO clickhouse.default.dim_customer (
sale_customer_id, customer_first_name, customer_last_name, customer_age,
customer_email, customer_country, customer_postal_code, customer_pet_id, pet_category
)
WITH combined AS (
    SELECT
        customer_first_name, customer_last_name, customer_age, customer_email,
        customer_country, customer_postal_code, pet_category,
        customer_pet_type, customer_pet_name, customer_pet_breed
    FROM postgresql.public.mock_data
    WHERE customer_email IS NOT NULL
    UNION ALL
    SELECT
        customer_first_name, customer_last_name, customer_age, customer_email,
        customer_country, customer_postal_code, pet_category,
        customer_pet_type, customer_pet_name, customer_pet_breed
    FROM clickhouse.default.mock_data
    WHERE customer_email IS NOT NULL
),
distinct_customers AS (
    SELECT DISTINCT
        customer_first_name, customer_last_name, customer_age, customer_email,
        customer_country, customer_postal_code, pet_category,
        customer_pet_type, customer_pet_name, customer_pet_breed
    FROM combined
)
SELECT
    ROW_NUMBER() OVER () AS sale_customer_id,
    dc.customer_first_name, dc.customer_last_name, dc.customer_age, dc.customer_email,
    dc.customer_country, dc.customer_postal_code,
    p.customer_pet_id,
    dc.pet_category
FROM distinct_customers dc
JOIN clickhouse.default.dim_customer_pet p
    ON dc.customer_pet_type = p.customer_pet_type
    AND dc.customer_pet_name = p.customer_pet_name
    AND dc.customer_pet_breed = p.customer_pet_breed;



INSERT INTO clickhouse.default.fact_sales (
sale_product_id, sale_seller_id, sale_customer_id, sale_store_id,
sale_quantity, sale_total_price, sale_date
)
WITH all_sales AS (
    SELECT
        product_name, product_price, product_color, product_size, product_brand, product_material,
        seller_email,
        customer_email,
        store_name, store_email,
        sale_quantity, sale_total_price, sale_date
    FROM postgresql.public.mock_data
    WHERE sale_date IS NOT NULL
    UNION ALL
    SELECT
        product_name, product_price, product_color, product_size, product_brand, product_material,
        seller_email,
        customer_email,
        store_name, store_email,
        sale_quantity, sale_total_price, sale_date
    FROM clickhouse.default.mock_data
    WHERE sale_date IS NOT NULL
)
SELECT
    p.sale_product_id,
    s.sale_seller_id,
    c.sale_customer_id,
    st.sale_store_id,
    asale.sale_quantity,
    asale.sale_total_price,
    DATE_PARSE(asale.sale_date, '%m/%d/%Y') AS DATE
FROM all_sales asale
JOIN clickhouse.default.dim_product p
    ON asale.product_name = p.product_name
    AND asale.product_price = p.product_price
    AND asale.product_color = p.product_color
    AND asale.product_size = p.product_size
    AND asale.product_brand = p.product_brand
    AND asale.product_material = p.product_material
JOIN clickhouse.default.dim_seller s
    ON asale.seller_email = s.seller_email
JOIN clickhouse.default.dim_customer c
    ON asale.customer_email = c.customer_email
JOIN clickhouse.default.dim_store st
    ON asale.store_name = st.store_name AND asale.store_email = st.store_email;