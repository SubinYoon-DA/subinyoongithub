## 카테고리/서브 카테고리 별 매출액 계산
-- 이 문제에서 핵심은 **한 번 GROUP BY, 그 이후는 전부 SUM() OVER()**❗
With Sales1 as (
  select 
    category, 
    sub_category,
    sum(sales) as sales_sub_category
  from records
  group by category, sub_category
  order by 1,2  -- 카테고리별, 서브카테고리별로 매출 확인 위해(없어도 무방)
),
Sales2 as (
  select 
    *,
  --  이미 집계된 sales_sub_category를 카테고리 기준으로 다시 합산
    sum(sales_sub_category) over (partition by category) as sales_category,
    sum(sales_sub_category) over () as sales_total
  from Sales1
)
-- 최종 쿼리
select 
  category,    -- 카테고리 이름
  sub_category,    -- 서브 카테고리 이름
  round(sales_sub_category,2) as sales_sub_category,    -- 서브 카테고리 별 매출액의 합계
  round(sales_category,2) as sales_category,    -- 카테고리 별 매출액의 합계
  round(sales_total,2) as sales_total,    -- 전체 매출액
  round((sales_sub_category / sales_category)*100,2) as pct_in_category,    -- 카테고리 매출 중 해당 서브 카테고리 매출의 비율 (%)
  round((sales_sub_category / sales_total)*100,2) as pct_in_total     -- 전체 매출 중 해당 서브 카테고리 매출의 비율 (%)
from Sales2;
