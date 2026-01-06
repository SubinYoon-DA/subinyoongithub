## 가구 판매 비중이 높았던 날
-- 일 별 주문 수 10개 이상인 날 중
-- ‘Furniture’ 카테고리 주문의 비율이 40% 이상 이었던 날만
## 일별 주문 수 집계 CTE - `일별 전체 주문 수`와 `일별 Furniture 주문 수`
with Orders as (
  select 
    order_date,
    count(distinct order_id) as total_orders,    -- 일별 전체 주문 수('주문 건수'이므로 행 단위가 아닌 order_id 기준!)
    count(distinct case when category = 'Furniture' then order_id end) as furniture  일별 Furniture 주문 수수('주문 건수'이므로 행 단위가 아닌 order_id 기준!)
  from records
  group by order_date
  having count(distinct order_id) >= 10    -- 일별 주문 수가 10개 이상인 날 중에서 filtering
)
select 
  order_date,
  furniture,
  round((furniture*1.0/total_orders) * 100, 2) as furniture_pct
from Orders 
where (furniture*1.0/total_orders) >= 0.4    -- 실수로 계산시키기 위해 '*1.0' 붙이기
order by 3 desc, 1;    -- 1.Furniture 카테고리의 주문 비율이 높은 것부터 보여주도록 정렬 2.비율이 같다면 날짜 순으로 정렬
