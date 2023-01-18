-- This test case verifies CBRD-24541 issue.
-- Core dump occurs when 'EXISTS' operation or 'count stop' is used for index scan of partitioned table.

drop table if exists ta, tb;
create table ta(a int, b char(10) default 'abc');
insert into ta(a, b) values(1, 'a');
insert into ta(a, b) values(2, 'b');
create table tb(a int, b char(10) default 'abc', primary key(a)) partition by hash(a) partitions 5;
insert into tb(a,b) values (1, 'e');
select ta.a, ta.b from ta ta where exists (select b from tb where tb.a = ta.a); 

drop table if exists tb, ta;
create table ta(a int, b char(10) default 'abc');
insert into ta(a, b) values(1, 'a');
insert into ta(a, b) values(2, 'b');
create table tb(a int, b char(10) default 'abc') partition by hash(a) partitions 5;
create index idx1 on tb(a);
insert into tb(a,b) values (1, 'e');
select ta.a, ta.b from ta ta where exists (select b from tb where tb.a = ta.a limit 1); 

drop table if exists ta, tb;
