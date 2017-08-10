--+ holdcas on;
set system parameters 'return_null_on_function_errors=yes';
select year('2010-01-01') FROM db_root;

SELECT YEAR('1987-01-01') FROM db_root;
SELECT YEAR('01:02:03') FROM db_root;
SELECT YEAR('1987-01-01 01:02:03') FROM db_root;
SELECT YEAR('1987-01-01 01:02:03.1234') FROM db_root;
select year('0000-00-00') FROM db_root;
select year('01/01/2010') FROM db_root;

select year(str_to_date('12/25/1999', '%m/%d/%Y')) FROM db_root;

select year('2010-01-01 12:20:00');

create table year_tests(char_col char(32), varchar_col varchar(32), 
			string_col string, 
			bit_col bit(16), 
			integer_col integer,
			smallint_col smallint,
			bigint_col bigint,
			float_col float,
			double_col double, 
			numeric_col numeric(10,2),
			monetary_col monetary,
			date_col DATETIME, 
			time_col TIME,
			timestamp_col timestamp,
			datetime_col datetime,
			set_col set(varchar(32), integer)
			);

insert into year_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, year(char_col) from year_tests order by smallint_col;
select varchar_col, year(varchar_col) from year_tests order by smallint_col;
select string_col, year(string_col) from year_tests order by smallint_col;
select bit_col, year(bit_col) from year_tests order by smallint_col;
select integer_col, year(integer_col) from year_tests order by smallint_col;
select smallint_col, year(smallint_col) from year_tests order by smallint_col;
select bigint_col, year(bigint_col) from year_tests order by smallint_col;
--select float_col, year(float_col) from year_tests order by smallint_col;
select float_col,if(year(float_col)=year(sysdate),'ok','nok') from year_tests order by smallint_col;
select double_col, year(double_col) from year_tests order by smallint_col;
--select numeric_col, year(numeric_col) from year_tests order by smallint_col;
select numeric_col,if(year(numeric_col)=year(sysdate),'ok','nok') from year_tests order by smallint_col;
select monetary_col, year(monetary_col) from year_tests order by smallint_col;
select date_col, year(date_col) from year_tests order by smallint_col;
select time_col, year(time_col) from year_tests order by smallint_col;
select timestamp_col, year(timestamp_col) from year_tests order by smallint_col;
select datetime_col, year(datetime_col) from year_tests order by smallint_col;
select set_col, year(set_col) from year_tests order by smallint_col; 


select * from year_tests where smallint_col < year(varchar_col) order by smallint_col;
select * from year_tests where smallint_col = year('2010-01-02')-2000 order by smallint_col;

drop table year_tests;

