## 2021년 가입 회원 중 상품 구매(연도 상관X) 회원 수/가입한 전체 회원 수
## 연, 월별로 상품 구매 회원 수, 구매 회원 비율
-- 출력: year, month, purchased_users, purchased_ratio
-- 정렬 기준: 1. 년을 기준으로 오름차순 정렬 2. 월을 기준으로 오름차순 정렬
-- Key point: (2021년에 가입한 전체 회원(A))과 (A중 상품을 구매한 회원)을 어떻게 분리해서 출력해야 하는가
  
WITH JOINED_2021 AS (      -- 2021년에 가입한 회원 CTE 생성(코호트)
    SELECT USER_ID, JOINED
    FROM USER_INFO
    WHERE YEAR(JOINED) = 2021
),
COHORT AS (            -- COHORT(CTE)로 2021년에 가입한 전체 회 수 N 분리
    SELECT COUNT(*) AS N
    FROM JOINED_2021
)
SELECT 
    YEAR(O.SALES_DATE) AS YEAR,
    MONTH(O.SALES_DATE) AS MONTH,   
    COUNT(DISTINCT O.USER_ID) AS PURCHASED_USERS,        -- 해당 년월에 구매한 2021년 가입자 수
    ROUND(COUNT(DISTINCT O.USER_ID)/COHORT.N,1) AS PUCHASED_RATIO       -- 분모는 코호트 전체(상수)
FROM JOINED_2021 J
JOIN ONLINE_SALE O ON J.USER_ID = O.USER_ID
CROSS JOIN COHORT           -- [중요!] 2021년 가입자 전체 수(상수)를 결과 모든 행에 붙임
GROUP BY YEAR(O.SALES_DATE), MONTH(SALES_DATE);
