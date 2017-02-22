drop if exists t1;
create table t1(i int);
insert into t1 values(1);
select count(x.*) from (select * from t1)x;
with tmp as (select * from t1)select count(tmp.*) from tmp;
with tmp as (select count(x.*) from (select * from t1)x) select *from tmp;
drop if exists t1;
