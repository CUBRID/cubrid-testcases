--test implicit type conversion when comparing different number types


create table number_arithmetic(
	col1 monetary,
	col2 double,
	col3 float,
	col4 numeric,
	col5 bigint,
	col6 int,
	col7 short
);

insert into number_arithmetic values(
	12345.6789123,
	12345.678912,
	12345.6789,
	123456,
	123456789,
	12345,
	123
);



select col1 + col2 from number_arithmetic;

select col1 - col3 from number_arithmetic;

select col1 * col4 from number_arithmetic;

select col1 / col5 from number_arithmetic;

select col1 % col6 from number_arithmetic;

select col1 + col7 from number_arithmetic;



select col2 % col1 from number_arithmetic;

select col2 / col3 from number_arithmetic;

select col2 * col4 from number_arithmetic;

select col2 - col5 from number_arithmetic;

select col2 + col6 from number_arithmetic;

select col2 div col7 from number_arithmetic;



select col3 - col1 from number_arithmetic;

select col3 * col2 from number_arithmetic;

select col3 / col4 from number_arithmetic;

select col3 % col5 from number_arithmetic;

select col3 div col6 from number_arithmetic;

select col3 + col7 from number_arithmetic;



select col4 + col5 - col7 * col1 from number_arithmetic;

select col4 / col6 + col2 % col3 from number_arithmetic;

select col4 div col7 - col3 * col5 / col2 from number_arithmetic;



select col5 + col6 / col7 from number_arithmetic;

select col5 % col7 - col2 + col1 * col2 from number_arithmetic;

select col6 div col7 + (col3 - col4) * col1 from number_arithmetic;


drop table number_arithmetic;
