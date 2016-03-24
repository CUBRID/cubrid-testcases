set names iso88591;


create table t1(a string collate iso88591_en_ci);
insert into t1 values ('A'), ('a'), (null);
prepare stmt from 'select * from t1 where a in (select ?)';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'A';
deallocate prepare stmt;
drop table t1;

create table t1(a string collate iso88591_en_ci);
insert into t1 values ('A'), ('a'), (null);
prepare stmt from 'select * from t1 where a in (select ? union select ?)';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'A', 'x';
deallocate prepare stmt;
drop table t1;


set names iso88591;


