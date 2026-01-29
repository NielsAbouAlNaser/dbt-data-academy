-- DAY 2.1


create or replace table analytics.orders_payment_summary as
select
    o.order_id,
    o.customer_id,
    cast(o.order_ts as date) as order_date,
    o.status as order_status,

 
    lower(coalesce(t.status, 'unknown')) as payment_status,

   
    coalesce(t.amount, 0) as payment_amount,

   
    case when lower(coalesce(t.status,'')) in ('paid','captured') then 1 else 0 end as is_paid,
    case when lower(coalesce(t.status,'')) = 'refunded' then 1 else 0 end as is_refunded,

    
    case
        when lower(coalesce(t.status,'')) in ('paid','captured') then coalesce(t.amount, 0)
        when lower(coalesce(t.status,'')) = 'refunded' then -abs(coalesce(t.amount, 0))
        else 0
    end as net_amount

from customers.orders o
left join finance.transactions t
    on o.order_id = t.order_id

where o.order_id is not null
  and o.customer_id is not null
  and lower(coalesce(o.status,'')) != 'cancelled';
