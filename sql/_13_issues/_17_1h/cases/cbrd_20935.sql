with c1 as (    
	select 1 n from db_root
	union all
	select n+1 from c1 where n<10
	union all 
	select 2 n from db_root
)
select * from c1 order by 1;

with c1 as (    
	select 1 n from db_root
	union all 
	select 2 n from db_root
	union all
	select n+1 from c1 where n<10
)
select * from c1 order by 1;

drop if exists t;
create table t(i int);
insert into t values(1);
insert into t values(2);
with c1 as (    
	select t1.i as m ,t2.i as n from t t1,t t2
	union all
	select m+1,n+1 from c1 where n<10
)
select * from c1 order by 1,2;    
with c1 as (    
	select t1.i as m ,t2.i as n from t t1,t t2
	union all
	select rownum,n+1 from c1 where n<10
)
select * from c1 order by 1,2;                     
drop if exists t;
