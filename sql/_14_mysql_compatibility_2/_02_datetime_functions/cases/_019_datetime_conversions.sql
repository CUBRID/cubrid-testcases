SELECT CAST('2010-01-01 12:00:00' AS DATE) FROM db_root;
SELECT CAST('2010-01-01aaa12:00:00' AS DATE) FROM db_root;

SELECT CAST('2010-01-01 11:22:33' AS TIME) FROM db_root;
SELECT CAST('2010-01-01aaa11:22:33' AS TIME) FROM db_root;

SELECT '12:13:14' + 1 AS rez FROM db_root;
SELECT '2010-01-01' + 1 AS rez FROM db_root;
SELECT '2010-01-01 12:13:14' + 1 AS rez FROM db_root;
SELECT '2010-01-01 12:13:14.123' + 1 AS rez FROM db_root;

CREATE TABLE t(s string);
INSERT INTO t(s) values('2010-01-01 11:12:13');
INSERT INTO t(s) values('2010-01-03 11:13:13');
INSERT INTO t(s) values('2010-01-04 11:14:13.123');

SELECT CAST(s AS DATE) FROM t ORDER BY s;
SELECT CAST(s AS TIME) FROM t ORDER BY s;

TRUNCATE TABLE t;
--the call to CAST(s AS TIME) should fail because of the next value
INSERT INTO t(s) values('2010-01-02');
SELECT CAST(s AS DATE) FROM t ORDER BY s;
SELECT CAST(s AS TIME) FROM t ORDER BY s;

TRUNCATE TABLE t;
--the call to CAST(s AS DATE) should fail because of the next value
INSERT INTO t(s) values('20:11:12');
SELECT CAST(s AS DATE) FROM t ORDER BY s;
SELECT CAST(s AS TIME) FROM t ORDER BY s;
drop table t;

$varchar, $2010-01-01
SELECT CAST(? AS DATE) AS rez FROM db_root;

$varchar, $2010-01-01 12:00:13
SELECT CAST(? AS DATE) AS rez FROM db_root;

$char, $2010-01-01
SELECT CAST(? AS DATE) AS rez FROM db_root;

$char, $2010-01-01 12:00:13
SELECT CAST(? AS DATE) AS rez FROM db_root;

$varchar, $12:00:13
SELECT CAST(? AS DATE) AS rez FROM db_root;

$varchar, $2010-01-01 12:00:13
SELECT CAST(? AS DATE) AS rez FROM db_root;

$char, $12:00:13
SELECT CAST(? AS DATE) AS rez FROM db_root;

$char, $2010-01-01 12:00:13
SELECT CAST(? AS DATE) AS rez FROM db_root;
