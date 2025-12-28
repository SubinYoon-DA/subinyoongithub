## 세션 30분 -> 1시간으로 재정의해야 한다.
-- 사용자 S3WDQCqLpK의 이벤트 로그를 시간순으로 정렬하고
-- 각 이벤트의 직전 이벤트 시각을 함께 조회
WITH UserS3W_Log AS (
  SELECT 
    user_pseudo_id,
    event_timestamp_kst,
    LAG(event_timestamp_kst, 1)      -- 바로 이전 이벤트 시각 (세션 단절 여부 판단용)
      OVER (PARTITION BY user_pseudo_id ORDER BY event_timestamp_kst) AS before_etk
  FROM ga
  WHERE user_pseudo_id = 'S3WDQCqLpK'
),

-- 이전 이벤트와의 시간 차이가 60분 이상이면
-- 새로운 세션이 시작되었음을 표시하는 flag 생성
New_Session_Start AS (
  SELECT 
    *,
    CASE
      WHEN TIMESTAMPDIFF(MINUTE, before_etk, event_timestamp_kst) >= 60 THEN 1
      ELSE 0
    END AS new_session_start
  FROM UserS3W_Log
),

-- 세션 시작 flag를 누적 합산하여
-- 재정의된 세션 번호 생성
New_Session AS (
  SELECT
    *,
    SUM(new_session_start)
      OVER (ORDER BY event_timestamp_kst) AS redefined_session
  FROM New_Session_Start
)

-- 재정의된 세션 기준으로
-- 각 세션의 시작 시각과 종료 시각 집계
SELECT
  user_pseudo_id,
  MIN(event_timestamp_kst) AS session_start,
  MAX(event_timestamp_kst) AS session_end
FROM New_Session
GROUP BY user_pseudo_id, redefined_session
ORDER BY session_start;
