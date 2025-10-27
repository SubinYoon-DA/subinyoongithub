## 상품코드 별 매출액
-- 매출액 = 판매가*판매량
SELECT 
    P.product_code,
    sum(P.price*O.sales_amount) as sales
from product P
join offline_sale O on P.product_id = O.product_id
group by P.product_code
order by 2 desc, 1 asc;     -- 1. 매출액을 기준으로 내림차순 정렬 2.매출액이 같다면 상품코드를 기준으로 오름차순 정렬
