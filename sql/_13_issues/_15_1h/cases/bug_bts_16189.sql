-- CASE 1
get optimization cost 'iscan' into :default_iscan;
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE table t1(a int, b int, c int);
CREATE INDEX idx ON t1 (c);
CREATE TABLE t2(a int, b int, c int, obj t1);
INSERT INTO t1 VALUES (0, 0, 0), (1, 1, 1), (2, 2, 2);
INSERT INTO t2 VALUES (0, 0, 0, NULL), (1, 1, 1, NULL), (2, 2, 2, NULL);
UPDATE t2 SET obj = (SELECT t1 FROM t1 WHERE t1.a = t2.a);
UPDATE t1 SET b = 0 WHERE b = 1;
set optimization cost 'iscan' '0';
-- 1 row affected is OK
DELETE FROM t2 WHERE obj.c = 1;
drop t1;
drop t2;


-- CASE 2
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
DROP VIEW IF EXISTS v2;
CREATE table t1(a int, b int, c int);
CREATE table t2(a int, b int, c int, obj t1);
CREATE VIEW v2 AS SELECT t2.a, t2.b, t2.c, t2.obj FROM t2;
CREATE INDEX idx ON t1 (c);
INSERT INTO t1 values (1, 1, 1);
INSERT INTO t2 values (1, 1, 1, NULL);
UPDATE t2 SET obj = (SELECT t1 FROM t1 WHERE t1.a = t2.a);
UPDATE t1 SET b = 0 WHERE b = 1;
set optimization cost 'iscan' '0';
-- 1 row affected is OK
DELETE FROM v2 WHERE obj.c = 1;
drop t1;
drop t2;
drop v2;

-- CASE 3
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
DROP VIEW IF EXISTS v2;
CREATE TABLE t1(a int, b int, c int);
CREATE TABLE t2(a int, b int, c int, obj t1);
CREATE VIEW v2 AS SELECT * FROM t2 ;
INSERT INTO t1 VALUES (0,0,0), (1,1,1);
INSERT INTO t2 VALUES(0,0,0,NULL),(1,1,1,NULL),(2,2,2,NULL),(3,3,3,NULL),(4,4,4,NULL),
(5,5,5,NULL),(6,6,6,NULL),(7,7,7,NULL),(8,8,8,NULL),(9,9,9,NULL),(10,10,10,NULL);
CREATE INDEX i_t1_b ON t1 (b);
CREATE INDEX i_t2_c ON t2 (c);
UPDATE t2 SET obj = (SELECT t1 FROM t1 WHERE t1.a = t2.a);
UPDATE t1 SET c = 0 WHERE b = 1;
set optimization cost 'iscan' '0';
-- 1 row affected is OK
DELETE FROM v2 WHERE c < 2 AND obj.b = 1;
drop t1;
drop t2;
drop v2;

-- CASE 4
DROP TABLE IF EXISTS foo;
CREATE class foo (a object);
INSERT INTO foo default values;
UPDATE foo SET a = class db_user;
INSERT INTO foo values (class foo);
-- 1 row affected is OK
DELETE from foo WHERE class foo = a;
drop foo;
set optimization cost 'iscan' :default_iscan;
