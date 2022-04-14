--+ holdcas on;
set system parameters 'compat_mode=mysql';

select 1;

create view v1 as select 1;
select * from v1;
drop view v1;

create view v1 as select 1 id;
select * from v1;
drop view v1;

create view v1 as select 1 id from db_root;
select * from v1;
drop view v1;

create or replace view v1 as select 1 id from db_root;
create or replace view v1 as select 2 id from db_root;
select * from v1;
drop view v1;

--id:123
create table t1 (a int, b int);
insert into t1 values (1,1),(2,2);
create view v1 as select * from t1;
insert into t1 values (3,3);
select * from v1 order by a asc;
drop view v1;


--bug
create view v2 as select 'a' as x;
select * from v2;
drop view v2;


--bug
create table t1 (a int, b int);
create view v2 as select * from t1;
--error line :should refuse create new view
create or replace view v2 as select * from v2;
select * from v2 order by a;
drop view v2;
drop table t1;

--no problem
create table t1 (a int, b int);
create view t1 as select * from t1 t1_new;
drop table t1;
drop view t1;

--bug
create table t1 (a int, b int);
create or replace view t1 as select * from t1;
select * from t1;
insert into t1 values (1,1);
drop table t1;
drop view t1;

--bug
create or replace view v11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111 as select 1 as result from db_root;
create table t1 like v11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
select * from t1;
drop view v11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;

create view v1 as select 1 as id from db_root;
create view v2 as select * from v1;
create view v3 as select * from v2;
create view v4 as select * from v3;
create view v5 as select * from v4;
create view v6 as select * from v5;
create view v7 as select * from v6;
create view v8 as select * from v7;
create view v9 as select * from v8;
create view v10 as select * from v9;
create view v11 as select * from v10;
create view v12 as select * from v11;
create or replace view v1 as select * from v12 x;
select * from v1;
select * from v2;
select * from v3;
select * from v4;
select * from v5;
select * from v6;
select * from v7;
select * from v8;
select * from v9;
select * from v10;
select * from v11;
select * from v12;
create table t1 like v1;
create table t2 as select * from v1;
drop view v1;
drop view v2;
drop view v3;
drop view v4;
drop view v5;
drop view v6;
drop view v7;
drop view v8;
drop view v9;
drop view v10;
drop view v11;
drop view v12;

create table t1 (a int, b int, c int);
create view v1 as select * from t1;
alter view v1 as select a from t1;
drop table t1;
drop view v1;


set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
