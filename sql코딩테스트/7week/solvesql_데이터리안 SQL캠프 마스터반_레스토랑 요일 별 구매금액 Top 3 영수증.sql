## 요일별 결제 금액 Top 3
-- 예를 들어, 금요일 손님들의 결제 금액이 각각 $10, $9, $9, $8, $5, $2 였다면, 상위 결제 금액 3개는 $10, $9, $8 
-- 따라서 결제 금액이 $10, $9, $9, $8인 총 4개의 영수증을 각각 출력해야 함
## 중복 시 모두 출력될 수 있게 dense_rank 써야 한다!
with Top_Tips as (
  select 
    day, 
    time, 
    sex, 
    total_bill,
    dense_rank() over (partition by day order by total_bill desc) as d_rk
  from tips
)
select day, time, sex, total_bill
from Top_Tips
where d_rk <= 3;
-- '요일별 Top 3'지만 문제에서 요구하고 있는 답이 '레코드 단위'이므로 group by 안 써도 됨
