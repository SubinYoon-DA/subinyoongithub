## 메달을 딴 선수
select distinct
  A.id,  -- 선수 id
  A.name,   -- 선수 이름
  group_concat(medal) as medals -- ❗group_concat() 함수가 문제 해결의 key였음
from records R
join athletes A on R.athlete_id = A.id
join teams T on R.team_id = T.id
join events E on R.event_id = E.id
where E.event = 'Volleyball Women''s Volleyball' and T.team = 'KOR'
and R.medal is not null
group by A.id, A.name;  -- group_concat의 기준

## Group_concat의 기본템플릿 
-- GROUP_CONCAT(
--     (컬럼명)
--     [ DISTINCT ]
--     [ ORDER BY 컬럼명 | FIELD(컬럼명, '값1','값2',...) ]
--     [ SEPARATOR '구분자' ]
-- )
## GROUP_CONCAT은 집계 함수이므로 GROUP BY와 함께 쓰는 것이 기본 패턴
