create table t(a monetary);
insert into t values(-9.9);
insert into t values(\CNY-9.9);
insert into t values($-9.9);
insert into t values(null);
select * from t order by 1;
update t set a=a+10;
select * from t order by 1;
drop table t;
