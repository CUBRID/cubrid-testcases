create table t(a monetary);
insert into t values(10);
insert into t values(\CNY10);
insert into t values($10);
insert into t values(null);
select * from t where a like '$%' order by 1;
select * from t where a like '\CNY%' order by 1;
select * from t where a like '_CNY%' order by 1;
drop table t;
