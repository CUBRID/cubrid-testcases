--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1 (a int);
insert into t1 values (1),(2),(3); 
alter table t1 add column b int primary key; 
drop table t1;

create table t1 (a int);
insert into t1 values (1),(2); 
alter table t1 add column b int not null; 
select count(*) from t1 where b is null;
drop table t1;

create table t1 (a int);
insert into t1 values (1),(2); 
alter table t1 add column b int unique key;
select count(*) from t1 where b is null;
drop table t1;

create table t1 (a int);
insert into t1 values (1),(2); 
alter table t1 add column b int unique; 
select count(*) from t1 where b is null;
drop table t1;

create table t1 (a int not null, b int);
insert into t1(b) values (1);
drop table t1;

create table t1 (a int primary key);
create table t2 (a int);
insert into t2 values (1), (2), (3), (3); 
insert into t1 select * from t2;
select count(*) from t1;
drop table t1;
drop table t2;


--CUBRIDSUS-3083[Original]
create table t1 (a int);
insert into t1 values (1),(2); 
alter table t1 add column b int unique key;
update t1 set b=1 where b is null;
select count(*) from t1 where b is null;
drop table t1;


create table t1 (a int);
insert into t1 values (1),(2);
alter table t1 add column b int unique key;
create table t2 (a int,b int);
insert into t2(a,b) values (3,1), (4,1); 
insert into t1(a,b) select a,b from t2;
drop table t1;
drop table t2;

--CUBRIDSUS-3083[QA Effort]
create table foo (a int unique);
insert into foo values (null);
insert into foo values (null);
update foo set a=3 where a is null; 
select * from foo; 
drop table foo;


set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
