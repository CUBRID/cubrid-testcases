--+ holdcas on;
set names utf8;
create table t1;

alter table t1 add column i_€ int;


alter table t1 add column i_Ÿ int;
alter table t1 add column i_¥ int;
alter table t1 add column i_￥ int;
drop table t1;
set names iso88591;
commit;
--+ holdcas off;