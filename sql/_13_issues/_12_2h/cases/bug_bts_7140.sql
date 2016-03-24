--+ holdcas on;

create table t1 (c1 int, c2 int, c3 int, c4 int);
insert into t1 values (1, 1, 1, 11);
insert into t1 values (1, 2, 1, 12);
insert into t1 values (1, 3, 2, 13);
insert into t1 values (2, 1, 1, 14);
insert into t1 values (2, 2, 2, 15);
insert into t1 values (2, 3, 1, 16);
insert into t1 values (2, 1, 2, 17);
insert into t1 values (2, 2, 1, 18);
create view v1 
as 
select * from t1 order by c1,c2,c3;
select * from v1;
select c1, c4, c2, c3 from v1;
select c4 from v1;
select c4 from v1 order by c4;

--case 2
CREATE TABLE t21 (c1 INT, c2 INT);
CREATE TABLE t22 (d1 INT, d2 INT);

INSERT INTO t21 VALUES (1,1);
INSERT INTO t21 VALUES (1,2);
INSERT INTO t21 VALUES (1,3);
INSERT INTO t21 VALUES (1,4);
INSERT INTO t21 VALUES (5,8);
INSERT INTO t21 VALUES (5,9);

INSERT INTO t22 VALUES (2,1);
INSERT INTO t22 VALUES (2,2);
INSERT INTO t22 VALUES (2,3);
INSERT INTO t22 VALUES (2,4);
INSERT INTO t22 VALUES (5,8);
INSERT INTO t22 VALUES (5,9);

CREATE VIEW v2 as
SELECT * FROM t21 UNION SELECT * FROM t22 order by 2 desc;


SELECT * FROM v2;
SELECT c1 FROM v2;
SELECT c2 FROM v2; 
SELECT c1 FROM v2 ORDER BY c1;



CREATE VIEW v3 as
SELECT * FROM (SELECT * FROM t21 UNION SELECT * FROM t22) AS t ORDER BY 2 desc;

SELECT * FROM v3;
SELECT c1 FROM v3;

SELECT c2 FROM v3;


SELECT c1 FROM v3 ORDER BY c1;
CREATE VIEW v4 as
SELECT * FROM t21 UNION  SELECT * FROM t22 UNION  SELECT c3,c4 FROM t1 ORDER BY 1 desc;

SELECT * FROM v4;
SELECT c2 FROM v4;
SELECT * FROM v4 ORDER BY c2;


CREATE VIEW v5 as
SELECT * FROM t21 DIFFERENCE SELECT * FROM t22 order by 2 desc;

SELECT * FROM v5;
SELECT c2 FROM v5;
SELECT c2 FROM v5 ORDER BY c2;

CREATE VIEW v6 as
SELECT * FROM (SELECT * FROM t21 UNION SELECT * FROM t22 ORDER BY 2 DESC) AS t UNION  SELECT c3,c4 FROM t1 ORDER BY 1;

SELECT * FROM v6;
SELECT c1 FROM v6;

SELECT c2 FROM v6;
SELECT c2 FROM v6 ORDER BY c2 desc;
create view v7 as 
SELECT c1, c2, c4 FROM t1 ORDER BY c2 FOR ORDERBY_NUM() BETWEEN  2 AND 6 ;

SELECT * FROM v7;
SELECT c4 FROM v7;

SELECT c4 FROM v7 order by c4;

CREATE VIEW v8 as
SELECT * FROM t21 UNION SELECT * FROM t22 ORDER BY c2 DESC FOR ORDERBY_NUM() BETWEEN 3 AND 7;

SELECT * FROM v8;
SELECT * FROM v8 ORDER BY c1;

CREATE VIEW v9 as
(SELECT * FROM t21 ORDER BY c2 DESC FOR ORDERBY_NUM() BETWEEN 1 AND 3) UNION SELECT * FROM t22;

select * from v9;
select c1 from v9 order by c1;

CREATE VIEW v10 as
SELECT * FROM t21 UNION SELECT * FROM t22 order by 2 DESC FOR ORDERBY_NUM() BETWEEN 2 AND 4 ;

SELECT * FROM v10;

SELECT DISTINCT c2 FROM v10 ORDER by c2;

drop t1;
drop t21;
drop t22;
drop v1;
drop v2;
drop v3;
drop v4;
drop v5;
drop v6;
drop v7;
drop v8;
drop v9;
drop v10;
--+ holdcas off;
