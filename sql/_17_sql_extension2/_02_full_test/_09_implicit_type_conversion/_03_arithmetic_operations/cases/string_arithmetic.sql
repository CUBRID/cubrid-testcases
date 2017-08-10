--+ holdcas on;
--test implicit type conversion when doing arithmetic operations with different string types


create table string_arithmetic(
	col1 char(20),
	col2 nchar(20),
	col3 varchar(20),
	col4 nchar varying(20),
	col5 string
);

insert into string_arithmetic values(
	'34234',
	n'5492.34534534',
	'-5435',
	n'390485.34544',
	'abcde'
);


set system parameters 'plus_as_concat=no';

select col1 + col2 from string_arithmetic;

select col1 - col3 from string_arithmetic;

select col1 * col4 from string_arithmetic;



select col2 / col1 from string_arithmetic;

select col2 - col3 from string_arithmetic;

select col2 * col4 from string_arithmetic;



select col3 + col1 from string_arithmetic;

select col3 - col2 from string_arithmetic;

select col3 % col4 from string_arithmetic;



select col4 + col1 from string_arithmetic;

select col4 * col2 from string_arithmetic;

select col4 / col3 from string_arithmetic;



select col1 + col5 from string_arithmetic;

select col2 - col5 from string_arithmetic;

select col3 * col5 from string_arithmetic;

select col4 div col5 from string_arithmetic;



set system parameters 'plus_as_concat=yes';

select col1 + col1 from string_arithmetic;
select col1 + col2 from string_arithmetic;
select col1 + col3 from string_arithmetic;
select col1 + col4 from string_arithmetic;
select col1 + col5 from string_arithmetic;

select col2 + col1 from string_arithmetic;
select col2 + col2 from string_arithmetic;
select col2 + col3 from string_arithmetic;
select col2 + col4 from string_arithmetic;
select col2 + col5 from string_arithmetic;

select col3 + col1 from string_arithmetic;
select col3 + col2 from string_arithmetic;
select col3 + col3 from string_arithmetic;
select col3 + col4 from string_arithmetic;
select col3 + col5 from string_arithmetic;

select col4 + col1 from string_arithmetic;
select col4 + col2 from string_arithmetic;
select col4 + col3 from string_arithmetic;
select col4 + col4 from string_arithmetic;
select col4 + col5 from string_arithmetic;


select col1 - col3 from string_arithmetic;

select col2 * col4 from string_arithmetic;

select col4 / col3 from string_arithmetic;

select col3 % col4 from string_arithmetic;



drop table string_arithmetic;
commit;
--+ holdcas off;
