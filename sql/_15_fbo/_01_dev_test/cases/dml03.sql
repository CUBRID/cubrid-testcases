set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
--delete from x;
--drop x;

-- several blob/clob columns  at a class
create class x (a clob, b blob, c clob, d blob);
insert into x(a,c) values (char_to_clob('x'), char_to_clob('y'));

update x set b = bit_to_blob(x'ee'), d = bit_to_blob(x'afafa');
select clob_to_char(a), blob_to_bit(b), clob_to_char(c), blob_to_bit(d) from x;

select x into :x from x where rownum = 1;
update object :x set a = char_to_clob('x2');
select clob_to_char(a) from x where rownum = 1;

delete from x;
drop x;
commit;
--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
