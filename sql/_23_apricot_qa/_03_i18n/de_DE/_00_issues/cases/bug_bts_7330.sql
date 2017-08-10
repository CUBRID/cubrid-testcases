create table t(a monetary);

insert into t values($4);

insert into t values(\CNY4);

select * from t order by 1;

update t set a =4 where a=$4;

select * from t order by 1;

drop table t;


