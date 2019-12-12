--insert with a column whose attribute has auto_increment keyword
create class insert4_tb(
col1 int auto_increment primary key,
col2 varchar(20),
col3 varchar(20),
col4 blob,
col5 clob
);

insert into insert4_tb (col2, col3, col4, col5) values('aaa1', 'bbb1', bit_to_blob(X'000010'), char_to_clob('bbb1'));
insert into insert4_tb (col2, col3, col4, col5) values('aaa2', 'bbb2', bit_to_blob(X'010010'), char_to_clob('bbb2'));
insert into insert4_tb (col2, col3, col4, col5) values('aaa3', 'bbb3', bit_to_blob(X'aaa3'), char_to_clob('bbb3'));

select col1, col2, col3, blob_to_bit(col4), clob_to_char(col5) from insert4_tb order by col1;

delete from insert4_tb;
drop class insert4_tb;
