autocommit off;
create table t (a int);
create view v1 as select * from t where a > 5 with check option;
create view v as select * from v1 where a > 10 with local check option;
insert into v values (12);
update v set a = 7;
rollback;
