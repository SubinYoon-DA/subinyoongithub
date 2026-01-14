## 주문 각각에 대해 매출이 일어나는 시점은 olist_orders_dataset 테이블의 
## order_purchase_timestamp 컬럼
-- select * from olist_orders_dataset limit 100;
## 주문 금액은 olist_order_payments_dataset 테이블의 
## payment_value 컬럼
-- select * from olist_order_payments_dataset limit 10;

## 2018-01-01 이후 일별로 집계된 
## 쇼핑몰의 고객 수 /매출액 /ARPPU
## ARPPU는 결제 고객 1인 당 평균 결제 금액
with Order_20180101 as (
  select 
    date_format(OD.order_purchase_timestamp, '%Y-%m-%d') as dt,
    count(distinct OD.customer_id) as pu,
    sum(OPD.payment_value) as revenue_daily
  from olist_orders_dataset OD 
  join olist_order_payments_dataset OPD on OD.order_id = OPD.order_id 
  where date(OD.order_purchase_timestamp) >= '2018-01-01'      -- timestamp 형식에서 단순 date 타입으로 바꾸는 것이므로 date()와 date_format(*, '%Y-%m-%d') 둘 다 가능
  group by dt
)
select 
  dt,    -- 주문일
  pu,    -- 고객 수
  round(revenue_daily,2) as revenue_daily,    -- 매출액
  round(revenue_daily/pu,2) as arppu      -- ARPPU = 매출액/결제 고객 (즉, 고객 1인당 평균 결제 금액), 해당 테이블은 사이트의 "판매 데이터"를 담고 있음
from Order_20180101
order by dt;    -- 매출 날짜 순으로 오름차순 정렬
