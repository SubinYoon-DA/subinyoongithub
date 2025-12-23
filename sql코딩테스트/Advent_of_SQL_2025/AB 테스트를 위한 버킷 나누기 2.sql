## 버킷 별 사용자 수/평균 주문 수/평균 주문 금액
## 주문 집계 시, 반품 주문은 제외
## 주의해야 할 점은, where절에 is_returned = 0을 넣어 반품한 customer가 배제되지 않게 해야 한다! 
with Buckets as (
  select
    case 
      when mod(customer_id,10) = 0 then 'A'
      else 'B'
    end as bucket,
    customer_id,
    count(case when is_returned = 0 then transaction_id end) as orders_cnt,   -- 주문 수(주문 집계시에만 반품 주문건 제외)
    sum(case when is_returned = 0 then total_price end) as total_sum   -- 주문 금액(주문 집계시에만 반품 주문건 제외)
  from transactions
  group by bucket, customer_id
)
select
  bucket,    -- 사용자 버킷
  count(distinct customer_id) as user_count,     -- 버킷에 포함된 사용자 수
  round(avg(orders_cnt),2) as avg_orders,    --  버킷에 포함된 사용자들의 평균 주문 수
  round(avg(total_sum),2) as avg_revenue    -- 버킷에 포함된 사용자들의 평균 주문 금액($)
from Buckets
group by bucket;
