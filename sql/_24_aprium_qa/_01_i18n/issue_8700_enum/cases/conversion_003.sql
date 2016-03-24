--conversion from string types to enum
--+ holdcas on;

drop table if exists t1;
create table t1(s1 char(5)  collate utf8_en_cs, s2 varchar  collate utf8_en_ci, s3 clob);
show full columns from t1;
insert into t1 values('char1', 'string1', 'clob1'), ('char2', 'string2', 'clob2'), ('char3', 'string3', 'clob3');

create table t2(e1 enum('char1', 'char2', 'char3') collate utf8_en_cs, e2 enum('string1', 'string2', 'string3')  collate utf8_en_ci, e3 enum('clob1', 'clob2', 'clob3')  collate utf8_en_cs);
show full columns from t2;

insert into t2 select * from t1;

select s1, s2, cast(s3 as varchar) from t1 order by 1, 2;
select * from t2 order by 1, 2;

drop table t1;

create table t1 as select * from t2;
show full columns from t1;
select * from t1 order by 1,2,3;

drop table t1;
drop table t2;

select cast(_utf8'a' as enum(_utf8'a', _utf8'b', _utf8'c'));
create table t2 as select cast(_utf8'a' as enum(_utf8'a', _utf8'b', _utf8'c')) a;
show full columns from t2;
select * from t2 order by 1;
drop table t2;

select cast(cast(_iso88591'a' as enum(_iso88591'a', _iso88591'b', _iso88591'c')) as int);
create table t2 as select cast(cast(_iso88591'a' as enum(_iso88591'a', _iso88591'b', _iso88591'c')) as int) a;
show full columns from t2;
select * from t2 order by 1;
drop table t2;

select cast(cast(_utf8'a' as enum('a', 'b', 'c') charset utf8) as varchar);
create table t2 as select cast(cast(_utf8'a' as enum('a', 'b', 'c') charset utf8) as varchar) a;
show full columns from t2;
select * from t2 order by 1;
drop table t2;

commit;
--+ holdcas off;
