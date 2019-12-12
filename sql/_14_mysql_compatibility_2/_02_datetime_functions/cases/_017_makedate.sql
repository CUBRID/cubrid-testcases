--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select makedate(1990,0);
select makedate(1990,5);
select makedate('3600','5');
select makedate(1990.1,5);
select makedate(1990.5,5);
select makedate(1990.9,5);

create table makedate_tests(char_col char(32), varchar_col varchar(32), 
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

insert into makedate_tests values('2010-01-02','6200','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, makedate(char_col,smallint_col) from makedate_tests order by smallint_col;
select varchar_col, makedate(varchar_col,smallint_col) from makedate_tests order by smallint_col;
select string_col, makedate(string_col,smallint_col) from makedate_tests order by smallint_col;
select bit_col, makedate(bit_col,smallint_col) from makedate_tests order by smallint_col;
select integer_col, makedate(integer_col,smallint_col) from makedate_tests order by smallint_col;
select smallint_col, makedate(smallint_col,smallint_col) from makedate_tests order by smallint_col;
select bigint_col, makedate(bigint_col,smallint_col) from makedate_tests order by smallint_col;
select float_col, makedate(float_col,smallint_col) from makedate_tests order by smallint_col;
select double_col, makedate(double_col,smallint_col) from makedate_tests order by smallint_col;
select numeric_col, makedate(numeric_col,smallint_col) from makedate_tests order by smallint_col;
select monetary_col, makedate(monetary_col,smallint_col) from makedate_tests order by smallint_col;
select date_col, makedate(date_col,smallint_col) from makedate_tests order by smallint_col;
select time_col, makedate(time_col,smallint_col) from makedate_tests order by smallint_col;
select timestamp_col, makedate(timestamp_col,smallint_col) from makedate_tests order by smallint_col;
select datetime_col, makedate(datetime_col,smallint_col) from makedate_tests order by smallint_col;
select set_col, makedate(set_col,smallint_col) from makedate_tests order by smallint_col; 

select * from makedate_tests where date_col = makedate('2019-01-02',365) order by smallint_col;

drop table makedate_tests;

create table makedate_tests as select makedate('2010',123);

SELECT * FROM db_attribute where class_name='makedate_tests';

select * from makedate_tests;

drop table makedate_tests;

create view makedate_view(v) as select makedate('2010',5) from db_root;

select * from makedate_view;

drop makedate_view;

$varchar, $'1900.21'
select makedate(?,10) as rez;

$int, $2540
select makedate(?,12) as rez;

$float, $2540.23
select makedate(?,10) as rez;

$double, $3540.23
select makedate(?,10) as rez;

$numeric, $2540.74
select makedate('2010-01-01',?) as rez;

$datetime, $01/02/1985 12:13:15
select makedate(?,0) as rez;

$int, $2540, $int, $12
select makedate(?,?) as rez;

$int, $2540
select makedate('1900-01-01',?) as rez;

$int, $10
select 1 as rez from db_root where makedate('2010-01-01',?) = '2010-01-10';

select makedate(2000, 1), if (makedate(2000, 1) = '2000-01-01', 'ok', 'nok');
select makedate(2000, 31+1), if (makedate(2000, 31+1) = '2000-02-01', 'ok', 'nok');
select makedate(2000, 31+29+1), if (makedate(2000, 31+29+1) = '2000-03-01', 'ok', 'nok');
select makedate(2000, 31+29+31+1), if (makedate(2000, 31+29+31+1) = '2000-04-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+1), if (makedate(2000, 31+29+31+30+1) = '2000-05-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+1), if (makedate(2000, 31+29+31+30+31+1) = '2000-06-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+1), if (makedate(2000, 31+29+31+30+31+30+1) = '2000-07-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+1), if (makedate(2000, 31+29+31+30+31+30+31+1) = '2000-08-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+1), if (makedate(2000, 31+29+31+30+31+30+31+31+1) = '2000-09-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+1) = '2000-10-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+1) = '2000-11-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+1) = '2000-12-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+31), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+31) = '2000-12-31', 'ok', 'nok');

select makedate(1980, date'05/08/1980'-date'01/01/1980'+1), if (makedate(1980, date'05/08/1980'-date'01/01/1980'+1) = date'05/08/1980', 'ok', 'nok');
select makedate(1980, date'09/18/1980'-date'01/01/1980'+1), if (makedate(1980, date'09/18/1980'-date'01/01/1980'+1) = date'09/18/1980', 'ok', 'nok');
select makedate(1980, date'11/23/1980'-date'01/01/1980'+1), if (makedate(1980, date'11/23/1980'-date'01/01/1980'+1) = date'11/23/1980', 'ok', 'nok');
select makedate(1980, date'07/30/1980'-date'01/01/1980'+1), if (makedate(1980, date'07/30/1980'-date'01/01/1980'+1) = date'07/30/1980', 'ok', 'nok');
select makedate(1980, date'08/20/1980'-date'01/01/1980'+1), if (makedate(1980, date'08/20/1980'-date'01/01/1980'+1) = date'08/20/1980', 'ok', 'nok');
select makedate(1977, date'05/08/1977'-date'01/01/1977'+1), if (makedate(1977, date'05/08/1977'-date'01/01/1977'+1) = date'05/08/1977', 'ok', 'nok');
select makedate(1977, date'09/18/1977'-date'01/01/1977'+1), if (makedate(1977, date'09/18/1977'-date'01/01/1977'+1) = date'09/18/1977', 'ok', 'nok');
select makedate(1977, date'11/23/1977'-date'01/01/1977'+1), if (makedate(1977, date'11/23/1977'-date'01/01/1977'+1) = date'11/23/1977', 'ok', 'nok');
select makedate(1977, date'07/30/1977'-date'01/01/1977'+1), if (makedate(1977, date'07/30/1977'-date'01/01/1977'+1) = date'07/30/1977', 'ok', 'nok');
select makedate(1977, date'08/20/1977'-date'01/01/1977'+1), if (makedate(1977, date'08/20/1977'-date'01/01/1977'+1) = date'08/20/1977', 'ok', 'nok');
select makedate(2003, date'05/08/2003'-date'01/01/2003'+1), if (makedate(2003, date'05/08/2003'-date'01/01/2003'+1) = date'05/08/2003', 'ok', 'nok');
select makedate(2003, date'09/18/2003'-date'01/01/2003'+1), if (makedate(2003, date'09/18/2003'-date'01/01/2003'+1) = date'09/18/2003', 'ok', 'nok');
select makedate(2003, date'11/23/2003'-date'01/01/2003'+1), if (makedate(2003, date'11/23/2003'-date'01/01/2003'+1) = date'11/23/2003', 'ok', 'nok');
select makedate(2003, date'07/30/2003'-date'01/01/2003'+1), if (makedate(2003, date'07/30/2003'-date'01/01/2003'+1) = date'07/30/2003', 'ok', 'nok');
select makedate(2003, date'08/20/2003'-date'01/01/2003'+1), if (makedate(2003, date'08/20/2003'-date'01/01/2003'+1) = date'08/20/2003', 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select makedate(2000, 0);
select makedate(2000, -1);
select makedate(10000, 1);
select makedate(-1, 1);

set system parameters 'return_null_on_function_errors = no';
select makedate(1990,0);
select makedate(1990,5);
select makedate('3600','5');
select makedate(1990.1,5);
select makedate(1990.5,5);
select makedate(1990.9,5);

create table makedate_tests(char_col char(32), varchar_col varchar(32), 
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

insert into makedate_tests values('2010-01-02','6200','05/04/2010 12:23:15.123',NULL,12000,10,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10}),('2010-01-02','1971-12-22 00:14:11','10/04/2010 12:23:15.123',NULL,12000,11,1111111111,12.25,111.11111111,11.12,1234,'2010-01-02','12:10:09',timestamp('2008-10-11 10:49:51'),'1983-01-02
17:28:31',{'golf', 'handicap', 10});

select char_col, makedate(char_col,smallint_col) from makedate_tests order by smallint_col;
select varchar_col, makedate(varchar_col,smallint_col) from makedate_tests order by smallint_col;
select string_col, makedate(string_col,smallint_col) from makedate_tests order by smallint_col;
select bit_col, makedate(bit_col,smallint_col) from makedate_tests order by smallint_col;
select integer_col, makedate(integer_col,smallint_col) from makedate_tests order by smallint_col;
select smallint_col, makedate(smallint_col,smallint_col) from makedate_tests order by smallint_col;
select bigint_col, makedate(bigint_col,smallint_col) from makedate_tests order by smallint_col;
select float_col, makedate(float_col,smallint_col) from makedate_tests order by smallint_col;
select double_col, makedate(double_col,smallint_col) from makedate_tests order by smallint_col;
select numeric_col, makedate(numeric_col,smallint_col) from makedate_tests order by smallint_col;
select monetary_col, makedate(monetary_col,smallint_col) from makedate_tests order by smallint_col;
select date_col, makedate(date_col,smallint_col) from makedate_tests order by smallint_col;
select time_col, makedate(time_col,smallint_col) from makedate_tests order by smallint_col;
select timestamp_col, makedate(timestamp_col,smallint_col) from makedate_tests order by smallint_col;
select datetime_col, makedate(datetime_col,smallint_col) from makedate_tests order by smallint_col;
select set_col, makedate(set_col,smallint_col) from makedate_tests order by smallint_col; 

select * from makedate_tests where date_col = makedate('2019-01-02',365) order by smallint_col;

drop table makedate_tests;

create table makedate_tests as select makedate('2010',123);

SELECT * FROM db_attribute where class_name='makedate_tests';

select * from makedate_tests;

drop table makedate_tests;

create view makedate_view(v) as select makedate('2010',5) from db_root;

select * from makedate_view;

drop makedate_view;

$varchar, $'1900.21'
select makedate(?,10) as rez;

$int, $2540
select makedate(?,12) as rez;

$float, $2540.23
select makedate(?,10) as rez;

$double, $3540.23
select makedate(?,10) as rez;

$numeric, $2540.74
select makedate('2010-01-01',?) as rez;

$datetime, $01/02/1985 12:13:15
select makedate(?,0) as rez;

$int, $2540, $int, $12
select makedate(?,?) as rez;

$int, $2540
select makedate('1900-01-01',?) as rez;

$int, $10
select 1 as rez from db_root where makedate('2010-01-01',?) = '2010-01-10';

select makedate(2000, 1), if (makedate(2000, 1) = '2000-01-01', 'ok', 'nok');
select makedate(2000, 31+1), if (makedate(2000, 31+1) = '2000-02-01', 'ok', 'nok');
select makedate(2000, 31+29+1), if (makedate(2000, 31+29+1) = '2000-03-01', 'ok', 'nok');
select makedate(2000, 31+29+31+1), if (makedate(2000, 31+29+31+1) = '2000-04-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+1), if (makedate(2000, 31+29+31+30+1) = '2000-05-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+1), if (makedate(2000, 31+29+31+30+31+1) = '2000-06-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+1), if (makedate(2000, 31+29+31+30+31+30+1) = '2000-07-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+1), if (makedate(2000, 31+29+31+30+31+30+31+1) = '2000-08-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+1), if (makedate(2000, 31+29+31+30+31+30+31+31+1) = '2000-09-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+1) = '2000-10-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+1) = '2000-11-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+1) = '2000-12-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+31), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+31) = '2000-12-31', 'ok', 'nok');

select makedate(1980, date'05/08/1980'-date'01/01/1980'+1), if (makedate(1980, date'05/08/1980'-date'01/01/1980'+1) = date'05/08/1980', 'ok', 'nok');
select makedate(1980, date'09/18/1980'-date'01/01/1980'+1), if (makedate(1980, date'09/18/1980'-date'01/01/1980'+1) = date'09/18/1980', 'ok', 'nok');
select makedate(1980, date'11/23/1980'-date'01/01/1980'+1), if (makedate(1980, date'11/23/1980'-date'01/01/1980'+1) = date'11/23/1980', 'ok', 'nok');
select makedate(1980, date'07/30/1980'-date'01/01/1980'+1), if (makedate(1980, date'07/30/1980'-date'01/01/1980'+1) = date'07/30/1980', 'ok', 'nok');
select makedate(1980, date'08/20/1980'-date'01/01/1980'+1), if (makedate(1980, date'08/20/1980'-date'01/01/1980'+1) = date'08/20/1980', 'ok', 'nok');
select makedate(1977, date'05/08/1977'-date'01/01/1977'+1), if (makedate(1977, date'05/08/1977'-date'01/01/1977'+1) = date'05/08/1977', 'ok', 'nok');
select makedate(1977, date'09/18/1977'-date'01/01/1977'+1), if (makedate(1977, date'09/18/1977'-date'01/01/1977'+1) = date'09/18/1977', 'ok', 'nok');
select makedate(1977, date'11/23/1977'-date'01/01/1977'+1), if (makedate(1977, date'11/23/1977'-date'01/01/1977'+1) = date'11/23/1977', 'ok', 'nok');
select makedate(1977, date'07/30/1977'-date'01/01/1977'+1), if (makedate(1977, date'07/30/1977'-date'01/01/1977'+1) = date'07/30/1977', 'ok', 'nok');
select makedate(1977, date'08/20/1977'-date'01/01/1977'+1), if (makedate(1977, date'08/20/1977'-date'01/01/1977'+1) = date'08/20/1977', 'ok', 'nok');
select makedate(2003, date'05/08/2003'-date'01/01/2003'+1), if (makedate(2003, date'05/08/2003'-date'01/01/2003'+1) = date'05/08/2003', 'ok', 'nok');
select makedate(2003, date'09/18/2003'-date'01/01/2003'+1), if (makedate(2003, date'09/18/2003'-date'01/01/2003'+1) = date'09/18/2003', 'ok', 'nok');
select makedate(2003, date'11/23/2003'-date'01/01/2003'+1), if (makedate(2003, date'11/23/2003'-date'01/01/2003'+1) = date'11/23/2003', 'ok', 'nok');
select makedate(2003, date'07/30/2003'-date'01/01/2003'+1), if (makedate(2003, date'07/30/2003'-date'01/01/2003'+1) = date'07/30/2003', 'ok', 'nok');
select makedate(2003, date'08/20/2003'-date'01/01/2003'+1), if (makedate(2003, date'08/20/2003'-date'01/01/2003'+1) = date'08/20/2003', 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select makedate(2000, 0);
select makedate(2000, -1);
select makedate(10000, 1);
select makedate(-1, 1);

commit;
--+ holdcas off;
