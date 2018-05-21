--+ holdcas on;
drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,2,2); 
--
SELECT a, b
        FROM t1 
        GROUP BY a, b with rollup order by 1,2;

SELECT a, b
        FROM t1 
        GROUP BY a, b with rollup order by a,b;

SELECT a, ifnull(b,2) AS b 
        FROM t1 
        GROUP BY a, b with rollup order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 
        GROUP BY a, b with rollup order by a,b;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b=2
        GROUP BY a, b with rollup order by a,b;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b is null
        GROUP BY a, b order by a,b;

--

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx with rollup order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx with rollup order by a,bxx;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx=2
        GROUP BY a, bxx with rollup order by a,bxx;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, bxx with rollup order by a,bxx;

SELECT a, ifnull(b,3) AS bxx 
        FROM t1 where b =2
        GROUP BY a, bxx with rollup order by a,bxx;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx with rollup order by a,bxx;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx is null
        GROUP BY a, bxx with rollup order by a,bxx;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where ifnull(b,2)=2
        GROUP BY a, bxx with rollup order by a,bxx;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where ifnull(bxx,2)=2
        GROUP BY a, bxx with rollup order by a,bxx;

--
SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, b order by a,b;

SELECT a, ifnull(b,-1) AS bxx 
        FROM t1 
        GROUP BY a, b order by a,b;

SELECT a, ifnull(b,4) AS bxx 
        FROM t1 
        GROUP BY a, b order by a,b;


SELECT a, ifnull(b,4) AS bxx 
        FROM t1 
        GROUP BY a, b order by a,bxx;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, b order by a,b;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, bxx order by a,bxx;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx order by a,bxx;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, b order by a,b;

drop table if exists t1;
---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,NULL,2);
INSERT INTO t1 VALUES(2,2,2); 
INSERT INTO t1 VALUES(2,2,2); 

SELECT a, b
        FROM t1 where b is not null
         GROUP BY a, b order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b is null
        GROUP BY a, b order by 1,2;


--
SELECT a, ifnull(b,2) AS b 
        FROM t1 
        GROUP BY a, b order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b=2
        GROUP BY a, b order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b<>2
        GROUP BY a, b;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b is null
        GROUP BY a, b order by 1,2;

--
SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx=2
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,3) AS bxx 
        FROM t1 where b =2
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, b order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx is null
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where ifnull(b,2)=2
        GROUP BY a, bxx order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where ifnull(bxx,2)=2
        GROUP BY a, bxx order by 1,2;

--
SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, b order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, b order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, bxx order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,3) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, b order by 1,2;

drop table if exists t1;
---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,2,2); 

SELECT a, NVL(b,2) AS b 
        FROM t1 
        GROUP BY a, b order by 1,2;

SELECT a, NVL(b,2) AS b 
        FROM t1 
        GROUP BY a, b order by 1,2 ;

SELECT a, NVL(b,2) AS b 
        FROM t1 
        GROUP BY a, b having b=2 order by 1,2;

SELECT a, NVL(b,2) AS bxxx 
            FROM t1 
            GROUP BY a, bxxx order by 1,2;

SELECT a, NVL(b,2) AS bxxx 
            FROM t1 
            GROUP BY a, bxxx having bxxx=2 order by 1,2;

SELECT a, NVL(b,3) AS bxxx 
            FROM t1 
            GROUP BY a, bxxx having bxxx=2 order by 1,2;

SELECT a, NVL(b,2) AS bxxx 
            FROM t1 
            GROUP BY a, bxxx having b=2 order by 1,2;

SELECT a, NVL(b,2) AS bxxx 
            FROM t1 
            GROUP BY a, b order by 1,2;

SELECT a, NVL(b,2) AS bxxx 
            FROM t1 
            GROUP BY a, b having b=2 order by 1,2;

SELECT a, NVL(b,2) AS bxxx 
            FROM t1 
            GROUP BY a, b having bxxx=2 order by 1,2;

drop table if exists t1;
---------------------------------------------------

drop table if exists t1;
drop view v1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,2,2); 

