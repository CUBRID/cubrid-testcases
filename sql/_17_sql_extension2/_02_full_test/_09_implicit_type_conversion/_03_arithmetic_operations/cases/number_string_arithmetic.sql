--test implicit type conversion when doing arithmetic operations with number and string type


create table number_string_arithmetic(
	col1 monetary,
	col2 double,
	col3 float,
	col4 numeric,
	col5 bigint,
	col6 int,
	col7 short,
	col8 char(20),
	col9 nchar(20),
	col10 varchar(20),
	col11 nchar varying(20),
	col12 string
);

insert into number_string_arithmetic values(
	12345.6789123,
	12345.678912,
	12345.6789,
	123456,
	123456789,
	12345,
	123,
	'1234567',
	n'12345.678888',
	'123.123',
	n'12345.678',
	'abcdefg'
);



select col1 + col8 from number_string_arithmetic;

select col1 - col9 from number_string_arithmetic;

select col1 * col10 from number_string_arithmetic;

select col1 / col11 from number_string_arithmetic;

select col1 % col12 from number_string_arithmetic;



select col2 - col8 from number_string_arithmetic;

select col2 * col9 from number_string_arithmetic;

select col2 / col10 from number_string_arithmetic;

select col2 % col11 from number_string_arithmetic;

select col2 + col12 from number_string_arithmetic;



select col3 * col8 from number_string_arithmetic;

select col3 / col9 from number_string_arithmetic;

select col3 % col10 from number_string_arithmetic;

select col3 + col11 from number_string_arithmetic;

select col3 - col12 from number_string_arithmetic;



select col4 / col8 from number_string_arithmetic;

select col4 % col9 from number_string_arithmetic;

select col4 + col10 from number_string_arithmetic;

select col4 - col11 from number_string_arithmetic;

select col4 * col12 from number_string_arithmetic;



select col5 % col8 from number_string_arithmetic;

select col5 + col9 from number_string_arithmetic;

select col5 - col10 from number_string_arithmetic;

select col5 * col11 from number_string_arithmetic;

select col5 / col12 from number_string_arithmetic;



select col6 + col8 from number_string_arithmetic;

select col6 - col9 from number_string_arithmetic;

select col6 * col10 from number_string_arithmetic;

select col6 / col11 from number_string_arithmetic;

select col6 % col12 from number_string_arithmetic;



select col7 - col8 from number_string_arithmetic;

select col7 / col9 from number_string_arithmetic;

select col7 * col10 from number_string_arithmetic;

select col7 % col11 from number_string_arithmetic;

select col7 + col12 from number_string_arithmetic;




drop table number_string_arithmetic;
