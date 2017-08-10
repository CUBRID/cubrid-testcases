-- --no-auto-commit
--delete from x;
--drop x;
autocommit off;
create class x (a clob, b blob, c clob, d blob);
-- create a,c
insert into x(a,c) values (char_to_clob('x'), char_to_clob('y'));
select clob_to_char(a), blob_to_bit(b), clob_to_char(c), blob_to_bit(d) from x;
--select * from x;
-- save top:a,c current null
savepoint s1;
-- create b,d
update x set b = bit_to_blob(x'ee'), d = bit_to_blob(x'aaaa');
select clob_to_char(a), blob_to_bit(b), clob_to_char(c), blob_to_bit(d) from x;
--select * from x;
-- save s1:b1,d1 current null
savepoint s2;
-- create b2,d2
update x set b = bit_to_blob(x'ff'), d = bit_to_blob(x'ffff');
select clob_to_char(a), blob_to_bit(b), clob_to_char(c), blob_to_bit(d) from x;
--select * from x;
-- drop b2,d2 current null
rollback to s2;
select clob_to_char(a), blob_to_bit(b), clob_to_char(c), blob_to_bit(d) from x;
-- keep a,c,b,d
commit;

delete from x;
drop x;
commit;
autocommit on;
