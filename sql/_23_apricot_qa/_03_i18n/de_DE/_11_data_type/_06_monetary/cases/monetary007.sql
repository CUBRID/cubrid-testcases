create table t(a monetary);
insert into t values(10);
select a*10 from t order by 1;
insert into t values(\CNY10);
select a*10 from t order by 1;
drop table t;
