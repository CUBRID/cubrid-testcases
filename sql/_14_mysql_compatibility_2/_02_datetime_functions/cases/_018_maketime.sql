select maketime(12,10,11);
select maketime(19.8,10.3,11.5);
select maketime(25,0,0);
select maketime(-1,0,5);

create table maketime_tests(char_col char(32), varchar_col varchar(32), 
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

insert into maketime_tests values('12','07','22',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02 17:28:31',{'golf', 'handicap', 10}),('17','1971-12-22 00:14:11','23',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02 17:28:31',{'golf', 'handicap', 10});

select char_col, maketime(char_col,smallint_col,35) from maketime_tests order by smallint_col;
select varchar_col, maketime(varchar_col,smallint_col,35) from maketime_tests order by smallint_col;
select string_col, maketime(string_col,19,smallint_col) from maketime_tests order by smallint_col;
select bit_col, maketime(bit_col,smallint_col,23) from maketime_tests order by smallint_col;
select integer_col, maketime(integer_col,12,smallint_col) from maketime_tests order by smallint_col;
select smallint_col, maketime(smallint_col,smallint_col,59) from maketime_tests order by smallint_col;
select bigint_col, maketime(bigint_col,smallint_col,59) from maketime_tests order by smallint_col;
select float_col, maketime(float_col,smallint_col,59) from maketime_tests order by smallint_col;
select double_col, maketime(double_col,smallint_col,59) from maketime_tests order by smallint_col;
select numeric_col, maketime(numeric_col,smallint_col,10) from maketime_tests order by smallint_col;
select monetary_col, maketime(monetary_col,smallint_col,12) from maketime_tests order by smallint_col;
select date_col, maketime(date_col,12,smallint_col) from maketime_tests order by smallint_col;
select time_col, maketime(time_col,12,smallint_col) from maketime_tests order by smallint_col;
select timestamp_col, maketime(timestamp_col,12,smallint_col) from maketime_tests order by smallint_col;
select datetime_col, maketime(datetime_col,12,smallint_col) from maketime_tests order by smallint_col;
select set_col, maketime(set_col,12,smallint_col) from maketime_tests order by smallint_col; 

select * from maketime_tests where time_col = maketime(12,10,9) order by smallint_col;

drop table maketime_tests;

create table maketime_tests as select maketime(12,10,9);

SELECT * FROM db_attribute where class_name='maketime_tests';

select * from maketime_tests;

drop table maketime_tests;

create view maketime_view(v) as select maketime(12,10,8) from db_root;

select * from maketime_view;

drop maketime_view;

$varchar, $'1.21'
select maketime(?,10,10) as rez;

$int, $59
select maketime(10,?,12) as rez;

$float, $58.6
select maketime(10,10,?) as rez;

$double, $21.23
select maketime(?,10,10) as rez;

$numeric, $22.74, $int, $10, $int, $14
select maketime(?,?,?) as rez;

$int, $10, $int, $23, $int, $59
select 1 as rez from db_root where maketime(?,?,?) = '10:23:59';

-- test for valid input
select maketime(0,0,0), if (maketime(0,0,0) = '00:00:00', 'ok', 'nok');
select maketime(0,0,59), if (maketime(0,0,59) = '00:00:59', 'ok', 'nok');
select maketime(0,59,0), if (maketime(0,59,0) = '00:59:00', 'ok', 'nok');
select maketime(23,0,0), if (maketime(23,0,0) = '23:00:00', 'ok', 'nok');
select maketime(23,59,59), if (maketime(23,59,59) = '23:59:59', 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select maketime(24, 0, 0);
select maketime(0, 60, 0);
select maketime(0, 0, 60);
select maketime(-1, 0, 0);
select maketime(0, -1, 0);
select maketime(0, 0, -1);