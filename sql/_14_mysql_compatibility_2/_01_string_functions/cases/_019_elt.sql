--ELT (element index) function

-- NULL index argument
SELECT ELT(NULL, '34', 'gadf', 'gradfa',CURRENT_TIMESTAMP);

-- negative index argument
SELECT ELT(-234243, 1234, 443, '2342', '432gds');

-- index argument 0
SELECT ELT(0, 'ASdf', 'ziopjhklfds', 'fdsaiusa');

-- index argument too large
SELECT ELT(43243, 'gdsuzi', CURRENT_USER, CURRENT_TIMESTAMP);

-- legal index argument
SELECT ELT(1, 'SQL-99', 'SQL-3');

-- legal index argument
SELECT ELT(2, 'SQL-99', 'SQL-3');

-- return type
CREATE TABLE EltTable AS SELECT ELT(2, 234.23421f, 432.0123432e43);
SELECT class_name, attr_name, data_type FROM db_attribute WHERE class_name='elttable';
DROP TABLE EltTable;

-- constant folding
SELECT ELT(1);
SELECT ELT(0);

-- run-time expressions
SELECT
 		ELT(idx, col1, col2, col3)
 FROM
 		(
 			SELECT 1 AS idx, CAST(43.5407f as real) AS col1, 'gdagd' AS col2, 4320.43234 AS col3
 				UNION ALL
 			SELECT 2, CAST(106743.4001234e10 as REAL), 'value', 407.23
 			    UNION ALL
 			SELECT 3, CAST(43.000432e20 AS DOUBLE), 'String value', 0.00432
 		)
 		  AS TableName;
 		  
-- host variables
$int, $1
SELECT ELT(?, 'Value1', 'Value2', 'Value3');

$int, $2
SELECT ELT(?+1, 'Value1', 'Value2', 'Value3');

$int, $1, $varchar, $Val
SELECT ELT(?+1, 'Value1', 'str' + ?, 'Value3');

$int, $1, $varchar, $Val
SELECT ELT(?+2, 'Value1', 'str' + ?, 'Value3');

SELECT ELT(idx, 'Value1', 10.4234)
FROM
	(SELECT 1e0 AS idx UNION ALL SELECT 2e0 as idx) AS TableName;
	
SELECT ELT(10, 'fdsa', CURRENT_TIMESTAMP, CURRENT_USER, CAST(12342.0432 AS REAL), 342.0432e10 ,
   DATE '2010-02-03', CAST('asdfa' AS VARCHAR(10)), CAST('VAlue342' AS CHARACTER(20)), 1, 210.2342,
   CURRENT_DATE);
   
   SELECT ELT(2, 'asfdsa', N'asdfas');
   
   SELECT ELT(2, SET { 10, -23, -43 }, B'010110011', N'agddad', 'afasd');
   
      SELECT ELT(2, SET { 10, -23, -43 }, LIST { 'asdf', 'asdfa', 'fsd'}, CURRENT_TIMESTAMP, B'010110011', N'agddad', 'afasd');
      
CREATE TABLE t1(s short,n numeric(10,2), f float);
insert into t1 values(1,1.2,1.2),(2,2.2,2.2); 

SELECT ELT(s,'1','2') FROM t1 order by s;

SELECT ELT(n,'1','2') FROM t1 order by n;

SELECT ELT(f,'1','2') FROM t1 order by f;

DROP TABLE t1;

--1. Test string types
select if(elt(1, 'abc', 'd', 'ef') = 'abc', 'ok', 'nok');
select if(elt(2, 'abc', 'd', 'ef') = 'd', 'ok', 'nok');
select if(elt(3, 'abc', 'd', 'ef') = 'ef', 'ok', 'nok');
select if(elt(1, n'abc', n'd', n'ef') = n'abc', 'ok', 'nok');
select if(elt(2, n'abc', n'd', n'ef') = n'd', 'ok', 'nok');
select if(elt(3, n'abc', n'd', n'ef') = n'ef', 'ok', 'nok');

-- out of range
select if(elt(0, 'abc', 'd', 'ef') is null, 'ok', 'nok');
select if(elt(-1, 'abc', 'd', 'ef') is null, 'ok', 'nok');
select if(elt(4, 'abc', 'd', 'ef') is null, 'ok', 'nok');

-- rounding 
select if(elt(1.5, 'abc', 'd', 'ef') = elt(2.4, 'abc', 'd', 'ef'), 'ok', 'nok');

-- error
select elt(1, 'abc', 'd', n'ef');
select elt(1, n'abc', 'd', n'ef');

-- server side
create table t (c1 char(32), c2 char(32), vc1 varchar(32), vc2 varchar(32), nc1 nchar(32), nc2 nchar(32), vnc1 nchar varying(32), vnc2 nchar varying(32));
insert into t values('a', 'bb', 'ccc', 'dddd', n'e', n'ff', n'ggg', n'hhhh');
select if(elt(1, c1, c2, vc1, vc2) = 'a', 'ok', 'nok') from t;
select if(elt(2, c1, c2, vc1, vc2) = 'bb', 'ok', 'nok') from t;
select if(elt(3, c1, c2, vc1, vc2) = 'ccc', 'ok', 'nok') from t;
select if(elt(4, c1, c2, vc1, vc2) = 'dddd', 'ok', 'nok') from t;
select if(elt(5, c1, c2, vc1, vc2) is null, 'ok', 'nok') from t;
select if(elt(0, c1, c2, vc1, vc2) is null, 'ok', 'nok') from t;
select if(elt(-100, c1, c2, vc1, vc2) is null, 'ok', 'nok') from t;
select if(elt(1, nc1, nc2, vnc1, vnc2) = n'e', 'ok', 'nok') from t;
select if(elt(2, nc1, nc2, vnc1, vnc2) = n'ff', 'ok', 'nok') from t;
select if(elt(3, nc1, nc2, vnc1, vnc2) = n'ggg', 'ok', 'nok') from t;
select if(elt(4, nc1, nc2, vnc1, vnc2) = n'hhhh', 'ok', 'nok') from t;
select if(elt(5, nc1, nc2, vnc1, vnc2) is null, 'ok', 'nok') from t;
select if(elt(0, nc1, nc2, vnc1, vnc2) is null, 'ok', 'nok') from t;
select if(elt(-100, nc1, nc2, vnc1, vnc2) is null, 'ok', 'nok') from t;
drop table t;

