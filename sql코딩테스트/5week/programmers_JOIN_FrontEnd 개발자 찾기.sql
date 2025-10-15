## Front End 스킬을 가진 개발자 조회
select id, email, first_name, last_name
from developers
where (skill_code & (
    select sum(code)    -- bit_or() 함수로 대체 가능(Front End인 모든 code를 합친 것)
    from skillcodes
    where category = 'Front End'
)) <> 0      -- "개발자가 가진 스킬(skill_code) 중에서, Front End 목록(서브쿼리)에 포함되는 것만 남긴 결과"에 겹치는 skillcode가 1개 이상 있다 = Front End 스킬 있다
order by id asc;
