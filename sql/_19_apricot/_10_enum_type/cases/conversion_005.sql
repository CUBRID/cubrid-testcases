--conversion from string types to enum
create table t1(s1 char(5), s2 varchar, s3 clob);
insert into t1 values('char1', 'string1', 'clob1'), ('char2', 'string2', 'clob2'), ('char3', 'string3', 'clob3');

create table t2(e1 enum('char1', 'char2', 'char3'), e2 enum('string1', 'string2', 'string3'), e3 enum('clob1', 'clob2', 'clob3'));
insert into t2 select * from t1;

select s1, s2, cast(s3 as varchar) from t1 order by 1, 2;
select * from t2 order by 1, 2;

select cast('a' as enum('a', 'b', 'c'));
select cast(cast('a' as enum('a', 'b', 'c')) as int);
select cast(cast('a' as enum('a', 'b', 'c')) as varchar);

drop table t1;
drop table t2;