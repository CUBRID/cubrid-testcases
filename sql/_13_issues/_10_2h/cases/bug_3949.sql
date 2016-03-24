create table t1 (s1 varchar(10));
--[er]
create index i on t1(s1(0));
--[er]
prepare s from 'create index i on t1(s1(?))';
drop table t1;

create table t1 (s1 varchar(10));
--[er]
create index i on t1(s1(11));
drop table t1;


create table t1 (s1 varchar(10));
create index i on t1(s1(1));
drop index i on t1;

create index i on t1(s1(10));
drop index i on t1;
drop table t1;


create table t1 (s1 varchar(10));
-- 1022
create index i on t1(s1(1999999999));
-- 494
create index i on t1(s1(2000000000));
drop table t1;


