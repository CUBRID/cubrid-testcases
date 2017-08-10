--+ holdcas on;
--Common Usage
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


select * from t order by b nulls first,a desc;
select * from t order by b nulls last,a desc;

select * from t order by b asc nulls first,a desc;
select * from t order by b asc nulls last,a desc;

select * from t order by b desc nulls  first,a desc;
select * from t order by b desc nulls last,a desc;

select * from t order by 1 asc nulls  first;
select * from t order by 1 asc nulls last;

select * from t order by 1 desc nulls  first;
select * from t order by 1 desc nulls last; 

drop table if exists t;


--Max Min function usage
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
(10,0);


select * from t order by b,a desc;
select * from t order by b desc,a desc;

select * from t order by b nulls first,a desc;
select * from t order by b nulls last,a desc;

select * from t order by b desc nulls first,a desc;
select * from t order by b desc nulls last, a desc;

select max(b) as c from t order by c nulls first;
select max(b) as c from t order by c nulls last;
select max(b) as c from t order by c desc nulls first;
select max(b) as c from t order by c desc nulls last;
select min(b) as c from t order by c desc nulls first;
select min(b) as c from t order by c desc nulls last;

select * from t order by b desc nulls last,a desc;
select * from (select * from t order by b desc nulls last) order by b desc nulls last,a desc;
select * from(select * from (select * from t order by b desc nulls last) order by b desc nulls last) order by b desc nulls last,a desc;
select * from(select * from(select * from (select * from t order by b desc nulls last) order by b desc nulls last) order by b desc nulls last) order by b desc nulls first ,a desc;


drop table if exists t;


--Exception Usage
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

select * from t order by b nulls  desc first;
select * from t order by b nulls  desc last;

select * from t order by b nulls desc first;
select * from t order by b nulls desc last;

select * from t order by b nulls      first  desc;
select * from t order by b nulls   last   desc;

select * from t order by b nulls  first desc;
select * from t order by b nulls last desc;

select * from t order by b nulls nulls last desc;
select * from t order by b nulls nulls last;

select * from t order by b nulls (nulls last);

drop table if exists t;



--SELECT DISTINCT Usage
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

select * from t order by b nulls first,a desc;
select * from t order by b nulls last,a desc;

select * from t order by b asc nulls first,a desc;
select * from t order by b asc nulls last,a desc;


SELECT DISTINCT b from t order by b desc nulls  first;
SELECT DISTINCT b from t order by b asc nulls last;

SELECT DISTINCT b from t order by b desc nulls  last;
SELECT DISTINCT b from t order by b asc nulls first;

SELECT /*+ RECOMPILE ORDERED USE_IDX */ DISTINCT b  from t order by b desc nulls  last;
SELECT /*+ RECOMPILE ORDERED USE_IDX */ DISTINCT b  from t order by b asc nulls first;

SELECT /*+ RECOMPILE ORDERED USE_IDX */ *  from t order by b asc nulls first,a desc;
SELECT /*+ RECOMPILE ORDERED USE_IDX */ *  from t order by b asc nulls last,a desc;
drop table if exists t;
commit;
--+ holdcas off;
