create table t(a monetary);

insert into t values(-10);

insert into t values(\CNY-10);

insert into t values($-10);

insert into t values(null);

select * from t order by 1;

delete from t where a=-10;

select * from t order by 1;

drop table t;


