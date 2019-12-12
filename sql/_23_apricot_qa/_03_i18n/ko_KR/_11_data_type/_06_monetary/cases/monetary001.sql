create table t(a monetary);
insert into t values(1);
insert into t values(-1);
insert into t values(0);
insert into t values(1.1);
insert into t values(-1.1);
insert into t values(0.2);
select * from t order by 1;
drop table t;
