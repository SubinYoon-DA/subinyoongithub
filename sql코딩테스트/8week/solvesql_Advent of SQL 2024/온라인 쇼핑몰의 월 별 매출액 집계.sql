## 온라인 쇼핑몰의 월별 매출 규모
## 취소 주문을 제외한 주문 금액의 합계/ 취소 주문의 금액 합계/ 총 합계
select
  date_format(O.order_date, '%Y-%m') as order_month,
  sum(case when O.order_id not like 'C%' then I.price*I.quantity else 0 end) as ordered_amount,    -- null로 써도 동일한 결과값을 가지지만 안정성을 위해 해당 조건 이외의 금액은 0 처리
  sum(case when O.order_id like 'C%' then I.price*I.quantity else 0 end) as canceled_amount,     -- null로 써도 동일한 결과값을 가지지만 안정성을 위해 해당 조건 이외의 금액은 0 처리
  sum(I.price*I.quantity) as total_amount
from orders O
join order_items I on O.order_id = I.order_id
group by order_month
order by order_month asc;
