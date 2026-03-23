drop table if exists fact_sales;
drop table if exists dim_date;
drop table if exists dim_supplier;
drop table if exists dim_store;
drop table if exists dim_product;
drop table if exists dim_seller;
drop table if exists dim_customer;

create table dim_customer (
    customer_id bigint generated always as identity primary key,
    customer_first_name text,
    customer_last_name text,
    customer_age integer,
    customer_email text,
    customer_country text,
    customer_postal_code text,
    customer_pet_type text,
    customer_pet_name text,
    customer_pet_breed text
);

create table dim_seller (
    seller_id bigint generated always as identity primary key,
    seller_first_name text,
    seller_last_name text,
    seller_email text,
    seller_country text,
    seller_postal_code text
);

create table dim_product (
    product_id bigint generated always as identity primary key,
    product_name text,
    product_category text,
    product_price numeric(12,2),
    product_quantity integer,
    pet_category text,
    product_weight numeric(10,2),
    product_color text,
    product_size text,
    product_brand text,
    product_material text,
    product_description text,
    product_rating numeric(3,1),
    product_reviews integer,
    product_release_date date,
    product_expiry_date date
);

create table dim_store (
    store_id bigint generated always as identity primary key,
    store_name text,
    store_location text,
    store_city text,
    store_state text,
    store_country text,
    store_phone text,
    store_email text
);

create table dim_supplier (
    supplier_id bigint generated always as identity primary key,
    supplier_name text,
    supplier_contact text,
    supplier_email text,
    supplier_phone text,
    supplier_address text,
    supplier_city text,
    supplier_country text
);

create table dim_date (
    date_id bigint generated always as identity primary key,
    sale_date date not null,
    year_num integer,
    month_num integer,
    day_num integer,
    unique (sale_date)
);

create table fact_sales (
    fact_id bigint generated always as identity primary key,
    date_id bigint not null references dim_date(date_id),
    customer_id bigint not null references dim_customer(customer_id),
    seller_id bigint not null references dim_seller(seller_id),
    product_id bigint not null references dim_product(product_id),
    store_id bigint not null references dim_store(store_id),
    supplier_id bigint not null references dim_supplier(supplier_id),
    sale_quantity integer,
    sale_total_price numeric(12,2)
);
