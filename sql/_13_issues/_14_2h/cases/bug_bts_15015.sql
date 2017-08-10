--scenario1
drop table if exists t;
create table t(i int) comment 'table t';
create index idx on t(i) comment 'index';
 show indexes from t;
show create table t;
drop view if exist view1;
insert into t select rownum from db_root connect by level<=200;
 create view view1 as select i from t where i<=100;
alter view view1 comment 'view for table t';
show create view view1;
alter table t  comment 'table comparision';
 drop table t;
create table t(i int) comment 'table t';
create index idx on t(i) comment 'index';
 show indexes from t;
show create table t;
drop view if exist view1;
insert into t select rownum from db_root connect by level<=200;
 create view view1 as select i from t where i<=100;
alter view view1 comment 'view for table t';
show create view view1;
alter table t  comment 'table comparision';


--scenario2
drop table if exists t;
create table t(a int);
create view v as select * from t;
show create view v;
drop table if exists t;
create table t(a int);
show create view v;

--scenario3
drop table if exists t;
 
create table t (a int);
insert into t values (1);
create or replace view v as select * from t;
 
select * from v;
 
drop table t;
 
create table t (a int);
insert into t values (2);
 
/* expected to retrieve 2 */
select * from v;

drop table if exists t;
 
create table t (a int);
insert into t values (1);
create or replace view v as select * from t;
 
select * from v;
 
drop table t;
 
/* expected to raise an error(unknown class t) */
select * from v;

--scenario4
drop table if exists t, t1;
 
create table t (a int);
insert into t values (1);
create or replace view v as select * from t;
 
select * from v;
 
RENAME TABLE t AS t1;
 
/* expected to raise an error(unknown class t) */ 
select * from v;
 
create table t (a int);
insert into t values (2);
 
/* expected to retrieve 2 */ 
select * from v;
drop table if exists t;
 
create table t (a int);
insert into t values (1);
create or replace view v as select * from t;
 
select * from v;
 
ALTER TABLE t CHANGE a b int;
 
/* expected to raise an error(Class (t) does not have attribute a.) */ 
select * from v;
 
ALTER TABLE t CHANGE b a int;
 
/* expected to retrieve 1 */ 
select * from v;
drop table if exists t;
 
create table t (a int);
insert into t values (1);
create or replace view v as select * from t;
 
select * from v;
 
ALTER TABLE t DROP COLUMN a;
 
/* expected to raise an error(Class (t) does not have attribute a.) */ 
select * from v;
 
ALTER TABLE t ADD COLUMN a int;
 
/* expected to retrieve a record with NULL value */
select * from v;
drop table t;
drop view v;
drop view view1;
drop table t1;
