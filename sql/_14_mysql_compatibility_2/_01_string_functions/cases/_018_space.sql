--Complete tests for SPACE function

-- check NULL argument, literal arguments --
SELECT
		SPACE(NULL),
		'|' || SPACE(3) || '|',
		LENGTH(SPACE(68423)) || '|', LENGTH(SPACE(12345678909));
		
-- check emtpy string returned from negative lengths, --
-- and NULL returned from lengths larger than max VARCHAR precision --
SELECT
	   '|' || SPACE(-20) || '|',
	   SPACE(1073741824),
	   '|' || SPACE(CAST(10 AS SMALLINT)) || '|';
	   
-- check type conversions --
SELECT
	  '|' || SPACE('8') || '|',
	  '|' || SPACE(CAST(N'8' AS NCHAR VARYING(10))) || '|';
	  
-- Check precision for resulting string from constant arguments --
CREATE TABLE SpaceTbl AS SELECT SPACE(8 + LENGTH('Hh')) AS Sp;
SELECT
	attr_name,
	class_name,
	attr_type,
	data_type,
	prec,
	scale
FROM 
	db_attribute 
WHERE
    class_name='spacetbl';

-- Check max varchar precision returned from run-time expressions arguments --
CREATE TABLE SpaceTbl2 AS SELECT SPACE(LENGTH(Sp)) FROM SpaceTbl;
SELECT
	attr_name,
	class_name,
	attr_type,
	data_type,
	prec,
	scale
FROM 
	db_attribute 
WHERE
    class_name='spacetbl2';

DROP TABLE SpaceTbl2;
DROP TABLE SpaceTbl;

-- check results from run-time expressions of types VARCHAR, SMALLINT, INTEGER, BIGINT --
CREATE TABLE SpaceTbl
  (
   TblId		 SMALLINT,
   val		 	 INTEGER,
   Big 			 BIGINT,
   CharValue VARCHAR(10)
  );
  
  INSERT INTO SpaceTbl
  VALUES
    (1, 1, 1, '1'),
    (2, 2, 2, '2'),
    (10, 10, 10, '10');
    
 SELECT
 	'|' || SPACE(TblId) || '|',
 	'|' || SPACE(val) || '|',
 	'|' || SPACE(val + 1073741823) || '|',
 	'|' || SPACE(Big) || '|',
 	'|' || SPACE(CharValue) || '|'
 FROM
    SpaceTbl
 ORDER BY 
    TblId;
    
 -- Check host variables usage with SPACE function --
 $int,$3, $bigint, $1073741824, $varchar, $1073741824, $char, $10
 SELECT '|' || SPACE(?) || '|', '|' || SPACE(?) || '|', '|' || SPACE(?) || '|', '|' || SPACE(?) || '|';
 $int, $2
 SELECT '|' || SPACE(Big + ?) || '|' FROM SpaceTbl ORDER BY TblId
 DROP TABLE SpaceTbl;
 
create table t1(i integer);

insert into t1 values(null);

select space(i) from t1;

drop table t1;

--Test numeric types
select if(length(space(cast(12345 as short))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345 as integer))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345 as bigint))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345.5 as float))) = 12346, 'ok', 'nok');
select if(length(space(cast(12345.4 as float))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345.5 as double))) = 12346, 'ok', 'nok');
select if(length(space(cast(12345.4 as double))) = 12345, 'ok', 'nok');
select if(length(space(cast(12345.5 as numeric(10,5)))) = 12346, 'ok', 'nok');
select if(length(space(cast(12345.4 as numeric(10,5)))) = 12345, 'ok', 'nok');

-- server side
create table t (s short, i integer, bi bigint, f float, d double, m monetary, n numeric(10,5));
insert into t values(12345, 12345, 12345, 12345.5, 12345.5, 12345.5, 12345.5);
select if(length(space(s)) = s, 'ok', 'nok') from t;
select if(length(space(i)) = i, 'ok', 'nok') from t;
select if(length(space(bi)) = bi, 'ok', 'nok') from t;
insert into t values(12345, 12345, 12345, 12345.4, 12345.4, 12345.4, 12345.4);
select if(length(space(f)) = round(f), 'ok', 'nok') from t;
select if(length(space(d)) = round(d), 'ok', 'nok') from t;
select if(length(space(m)) = round(m), 'ok', 'nok') from t;
select if(length(space(n)) = round(n), 'ok', 'nok') from t;
drop table t;

-- Test unsupported types
-- TBD
select space(cast('1' as char(8)));
select space(cast('1' as varchar(8)));
select space(cast(n'1' as nchar(8)));
select space(cast(n'1' as nchar varying(8)));
select space(cast(B'1' as bit(8)));
select space(cast(B'1' as bit varying(8)));
select space(current_date);
select space(current_time);
select space(current_datetime);
select space(current_timestamp);

--3. Check the result
-- check whether the result includes only space character
select if(length(trim(space(cast(12345 as short)))) = 0, 'ok', 'nok'); 
-- check the length
select if(length(space(1073741823)) is null, 'ok', 'nok');

--4. Test host variables
-- success
$int, $12345, $int, $12345;
select if(length(space(?)) = ?, 'ok', 'nok');

$numeric, $12345.5, $int, $12346;
select if(length(space(?)) = ?, 'ok', 'nok');

$float, $12345.5, $int, $12346;
select if(length(space(?)) = ?, 'ok', 'nok');

$double, $12345.5, $int, $12346;
select if(length(space(?)) = ?, 'ok', 'nok');

$numeric, $12345.4, $int, $12345;
select if(length(space(?)) = ?, 'ok', 'nok');

$float, $12345.4, $int, $12345;
select if(length(space(?)) = ?, 'ok', 'nok');

$double, $12345.4, $int, $12345;
select if(length(space(?)) = ?, 'ok', 'nok');

-- failure
$date, $2010-09-02;
select space(?);

$time, $17:30:30;
select space(?);

$datetime, $2010-09-02 17:30:30;
select space(?);

$timestamp, $2010-09-02 17:30:30;
select space(?);
