select ('a' like 'a');

create table t (a int);
insert into t values(1),(0),(2);
select (a = 0) from t order by 1;
select (a <> 0) from t order by 1;
select (a > 0) from t order by 1;
select (a between 0 and 10) from t order by 1;

drop table t;

