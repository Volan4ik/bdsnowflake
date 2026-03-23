insert into dim_customer (
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
)
select distinct
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
from mock_data;

insert into dim_seller (
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
)
select distinct
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
from mock_data;

insert into dim_product (
    product_name,
    product_category,
    product_price,
    product_quantity,
    pet_category,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date
)
select distinct
    product_name,
    product_category,
    round(product_price::numeric, 2),
    product_quantity::int,
    pet_category,
    round(product_weight::numeric, 2),
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    round(product_rating::numeric, 1),
    product_reviews::int,
    to_date(product_release_date, 'FMMM/FMDD/YYYY'),
    to_date(product_expiry_date, 'FMMM/FMDD/YYYY')
from mock_data;

insert into dim_store (
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
)
select distinct
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
from mock_data;

insert into dim_supplier (
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
)
select distinct
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
from mock_data;

insert into dim_date (
    sale_date,
    year_num,
    month_num,
    day_num
)
select distinct
    dt,
    extract(year from dt)::int,
    extract(month from dt)::int,
    extract(day from dt)::int
from (
    select to_date(sale_date, 'FMMM/FMDD/YYYY') as dt
    from mock_data
) t;

insert into fact_sales (
    date_id,
    customer_id,
    seller_id,
    product_id,
    store_id,
    supplier_id,
    sale_quantity,
    sale_total_price
)
select
    dd.date_id,
    dc.customer_id,
    ds.seller_id,
    dp.product_id,
    dst.store_id,
    dsp.supplier_id,
    m.sale_quantity,
    m.sale_total_price
from mock_data m
join dim_date dd
    on dd.sale_date = to_date(m.sale_date, 'FMMM/FMDD/YYYY')
join dim_customer dc
    on dc.customer_first_name is not distinct from m.customer_first_name
   and dc.customer_last_name is not distinct from m.customer_last_name
   and dc.customer_age is not distinct from m.customer_age
   and dc.customer_email is not distinct from m.customer_email
   and dc.customer_country is not distinct from m.customer_country
   and dc.customer_postal_code is not distinct from m.customer_postal_code
   and dc.customer_pet_type is not distinct from m.customer_pet_type
   and dc.customer_pet_name is not distinct from m.customer_pet_name
   and dc.customer_pet_breed is not distinct from m.customer_pet_breed
join dim_seller ds
    on ds.seller_first_name is not distinct from m.seller_first_name
   and ds.seller_last_name is not distinct from m.seller_last_name
   and ds.seller_email is not distinct from m.seller_email
   and ds.seller_country is not distinct from m.seller_country
   and ds.seller_postal_code is not distinct from m.seller_postal_code
join dim_product dp
    on dp.product_name is not distinct from m.product_name
   and dp.product_category is not distinct from m.product_category
   and dp.product_price is not distinct from round(m.product_price::numeric, 2)
   and dp.product_quantity is not distinct from m.product_quantity::int
   and dp.pet_category is not distinct from m.pet_category
   and dp.product_weight is not distinct from round(m.product_weight::numeric, 2)
   and dp.product_color is not distinct from m.product_color
   and dp.product_size is not distinct from m.product_size
   and dp.product_brand is not distinct from m.product_brand
   and dp.product_material is not distinct from m.product_material
   and dp.product_description is not distinct from m.product_description
   and dp.product_rating is not distinct from round(m.product_rating::numeric, 1)
   and dp.product_reviews is not distinct from m.product_reviews::int
   and dp.product_release_date is not distinct from to_date(m.product_release_date, 'FMMM/FMDD/YYYY')
   and dp.product_expiry_date is not distinct from to_date(m.product_expiry_date, 'FMMM/FMDD/YYYY')
join dim_store dst
    on dst.store_name is not distinct from m.store_name
   and dst.store_location is not distinct from m.store_location
   and dst.store_city is not distinct from m.store_city
   and dst.store_state is not distinct from m.store_state
   and dst.store_country is not distinct from m.store_country
   and dst.store_phone is not distinct from m.store_phone
   and dst.store_email is not distinct from m.store_email
join dim_supplier dsp
    on dsp.supplier_name is not distinct from m.supplier_name
   and dsp.supplier_contact is not distinct from m.supplier_contact
   and dsp.supplier_email is not distinct from m.supplier_email
   and dsp.supplier_phone is not distinct from m.supplier_phone
   and dsp.supplier_address is not distinct from m.supplier_address
   and dsp.supplier_city is not distinct from m.supplier_city
   and dsp.supplier_country is not distinct from m.supplier_country;

/*проверка, оба каунта вернули по 10000*/ 
select count(*) from mock_data;
select count(*) from fact_sales;
select sum(sale_total_price) from mock_data;/* =2,529,852.12 */
select sum(sale_total_price) from fact_sales;/* =2,529,852.12 */
