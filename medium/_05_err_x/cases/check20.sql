autocommit off;
create table t (a int)
create table t2 (b t)
create view v as select * from t where a > 10 with local check option;
create view v2 (b v) as select * from t2;
insert into v2 values (insert into v values (4));
rollback;
