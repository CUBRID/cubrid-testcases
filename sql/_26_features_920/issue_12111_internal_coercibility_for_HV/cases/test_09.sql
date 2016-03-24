create table t1(a clob);
insert into t1 values (char_to_clob('A')), (char_to_clob('a'));
prepare stmt from 'select clob_to_char(a) from t1 where clob_to_char(a) = cast(? as varchar(10) collate iso88591_en_ci) ';
set names iso88591 collate iso88591_en_ci;
execute stmt using 'a';
deallocate prepare stmt;
drop table t1;


prepare stmt from 'show collation like ''ut'' collate iso88591_en_ci||? ';
set names iso88591 collate iso88591_en_ci;
execute stmt using 'f8%';
deallocate prepare stmt;

set names iso88591;

