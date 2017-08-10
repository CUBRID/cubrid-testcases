--01_nulls_first_last_003.sql

--Test null position
--+ holdcas on;
drop table if exists t;
create table t (a int, b varchar);

insert into t values
(1,null),
(2,null),
(3,'ab'),
(4,null),
(5,'ab'),
(6,null),
(7,'abcd'),
(8,null),
(9,'abcd'),
(10,null);


select * from t order by b nulls first ,a desc;
select * from t order by b nulls last ,a desc;

update t set b='xx' where a=6;
update t set b=null where a=6;
delete from t where a=6;
insert into t values (6,null);

select * from t order by b nulls first ,a desc;
select * from t order by b nulls last ,a desc;
drop table if exists t;

--Test null position
drop table if exists t;
create table t (a int, b varchar);

insert into t values
(1,null),
(2,null),
(3,'ab'),
(4,null),
(5,'ab'),
(6,null),
(7,'abcd'),
(8,null),
(9,'abcd'),
(10,null);

select * from t where b is null order by b,a desc;
select * from t where b is null order by b asc,a desc;
select * from t where b is null order by b desc,a desc;

select * from t where b is null order by b nulls first,a desc;
select * from t where b is null order by b nulls last,a desc;
select * from t where b is null order by b desc nulls first ,a desc;
select * from t where b is null order by b desc nulls last , a desc;

update t set b='xx' where a=6;
update t set b=null where a=6;
delete from t where a=6;
insert into t values (6,null);


select * from t where b is null order by b ,a desc;
select * from t where b is null order by b asc ,a desc;
select * from t where b is null order by b desc ,a desc;

select * from t where b is not null order by b nulls first ,a desc;
select * from t where b is not null order by b asc nulls first ,a desc;
select * from t where b is not null order by b desc nulls first, a desc;

select * from t where b is not null order by b nulls last, a desc;
select * from t where b is not null order by b asc nulls last, a desc;
select * from t where b is not null order by b desc nulls last,a desc;

drop table if exists t;

--Test nulls key word
drop table if exists t;
create table t (a int, nulls varchar);

insert into t values
(1,null),
(2,null),
(3,'ab'),
(4,null),
(5,'ab'),
(6,null),
(7,'abcd'),
(8,null),
(9,'abcd'),
(10,null);


select * from t order by nulls nulls first, a desc;
select * from t order by nulls nulls last,a desc;
select * from t where nulls is null order by nulls nulls last,a desc;
select * from t where nulls is null order by 2 nulls last ,a desc;
select * from (select * from t where nulls is null order by 2 nulls last) where nulls is null order by 2 nulls last ,a desc;
select * from (select * from t where nulls is null order by 2 nulls last) where nulls is null order by nulls nulls last,a desc;
select * from (select * from t where nulls is null order by 2 nulls last) where nulls is not null order by nulls nulls last,a desc;
select * from (select * from t where nulls is null order by 2 nulls last) where nulls is not null order by nulls nulls first,a desc;

drop table if exists t;

--Test nulls first last key word
drop table if exists t;
create table t (a int, "nulls first" varchar);

insert into t values
(1,null),
(2,null),
(3,'ab'),
(4,null),
(5,'ab'),
(6,null),
(7,'abcd'),
(8,null),
(9,'abcd'),
(10,null);


select * from t order by "nulls first" nulls first,a desc;

drop table if exists t;

drop table if exists t;
create table t (a int, "nulls last" varchar);

insert into t values
(1,null),
(2,null),
(3,'ab'),
(4,null),
(5,'ab'),
(6,null),
(7,'abcd'),
(8,null),
(9,'abcd'),
(10,null),
(11,ucase(null));


select * from t order by "nulls last" nulls last,a desc;

select a,"nulls last" as nulls from t order by nulls nulls last,a desc;
select a,"nulls last" as nulls from t order by nulls nulls first,a desc;

select * from t order by "nulls last" nulls last group by 2;

--bug
--select * from t group by 2 order by 2 nulls last ;

select group_concat(a order by a), "nulls last" from t group by 2 order by "nulls last" nulls first ;

create view abc as select a,"nulls last" as nulls from t order by nulls nulls first ,a desc;
select * from abc;
drop abc;

create view abc as select a,"nulls last" as nulls from t order by nulls nulls last,a desc ;
select * from abc;
drop abc;

select a,"nulls last" as nulls from t order by nulls nulls last,a desc limit 1;
select a,"nulls last" as nulls from t order by nulls nulls first,a desc  limit 1;

drop table if exists t;

--Test function

drop table if exists t;
create table t (a int, "nulls last" varchar);

insert into t values
(null,null),
(2,null),
(null,'ab'),
(4,null),
(5,'ab'),
(6,null),
(7,'abcd'),
(8,null),
(9,'abcd'),
(10,null);


select * from t order by 1,2;
select * from t order by 1 desc, 2;

select * from t order by 1,2;
select * from t order by 1 desc ,2 desc;

select * from t order by 1,2 nulls first;
select * from t order by 1,2 nulls last;

select * from t order by 1 desc ,2 desc  nulls first;
select * from t order by 1 desc ,2 desc  nulls last;

select * from t order by 1 desc nulls first ,2 desc  nulls first;
select * from t order by 1 desc nulls first ,2 desc  nulls last;
select * from t order by 1 desc nulls last ,2 desc  nulls last;
select * from t order by 1 desc nulls last ,2 desc  nulls first;


drop table if exists t;
commit;
--+ holdcas off;
