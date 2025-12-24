## 목적: 고객의 도시 별로 VIP를 추려 오프라인 한정 특별 프로모션
## 1. 고객별 순매출을 집계 후
## 2. 각 도시별 최고 순매출 고객을 추출하는 쿼리
## 단, 순매출 = 주문 금액 - 할인 금액 제외/ 반품 주문은 집계에서 제외
## 여기서 의문점🤔: 오프라인 구매한 고객만 추려야 하나?(즉, is_online_order = 0인 레코드만 추려야 하나?) NO!!
  -- ## 온라인 구매한 고객도 해당됨
With Net_Sales as (
  select 
    customer_id,
    city_id,
    sum(
      case when is_returned = 0 then total_price - discount_amount end
      ) as total_spent
  from transactions 
  -- where is_online_order = 0
  group by customer_id, city_id
  having total_spent is not null    -- null인 경우는 반품 주문 건이므로 집계에서 제외
),
VIP_Rank as (
  select *,
    rank() over (partition by city_id order by total_spent desc) as rk    -- 각 도시별 최고 순매출 rank 매기기
  from Net_Sales
)
select
  city_id,
  customer_id,
  total_spent
from VIP_Rank
where rk = 1;      -- 각 도시별 순매출 rank=1인 레코드만 출력
