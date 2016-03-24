autocommit off;
create table t (a int);
create view v1 as select * from t where a > 10 with check option;
create view v as select * from v1 where a > 5 with cascaded check option;
insert into v values (7);
rollback;
