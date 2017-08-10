-- --no-auto-commit
--delete from x;
--drop x;
autocommit off;
create class x (a clob, b blob, c clob, d blob);
-- create a,c
insert into x(a,c) values (char_to_clob('x'), char_to_clob('y'));
-- save a,c current null
savepoint s1;
-- create b,d
update x set b = bit_to_blob(x'aa'), d = bit_to_blob(x'aaaa');
select clob_to_char(a), blob_to_bit(b), clob_to_char(c), blob_to_bit(d) from x;
-- drop b,d current a,c
rollback to s1;
update x set b = bit_to_blob(x'bb'), d = bit_to_blob(x'bbbb');
select clob_to_char(a), blob_to_bit(b), clob_to_char(c), blob_to_bit(d) from x;
-- keep a,c
commit;

delete from x;
drop x;
commit;
autocommit on;
