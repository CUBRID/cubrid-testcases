--simple case: order by different data types:
--int, bit varying(n), blob, clob

create table uoo(
	col1 int,
	col2 bit varying(20),
	col3 blob,
	col4 clob
);

insert into uoo values 
	(1, X'fff', bit_to_blob(b'1010100'), char_to_clob('abc')), 
	(4, X'ccc', bit_to_blob(b'0110011'), char_to_clob('ghi')),
	(3, X'aaa', bit_to_blob(x'1982818'), char_to_clob('opq')),
	(5, X'ddd', bit_to_blob(b'1110010'), char_to_clob('def')),
	(2, X'bbb', bit_to_blob(x'abcdefa'), char_to_clob('jkl'));

select col1, col2, blob_to_bit(col3), clob_to_char(col4) from uoo order by col1;

update uoo set col1=col1+2 order by col1;
select col1, col2, blob_to_bit(col3), clob_to_char(col4) from uoo order by col1;

update uoo set col1=col1+2 order by col2;
select col1, col2, blob_to_bit(col3), clob_to_char(col4) from uoo order by col1;

--error
update uoo set col1=col1+2 order by col3;

--error
update uoo set col1=col1+2 order by col4;


delete from uoo;
drop table uoo;
