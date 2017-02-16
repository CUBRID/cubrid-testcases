with c1 (m, n) as (
	select 1 m, 1 n from db_root
	union all
	select rownum, n+1 from c1 where m=1 and n<10
)
select * from c1 order by 1,2;
with c1 (m, n) as (
	select 1 m, 1 n from db_root
	union all
	select rownum, n+1 from c1 where m=1 and n<10
)
select * from c1 order by 1,2;

with c1 (m, n) as (
        select 1 m, 1 n 
        union all
        select m+1,row_number( )OVER(order by 1) from c1 where m<10
)
select * from c1 order by 1,2;
