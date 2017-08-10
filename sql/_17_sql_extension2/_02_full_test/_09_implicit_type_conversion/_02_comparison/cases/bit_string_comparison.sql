--test implicit type conversion when comparing bit with string type


create table bit_string_comparison(
	col1 bit(20),
	col2 bit varying,
	col3 char(20),
	col4 nchar(20),
	col5 varchar(20),
	col6 nchar varying(20),
	col7 string
);

insert into bit_string_comparison values(
	B'10101001',
	B'0010101011',
	'b1010111',
	n'B01010111',
	B'11011111',
	n'b10110101',
	'abcdefg'
);


--[er]
select (col1 > col3) from bit_string_comparison;
--[er]
select (col1 < col4) from bit_string_comparison;
--[er]
select (col1 >= col5) from bit_string_comparison;
--[er]
select (col1 <> col6) from bit_string_comparison;
--[er]
select (col1 <> col7) from bit_string_comparison;


--[er]
select (col2 > col3) from bit_string_comparison;
--[er]
select (col2 < col4) from bit_string_comparison;
--[er]
select (col2 >= col5) from bit_string_comparison;
--[er]
select (col2 <> col6) from bit_string_comparison;
--[er]
select (col2 <> col7) from bit_string_comparison;



drop table bit_string_comparison;
