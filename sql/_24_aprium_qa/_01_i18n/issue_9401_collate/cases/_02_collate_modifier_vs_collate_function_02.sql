--+ holdcas on;
set names utf8;

drop table if exists t;
create table t(i int,s1 string, s2 string collate utf8_tr_cs);
insert into t values(1,'TRY','TRY'),(2,'ş','ş'),(3,'İ','İ'),(4,'ı','ı'),(5,'i','i'),(6,'I','I');
select collation(distinct s2 collate utf8_tr_cs_uca),charset(distinct s1 collate utf8_tr_cs_uca) from t order by 1;
drop t;

set names iso88591 collate iso88591_en_ci;
select collation (distinct * collate iso88591_en_cs) from (select 'A' union select 'a' union select 'D' union select '0') t1 order by 1 desc;
set names iso88591 collate iso88591_bin;
select charset(t1.s collate utf8_km_exp) from (select '។ល។' as s union select 'អែ' union select  'ឰ') t1 order by 1 desc;

set names iso88591;
select charset('a'),collation('a');
select charset(_utf8'a'),collation(_utf8'a');
select coercibility('a');

set names utf8;
select charset('a'),collation('a');
select charset(_iso88591'a'),collation(_iso88591'a');
select coercibility('a');

set names iso88591;
commit;
--+ holdcas off;
