SELECT (
case when cnt > 1 and cnt < 6 then 1
when cnt > 5 and cnt < 11 then 5.5
when cnt > 10 and cnt <= 15 then 3
when cnt >= 16 and cnt < 20 then 2.5
when cnt >= 21 and cnt <= 500 then 7
End ) AS subhap
From ( SELECT 4 as cnt union all
SELECT 6 as cnt union all
SELECT 12 as cnt union all
SELECT 16 as cnt union all
SELECT 22 as cnt
) rslt;
