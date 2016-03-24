-- set names is a client setting, requires the entire SQL file to be execute in a single process
--+ holdcas on;
set names iso88591;
create table t1 as select 'iso_bin';

set names utf8;
create table t2 as select 'utf8_bin';

set names iso88591 collate iso88591_en_ci;
create table t3 as select 'iso_en_ci';

set names utf8 collate utf8_en_ci;
create table t4 as select 'utf8_en_ci';

show full columns in t1;
show full columns in t2;

show full columns in t3;
show full columns in t4;

drop table t1;
drop table t2;
drop table t3;
drop table t4;


-- invalid charset, collation
set names iso9;

set names iso9 collate iso88591_en_ci;

set names iso88591 collate iso88591_en_cp;

--restore default names : this assumes CUBRID_LANG=en_US (ISO-8859-1 charset)
set names iso88591; 

commit;
--+ holdcas off;