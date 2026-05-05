create view  vw_promo_analysis as
select
years,
months,
month_num,
quarter,
discount_pct,
promo_event,
campaign_theme,
count(distinct order_id) orders,
sum(net_revenue) revenue,
sum(gross_profit) profit,
round((CAST(sum(gross_profit) as numeric)/ nullif(sum(net_revenue),0))* 100, 2) as profit_margin_pct,
round((CAST(sum(gross_profit) as numeric)/ nullif(sum(net_revenue),0)), 2) as profit_margin
from vw_cleans_sales
group by
years,
months,
month_num,
quarter,
promo_event,
campaign_theme,
discount_pct;

create view vw_demand_drivers as
select 
years,
months,
month_num,
quarter,
customer_segment,
member_tier,
channel,
category,
subcategory,
brand,
origin_country,
count(distinct customer_id) as customers,
count(distinct order_id) as orders,
sum(units_sold) as units_sold,
sum(net_revenue) as revenue,
sum(gross_profit) as profit,
sum(net_revenue)/ NULLIF(COUNT(distinct customer_id),0)as revenue_per_customer,
ROUND(( cast(sum(gross_profit) as numeric)/ NULLIF(sum(net_revenue),0)) * 100, 2) as profit_margin_pct,
ROUND(( cast(sum(gross_profit) as numeric)/ NULLIF(sum(net_revenue),0)), 2) as profit_margin
from vw_cleans_sales
group by
years,
months,
month_num,
quarter,
customer_segment,
subcategory,
member_tier,
acquisition_channel,
channel,
category,
brand,
origin_country;