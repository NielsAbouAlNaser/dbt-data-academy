-- DAY X - harder legacy exercise
-- Goal:
-- Build one table at order grain with:
--  - total_paid_amount per order
--  - total_refund_amount per order
--  - net_amount per order
--  - payment_state based on amounts
-- Also: only keep "real" orders (not cancelled)

create or replace table analytics.order_payment_status as
select
    o.order_id,
    o.customer_id,
    cast(o.order_ts as date) as order_date,
    lower(coalesce(o.status, '')) as order_status,

    coalesce(p.total_paid_amount, 0) as total_paid_amount,
    coalesce(r.total_refund_amount, 0) as total_refund_amount,
    coalesce(p.total_paid_amount, 0) - coalesce(r.total_refund_amount, 0) as net_amount,

    case
        when coalesce(p.total_paid_amount, 0) = 0 and coalesce(r.total_refund_amount, 0) = 0 then 'unpaid'
        when coalesce(p.total_paid_amount, 0) > 0 and coalesce(r.total_refund_amount, 0) = 0 then 'paid'
        when coalesce(p.total_paid_amount, 0) > 0 and coalesce(r.total_refund_amount, 0) > 0
             and (coalesce(p.total_paid_amount, 0) - coalesce(r.total_refund_amount, 0)) > 0 then 'partially_refunded'
        when coalesce(p.total_paid_amount, 0) > 0 and coalesce(r.total_refund_amount, 0) >= coalesce(p.total_paid_amount, 0) then 'refunded'
        else 'unknown'
    end as payment_state,

    -- legacy: pick "latest transaction status" by timestamp (for extra debugging)
    lt.latest_transaction_status

from customers.orders o

left join (
    -- total paid amount per order
    select
        t.order_id,
        sum(case when lower(coalesce(t.status,'')) in ('paid','captured') then cast(coalesce(t.amount,0) as double) else 0 end) as total_paid_amount
    from finance.transactions t
    where t.order_id is not null
    group by t.order_id
) p
on o.order_id = p.order_id

left join (
    -- total refund amount per order (abs because some systems store refunds negative)
    select
        t2.order_id,
        sum(case when lower(coalesce(t2.status,'')) = 'refunded' then abs(cast(coalesce(t2.amount,0) as double)) else 0 end) as total_refund_amount
    from finance.transactions t2
    where t2.order_id is not null
    group by t2.order_id
) r
on o.order_id = r.order_id

left join (
    -- latest transaction status per order (row_number in a subquery, no CTEs)
    select
        z.order_id,
        z.status as latest_transaction_status
    from (
        select
            t3.order_id,
            lower(coalesce(t3.status,'unknown')) as status,
            row_number() over (
                partition by t3.order_id
                order by t3.transaction_ts desc
            ) as rn
        from finance.transactions t3
        where t3.order_id is not null
    ) z
    where z.rn = 1
) lt
on o.order_id = lt.order_id

where o.order_id is not null
  and o.customer_id is not null
  and lower(coalesce(o.status,'')) != 'cancelled';
