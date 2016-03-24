create table t1(a string collate iso88591_en_ci);
insert into t1 values ('A'), ('a'), (null);
prepare stmt from 'select * from t1 where a = any{?, ?}';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'A', null;
deallocate prepare stmt;
drop table t1;

prepare stmt from 'select 1 from db_root where ''a'' collate iso88591_en_ci  = some{?, ?, ?}';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'A', 'B', 'C';
deallocate prepare stmt;

prepare stmt from 'select 1 from db_root where ? is null';
set names iso88591 collate iso88591_en_cs;
execute stmt using null;
execute stmt using 'm';
deallocate prepare stmt;


prepare stmt from 'select 1 from db_root where ? REGEXP ? ';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'Aabc', 'aAbc';
deallocate prepare stmt;


prepare stmt from 'select ? REGEXP ? ';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'abc', 'ABC';
set names utf8 collate utf8_en_cs;
execute stmt using 'abc', 'ABC';
deallocate prepare stmt;

prepare stmt from 'select 1 from db_root where ? between ? and ?';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'B', 'a', 'c';
set names iso88591 collate iso88591_en_ci;
execute stmt using 'B', 'a', 'c';
deallocate prepare stmt;

create table t1(a set(varchar(20) collate utf8_en_cs) );
insert into t1 values ({'A'}), ({'B'}), ({'C'});
prepare stmt from 'select * from t1 where a subset {?, ?, ?, ?}';
set names utf8 collate utf8_en_ci;
execute stmt using 'a', 'b', 'x', 'd';
deallocate prepare stmt;
drop table t1;

set names iso88591;
