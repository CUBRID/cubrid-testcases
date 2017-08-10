--pass a group of int/blob/clob arguments


create table voo(col1 int, col2 blob, col3 clob);

insert into voo values (95, bit_to_blob(b'10100101'), char_to_clob('aaaaaaa'));
insert into voo values (88, bit_to_blob(x'aaabbbc'), char_to_clob('bbbbbb'));
insert into voo values (101, bit_to_blob(x'cdcdeee'), char_to_clob('cccccc'));
insert into voo values(67, bit_to_blob(b'0101011'), char_to_clob('dddddd'));

select col1, blob_to_bit(col2), clob_to_char(col3) from voo order by 1;

select var_pop(col1) from voo;
select var_pop(col2) from voo;
select var_pop(blob_to_bit(col2)) from voo;
select var_pop(col3) from voo;
select var_pop(clob_to_char(col3)) from voo;

delete from voo;
drop table voo;
