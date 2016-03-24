--+ holdcas on;

drop table if exists t1;
create table t1(a int, b int, c int);
insert into t1 values(1,1,1);
insert into t1 values(2,null,2);
insert into t1 values(2,null,2);
insert into t1 values(2,3,2);
insert into t1 values(2,2,2);

SELECT ifnull(b,10) b, b  FROM t1 GROUP BY b order by b;

SELECT ifnull(b,10) b, b ,count(*) FROM t1 GROUP BY b order by b;

SELECT ifnull(b,10) b, b ,count(*) FROM t1 GROUP BY a,b order by a,b;
SELECT ifnull(b,10) b, ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,ifnull(b,10) b,b ,count(*) FROM t1 GROUP BY a,b;

SELECT ifnull(b,10) b, b ,count(*) FROM t1 GROUP BY 1,2 order by 1,2;


drop table if exists t1;
---------------------------------------------------
drop table if exists student;
create table student(id int, name char(10));
insert into student values(1, 'a'),(3, 'a'),(2, 'b');
select max(id), name from student group BY 1=1 order by 1,2;

select max(id), name from student group by a order by 1,2;
select max(id), name from student where 1=1 order by 1,2;
select id, name from student where id =(select max(id) from student) order by 1,2;

drop table if exists student;
---------------------------------------------------

drop table if exists t1;
create table t1(a int, b int, c int);
insert into t1 values(2,null,2);
insert into t1 values(2,null,2);
--good
SELECT ifnull(b,10) b,b FROM t1 group by b order by 1,2;
--error
SELECT ifnull(b,10) b,b FROM t1 order by b;

drop table if exists t1;

---------------------------------------------------

drop table if exists participant2;
CREATE TABLE participant2 (host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT);

INSERT INTO participant2 VALUES (1988, 'NZL', 3, 2, 8);
INSERT INTO participant2 VALUES (1988, 'CAN', 3, 2, 5);
INSERT INTO participant2 VALUES (1996, 'KOR', 7, 15, 5);
INSERT INTO participant2 VALUES (2000, 'RUS', 32, 28, 28);
INSERT INTO participant2 VALUES (2004, 'JPN', 16, 9, 12);
INSERT INTO participant2 VALUES (2005, 'JPN', 16, 9, 12);

SELECT host_year, nation, gold,
MAX(gold) mx_gold
FROM participant2
WHERE nation LIKE 'J%'
group BY 1=1 order by 1,2,3,4;

drop table if exists participant2;
---------------------------------------------------


drop table if exists t1;
create table t1(a int, b int, c int);
insert into t1 values(1,1,1);
insert into t1 values(2,null,2);
insert into t1 values(2,2,2);

select a, nvl(b,2) as b from t1 group by a,b; order by 1,2

select a, nvl(b,999) as b from t1 group by a,b having b = 999 order by 1,2;

select a, nvl(b,3) as b from t1 order by b order by 1,2;

select a, nvl(b,3) as b, count(*) from t1 group by nvl(b,2) order by 1,2;

select a, nvl(b,3) as b, count(*) from t1 group by nvl(b,a) order by 1,2;

select a, nvl(b,3) as b, count(*) from t1 group by if(b is null, 2, b) order by 1,2;

select a, nvl(b,3) as b, count(*) from t1 group by nvl(b,2) having if(b is null, 999, b) = 999 order by 1,2;

select a, nvl(b,3) as b, count(*) from t1 group by nvl(b,2) having if(b is null, a, b) = 3 order by 1,2;

select a, b as bxx from t1 group by bxx having bxx is not null order by 1,2;

select a, nvl(b,3) as b, count(*) from t1 group by if(b is null, power(a,2), power(b,2)) order by 1,2;

select a as axx, nvl(b,3) as bxx, count(*) from t1 group by if(bxx is null, power(axx,2), power(bxx,2)) having power(axx, 2) > 1 order by 1,2;

select * from t1 where b in (select nvl(b,2) as b from t1 group by b) order by 1,2;