create table t (col varchar(255)) partition by list (year(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table year_tests as select year('2010-01-02');

SELECT * FROM db_attribute where class_name='year_tests';

select * from year_tests;

drop table year_tests;

create view year_view(v) as select year('2010-01-02') from db_root;

select * from year_view;

drop year_view;

$varchar, $2009-01-01 20:18:32
select year(?) as rez;

$date, $1985-01-02
select year(?) as rez;

$datetime, $01/02/1985 12:13:15
select year(?) as rez;

--wrong type of hostvar
$int, $12
select year(?) as rez;
--wrong string format
$varchar, $2010
select year(?) as rez;

-- test for valid date time format
select year(datetime'2003-12-31 01:02:03.1234'), if (year(datetime'2003-12-31 01:02:03.1234') = 2003, 'ok', 'nok');
select year(timestamp'2003-12-31 01:02:03'), if (year(timestamp'2003-12-31 01:02:03') = 2003, 'ok', 'nok');
select year(date'2003-12-31'), if (year(date'2003-12-31') = 2003, 'ok', 'nok');


-- test for valid date, time string format
select year('2003-12-31 01:02:03.1234'), if (year('2003-12-31 01:02:03.1234') = 2003, 'ok', 'nok');
select year('2003-12-31 01:02:03'), if (year('2003-12-31 01:02:03') = 2003, 'ok', 'nok');
select year('2003-12-31'), if (year('2003-12-31') = 2003, 'ok', 'nok');


-- test for valid current_*
SELECT if(year(current_date) = CAST(DATE_FORMAT(current_date,'%Y') AS INTEGER),'ok','not ok');
SELECT if(year(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%Y') AS INTEGER),'ok','not ok');
SELECT if(year(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%Y') AS INTEGER),'ok','not ok');

-- test for special year
select year('9999-12-31 01:02:03'), if (year('9999-12-31 01:02:03') = 9999, 'ok', 'nok');
select year('1999-2-28 01:02:03'), if (year('1999-2-28 01:02:03') = 1999, 'ok', 'nok');
select year('1-1-1'), if (year('1-1-1') = 1, 'ok', 'nok');
select year('01/01/2000'), if (year('01/01/2000') = 2000, 'ok', 'nok');
select year('1/1/1'), if (year('1/1/1') = 1, 'ok', 'nok');
select year('2000-000001-000001'), if (year('2000-000001-000001') = 2000, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is returned.
select year('0000-12-31 01:02:03');
select year('10000-12-31 01:02:03');
select year('2000-12-32 01:02:03');
select year('1999-2-29 01:02:03');

select year('01:02:03');

set system parameters 'return_null_on_function_errors = no';
select year('2010-01-02') FROM db_root;

SELECT YEAR('1987-01-02') FROM db_root;
SELECT YEAR('01:02:04') FROM db_root;
SELECT YEAR('1988-01-01 01:02:03') FROM db_root;
SELECT YEAR('1988-01-01 01:02:03.1234') FROM db_root;
select year('0000-00-01') FROM db_root;
select year('01/01/2018') FROM db_root;

select year(str_to_date('12/26/1999', '%m/%d/%Y')) FROM db_root;

select year('2010-01-01 12:20:01');

create table year_tests(char_col char(32), varchar_col varchar(32), 
			string_col string, 
			bit_col bit(16), 
			integer_col integer,
			smallint_col smallint,
			bigint_col bigint,
			float_col float,
			double_col double, 
			numeric_col numeric(10,2),
			monetary_col monetary,
			date_col DATETIME, 
			time_col TIME,
			timestamp_col timestamp,
			datetime_col datetime,
			set_col set(varchar(32), integer)
			);

insert into year_tests values('2010-01-02','asdf','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, year(char_col) from year_tests order by smallint_col;
select varchar_col, year(varchar_col) from year_tests order by smallint_col;
select string_col, year(string_col) from year_tests order by smallint_col;
select bit_col, year(bit_col) from year_tests order by smallint_col;
select integer_col, year(integer_col) from year_tests order by smallint_col;
select smallint_col, year(smallint_col) from year_tests order by smallint_col;
select bigint_col, year(bigint_col) from year_tests order by smallint_col;
--select float_col, year(float_col) from year_tests order by smallint_col;
select float_col,if(year(float_col)=year(sysdate),'ok','nok') from year_tests order by smallint_col;
select double_col, year(double_col) from year_tests order by smallint_col;
--select numeric_col, year(numeric_col) from year_tests order by smallint_col;
select numeric_col,if(year(numeric_col)=year(sysdate),'ok','nok') from year_tests order by smallint_col;
select monetary_col, year(monetary_col) from year_tests order by smallint_col;
select date_col, year(date_col) from year_tests order by smallint_col;
select time_col, year(time_col) from year_tests order by smallint_col;
select timestamp_col, year(timestamp_col) from year_tests order by smallint_col;
select datetime_col, year(datetime_col) from year_tests order by smallint_col;
select set_col, year(set_col) from year_tests order by smallint_col; 


select * from year_tests where smallint_col < year(varchar_col) order by smallint_col;
select * from year_tests where smallint_col = year('2010-01-02')-2000 order by smallint_col;

drop table year_tests;

create table t (col varchar(255)) partition by list (year(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

create table year_tests as select year('2010-01-02');

SELECT * FROM db_attribute where class_name='year_tests';

select * from year_tests;

drop table year_tests;

create view year_view(v) as select year('2010-01-02') from db_root;

select * from year_view;

drop year_view;

$varchar, $2009-01-01 20:18:32
select year(?) as rez;

$date, $1985-01-02
select year(?) as rez;

$datetime, $01/02/1985 12:13:15
select year(?) as rez;

--wrong type of hostvar
$int, $12
select year(?) as rez;
--wrong string format
$varchar, $2010
select year(?) as rez;

-- test for valid date time format
select year(datetime'2003-12-31 01:02:03.1234'), if (year(datetime'2003-12-31 01:02:03.1234') = 2003, 'ok', 'nok');
select year(timestamp'2003-12-31 01:02:03'), if (year(timestamp'2003-12-31 01:02:03') = 2003, 'ok', 'nok');
select year(date'2003-12-31'), if (year(date'2003-12-31') = 2003, 'ok', 'nok');


-- test for valid date, time string format
select year('2003-12-31 01:02:03.1234'), if (year('2003-12-31 01:02:03.1234') = 2003, 'ok', 'nok');
select year('2003-12-31 01:02:03'), if (year('2003-12-31 01:02:03') = 2003, 'ok', 'nok');
select year('2003-12-31'), if (year('2003-12-31') = 2003, 'ok', 'nok');


-- test for valid current_*
SELECT if(year(current_date) = CAST(DATE_FORMAT(current_date,'%Y') AS INTEGER),'ok','not ok');
SELECT if(year(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%Y') AS INTEGER),'ok','not ok');
SELECT if(year(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%Y') AS INTEGER),'ok','not ok');


-- test for special year
select year('9999-12-31 01:02:03'), if (year('9999-12-31 01:02:03') = 9999, 'ok', 'nok');
select year('1999-2-28 01:02:03'), if (year('1999-2-28 01:02:03') = 1999, 'ok', 'nok');
select year('1-1-1'), if (year('1-1-1') = 1, 'ok', 'nok');
select year('01/01/2000'), if (year('01/01/2000') = 2000, 'ok', 'nok');
select year('1/1/1'), if (year('1/1/1') = 1, 'ok', 'nok');
select year('2000-000001-000001'), if (year('2000-000001-000001') = 2000, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is returned
select year('0000-12-31 01:01:03');
select year('10000-12-31 01:01:03');
select year('2000-12-32 01:01:03');
select year('1999-2-29 01:01:03');

select year('01:02:04');
commit;
--+ holdcas off;

set system parameters 'return_null_on_function_errors=no';
