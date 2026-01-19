## 2017년 1월 한 달 동안
## 고객의 구매 일자 별로
## 배송 예정 시각 안에 고객에게 도착한 주문/ 
## 배송 예정 시각이 지나서 고객에게 도착한 주문
## 배송 완료 또는 배송 예정 시각 데이터가 없는 경우는 계산에서 제외
select 
  date(order_purchase_timestamp) as purchase_date,    -- 고객 구매 일자 type을 datetime 에서 date로 변
  sum(case when order_delivered_customer_date <= order_estimated_delivery_date then 1 else 0 end) as success,    -- 배송 예정 시각 안에 고객에게 도착한 주문은 succeess
  sum(case when order_delivered_customer_date >= order_estimated_delivery_date then 1 else 0 end) as fail    -- 배송 예정 시각이 지나서 고객에게 도착한 주문은 fail
from olist_orders_dataset
where order_delivered_customer_date is not null     -- 배송 완료 시각 없으면 집계 제외
and order_estimated_delivery_date is not null    -- 배송 예정 시각 없으면 집계 제외
and date_format(order_purchase_timestamp, '%Y-%m') = '2017-01'
group by purchase_date    -- 고객의 구매 일자 별로
order by 1 asc;    -- 구매 날짜를 기준으로 오름차순 정렬
