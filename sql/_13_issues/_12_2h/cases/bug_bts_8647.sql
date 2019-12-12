create table t(a int);
select a,rank() over(order by (select 1 from t where 1=0)) from t ;
drop table t;
