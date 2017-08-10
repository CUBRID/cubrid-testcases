CREATE TABLE t (a INT, s VARCHAR(255));
INSERT INTO t(a, s) VALUES(0,'0');
INSERT INTO t(a, s) VALUES(1,'1.2');
INSERT INTO t(a, s) VALUES(2,'2.2');
INSERT INTO t(a, s) VALUES(3,'3.6');
INSERT INTO t(a, s) VALUES(4,'4.2');
INSERT INTO t(a, s) VALUES(5,'5.8');
INSERT INTO t(a, s) VALUES(6,'6.1');
--simple case
SELECT a, s,
	DECODE (a, 1, s, 2, a, 3, '12', 4, 5.3, 17)
FROM t ORDER BY a, s;

--host variables
$int, $123
SELECT a, s,
	DECODE(a, 1, s, 2, ?, 3, '12', 4, 5.3, 17)
FROM t ORDER BY a, s;

$int, $123, $varchar, $123
SELECT a, s,
	DECODE(?, 1, s, 2, ?, 3, '12', 123, 5.3, 17)
FROM t ORDER BY a, s;

$char, $123, $varchar, $19, $double, $12.001
SELECT a, s,
	DECODE(?, 1, s, 2, ?, 3, '12', 123, ?, 17)
FROM t ORDER BY a, s;

drop table t;

CREATE TABLE t (s VARCHAR(255), d date);
INSERT INTO t(s) VALUES('2010-01-01');
INSERT INTO t(s) VALUES('2011-01-01');
INSERT INTO t(s) VALUES('2012-01-01');
INSERT INTO t(s) VALUES('2013-01-01');

UPDATE t SET d = CAST(s AS date) + 1;

SELECT * FROM t ORDER BY s,d;
--simple case
SELECT s, d, DECODE(s, '2010-01-01', s, '2011-01-01', d, '2012-01-01', '2012-01-03') FROM t ORDER BY s, d;

--search case
SELECT s, d, DECODE(s, '2010-01-01', s, date'2011-01-01', d, NULL) FROM t ORDER BY s, d;

--host variables
$date, $2010-01-01
SELECT s, d, DECODE(d, date'2010-01-02', s, date'2011-01-02', ?, '2012-01-02', date'1999-01-01', NULL) FROM t ORDER BY s, d;

$char, $2010-01-01
SELECT s, d, 
	DECODE(d, date'2010-01-02', s, date'2011-01-02', ?, '2012-01-02', date'1999-01-01', '2013-01-02', NULL, date'1899-01-01')
FROM t ORDER BY s, d;
drop table t;
