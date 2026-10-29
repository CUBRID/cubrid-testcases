--+ holdcas on;
set names utf8;
create table t(i int,s string collate utf8_ko_cs);
insert into t values(1,'年'),(2,'끽');
set names utf8 collate utf8_ko_cs_uca;
prepare st from 'select * from t where s collate utf8_ko_cs_uca > ?';
execute st using '年';
deallocate prepare st;
drop t;

set names utf8 collate utf8_ko_cs_uca;
create table t(i int,s string collate utf8_ko_cs);
insert into t values(1,'年'),(2,'끽');
prepare st from 'select * from t where s > ?';
execute st using '年';
deallocate prepare st;
drop t;

set names iso88591;
create table t(i int,s string) collate iso88591_bin;
insert into t values(1,'A'),(2,'a');
set names iso88591 collate iso88591_en_ci;
prepare st from 'select * from t where s = ? order by 1';
execute st using 'a';
deallocate prepare st;
drop t;

set names utf8;
create table t(i int,s string charset utf8);
insert into t values(1,'A'),(2,'a');
set names utf8 collate utf8_de_exp_ai_ci;
prepare st from 'select * from t where s = ? order by 1';
execute st using 'a';
deallocate prepare st;
drop t;

set names utf8;
create table t(i int,s string collate utf8_ko_cs);
insert into t values(1,'a'),(2,'끽');
set names utf8 collate utf8_ko_cs_uca;
prepare st from 'select * from t where s||s like ? and s||s > ?';
execute st using '_끽','年';
deallocate prepare st;
drop t;

set names iso88591;
create table t(i int,s string) collate iso88591_bin;
insert into t values(1,'A'),(2,'a');
set names iso88591 collate iso88591_en_ci;
prepare st from 'select * from t where s||s = ? order by 1';
execute st using 'aa';
deallocate prepare st;
drop t;

set names utf8;
create table t(i int,s string charset utf8);
insert into t values(1,'A'),(2,'a');
set names utf8 collate utf8_de_exp_ai_ci;
prepare st from 'select * from t where s||s = ? order by 1';
execute st using 'aa';
deallocate prepare st;
drop t;

set names utf8;
create table t(i int,s string collate utf8_en_ci);
insert into t values(1,'A'),(2,'a');
set names utf8 collate utf8_de_exp_ai_ci;
prepare st from 'select * from t where s||s = ? order by 1';
execute st using 'aa';
deallocate prepare st;
drop t;

set names utf8 collate utf8_en_ci;
prepare st from 'select 1 from db_class where USER=? limit 1';
execute st using 'dba';
deallocate prepare st;

-- CBRD-27583: the statements below, which run SET NAMES between PREPARE and EXECUTE, were written to check that
-- a literal of the statement keeps the collation of the session at PREPARE time. Since CBRD-27583 a PREPARE whose
-- statement has a position typed by its value makes no plan, and the first EXECUTE compiles it, so the literal
-- takes the collation of the session at EXECUTE time and these statements no longer check that.
set names utf8 collate utf8_de_exp_ai_ci;
prepare st from 'select 1 from db_class where ''a''=? limit 1';
set names utf8;
execute st using 'A';
deallocate prepare st;

set names iso88591;
prepare st from 'select 1 from db_class where ''a''=? limit 1';
set names iso88591 collate iso88591_en_ci;
execute st using 'A';
deallocate prepare st;

set names utf8;
prepare st from 'select 1 from db_class where ''a''=? limit 1';
set names iso88591 collate iso88591_en_ci;
execute st using 'A';
deallocate prepare st;

set names utf8;
prepare st from 'select 1 from db_class where ''a''=? limit 1';
set names iso88591;
execute st using 'A';
deallocate prepare st;

set names iso88591;
set @a='a';
prepare st from 'select 1 from db_class where @a=? limit 1';
set names iso88591 collate iso88591_en_ci;
execute st using 'A';
set names iso88591 collate iso88591_bin;
deallocate prepare st;

drop variable @a;
set names utf8;

--+ holdcas off;
