--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select second('12:23:15');

select second(str_to_date('2010-01-02 12:23:25', '%Y-%m-%d %H:%i:%s'));

select second('2010-01-01 12:20:43');

create table second_tests(char_col char(32), varchar_col varchar(32), 
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

insert into second_tests values('2010-01-02 10:19:21','asdf','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, second(char_col) from second_tests order by smallint_col;
select varchar_col, second(varchar_col) from second_tests order by smallint_col;
select string_col, second(string_col) from second_tests order by smallint_col;
select bit_col, second(bit_col) from second_tests order by smallint_col;
select integer_col, second(integer_col) from second_tests order by smallint_col;
select smallint_col, second(smallint_col) from second_tests order by smallint_col;
select bigint_col, second(bigint_col) from second_tests order by smallint_col;
select float_col, second(float_col) from second_tests order by smallint_col;
select double_col, second(double_col) from second_tests order by smallint_col;
select numeric_col, second(numeric_col) from second_tests order by smallint_col;
select monetary_col, second(monetary_col) from second_tests order by smallint_col;
select date_col, second(date_col) from second_tests order by smallint_col;
select time_col, second(time_col) from second_tests order by smallint_col;
select timestamp_col, second(timestamp_col) from second_tests order by smallint_col;
select datetime_col, second(datetime_col) from second_tests order by smallint_col;
select set_col, second(set_col) from second_tests order by smallint_col;


select * from second_tests where smallint_col < second(varchar_col) order by smallint_col;
select * from second_tests where smallint_col = second('11:24:11')-1 order by smallint_col;

create table t (col varchar(255)) partition by list (second(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

drop table second_tests;

create table second_tests as select second('2010-01-02 11:12:13') as [ second('2010-01-02 11:12:13')];

SELECT * FROM db_attribute where class_name='second_tests';

select * from second_tests;

drop table second_tests;

create view second_view(v) as select second('2010-01-02 12:23:10') from db_root;

select * from second_view;

drop second_view;

$varchar, $2009-01-01 20:18:32
select second(?) as rez;

$varchar, $2009-01-01 20:18:32
select second(?) as rez;

$date, $1985-01-02
select second(?) as rez;

$datetime, $01/02/1985 12:13:15
select second(?) as rez;

-- test for valid date time format
select second(datetime'2003-12-31 01:02:03.1234'), if (second(datetime'2003-12-31 01:02:03.1234') = 3, 'ok', 'nok');
select second(timestamp'2003-12-31 01:02:03'), if (second(timestamp'2003-12-31 01:02:03') = 3, 'ok', 'nok');
select second(time'01:02:03'), if (second(time'01:02:03') = 3, 'ok', 'nok');


-- test for valid date, time string format
select second('2003-12-31 01:02:03.1234'), if (second('2003-12-31 01:02:03.1234') = 3, 'ok', 'nok');
select second('2003-12-31 01:02:03'), if (second('2003-12-31 01:02:03') = 3, 'ok', 'nok');
select second('01:02:03'), if (second('01:02:03') = 3, 'ok', 'nok');


-- test for valid current_*
SELECT if(second(current_date) is null,'ok','not ok');
SELECT if(second(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%s') AS INTEGER),'ok','not ok');
SELECT if(second(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%s') AS INTEGER),'ok','not ok');
SELECT if(second(current_time) = CAST(DATE_FORMAT(current_timestamp,'%s') AS INTEGER),'ok','not ok');

-- test for special case
select second('23:59:59'), if (second('23:59:59') = 59, 'ok', 'nok');
select second('00:00:00'), if (second('00:00:00') = 0, 'ok', 'nok');
select second(time'00:00:00' - 1), if (second(time'00:00:00' - 1) = 59, 'ok', 'nok');
select second(time'23:59:59' + 1), if (second(time'23:59:59' + 1) = 0, 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select second('00:00:60');
select second('00:00:-10');
select second('2003-12-31');

set system parameters 'return_null_on_function_errors = no';

select second('12:23:15');

select second(str_to_date('2010-01-02 12:23:25', '%Y-%m-%d %H:%i:%s'));

select second('2010-01-01 12:20:43');

create table second_tests(char_col char(32), varchar_col varchar(32), 
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

insert into second_tests values('2010-01-02 10:19:21','asdf','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, second(char_col) from second_tests order by smallint_col;
select varchar_col, second(varchar_col) from second_tests order by smallint_col;
select string_col, second(string_col) from second_tests order by smallint_col;
select bit_col, second(bit_col) from second_tests order by smallint_col;
select integer_col, second(integer_col) from second_tests order by smallint_col;
select smallint_col, second(smallint_col) from second_tests order by smallint_col;
select bigint_col, second(bigint_col) from second_tests order by smallint_col;
select float_col, second(float_col) from second_tests order by smallint_col;
select double_col, second(double_col) from second_tests order by smallint_col;
select numeric_col, second(numeric_col) from second_tests order by smallint_col;
select monetary_col, second(monetary_col) from second_tests order by smallint_col;
select date_col, second(date_col) from second_tests order by smallint_col;
select time_col, second(time_col) from second_tests order by smallint_col;
select timestamp_col, second(timestamp_col) from second_tests order by smallint_col;
select datetime_col, second(datetime_col) from second_tests order by smallint_col;
select set_col, second(set_col) from second_tests order by smallint_col;


select * from second_tests where smallint_col < second(varchar_col) order by smallint_col;
select * from second_tests where smallint_col = second('11:24:11')-1 order by smallint_col;

create table t (col varchar(255)) partition by list (second(col)) (PARTITION P0 VALUES IN (2010, 2011));

drop table t;

drop table second_tests;

create table second_tests as select second('2010-01-02 11:12:13') as [ second('2010-01-02 11:12:13')];

SELECT * FROM db_attribute where class_name='second_tests';

select * from second_tests;

drop table second_tests;

create view second_view(v) as select second('2010-01-02 12:23:10') from db_root;

select * from second_view;

drop second_view;

$varchar, $2009-01-01 20:18:32
select second(?) as rez;

$varchar, $2009-01-01 20:18:32
select second(?) as rez;

$date, $1985-01-02
select second(?) as rez;

$datetime, $01/02/1985 12:13:15
select second(?) as rez;

-- test for valid date time format
select second(datetime'2003-12-31 01:02:03.1234'), if (second(datetime'2003-12-31 01:02:03.1234') = 3, 'ok', 'nok');
select second(timestamp'2003-12-31 01:02:03'), if (second(timestamp'2003-12-31 01:02:03') = 3, 'ok', 'nok');
select second(time'01:02:03'), if (second(time'01:02:03') = 3, 'ok', 'nok');


-- test for valid date, time string format
select second('2003-12-31 01:02:03.1234'), if (second('2003-12-31 01:02:03.1234') = 3, 'ok', 'nok');
select second('2003-12-31 01:02:03'), if (second('2003-12-31 01:02:03') = 3, 'ok', 'nok');
select second('01:02:03'), if (second('01:02:03') = 3, 'ok', 'nok');


-- test for valid current_*
SELECT if(second(current_date) is null,'ok','not ok');
SELECT if(second(current_datetime) = CAST(DATE_FORMAT(current_datetime,'%s') AS INTEGER),'ok','not ok');
SELECT if(second(current_timestamp) = CAST(DATE_FORMAT(current_timestamp,'%s') AS INTEGER),'ok','not ok');
SELECT if(second(current_time) = CAST(DATE_FORMAT(current_timestamp,'%s') AS INTEGER),'ok','not ok');

-- test for special case
select second('23:59:59'), if (second('23:59:59') = 59, 'ok', 'nok');
select second('00:00:00'), if (second('00:00:00') = 0, 'ok', 'nok');
select second(time'00:00:00' - 1), if (second(time'00:00:00' - 1) = 59, 'ok', 'nok');
select second(time'23:59:59' + 1), if (second(time'23:59:59' + 1) = 0, 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select second('00:00:60');
select second('00:00:-10');
select second('2003-12-31');
commit;
--+ holdcas off;
