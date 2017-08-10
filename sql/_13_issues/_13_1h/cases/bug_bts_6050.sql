drop if exists t1,t2; 

CREATE TABLE t1(x INTEGER);
CREATE TABLE t2(x bigint);

SELECT * from t1 where 1 in (1);
SELECT 1 IN (1);
SELECT 1 NOT IN (1);

SELECT 1 NOT IN (1);

SELECT 65535 NOT IN (65535);

SELECT 65535 IN (65535,65535,null);

SELECT 2+2 IN (65535,65535);

SELECT 2+2 IN (65535,65535,null);

SELECT 2-2 IN (65535,65535);

SELECT 2-65535 IN (65535,65535);

insert into t1 values(1),(2);
insert into t2 values(1),(2);

select 1,x from t1 where 1 in (select 1 from t2) order by x;

select 1,x from t1 where 1 in (select 1 from t2) order by x limit 1;

select 1 from t1 where 1 in (select 1 from t2) order by x limit 1;

drop t1,t2; 

CREATE TABLE t1(x INTEGER) partition by hash(x) partitions 2;
CREATE TABLE t2(x bigint) partition by hash(x) partitions 2;

SELECT * from t1 where 1 in (1);
SELECT 1 IN (1);
SELECT 1 NOT IN (1);

SELECT 1 NOT IN (1);

insert into t1 values(1),(2);
insert into t2 values(1),(2);

SELECT 65535 NOT IN (65535);

SELECT 65535 IN (65535,65535,null);

select 1,x from t1 where 1 in (select 1 from t2) order by x;

select 1,x from t1 where 1 in (select 1 from t2) order by x limit 1;

select 1 from t1 where 1 in (select 1 from t2) order by x limit 1;

drop t1,t2; 

