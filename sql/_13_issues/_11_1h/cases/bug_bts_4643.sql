--Tests IS [NOT] NULL rewrite optimization with the null-safe equality operator <=>

create table t ( a int);
insert into t values (1);
insert into t values (2);
insert into t values (null);

select * from t where a<=>null;

select * from t where a<=>null and a is not null;

select * from t where a<=>null and a is null;

drop table t;

