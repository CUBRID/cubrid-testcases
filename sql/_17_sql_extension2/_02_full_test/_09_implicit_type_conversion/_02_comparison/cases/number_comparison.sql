--test implicit type conversion when comparing different number types


create table datetime_number_comparison(
	col1 monetary,
	col2 double,
	col3 float,
	col4 numeric,
	col5 bigint,
	col6 int,
	col7 short
);

insert into datetime_number_comparison values(
	12345.6789123,
	12345.678912,
	12345.6789,
	123456,
	123456789,
	12345,
	123
);



select (col1 > col2) from datetime_number_comparison;

select (col1 < col3) from datetime_number_comparison;

select (col1 >= col4) from datetime_number_comparison;

select (col1 <> col5) from datetime_number_comparison;

select (col1 <= col6) from datetime_number_comparison;

select (col1 = col7) from datetime_number_comparison;

select (col1 <=> col1) from datetime_number_comparison;



select (col2 > col1) from datetime_number_comparison;

select (col2 < col3) from datetime_number_comparison;

select (col2 >= col4) from datetime_number_comparison;

select (col2 <> col5) from datetime_number_comparison;

select (col2 <= col6) from datetime_number_comparison;

select (col2 = col7) from datetime_number_comparison;

select (col2 <=> col2) from datetime_number_comparison;



select (col3 > col1) from datetime_number_comparison;

select (col3 < col2) from datetime_number_comparison;

select (col3 >= col3) from datetime_number_comparison;

select (col3 <> col4) from datetime_number_comparison;

select (col3 <= col5) from datetime_number_comparison;

select (col3 = col6) from datetime_number_comparison;

select (col3 <=> col7) from datetime_number_comparison;



select (col4 > col5) from datetime_number_comparison;

select (col4 < col6) from datetime_number_comparison;

select (col4 >= col7) from datetime_number_comparison;



select (col5 > col6) from datetime_number_comparison;

select (col5 < col7) from datetime_number_comparison;

select (col6 >= col7) from datetime_number_comparison;


drop table datetime_number_comparison;
