## 기존: 30분 이상 기간 동안 사용자의 로그가 없을 때
## 기존 세션 종료하고 새 세션을 생성
## 세션 정의 시간을 '10분'으로 바꾸고 싶음
--- CTE1  
with New_Session as (
  select
    user_pseudo_id,
    event_timestamp_kst,
    event_name,
    ga_session_id,
    LAG(event_timestamp_kst,1) over (order by event_timestamp_kst asc) as before_etk
  from ga
  where user_pseudo_id = 'a8Xu9GO6TB'
),
--- CTE2
New_Session1 as (
  select
    user_pseudo_id,
    event_timestamp_kst,
    event_name,
    ga_session_id,
    case
      when before_etk is null then 1  -- 첫 번째 이벤트는 무조건 새 세션(1부터 시작)
      when timestampdiff(minute, before_etk, event_timestamp_kst) >= 10 then 1    -- 10분 넘어가면 새 세션 시작
      else 0 end new_session_flag
  from New_Session
)
  
select 
  user_pseudo_id,
  event_timestamp_kst,
  event_name,
  ga_session_id,
  sum(new_session_flag) over (order by event_timestamp_kst) as new_session_id   -- new_session_flag의 누적합
from New_Session1
order by event_timestamp_kst asc;
