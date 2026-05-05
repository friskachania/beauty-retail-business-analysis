create view vw_cleans_sales as 
select 
order_id,
order_date,
ship_date,
delivery_date,
return_date,
quarter,
day_of_week,
holiday_flag,
weekend_flag,
customer_id,
category,
subcategory,
brand,
product_id,
product_name,
origin_country,
net_revenue,
gross_profit,
gross_revenue,
member_tier,
customer_segment,
channel,
device_type,
payment_method,
order_status,
store_city,
region,
units_sold,
size_label,
discount_pct,
inventory_before,
inventory_after,
lead_time_days,
stockout_flag,
return_units,
return_reason,
review_text_flag,
shipping_delay_flag,
display_slot_code,
shelf_tag_version,
internal_note,
unit_cost,
nullif(ship_date,'') as ship_date_clean,
round(( gross_profit::numeric/ nullif(net_revenue,0)) * 100, 2) as profit_margin_pct,
round((gross_profit::numeric / nullif(net_revenue,0) ),2 ) as profit_margin,
round((return_units::numeric / nullif(units_sold,0)),2 ) as return_rate,
coalesce(unit_cost, 0) as clean_unit_cost,
coalesce(nullif(trim(campaign_theme),''),'non campaign') as campaign_theme,
coalesce(nullif(trim(promo_event),''), 'no promo') as promo_event,
coalesce(nullif(trim(customer_gender),''), 'Unknown') as customer_gender,
coalesce(nullif(trim(age_group),''), 'Unknown') as age_group,
coalesce(nullif(trim(city_tier),''), 'Unknown') as city_tier,
coalesce(nullif(trim(acquisition_channel),''),'Unknown' ) as acquisition_channel,
coalesce(nullif(trim(warehouse_region),''), 'Unknown') as warehouse_region,
coalesce(review_score,0) as review_score,
cast(year as integer) as years,
cast(month as integer) as month_num,
case cast (month AS integer)
        when 1 then 'January'
        when 2 then 'February'
        when 3 then 'March'
        when 4 then 'April'
        when 5 then 'May'
        when 6 then 'June'
        when 7 then 'July'
        when 8 then 'August'
        when 9 then 'September'
        when 10 then 'October'
        when 11 then 'November'
        when 12 then 'December'
    end as months
from beauty_box_sales_raw; 
