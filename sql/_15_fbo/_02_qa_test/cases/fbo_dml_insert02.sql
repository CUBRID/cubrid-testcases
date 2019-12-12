--normal insert with column list
create class insert2_tb(
col1 int primary key,
col2 varchar(20),
col3 varchar(20),
col4 blob,
col5 clob
);

insert into insert2_tb (col1, col2, col3, col4, col5) values(1, 'aaa1', 'bbb1', bit_to_blob(B'000010'), char_to_clob('bbb1'));
insert into insert2_tb (col1, col2, col3, col4, col5) values(2, 'aaa2', 'bbb2', bit_to_blob(B'000010'), char_to_clob('bbb2'));
insert into insert2_tb (col1, col2, col3, col4, col5) values(3, 'aaa3', 'bbb3', bit_to_blob(B'000010'), char_to_clob('bbb3'));

select col1, col2, col3, blob_to_bit(col4), clob_to_char(col5) from insert2_tb order by col1;

delete from insert2_tb;
drop class insert2_tb;
