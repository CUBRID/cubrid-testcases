--+ holdcas on;
set names utf8;

drop table if exists t;
create table t(s1 string, s2 string collate utf8_gen);
insert into t values('A','AE'),('a','a'),('Ä','Ä'),('AE','AE');
select * from t order by s1 collate utf8_gen_ai_ci desc,s2 collate utf8_gen_ai_ci;
drop t;

set names utf8 collate utf8_ko_cs;
select t1.s from (select '金' as s union select '끽' union select '납' union select '年') t1 order by t1.s collate utf8_ko_cs_uca desc;

set names utf8;
select t2.s from (select t1.s from (select 'D' as s union select 'ă' union select 'a' union select 'A') t1 order by t1.s collate utf8_en_cs) t2 order by t2.s collate utf8_gen_ai_ci;

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

select t1.s from (select _utf8'Ñ' as s union select _utf8'N' union select _utf8'Ñ') t1 order by t1.s collate utf8_es_cs;

select t1.s from (select '¥' as s union select version()) t1 order by t1.s collate utf8_ja_exp_cbm;

set names iso88591;
commit;
--+ holdcas off;
