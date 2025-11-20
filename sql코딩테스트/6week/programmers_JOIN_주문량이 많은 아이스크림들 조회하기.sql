## (7월 아이스크림 총 주문량) + (상반기 아이스크림 총 주문량)이 큰 순서대로
## 상위 3개 맛
select J.flavor
from FIRST_HALF FH
join JULY J on FH.flavor = J.flavor   -- flavor 기준으로 두 테이블 병합
group by J.flavor  -- flavor 기준 그룹화
order by sum(FH.total_order)+sum(J.total_order) desc  -- (7월 아이스크림 총 주문량) + (상반기 아이스크림 총 주문량) 기준 내림차순 정렬
limit 3;  -- 상위 3개 flavor만 출력
