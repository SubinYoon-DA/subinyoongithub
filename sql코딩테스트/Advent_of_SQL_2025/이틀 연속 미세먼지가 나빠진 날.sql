## 2022년/ 2일 연속/ 미세먼지 30이상
## 마지막날/3일째 -> 1일 카운트
## "연속적으로" "나빠지는"
WITH pm10_Day_List as (
  select 
    measured_at,
    pm10,
    LAG(pm10,1) over (order by measured_at asc) as pm10_1d_ago, -- 🌟LAG 문법 정확히 익히기
    LAG(pm10,2) over (order by measured_at asc) as pm10_2d_ago
  from measurements
  where year(measured_at) = 2022
)
select measured_at as date_alert
from pm10_Day_List
where pm10 >= 30
  and pm10 > pm10_1d_ago
  and pm10_1d_ago > pm10_2d_ago   -- ❗SQL에서 삼중 비교 A > B > C 는 적용 안 된다!
order by 1 asc;
