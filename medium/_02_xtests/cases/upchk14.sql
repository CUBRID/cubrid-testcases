autocommit off;
create table t (a int)
create view v1 as select * from t where a > 10 ;
create view v as select * from v1 where a > 5 with local check option;
insert into v values (7)
select * from v
rollback;
