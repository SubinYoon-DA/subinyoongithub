## 개발사마다 주력 플랫폼은 보통 판매량이 가장 많은 플랫폼
## 각 게임 개발사의 주력 플랫폼과 해당 플랫폼의 판매량 합계
-- `companies` 테이블에 publisher(배급사), developer(개발사) 모두 포함
With DP_Sales as (
  select 
    developer_id,   -- 개발사id
    platform_id,    -- 플랫폼id
    sum(sales_na + sales_eu + sales_jp + sales_other) as sales -- 판매량 합계
  from games
  group by developer_id, platform_id
),
DP_Sales_Rk as (
  select *,
    rank() over (partition by developer_id order by sales desc) as rk  -- 개발사별로 sales(판매량 합계) rank 매기기
  from DP_Sales 
)
select 
  C.name as developer,  -- 개발사 이름
  P.name as platform,   -- 주력 플랫폼 이름
  D.sales   -- 게임 개발사 주력 플랫폼(rk=1)의 판매량 합계
from DP_Sales_Rk D 
join companies C on D.developer_id = C.company_id
join platforms P on D.platform_id = P.platform_id
where rk = 1;   -- 가장 판매량이 많은 플랫폼만 필터링
