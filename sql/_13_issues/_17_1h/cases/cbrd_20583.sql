--+ holdcas on;

drop table if exists t;

drop table if exists t1;

CREATE TABLE t1(s1 varchar, s2 string);

INSERT INTO t1 VALUES (repeat('abc',1000), repeat('abc',1000));

SELECT * FROM t1 CONNECT BY PRIOR s1=s2;

SELECT * FROM t1 CONNECT BY NOCYCLE PRIOR s1=s2;  

CREATE TABLE t(s1 varchar, s2 string);

INSERT INTO t VALUES (repeat('abc',500), repeat('def',200));

INSERT INTO t VALUES (repeat('mmm',500), 'test');

INSERT INTO t VALUES (repeat('o',100), repeat('mmm',500));

SELECT * FROM t CONNECT BY PRIOR s1=s2 order by 1;

SELECT * FROM t where s1>'aaa' START WITH s2='test' CONNECT BY PRIOR s1=s2 order by 1;

SELECT s1,s2,CONNECT_BY_ISLEAF FROM t where s1>'aaa' START WITH s2='test' CONNECT BY PRIOR s1= prior s2 order by 1;

SELECT t1.s1,t2.s2, level FROM t t1 inner join t t2 on t1.s1=t2.s1 start with t2.s2='test' CONNECT BY PRIOR t1.s1=t1.s2 order by 1;

drop table t1;

drop table t;

--+ holdcas off;