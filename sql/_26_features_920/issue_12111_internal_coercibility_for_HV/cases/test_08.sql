create table t1(a string collate iso88591_en_ci);
insert into t1 values ('A'), ('a'), ('B'), ('b');
create view v1 as select * from t1 where a>'A';

prepare stmt from 'select /*+ recompile */ * from v1 where a in (?, ?) order by a';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'A', 'B';
deallocate prepare stmt;
drop table t1;
drop view v1;


create table t1(a string collate iso88591_en_ci);
insert into t1 values ('A1'), ('a2'), ('B1'), ('b2');
prepare stmt from 'select /*+ recompile */ repeat(a||?, ?) from t1 order by 1';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'A', 5;
deallocate prepare stmt;
prepare stmt from 'select replace(a, ?, ?) from t1 order by a';
set names iso88591 collate iso88591_en_cs;
execute stmt using 'A', 'X';
deallocate prepare stmt;
drop table t1;


create table t1(a string collate iso88591_en_cs);
insert into t1 values ('A'), ('a'), ('B'), ('b');
prepare stmt from 'select replace(a, ?, ?) from t1 order by a';
set names iso88591 collate iso88591_en_ci;
execute stmt using 'B', 'X';
deallocate prepare stmt;
drop table t1;


create table t1(a string collate utf8_de_exp_ai_ci);
insert into t1 values ('ä'), ('ä');
prepare stmt from 'select replace(a, ?, ?) from t1 order by a';
set names utf8 collate utf8_bin;
execute stmt using 'AE', 'X';
deallocate prepare stmt;
drop table t1;

create table t1(a string collate utf8_de_exp_ai_ci);
insert into t1 values ('AE'), ('AE');
prepare stmt from 'select replace(a, ?, ?) from t1 order by a';
set names utf8 collate utf8_bin;
execute stmt using 'ä', 'X';
execute stmt using 'X', 'ä';
deallocate prepare stmt;
drop table t1;

create table t1(a string collate utf8_de_exp_ai_ci unique);
insert into t1 values ('X'), ('ä');
prepare stmt from 'update t1 set a=? where a=?';
set names utf8 collate utf8_bin;
execute stmt using 'X', 'AE';
deallocate prepare stmt;
drop table t1;


create table t1(a string collate utf8_de_exp_ai_ci unique);
insert into t1 values ('X'), ('ä');
prepare stmt from 'select * from t1 where a<>?';
set names utf8 collate utf8_bin;
execute stmt using _euckr'AE';
deallocate prepare stmt;
drop table t1;


set names iso88591;
