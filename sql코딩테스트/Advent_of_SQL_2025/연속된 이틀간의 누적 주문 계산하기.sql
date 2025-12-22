## 2023년 11월, 12월 '온라인' 주문만
## 주문일별 주문건수 CTE
With Orders as (
  select 
    date(purchased_at) as order_date,
    count(transaction_id) as num_orders_today
  from transactions
  where is_online_order = 1    -- 온라인 주문만
    and year(purchased_at) = 2023 and month(purchased_at) in (11,12)    -- 2023년 11월, 12월
  group by date(purchased_at)
),
## LAG 함수로 전날 주문 건수 컬럼 추가
Orders1 as (
  select 
    *,
    LAG(num_orders_today,1,0) over (order by order_date) as num_orders_yesterday    -- 전날 주문 건수, 첫 날(전 날이 없는 날) 집계 위해 3번째 인자인 default_value = 0
  from Orders
)
## 최종
select
  order_date,    -- 주문일(주문 날짜)
  dayname(order_date) as weekday,    -- 요일 (Sunday, Monday, ..., Saturday)
  num_orders_today,    -- 주문일 당일의 주문 건수
  (num_orders_today + num_orders_yesterday) as num_orders_from_yesterday    -- 주문일 하루 이전 날짜부터 주문일 당일까지 연속된 이틀간의 합계 주문 건수의 합
from Orders1
order by 1;

## 수정/인사이트
- 1. 최종 쿼리 select 절
num_orders_today
  + LAG(num_orders_today, 1, 0) OVER (ORDER BY order_date)
    AS num_orders_from_yesterday
-- CTE 한번 더 구성하지 않고 num_orders_from_yesterday 한번에 가능

-- 2. 최종 쿼리 where 조건
purchased_at >= '2023-11-01'
    AND purchased_at <  '2024-01-01'
-- 대체 가능
