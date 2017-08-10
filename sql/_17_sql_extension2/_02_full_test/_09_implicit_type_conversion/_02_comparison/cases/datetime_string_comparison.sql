--test implicit type conversion when comparing date/time with string type


create table datetime_string_comparison(
	col1 datetime,
	col2 timestamp,
	col3 date,
	col4 time,
	col5 char(30),
	col6 nchar(30),
	col7 varchar(30),
	col8 nchar varying(30),
	col9 string
);

insert into datetime_string_comparison values(
	datetime'11/09/2010 17:56:22.222',
	timestamp'11/09/2010 17:56:22 PM',
	date'2010-11-09',
	time'17:56:22 pm',
	'2010-11-10 17:56:22.222',
	n'2010-11-10 17:56:22',
	'2010-11-10',
	n'17:56:23',
	'abcde'
);



select (col1 > col5) from datetime_string_comparison;

select (col1 < col6) from datetime_string_comparison;

select (col1 >= col7) from datetime_string_comparison;

select (col1 <> col8) from datetime_string_comparison;



select (col2 < col5) from datetime_string_comparison;

select (col2 <= col6) from datetime_string_comparison;

select (col2 > col7) from datetime_string_comparison;

select (col2 != col8) from datetime_string_comparison;



select (col3 <= col5) from datetime_string_comparison;

select (col3 = col6) from datetime_string_comparison;

select (col3 <=> col7) from datetime_string_comparison;

select (col3 > col8) from datetime_string_comparison;



select (col4 < col5) from datetime_string_comparison;

select (col4 >= col6) from datetime_string_comparison;

select (col4 = col7) from datetime_string_comparison;

select (col4 != col8) from datetime_string_comparison;



--[er]
select (col1 < col9) from datetime_string_comparison;
--[er]
select (col2 > col9) from datetime_string_comparison;
--[er]
select (col3 != col9) from datetime_string_comparison;
--[er]
select (col4 <= col9) from datetime_string_comparison;



drop table datetime_string_comparison;
