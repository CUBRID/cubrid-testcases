create table t(n numeric(38,0));

insert into t values(1);

select * from t where n=1;

select * from t where n=1.0;

select * from t where n<0.0;

drop table t;