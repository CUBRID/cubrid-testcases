--test implicit type conversion when comparing different date/time types


create table date_time_comparison(
	col1 datetime,
	col2 timestamp,
	col3 date,
	col4 time
);

insert into date_time_comparison values(
	datetime'11/09/2010 17:56:22.222',
	timestamp'11/09/2010 17:56:22 PM',
	date'2010-11-09',
	time'17:56:22 pm'
);


--true
select (col1 > col2) from date_time_comparison;
--false
select (col1 < col3) from date_time_comparison;
--true
select (col1 >= col4) from date_time_comparison;
--false
select (col1 <> col1) from date_time_comparison;


--true
select (col2 < col1) from date_time_comparison;
--false
select (col2 <= col3) from date_time_comparison;
--true
select (col2 > col4) from date_time_comparison;
--false
select (col2 != col2) from date_time_comparison;


--true
select (col3 <= col1) from date_time_comparison;
--false
select (col3 = col2) from date_time_comparison;
--true
select (col3 <=> col3) from date_time_comparison;
--[er]
select (col3 > col4) from date_time_comparison;


--true
select (col4 < col1) from date_time_comparison;
--false
select (col4 >= col2) from date_time_comparison;
--true
select (col4 = col4) from date_time_comparison;
--[er]
select (col4 != col3) from date_time_comparison;


drop table date_time_comparison;
