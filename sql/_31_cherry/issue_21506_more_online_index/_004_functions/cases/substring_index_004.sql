--pass unmatched types of values to the 1st parameter


create table soo(
	col1 bit(20),
	col2 bit varying(20),
	col3 set,
	col4 multiset,
	col5 list,
	col6 blob,
	col7 clob
);
create index aa on soo(col1,col2) with online;

insert into soo values(b'10101001', x'abcdabc', {1, 2, 3}, {1, 2, 3, 1, 2, 3}, {3, 2, 1, 3}, bit_to_blob(b'1001001'), char_to_clob('123123'));


--error
select substring_index(col1, '0', 2) from soo; 
--error
select substring_index(col2, 'c', 1) from soo;
--error
select substring_index(col3, ',', -3) from soo;
--error
select substring_index(col4, ',', -2) from soo;
--error
select substring_index(col5, ',', -1) from soo;
--error
select substring_index(col6, '0', 2) from soo;
--error
select substring_index(col7, '3', 1) from soo;


delete from soo;
drop table soo;


