--01_if_exists_003.sql
--+ holdcas on;
autocommit on;

DROP TABLE if exists t1;
drop serial if exists t1_serial;
create serial t1_serial increment by 1;
create table t1 ( a int);
insert into t1 select t1_serial.next_value from db_class a, db_class b, db_class c limit 10;

autocommit off;
drop serial if exists t1_serial;
rollback;
insert into t1 select t1_serial.next_value from db_class a, db_class b, db_class c limit 10;
select count(*) from t1;

DROP TABLE if exists t1;
drop serial if exists t1_serial;

autocommit on;
--+ holdcas off;
commit;
