--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select from_days(733466);
select from_days('733466');
select from_days(734138.1);
select from_days(734138.5);
select from_days(734138.9);
select from_days(365);

select from_days(3020398) as rez;
select from_days(-3020398) as rez;

create table from_days_tests(char_col char(32), varchar_col varchar(32), 
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

insert into from_days_tests values('2010-01-02','6200','05/04/2010 12:23:15.123',NULL,12000,30010,1111111111,800012.25,800012.11111111,800012.92,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, from_days(char_col) from from_days_tests order by smallint_col;
select varchar_col, from_days(varchar_col) from from_days_tests order by smallint_col;
select string_col, from_days(string_col) from from_days_tests order by smallint_col;
select bit_col, from_days(bit_col) from from_days_tests order by smallint_col;
select integer_col, from_days(integer_col) from from_days_tests order by smallint_col;
select smallint_col, from_days(smallint_col) from from_days_tests order by smallint_col;
select bigint_col, from_days(bigint_col) from from_days_tests order by smallint_col;
select float_col, from_days(float_col) from from_days_tests order by smallint_col;
select double_col, from_days(double_col) from from_days_tests order by smallint_col;
select numeric_col, from_days(numeric_col) from from_days_tests order by smallint_col;
select monetary_col, from_days(monetary_col) from from_days_tests order by smallint_col;
select date_col, from_days(date_col) from from_days_tests order by smallint_col;
select time_col, from_days(time_col) from from_days_tests order by smallint_col;
select timestamp_col, from_days(timestamp_col) from from_days_tests order by smallint_col;
select datetime_col, from_days(datetime_col) from from_days_tests order by smallint_col;
select set_col, from_days(set_col) from from_days_tests order by smallint_col; 

select * from from_days_tests where smallint_col = from_days('2010-01-02')+10 order by smallint_col;

drop table from_days_tests;

create table from_days_tests as select from_days('77777');

SELECT * FROM db_attribute where class_name='from_days_tests';

select * from from_days_tests;

drop table from_days_tests;

create view from_days_view(v) as select from_days('77777') from db_root;

select * from from_days_view;

drop from_days_view;

$varchar, $1900.21
select from_days(?) as rez;

$int, $2540
select from_days(?) as rez;

$float, $2540.23
select from_days(?) as rez;

$double, $3540.23
select from_days(?) as rez;

$numeric, $2540.74
select from_days(?) as rez;

$datetime, $01/02/1985 12:13:15
select from_days(?) as rez;

$datetime, $01/02/1985 12:13:15
select 1 as rez from db_root where from_days(?) = 1;


select from_days(731945), if (from_days(731945) = '2003-12-31', 'ok', 'nok');
select from_days(731945+10), if (from_days(731945+10) = '2004-01-10', 'ok', 'nok');
select from_days(731945-10), if (from_days(731945-10) = '2003-12-21', 'ok', 'nok');
select from_days(731945+366), if (from_days(731945+366) = '2004-12-31', 'ok', 'nok');
select from_days(731945+365*2+1), if (from_days(731945+365*2+1) = '2005-12-31', 'ok', 'nok');
select from_days(731945+365*3+1), if (from_days(731945+365*3+1) = '2006-12-31', 'ok', 'nok');
select from_days(731945+365*4+1), if (from_days(731945+365*4+1) = '2007-12-31', 'ok', 'nok');
select from_days(731945+365*5+2), if (from_days(731945+365*5+2) = '2008-12-31', 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select from_days(-1);
select from_days(1000000000);

set system parameters 'return_null_on_function_errors = no';

select from_days(733466);
select from_days('733466');
select from_days(734138.1);
select from_days(734138.5);
select from_days(734138.9);
select from_days(365);

select from_days(3020398) as rez;
select from_days(-3020398) as rez;

create table from_days_tests(char_col char(32), varchar_col varchar(32), 
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

insert into from_days_tests values('2010-01-02','6200','05/04/2010 12:23:15.123',NULL,12000,30010,1111111111,800012.25,800012.11111111,800012.92,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, from_days(char_col) from from_days_tests order by smallint_col;
select varchar_col, from_days(varchar_col) from from_days_tests order by smallint_col;
select string_col, from_days(string_col) from from_days_tests order by smallint_col;
select bit_col, from_days(bit_col) from from_days_tests order by smallint_col;
select integer_col, from_days(integer_col) from from_days_tests order by smallint_col;
select smallint_col, from_days(smallint_col) from from_days_tests order by smallint_col;
select bigint_col, from_days(bigint_col) from from_days_tests order by smallint_col;
select float_col, from_days(float_col) from from_days_tests order by smallint_col;
select double_col, from_days(double_col) from from_days_tests order by smallint_col;
select numeric_col, from_days(numeric_col) from from_days_tests order by smallint_col;
select monetary_col, from_days(monetary_col) from from_days_tests order by smallint_col;
select date_col, from_days(date_col) from from_days_tests order by smallint_col;
select time_col, from_days(time_col) from from_days_tests order by smallint_col;
select timestamp_col, from_days(timestamp_col) from from_days_tests order by smallint_col;
select datetime_col, from_days(datetime_col) from from_days_tests order by smallint_col;
select set_col, from_days(set_col) from from_days_tests order by smallint_col; 

select * from from_days_tests where smallint_col = from_days('2010-01-02')+10 order by smallint_col;

drop table from_days_tests;

create table from_days_tests as select from_days('77777');

SELECT * FROM db_attribute where class_name='from_days_tests';

select * from from_days_tests;

drop table from_days_tests;

create view from_days_view(v) as select from_days('77777') from db_root;

select * from from_days_view;

drop from_days_view;

$varchar, $1900.21
select from_days(?) as rez;

$int, $2540
select from_days(?) as rez;

$float, $2540.23
select from_days(?) as rez;

$double, $3540.23
select from_days(?) as rez;

$numeric, $2540.74
select from_days(?) as rez;

$datetime, $01/02/1985 12:13:15
select from_days(?) as rez;

$datetime, $01/02/1985 12:13:15
select 1 as rez from db_root where from_days(?) = 1;


select from_days(731945), if (from_days(731945) = '2003-12-31', 'ok', 'nok');
select from_days(731945+10), if (from_days(731945+10) = '2004-01-10', 'ok', 'nok');
select from_days(731945-10), if (from_days(731945-10) = '2003-12-21', 'ok', 'nok');
select from_days(731945+366), if (from_days(731945+366) = '2004-12-31', 'ok', 'nok');
select from_days(731945+365*2+1), if (from_days(731945+365*2+1) = '2005-12-31', 'ok', 'nok');
select from_days(731945+365*3+1), if (from_days(731945+365*3+1) = '2006-12-31', 'ok', 'nok');
select from_days(731945+365*4+1), if (from_days(731945+365*4+1) = '2007-12-31', 'ok', 'nok');
select from_days(731945+365*5+2), if (from_days(731945+365*5+2) = '2008-12-31', 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select from_days(-1);
select from_days(1000000000);

commit;
--+ holdcas off;
