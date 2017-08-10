--test implicit type conversion when comparing date/time with number type


create table datetime_number_comparison(
	col1 datetime,
	col2 timestamp,
	col3 date,
	col4 time,
	col5 monetary,
	col6 double,
	col7 float,
	col8 numeric,
	col9 bigint,
	col10 int,
	col11 short
);

insert into datetime_number_comparison values(
	datetime'11/09/2010 17:56:22.222',
	timestamp'11/09/2010 17:56:22 PM',
	date'2010-11-09',
	time'17:56:22 pm',
	12345.6789123,
	1234.56789,
	1234.56789,
	44455,
	123456789,
	12345,
	123
);


--[er]
select (col1 > col5) from datetime_number_comparison;
--[er]
select (col1 < col6) from datetime_number_comparison;
--[er]
select (col1 >= col7) from datetime_number_comparison;
--[er]
select (col1 <> col8) from datetime_number_comparison;
--[er]
select (col1 <= col9) from datetime_number_comparison;
--[er]
select (col1 = col10) from datetime_number_comparison;
--[er]
select (col1 <=> col11) from datetime_number_comparison;


--[er]
select (col2 > col5) from datetime_number_comparison;
--[er]
select (col2 < col6) from datetime_number_comparison;
--[er]
select (col2 >= col7) from datetime_number_comparison;
--[er]
select (col2 <> col8) from datetime_number_comparison;
--[er]
select (col2 <= col9) from datetime_number_comparison;
--[er]
select (col2 = col10) from datetime_number_comparison;
--[er]
select (col2 <=> col11) from datetime_number_comparison;


--[er]
select (col3 > col5) from datetime_number_comparison;
--[er]
select (col3 < col6) from datetime_number_comparison;
--[er]
select (col3 >= col7) from datetime_number_comparison;
--[er]
select (col3 <> col8) from datetime_number_comparison;
--[er]
select (col3 <= col9) from datetime_number_comparison;
--[er]
select (col3 = col10) from datetime_number_comparison;
--[er]
select (col3 <=> col11) from datetime_number_comparison;


--[er]
select (col4 > col5) from datetime_number_comparison;
--[er]
select (col4 < col6) from datetime_number_comparison;
--[er]
select (col4 >= col7) from datetime_number_comparison;
--[er]
select (col4 <> col8) from datetime_number_comparison;
--[er]
select (col4 <= col9) from datetime_number_comparison;
--[er]
select (col4 = col10) from datetime_number_comparison;
--[er]
select (col4 <=> col11) from datetime_number_comparison;



drop table datetime_number_comparison;



--returns 0 in mysql
select (time'12:12:12' > 13);
