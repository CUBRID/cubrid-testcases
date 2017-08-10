--pass unmatched types of values to the 2nd parameter


create table soo(
	col1 bit(20),
	col2 bit varying(20),
	col3 set,
	col4 multiset,
	col5 list,
	col6 blob,
	col7 clob
);


insert into soo values(b'10101001', x'abcdabc', {1, 2, 3}, {1, 2, 3, 1, 2, 3}, {3, 2, 1, 3}, bit_to_blob(b'1001001'), char_to_clob('123123'));


--error
select substring_index(10101001, col1, 2) from soo; 
--error
select substring_index('abcabc', col2, 1) from soo;
--error
select substring_index('1, 2, 3', col3, -3) from soo;
--error
select substring_index('1, 2, 3, 1, 2, 3', col4,-2) from soo;
--error
select substring_index('3, 2, 1, 3', col5, -1) from soo;
--error
select substring_index('1001001', col6, 2) from soo;
--error
select substring_index('123123', col7, 1) from soo;


delete from soo;
drop table soo;


