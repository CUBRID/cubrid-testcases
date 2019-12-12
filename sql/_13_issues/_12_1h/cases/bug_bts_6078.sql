autocommit on;
create table t(i int);
insert into t values(1),(2),(1);
select 8 as col0 from t group by col0; 
select 8 as i from t group by i; 
select 8 i from t group by i; 
drop table t;
