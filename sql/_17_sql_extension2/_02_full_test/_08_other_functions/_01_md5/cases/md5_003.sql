--pass argument with blob_to_bit() and clob_to_char() function


create table moo(a int, b blob, c clob);

insert into moo values(1, bit_to_blob(X'aaaaaaaaabbbbbbbbccccccccccccccccddddddddd'), char_to_clob('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddd'));

insert into moo values(2, bit_to_blob(B'10101010100000001111111'), char_to_clob('111111111111111777777777777777777ddddddddddddddddd000000000000000000000'));

insert into moo values(3, null, null);

select a, blob_to_bit(b), clob_to_char(c) from moo order by 1;

select a, md5(blob_to_bit(b)), md5(clob_to_char(c)) from moo order by 1;


delete from moo;
drop table moo;
