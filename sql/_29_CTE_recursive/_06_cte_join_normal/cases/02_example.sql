  
drop table if exists t1,t2,t3;  
CREATE TABLE t1 (a INT);
CREATE TABLE t2 (a INT);
CREATE TABLE t3 (a INT);
INSERT INTO t1 VALUES (1),(2),(3);
INSERT INTO t2 VALUES (1),(2),(3);
INSERT INTO t3 VALUES (1),(2),(3);

--ERROR ER_PARSE_ERROR
SELECT * FROM (WITH a AS (SELECT * FROM t1) (t2 NATURAL JOIN t3));

--correct
WITH a AS (SELECT * FROM t1) SELECT * FROM t2 NATURAL JOIN t3;
SELECT * FROM (WITH a AS (SELECT * FROM t1) SELECT * FROM t2 NATURAL JOIN t3) AS d1 order by 1;

DROP TABLE t1,t2,t3;


drop if exists t1;
drop if exists v1;
create table t1 (a int);
insert into t1 values (20), (30), (10);
create view v1 as select * from t1 where a > 10;

with t1 as (select * from v1) select * from t1 order by 1;

drop view v1;
drop table t1;

drop table if exists ten, one_k;
create table ten(a int primary key);
insert into ten values (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
 
create table one_k(a int primary key);
insert into one_k select A.a + B.a* 10 + C.a * 100 from ten A, ten B, ten C;
 
create view v1 as select * from ten;

select * from v1 order by 1;

drop view v1;
drop table ten, one_k;

DROP TABLE if exists t1,t2,t3;
CREATE TABLE t1 (i1 INT,primary KEY(i1));
INSERT INTO t1 VALUES (4),(8);
                        
CREATE TABLE t2 (a2 INT, b2 INT, primary KEY(b2));
INSERT INTO t2 VALUES (8,7);
            
CREATE TABLE t3 (i3 INT);
INSERT INTO t3 VALUES (2),(6);
 
SELECT * FROM t1, t2 WHERE a2 = i1 and b2 >= i1 AND i1 IN ( SELECT i3 FROM t3 )
UNION
SELECT * FROM t1, t2 WHERE a2 = i1 and b2 >= i1 AND i1 IN ( SELECT i3 FROM t3 )
;
DROP TABLE t1,t2,t3;

drop table if exists  employees;
create table employees (
  name varchar(32),
  dept varchar(32),
  country varchar(8)
);
 
insert into employees 
values 
('Sergei Golubchik', 'Development', 'DE'),
('Claudio Nanni', 'Support', 'ES'),
('Sergei Petrunia', 'Development', 'RU');

with eng as 
(
   select * from employees
   where dept in ('Development','Support')
),
eu_eng  as 
(
  select * from eng where country IN ('DE','ES','RU')
)
select * from eu_eng T1 
where 
  not exists (select 1 from eu_eng T2 
              where T2.country=T1.country
              and T2.name <> T1.name)
order by 1,2;

drop table employees;
