with c1 (n) as (    
	select 1
	union all
	select n+1 from (select 1 union all select 1 ) t, c1 where n<4
)
select * from c1 order by 1 asc;
