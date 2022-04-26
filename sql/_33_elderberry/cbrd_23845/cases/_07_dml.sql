/*
 * Test Group #6: Use SYNONYM.
 */

create user u1;
call login ('u1') on class db_user;
drop table if exists t1;
drop synonym if exists s1;
create table t1 (c1 int);
insert into t1 values (1),(2),(3);
create synonym s1 for t1;
select * from db_synonym order by 1;
select * from s1;

--err case
create table s1 (c1 int);
alter table s1 add column c2 int;
rename table s1 to s2;
drop table s1;
create index i1 on s1 (c1);

--view
create view v1 as select * from s1;
select * from v1;
insert into s1 values (4);
select * from s1;
update s1 set c1 = 2 where c1=1;
select * from s1;
delete from s1 where c1 = 3;
select * from s1;
--err case
truncate s1;
select * from s1;

--cte
insert into s1 values (10);
with cte1 as (select * from s1)
select * from cte1;

create table t2 (c1 int);
insert into t2 values (-1);
with s1 as (select * from t2)
select * from s1;

call login ('dba') on class db_user;
drop synonym u1.s1;
drop view u1.v1;
drop table u1.t2;
drop table u1.t1;
drop user u1;
