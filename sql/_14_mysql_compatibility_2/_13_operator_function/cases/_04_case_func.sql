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
	CASE a
		WHEN 1 then s
		WHEN 2 then a
		WHEN 3 then '12'
		WHEN 4 then 5.3
		else 17
	end
FROM t ORDER BY a, s;

--search case
SELECT a, s,
	CASE 
		WHEN a = 1 then s
		WHEN a = 2 then a
		WHEN a = 3 then '12'
		WHEN a = 4 then 5.3
		else 17
	end
FROM t ORDER BY a, s;

--host variables
$int, $123
SELECT a, s,
	CASE a
		WHEN 1 then s
		WHEN 2 then ?
		WHEN 3 then '12'
		WHEN 4 then 5.3
		else 17
	end
FROM t ORDER BY a, s;

$int, $123, $char, $19
SELECT a, s,
	CASE ?
		WHEN 1 then s
		WHEN 2 then ?
		WHEN 3 then '12'
		WHEN 123 then 5.3
		else 17
	end
FROM t ORDER BY a, s;

$char, $123, $varchar, $19, $double, $1000
SELECT a, s,
	CASE ?
		WHEN 1 then s
		WHEN 2 then ?
		WHEN 3 then '12'
		WHEN 123 then ?
		else 17
	end
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
SELECT s, d,
	CASE s
		WHEN '2010-01-01' then s
		WHEN '2011-01-01' then d
		WHEN '2012-01-01' then '2012-01-03'
		else '1999-01-01'
	end
FROM t ORDER BY s, d;

--search case
SELECT s, d,
	CASE WHEN s = '2010-01-01' THEN s
		WHEN s = date'2011-01-01' then d
		WHEN s >= date'2012-01-01' then NULL
	end
FROM t ORDER BY s,d;

--host variables
$date, $2010-01-01
SELECT s, d,
	CASE d
		WHEN date'2010-01-02' then s
		WHEN date'2011-01-02' then ?
		WHEN '2012-01-02' then date'1999-01-01'
		WHEN '2013-01-02' then NULL
		else date'1899-01-01'
	end
FROM t ORDER BY s, d;

$char, $2010-01-01
SELECT s, d,
	CASE d
		WHEN date'2010-01-02' then s
		WHEN date'2011-01-02' then ?
		WHEN '2012-01-02' then date'1999-01-01'
		WHEN '2013-01-02' then NULL
		else date'1899-01-01'
	end
FROM t ORDER BY s, d;
drop table t;