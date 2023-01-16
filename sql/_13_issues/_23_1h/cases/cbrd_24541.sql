-- This test case verifies CBRD-24541 issue.
-- Core dump occurs when 'EXISTS' operation or 'count stop' is used for index scan of partitioned table.

drop table if exists t2, t1;
create table t1(a int, b char(10) default 'abc');
insert into t1(a, b) values(1, 'a');
insert into t1(a, b) values(2, 'b');
create table t2(a int, b char(10) default 'abc', primary key(a)) partition by hash(a) partitions 5;
insert into t2(a,b) values (1, 'e');
select t1.a, t1.b from t1 t1 where exists (select b from t2 where t2.a = t1.a); 

drop table if exists t2, t1;
create table t1(a int, b char(10) default 'abc');
insert into t1(a, b) values(1, 'a');
insert into t1(a, b) values(2, 'b');
create table t2(a int, b char(10) default 'abc') partition by hash(a) partitions 5;
create index idx1 on t2(a);
insert into t2(a,b) values (1, 'e');
select t1.a, t1.b from t1 t1 where exists (select b from t2 where t2.a = t1.a limit 1); 

drop table if exists t2, t1;