--errer--
select a, b from t1 where bxx = 1 order by 1,2;
select a, b from t1 group by bxx = 1 order by 1,2;

-- pt_name --
select a as b, count(*) from t1 group by b order by 1,2;
select a as bxx, count(*) from t1 group by bxx order by 1,2;
select a as bxx, count(*) from t1 group by bx order by 1,2;

-- pt_dot --
select a, b, count(*) from t1 group by t1.a order by 1,2;
select t1.a as b, count(*) from t1 group by t1.b order by 1,2;
select t1.a as bxx, count(*) from t1 group by b order by 1,2;
select t1.a as bxx, count(*) from t1 group by bxx order by 1,2;
select t1.a as bxx, count(*) from t1 group by t1.bxx order by 1,2;

-- pt_expr --
select a, nvl(b, 2) as b from t1 group by b order by 1,2;
select a, nvl(b, 2) as b from t1 group by t1.b order by 1,2;
select a, nvl(t1.b, 2) as b from t1 group by b order by 1,2;
select a, nvl(b, 2) as b from t1 group by power(b, 2) order by 1,2;
select a, nvl(b, 2) as txx from t1 group by power(txx,2) order by 1,2;
select a, nvl(b, 2) as b from t1 group by power(txx,2) order by 1,2;

-- pt_sort_spec --
select a, nvl(b, 2) as b from t1 group by 2 order by 1,2;
select a, b from t1 group by 2 order by 1,2;
select a, b from t1 group by 3 order by 1,2;
select a as 2, b from t1 group by 2 order by 1,2;

drop table if exists t1;
---------------------------------------------------

drop table if exists t;
create table t (a varchar(10) , b varchar(10) );
INSERT INTO t(a,b) VALUES ('Test Case', 'Show Me...'),('Test case', 'Show Me...'),('test Case', 'Show Me...');
INSERT INTO t(a,b) VALUES ('Test Case', null);
select a from t group by a order by 1;
select a, nvl(b, 2) as b from t as b group by a,b order by 1,2;
select a, nvl(b, null) as b from t as b group by a,b order by 1,2;
select a, nvl(b, null-1) as b from t as b group by a,b order by 1,2;
select a, nvl(b, 1+null) as b from t as b group by a,b order by 1,2;
drop table if exists t;


drop table if exists t1;
create table t1(a int, b int, c int);
insert into t1 values(2,null,2);
insert into t1 values(2,null,2);
--good
SELECT b b,b FROM t1 group by b order by 1,2;
--error
SELECT b b,b FROM t1 order by b;


drop table if exists t1;
create table t1(a int, b int, c int);
insert into t1 values(1,1,1);
insert into t1 values(2,null,2);
insert into t1 values(2,2,2);
select a, nvl(b, 3) as b from t1 as b group by a,b order by 1,2;
select a, nvl(b, 3) as b from t1 as b order by a,b;
---------------------------------------------------


drop table if exists t1,t2;
create table t1(a int,b int);
insert into t1 values(2,null);
insert into t1 values(3,null);


create table t2(a int,b int);
insert into t2 values(2,null);
insert into t2 values(3,null);

delete from t1,t2 where t1.a=2 group by a,b;

select a, nvl(b, 3) as b from t1 as b group by a,b order by 1,2;
select a, nvl(b, 3) as b from t1 as b order by a,b order by 1,2;
drop table if exists t1,t2;
---------------------------------------------------
drop table if exists t1,t2;
create table t1(id int, name varchar(20));
create table t2(id int, name varchar(20));
insert into t1 select 1, null;
insert into t1 select 2, null;
insert into t1 select 3, null;
insert into t2 select 1, null;
insert into t2 select 1, 'JOHN';
insert into t2 select 2, 'ARMI';
insert into t2 select 3, 'TAN';

update t1 a, t2 b
set a.name = b.name 
where a.id = b.id;

select * from t order by 1,2;
select * from t2 order by 1,2;
drop table if exists t1,t2;


--+ holdcas off;
commit;