--+ holdcas on;
set names utf8;

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

drop table if exists t;
create table t(i int,s1 string, s2 string collate utf8_tr_cs);
insert into t values(1,'TRY','TRY'),(2,'ş','ş'),(3,'İ','İ'),(4,'ı','ı'),(5,'i','i'),(6,'I','I'); 
select distinct s1 collate utf8_tr_cs_uca from t order by 1;
select distinct s2 collate utf8_tr_cs_uca from t order by 1;
drop t;

set names iso88591 collate iso88591_en_ci;
select distinct t1.s collate iso88591_en_cs from (select 'A' as s union select 'a' as s union select 'D' as s union select '0' as s) t1 order by 1 desc;

set names utf8 collate utf8_en_cs;
select distinct t1.s collate utf8_en_ci from (select 'A' as s union select 'a' as s union select 'D' as s union select '0' as s) t1 order by 1 desc;

select distinct * from (select 'P' collate utf8_ja_exp_cbm union select 'てﾃ' collate utf8_ja_exp_cbm union select 'ソ' collate utf8_ja_exp_cbm union select 'ァ' collate utf8_ja_exp_cbm) t1 order by 1 desc;

set names iso88591 collate iso88591_bin;
select distinct t1.s collate utf8_km_exp from (select '។ល។' as s union select 'អែ' union select  'ឰ') t1 order by 1 desc;

set names utf8;
select distinct t1.s collate utf8_km_exp from (select '។ល។' as s union select 'អែ' union select  'ឰ') t1 order by 1 desc;

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

set names iso88591;
commit;
--+ holdcas off;