--2. Test numeric types
select if(elt(1, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '123', 'ok', 'nok');
select if(elt(2, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '1234', 'ok', 'nok');
select if(elt(3, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '12345', 'ok', 'nok');
--returns nok, will return ok when 
select if(elt(4, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = cast(1.1f AS VARCHAR), 'ok', 'nok');
select if(elt(5, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = cast(11e11 AS VARCHAR), 'ok', 'nok');
select if(elt(6, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '$111.11', 'ok', 'nok');
select if(elt(7, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) = '1111.111', 'ok', 'nok');
select if(elt(8, cast(123 as short), cast(1234 as integer), cast(12345 as bigint), cast(1.1 as float), cast(11.11 as double), cast(111.11 as monetary), cast(1111.111 as numeric(10,3))) is null, 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary, n numeric(10,1));
insert into t values(1, 2, 3, 1.1, 2.2, 3.3, 4.4);
select if(elt(1, s, i, bi, f, d, m, n) = '1', 'ok', 'nok') from t;
select if(elt(2, s, i, bi, f, d, m, n) = '2', 'ok', 'nok') from t;
select if(elt(3, s, i, bi, f, d, m, n) = '3', 'ok', 'nok') from t;
select if(elt(4, s, i, bi, f, d, m, n) = CAST(f AS VARCHAR), 'ok', 'nok') from t;
select if(elt(5, s, i, bi, f, d, m, n) = CAST(d AS VARCHAR), 'ok', 'nok') from t;
select if(elt(6, s, i, bi, f, d, m, n) = '$3.3', 'ok', 'nok') from t;
select if(elt(7, s, i, bi, f, d, m, n) = '4.4', 'ok', 'nok') from t;
select if(elt(8, s, i, bi, f, d, m, n) is null, 'ok', 'nok') from t;
select if(elt(0, s, i, bi, f, d, m, n) is null, 'ok', 'nok') from t;
select if(elt(-100, s, i, bi, f, d, m, n) is null, 'ok', 'nok') from t;
drop table t;

--3. Exceptions
select if(elt(1, '1', null, null) = '1', 'ok', 'nok');
select if(elt(2, '1', null, null) is null, 'ok', 'nok');
select if(elt(3, '1', null, null) is null, 'ok', 'nok');
select if(elt(3, '1', null, '') = '', 'ok', 'nok');

--4. Test host variable
-- success
$int, $1, $varchar, $a, $varchar, $b, $varchar, $a
select if(elt(?, ?, ?) = ?, 'ok', 'nok');
$int, $2, $varchar, $a, $varchar, $b, $varchar, $b
select if(elt(?, ?, ?) = ?, 'ok', 'nok');
$numeric, $1.4, $varchar, $a, $varchar, $b, $varchar, $a
select if(elt(?, ?, ?) = ?, 'ok', 'nok');
$numeric, $1.5, $varchar, $a, $varchar, $b, $varchar, $b
select if(elt(?, ?, ?) = ?, 'ok', 'nok');

$float, $1.4, $varchar, $a, $varchar, $b, $varchar, $a
select if(elt(?, ?, ?) = ?, 'ok', 'nok');
$float, $1.5, $varchar, $a, $varchar, $b, $varchar, $b
select if(elt(?, ?, ?) = ?, 'ok', 'nok');

$double, $1.4, $varchar, $a, $varchar, $b, $varchar, $a
select if(elt(?, ?, ?) = ?, 'ok', 'nok');
$double, $1.5, $varchar, $a, $varchar, $b, $varchar, $b
select if(elt(?, ?, ?) = ?, 'ok', 'nok');

$int, $1, $date, $2010-09-02, $time, $17:30:30, $date, $2010-09-02
select if(elt(?, ?, ?) = ?, 'ok', 'nok');

$int, $2, $datetime, $2010-09-02 17:30:30, $timestamp, $2010-09-02 17:30:30, $timestamp, $2010-09-02 17:30:30
select if(elt(?, ?, ?) = ?, 'ok', 'nok');

$int, $1, $numeric, $1.1, $numeric, $2.2, $numeric, $1.1
select if(elt(?, ?, ?) = cast(? AS VARCHAR), 'ok', 'nok');

$int, $2, $float, $1.1, $double, $2.2, $double, $2.2
select if(elt(?, ?, ?) = cast (? AS varchar), 'ok', 'nok');

-- failure
$char, $a, $int, $1, $int, $2
select elt(?, ?, ?);

$nchar, $a, $int, $1, $int, $2
select elt(?, ?, ?);

$binary, $0b1100, $int, $1, $int, $2
select elt(?, ?, ?);

$date, $2010-09-02, $int, $1, $int, $2
select elt(?, ?, ?);

$time, $17:30:30, $int, $1, $int, $2
select elt(?, ?, ?);

$datetime, $2010-09-02 17:30:30, $int, $1, $int, $2
select elt(?, ?, ?);

$timestamp, $2010-09-02 17:30:30, $int, $1, $int, $2
select elt(?, ?, ?);

$int, $1, $nchar, $a, $nchar, $b
select elt(?, ?, ?);
