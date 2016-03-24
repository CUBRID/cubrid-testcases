autocommit off;
create table t (a int);
create view v as select * from t where a > 5 with check option;
insert into v values (12);
update v set a = 3;
rollback;
