autocommit off;
create table t (a int);
create view v1 as select * from t where a > 3 with cascaded check option; 
create view v2 as select * from v1 where a > 10 ;
create view v as select * from v2 where a > 1 with local check option;
insert into v values (2);
rollback;