create view v1 as select tx.a a ,tx.b b from t1 tx join t1 txx on tx.a=txx.a;
select a,ifnull(b,2) b from v1 group by a,b order by 1,2;
select a,ifnull(b,2) b from v1 group by a,b having b=2 order by 1,2;

select a,ifnull(b,2) bxx from v1 group by a,bxx order by 1,2;

select a,ifnull(b,2) b from v1 group by a,b having b=2 order by 1,2;
select a,ifnull(b,2) bxx from v1 group by a,bxx having b=2 order by 1,2;

select a,ifnull(b,10) b from v1 group by a,b order by 1,2;
select a,ifnull(b,10) bxx from v1 group by a,bxx order by 1,2;

select ifnull(b,10) bxx from v1 group by bxx order by 1,2;

select txx.b b from t1 tx join t1 txx on tx.a=txx.a group by b order by 1,2;
drop table if exists t1;
drop view v1;
---------------------------------------------------


drop table if exists t1;
drop table if exists t2;
CREATE TABLE t1 (a INT, b INT);
CREATE TABLE t2 (a INT, d INT);
INSERT INTO t1 VALUES (1,9), (2, 8), (3, 7),(null,1),(null,1),(1,null),(2,null);
INSERT INTO t2 VALUES (1,9), (2, 8), (3, 7),(null,1),(null,1),(1,null),(2,null);
select txx.d b from t1 tx join t2 txx on tx.a=txx.a group by b order by 1,2;


select ifnull(tx.b,20) b from t1 tx join t1 txx on tx.a=txx.a group by b order by 1,2;


INSERT INTO t1 VALUES (1,9), (2, 8), (3, 7),(null,1),(null,1),(1,null),(2,null);
SELECT b FROM t1 where b is null GROUP BY b order by 1,2;

select txx.b b from t1 tx join t1 txx group by b order by 1,2;
select tx.a b, txx.b b from t1 tx join t1 txx group by b order by 1,2;
SELECT min(a) b, b ,count(*) FROM t1 where b is null GROUP BY b order by 1,2;
SELECT min(a) b, ifnull(b,10) b ,count(*) FROM t1 where b is null GROUP BY b order by 1,2;
SELECT min(a) b, b , b , min(a) a, count(*) FROM t1 where b is null GROUP BY b order by 1,2;
SELECT a b, b , b , a, count(*) FROM t1 where b is null GROUP BY a,b order by 1,2;
SELECT a b, b ,count(*) FROM t1 where b is null GROUP BY a,b order by 1,2;

SELECT a b, b ,count(*) FROM t1 where b=null GROUP BY b order by 1,2;
SELECT a b, b ,count(*) FROM t1 where b=1 GROUP BY b order by 1,2;
SELECT min(a) b, b ,count(*) FROM t1 GROUP BY b order by 1,2;
SELECT min(a) b, b ,count(*) FROM t1 GROUP BY b + 0 order by 1,2;

SELECT ifnull(min(a),10) b, b ,count(*) FROM t1 GROUP BY b order by 1,2;

SELECT ifnull(a,10) b, b ,count(*) FROM t1 GROUP BY a,b order by 1,2;


drop table if exists t1;
drop table if exists t2;
---------------------------------------------------

--good
drop table if exists t1;
CREATE TABLE t1 (a INT, b INT);
INSERT INTO t1 VALUES (null,1),(null,1),(1,null),(2,null);
SELECT a b, b ,count(*) FROM t1 GROUP BY b order by 1,2;
SELECT a b, b ,count(*) FROM t1 GROUP BY b + 0 order by 1,2;

select * from t1 order by 1,2;
SELECT ifnull(a,10) b, b ,count(*) FROM t1 GROUP BY b order by 1,2;
SELECT ifnull(a,10) b, b ,count(*) FROM t1 GROUP BY b +0 order by 1,2;
SELECT ifnull(a,10) b, b ,count(*) FROM t1 GROUP BY a,b order by 1,2;

drop table if exists t1;


--+ holdcas off;
commit;
