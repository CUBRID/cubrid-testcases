autocommit off;
create table t (a int)
create view v as select * from t where a > 5 with check option;
insert into v values (7)
update v set a = 8
rollback;
