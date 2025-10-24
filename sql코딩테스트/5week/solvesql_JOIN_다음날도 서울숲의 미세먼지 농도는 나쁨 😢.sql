## 당일의 미세먼지 농도보다 다음날의 미세먼지 농도가 더 안 좋은 날
## 출력: today, next_day, pm10, next_pm10
WITH LEAD_dirt as (
  select
    measured_at as today,
    LEAD(measured_at,1) over (order by measured_at asc) as next_day,    -- 주의) next_day `measured_at(측정 날짜)` 기준으로 오름차순
    pm10,
    LEAD(pm10,1) over (order by measured_at asc) as next_pm10    -- 주의) pm10 역시 `measured_at(측정 날짜)` 기준으로 오름차순
  from measurements
)
select *
from LEAD_dirt
where pm10 < next_pm10;
