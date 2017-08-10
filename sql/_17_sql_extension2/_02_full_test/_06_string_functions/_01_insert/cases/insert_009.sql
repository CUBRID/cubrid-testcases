--pass unmatched types of values to the 4th parameter


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
select insert('aaa-bbb-ccc-ddd-eee-fff', 3, 2, col1) from soo; 
--error
select insert('aaa-bbb-ccc-ddd-eee-fff', 3, 2, col2) from soo;
--error
select insert('aaa-bbb-ccc-ddd-eee-fff', 3, 2, col3) from soo;
--error
select insert('aaa-bbb-ccc-ddd-eee-fff', 3, 2, col4) from soo;
--error
select insert('aaa-bbb-ccc-ddd-eee-fff', 3, 2, col5) from soo;
--error
select insert('aaa-bbb-ccc-ddd-eee-fff', 3, 2, col6) from soo;
--error
select insert('aaa-bbb-ccc-ddd-eee-fff', 3, 2, col7) from soo;


delete from soo;
drop table soo;


