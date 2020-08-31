set system parameters 'create_table_reuseoid=no';
--test insert with two tables and a sub insert statement
create class insert6_tb2(
        col2_1 int,
        col2_2 clob
);

create class insert6_tb1(
        col1 int primary key,
        col2 blob,
        col3 insert6_tb2
);

insert into insert6_tb1 values(1, bit_to_blob(b'1001'), insert into insert6_tb2 values(1, char_to_clob('bbb1')));
insert into insert6_tb1 values(2, bit_to_blob(b'1010'), insert into insert6_tb2 values(2, char_to_clob('bbb2')));
insert into insert6_tb1 values(3, bit_to_blob(b'1100'), insert into insert6_tb2 values(3, char_to_clob('bbb3')));

select col1, blob_to_bit(col2), col3 from insert6_tb1 order by col1;
select col2_1, clob_to_char(col2_2) from insert6_tb2 order by col2_1;

delete from insert6_tb2;
delete from insert6_tb1;
drop class insert6_tb2;
drop class insert6_tb1;
set system parameters 'create_table_reuseoid=yes';
