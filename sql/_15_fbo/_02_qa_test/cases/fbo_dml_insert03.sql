--normal insert without column list
create class insert3_tb(
col1 int primary key,
col2 varchar(20),
col3 varchar(20),
col4 blob,
col5 clob
);

insert into insert3_tb values(1, 'aaa1', 'bbb1', bit_to_blob(X'000010'), char_to_clob('bbb1'));
insert into insert3_tb values(2, 'aaa2', 'bbb2', bit_to_blob(X'010010'), char_to_clob('bbb2'));
insert into insert3_tb values(3, 'aaa3', 'bbb3', bit_to_blob(B'010010'), char_to_clob('bbb3'));

select col1, col2, col3, blob_to_bit(col4), clob_to_char(col5) from insert3_tb order by col1;

delete from insert3_tb;
drop class insert3_tb;
