create table r30_fun_t1 (nr int primary key not null auto_increment, b blob, c clob, str varchar(10) );
insert into r30_fun_t1 values (null, bit_to_blob(X'10011'),char_to_clob('abc''def''ghi'),'ABC');
insert into r30_fun_t1 values (null, bit_to_blob(X'10111'),char_to_clob('bcd''efg''hij'),'BCD');
insert into r30_fun_t1 values (null, bit_to_blob(X'11011'),char_to_clob('cde''fgh''ijk'),'CDE');

-- 1  REVERSE() blob/clob column.
select str,reverse(str) from r30_fun_t1 order by nr;
select nr ,reverse(c) from r30_fun_t1 order by nr;
select nr ,reverse(b) from r30_fun_t1 order by nr;
select nr ,reverse(clob_to_char(c)) from r30_fun_t1 order by nr;
select nr ,reverse(blob_to_bit(b)) from r30_fun_t1 order by nr;

delete from r30_fun_t1
drop r30_fun_t1;