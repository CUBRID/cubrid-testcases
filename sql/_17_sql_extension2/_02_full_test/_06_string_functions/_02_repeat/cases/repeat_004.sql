--pass unmatched types of values to the 1st parameter


create table soo(
	col1 bit(20),
	col2 bit varying(30),
	col3 set,
	col4 multiset,
	col5 list,
	col6 blob,
	col7 clob
);


insert into soo values(b'10101001', x'abcdabc', {1, 2, 3}, {1, 2, 3, 1, 2, 3}, {3, 2, 1, 3}, bit_to_blob(b'1001001'), char_to_clob('123123'));


--ok
select repeat(col1, 3) from soo; 
--ok
select repeat(col2, 3) from soo;
--error
select repeat(col3, 3) from soo;
--error
select repeat(col4, 3) from soo;
--error
select repeat(col5, 3) from soo;
--error
select repeat(col6, 3) from soo;
--ok
select repeat(col7, 3) from soo;


delete from soo;
drop table soo;


