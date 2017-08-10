create table t(i integer);

insert into t values(1);

select i + date'9999-12-31' from t;

select 1 + date'9999-12-31';

drop table t;
