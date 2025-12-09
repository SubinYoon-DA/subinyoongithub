## 2016년까지 국가대표팀 소속/여자 배구/2회 이상 연속 출전/선수 ID, 선수 이름
with Athlete_List as (       -- 운동선수 후보 CTE: 1)2016년까지 출전 2)KOR 소속 3)여자배구 4)2회 이상 출전했는지 파악 위해 prev_year(직전 출전 연도)
  select 
    R.athlete_id, 
    A.name, 
    G.year,
    LAG(G.year,1) over (partition by R.athlete_id order by G.year asc) as prev_year    -- ❗직전 출전 연도 (prev_year가 존재하면 2회 이상 출전했다는 의미)
  from records R
  join teams T on R.team_id = T.id
  join athletes A on R.athlete_id = A.id
  join games G on R.game_id = G.id
  join events E on R.event_id = E.id
  where E.event = 'Volleyball Women''s Volleyball' and T.team = 'KOR'
  and G.year <= 2016
)  
select
  distinct athlete_id as id, name     -- 🌟 distinct는 함수 X, '키워드'이기 때문에 select절에 1번만 써야 함
from Athlete_List
where year - prev_year = 4;  -- ❗2회 이상 "연속" 출전이려면 두 연도의 차이가 4여야 함
