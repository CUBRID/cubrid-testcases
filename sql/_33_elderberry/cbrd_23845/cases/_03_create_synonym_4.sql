/* Test7: use the same name for synonym, table, and view */
call login ('dba') on class db_user;
drop table if exists t1;
drop table if exists t2;
drop view if exists v1;
drop synonym if exists s1;
create table t1 (c1 varchar, c2 int);
create table t2 (c1 varchar, c2 int);
create view v1 as select * from t1;
create synonym s1 for t1;

--err case
create table s1 (c1 int);
create view s1 as select * from t1;
create synonym t1 for t2;
create synonym v1 for t1;


call login ('dba') on class db_user;
drop synonym if exists s1;
drop view if exists v1;
drop table if exists t1;
drop table if exists t2;

select * from db_synonym;
select * from db_class where is_system_class = upper ('NO');
