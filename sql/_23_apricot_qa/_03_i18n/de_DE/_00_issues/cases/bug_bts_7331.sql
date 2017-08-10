create table t(a monetary);

insert into t values(\CNY123+\CNY321);

select * from t order by 1;

drop table t;


