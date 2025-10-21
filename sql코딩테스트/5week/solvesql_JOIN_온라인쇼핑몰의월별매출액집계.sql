## 월별로 취소 주문을 제외한 주문금액 합계/ 취소 주문 금액 합계/ 총 합계
## 정렬: order_month 기준으로 오름차순
## order_month, ordered_amount, canceled_amount, total_amount


select 
  date_format(O.order_date,'%Y-%m') as order_month,
  -- CASE는 행 단위로 평가/ SUM()은 그룹 단위로 집계 => SUM()을 바깥에 씌워줘야
  sum(case when I.order_id not like 'C%' then I.price * I.quantity else 0 end) as ordered_amount,    -- else 0 안 쓰면 NULL이 됨 주의!
  sum(case when I.order_id like 'C%' then I.price * I.quantity else 0 end) as canceled_amount,  -- 해당 월에 “취소 주문이 전혀 없는 경우” 0으로 합산
  sum(I.price * I.quantity) as total_amount 
from orders O
join order_items I on O.order_id = I.order_id
group by date_format(O.order_date,'%Y-%m')
order by order_month asc;
