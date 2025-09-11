## 1. WHERE 절로 푸는 방식
-- [문제 접근 방법]
-- - SKILL_CODE는 여러 스킬을 비트마스크(2진수 합)로 저장한다.
-- - 특정 스킬을 보유했는지 확인하려면 (SKILL_CODE & 해당 CODE) > 0 조건을 사용한다.
-- - Python(256), C#(1024) 코드값을 직접 조건으로 비교해 필터링한다.
-- - SKILLCODES 테이블을 사용하지 않으므로, 스킬명을 쓰는 대신 코드값을 하드코딩해야 한다.

-- [문제 푸는 순서]
-- 1) DEVELOPERS 테이블에서 모든 개발자 조회
FROM DEVELOPERS D
-- 2) WHERE 절에서 SKILL_CODE 비트연산으로 Python(256) 또는 C#(1024) 보유 여부 검사
WHERE (D.SKILL_CODE & 256) > 0   -- Python 보유 여부 확인
   OR (D.SKILL_CODE & 1024) > 0 -- C# 보유 여부 확인
-- 3) 조건을 만족하는 개발자의 정보(ID, EMAIL, FIRST_NAME, LAST_NAME) 출력
SELECT D.ID, D.EMAIL, D.FIRST_NAME, D.LAST_NAME
-- 4) ID 오름차순 정렬
ORDER BY 1 ASC;

## 답
SELECT D.ID, D.EMAIL, D.FIRST_NAME, D.LAST_NAME
FROM DEVELOPERS D
WHERE (D.SKILL_CODE & 256) > 0   -- Python
   OR (D.SKILL_CODE & 1024) > 0 -- C#
ORDER BY D.ID;

## 2. JOIN ... ON 방식 (확장성 이슈로 더 선호됨)
-- [문제 접근 방법]
-- - SKILL_CODE는 여러 스킬을 비트마스크로 저장한다.
-- - SKILLCODES 테이블에는 각 스킬의 NAME과 CODE가 매핑되어 있다.
-- - JOIN 조건 (D.SKILL_CODE & S.CODE) > 0 을 사용하면, 개발자의 스킬코드와
--   SKILLCODES의 개별 코드가 일치하는 경우만 매칭된다.
-- - 그 후 WHERE 절에서 NAME으로 필터링하면, Python이나 C#을 가진 개발자만 조회 가능하다.

-- [문제 푸는 순서]
-- 1) DEVELOPERS 테이블과 SKILLCODES 테이블을 조인
FROM DEVELOPERS D
JOIN SKILLCODES S
-- 2) 조인 조건은 (개발자의 SKILL_CODE 안에 해당 스킬코드가 포함되어 있는지) 비트연산으로 확인
JOIN SKILLCODES S
  ON (D.SKILL_CODE & S.CODE) > 0 -- 개발자가 해당 스킬을 가지고 있으면 매칭
-- 3) WHERE 절에서 SKILLCODES.NAME이 'Python' 또는 'C#' 인 경우만 필터링
WHERE S.NAME IN ('Python', 'C#')
-- 4) 중복 제거(DISTINCT) 후 개발자의 ID, EMAIL, FIRST_NAME, LAST_NAME 출력
SELECT DISTINCT D.ID, D.EMAIL, D.FIRST_NAME, D.LAST_NAME
-- 5) ID 오름차순 정렬
ORDER BY 1 ASC;

## 답
SELECT DISTINCT D.ID, D.EMAIL, D.FIRST_NAME, D.LAST_NAME -- 개발자 한 명이 여러 스킬을 동시에 가지고 있을 수 있으므로 DISTINCT
FROM DEVELOPERS D
JOIN SKILLCODES S ON (D.SKILL_CODE & S.CODE) > 0 -- 개발자가 가진 스킬과 매칭
WHERE S.NAME IN ('Python', 'C#')
ORDER BY 1 ASC;
