--02_first_last_bug_from_web_001.sql
drop table if exists t;
CREATE TABLE T
(
ID VARCHAR(5),
NAME VARCHAR(10)
);

ALTER TABLE t ADD CONSTRAINT pk_t PRIMARY KEY(ID);

Insert into t (ID, NAME) Values ('ab', 'x');
Insert into t (ID, NAME) Values ('bc', 'x');
Insert into t (ID, NAME) Values ('s', 'x');
Insert into t (ID, NAME) Values ('f', 'x');
Insert into t (ID) Values ('g');

SELECT *
FROM t
WHERE name = 'x'
ORDER BY id asc NULLS first;

SELECT /*+ full(t) */ *
FROM t
WHERE name = 'x'
ORDER BY id asc NULLS first;

drop table if exists t;

drop table if exists tab;
create table tab(id numeric,resp varchar(50), constraint pk_tab unique (resp));
insert into tab values(1,'Pippo');
insert into tab values(3,'topolino');
insert into tab values(7,'Zio Paperone');

select * from tab order by resp nulls first;
select * from tab order by resp nulls last;

ALTER TABLE tab drop CONSTRAINT PK_tab ;
alter table tab add (constraint pk_tab unique (id));
select * from tab order by id;
select * from tab order by id nulls first;

ALTER TABLE tab drop CONSTRAINT PK_tab;
alter table tab add (constraint pk_tab primary key (id));
select * from tab order by id;
select * from tab order by id nulls first;
select * from tab order by id desc nulls first;
select * from tab order by id desc nulls last;

drop table if exists tab;

select 1 as test
union all
select 2
union all
select NULL
union all
select 3
union all
select 4
order by test nulls first;

select 1 as test
union all
select 2
union all
select NULL
union all
select 3 
union all
select 4
order by test nulls last;

select 1 as test
union all
select 2
union all
select NULL order by 1 nulls first
union all
select 3 
union all
select 4
order by test nulls last;

select 1 as test
union all
select 2
union all
select NULL order by 1 nulls last
union all
select 3 
union all
select 4
order by test nulls last;

DROP TABLE if exists #sorttest;

CREATE TABLE #sorttest(test int);
INSERT INTO #sorttest values(1);
INSERT INTO #sorttest values(5);
INSERT INTO #sorttest values(4);
INSERT INTO #sorttest values(NULL);
INSERT INTO #sorttest values(3);
INSERT INTO #sorttest values(2);
SELECT test
FROM #sorttest
ORDER BY CASE WHEN test IS NULL THEN 1 ELSE 0 END, test;

DROP TABLE if exists #sorttest;

CREATE TABLE #sorttest(test int);
INSERT INTO #sorttest values(1);
INSERT INTO #sorttest values(5);
INSERT INTO #sorttest values(4);
INSERT INTO #sorttest values(NULL);
INSERT INTO #sorttest values(3);
INSERT INTO #sorttest values(2);

SELECT test
FROM (select * from #sorttest order by 1)
ORDER BY CASE WHEN test IS NULL THEN 1 ELSE 0 END asc;

SELECT test
FROM (select * from #sorttest order by 1)
ORDER BY CASE WHEN test IS NULL THEN 1 ELSE 0 END nulls last;

--bug
--SELECT test
--FROM #sorttest
--ORDER BY CASE WHEN test IS NULL THEN 1 ELSE 0 END nulls first;


SELECT test
FROM (select * from #sorttest order by 1)
ORDER BY CASE WHEN test IS NULL THEN 1 ELSE 0 END desc;

SELECT test
FROM (select * from #sorttest order by 1)
ORDER BY CASE WHEN test IS NULL THEN 1 ELSE 0 END desc nulls first;

--bug
--SELECT test
--FROM #sorttest
--ORDER BY CASE WHEN test IS NULL THEN 1 ELSE 0 END desc nulls last;

DROP TABLE if exists #sorttest;
