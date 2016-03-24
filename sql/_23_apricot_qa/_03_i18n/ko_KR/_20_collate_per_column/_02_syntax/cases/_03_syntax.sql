--+ holdcas on;
set names utf8;
create table t1 (s1 string collate 'utf8_zh_cs_uca');
create table t1 (a int collate 'utf8_ko_cs_uca');
create table t1 (s1 string charset 'utf8_ko_KR');
create table t1 (s1 string collate 'utf8_ko_cs_uca');
SHOW full COLUMNS FROM t1;
alter table  t1 CHANGE s1 a INTEGER;
SHOW full COLUMNS FROM t1;
drop t1;
set names iso88591;
commit;
--+ holdcas off;

