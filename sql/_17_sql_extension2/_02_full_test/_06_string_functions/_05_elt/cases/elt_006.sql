--pass unmatched types of values to the 2nd and more parameters


create table soo(
	col1 bit(20),
	col2 bit varying(20),
	col3 set,
	col4 multiset,
	col5 list,
	col6 blob,
	col7 clob,
	col8 bit(20),
	col9 bit varying(20),
	col10 set,
	col11 multiset,
	col12 list,
	col13 blob,
	col14 clob
);


insert into soo values(b'10101001', x'abcdabc', {1, 2, 3}, {1, 2, 3, 1, 2, 3}, {3, 2, 1, 3}, bit_to_blob(b'1001001'), char_to_clob('123123'),
		       b'10101111', x'abcdeff', {2, 3, 4}, {2, 3, 4, 2, 3, 4}, {2, 4, 3, 2}, bit_to_blob(X'abccccc'), char_to_clob('abcabc'));

--error
select elt(1, col1, col8) from soo; 
--error
select elt(2, col2, col9) from soo;
--error
select elt(1, col3, col10) from soo;
--error
select elt(2, col4, col11) from soo;
--error
select elt(2, col5, col12) from soo;
--error
select elt(1, col6, col13) from soo;
--error
select elt(2, col7, col14) from soo;
--error
select elt(10, col7, col14) from soo;
--error
select elt(7, col1, col2, col3, col4, col5, col6, col7) from soo;


delete from soo;
drop table soo;


