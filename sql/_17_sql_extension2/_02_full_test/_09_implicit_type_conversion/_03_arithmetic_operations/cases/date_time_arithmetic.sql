--test implicit type conversion when doing arithmetic operations with different date/time types


create table date_time_arithmetic(
	col1 datetime,
	col2 timestamp,
	col3 date,
	col4 time
);

insert into date_time_arithmetic values(
	datetime'11/09/2010 17:56:22.222',
	timestamp'11/09/2010 17:56:22 PM',
	date'2010-11-09',
	time'17:56:22 pm'
);



select (col1 - col2) from date_time_arithmetic;

select (col1 - col3) from date_time_arithmetic;

select (col1 - col4) from date_time_arithmetic;

select (col1 - datetime'12/25/1923 23:33:45.122') from date_time_arithmetic;



select (col2 - col1) from date_time_arithmetic;

select (col2 - col3) from date_time_arithmetic;

select (col2 - col4) from date_time_arithmetic;

select (col2 - col3 - col1) from date_time_arithmetic;



select (col3 - col1) from date_time_arithmetic;

select (col3 - col2) from date_time_arithmetic;

select (col3 - col1 - col4) from date_time_arithmetic;

select (col3 - col4) from date_time_arithmetic;



select (col4 - col1) from date_time_arithmetic;

select (col4 - col2) from date_time_arithmetic;

select (col4 - col2 - col1 - col3) from date_time_arithmetic;

select (col4 - col3) from date_time_arithmetic;



--[er]
select (col1 + col2) from date_time_arithmetic;
--[er]
select (col2 * col3) from date_time_arithmetic;
--[er]
select (col3 / col4) from date_time_arithmetic;
--[er]
select (col1 % col3) from date_time_arithmetic;
--[er]
select (col2 / col3) from date_time_arithmetic;
--[er]
select (col3 + col4) from date_time_arithmetic;




drop table date_time_arithmetic;
