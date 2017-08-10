--+ holdcas on;
--delete from x;
--drop x;

-- several blob/clob columns  at a class
create class x (a clob, b blob, c clob, d blob);
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));
insert into x(a,b,c,d) values (char_to_clob('x'), bit_to_blob(x'aa00'), char_to_clob('y'), bit_to_blob(x'ff11bb'));

-- 20
insert into x select * from x;
-- 40
insert into x select * from x;
-- 80
insert into x select * from x;
-- 160
insert into x select * from x; 

select count(*) from x;

update x set a = char_to_clob('x2'), b = bit_to_blob(x'bb00');
select clob_to_char(a), blob_to_bit(b) from x where rownum = 1;

delete from x;

drop x;
commit;
--+ holdcas off;
