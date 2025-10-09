# order_delivered_carrier_date 기록되지만, order_delivered_customer_date는 null값
with Not_Delivered_Customer as (      -- 택배사에 물건을 보내 배송 시작이 되었지만, 고객에게 도착하지 않은 택배에 대한 CTE 생성
  select order_id, order_delivered_carrier_date    -- 최종 쿼리에서 필요한 컬럼인 택배 건수와 택배사 도착 날짜만 출력
  from olist_orders_dataset
  where order_delivered_carrier_date is not NULL      -- order_delivered_carrier_date는 기록되지만
  and order_delivered_customer_date is NULL          -- order_delivered_customer_date는 기록되지 않는 택배 필터링
)
# 2017년 1월 한 달 동안 택배사에 전달되었지만 배송 완료는 되지 않은 주문 건수
  -- 택배사 도착일을 기준으로 집계
select 
  date_format(order_delivered_carrier_date, '%Y-%m-%d') as delivered_carrier_date,
  count(order_id) as orders
from Not_Delivered_Customer
where year(order_delivered_carrier_date) = 2017 and month(order_delivered_carrier_date) = 1      -- 2017년 1월 택배 대상
group by date_format(order_delivered_carrier_date, '%Y-%m-%d')
having count(order_id) is not null    -- 위 서술에 해당하는 주문이 없었던 날은 출력에서 제외(즉, count(order_id) = 0이면 출력에서 제외)
order by 1 asc;
