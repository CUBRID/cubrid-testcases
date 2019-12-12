create class loo (a int, b blob, c clob);
insert into loo values (1, bit_to_blob(0x0001000200030004), char_to_clob('clob'));
insert into loo values (2, bit_to_blob(0x0000), char_to_clob(''));
select a, blob_length(b), clob_length(c) from loo order by a;

delete from loo;
drop table loo;
