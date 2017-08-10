--+ holdcas on;
set names utf8 collate utf8_de_exp;
select t1.s from (select 'ß' as s union select 'SS' union select 'ss' union select 'ü' union select 'Ü') t1 group by t1.s collate utf8_gen_ai_ci order by 1;
select t1.s from (select 'ß' as s union select 'SS' union select 'ss' union select 'ü' union select 'Ü') t1 group by t1.s collate utf8_gen_ai_ci;

set system parameters 'unicode_input_normalization=yes';
set system parameters 'unicode_output_normalization=yes';

set names iso88591;
select t1.s from (select _utf8'ğ' as s union select _utf8'ş' union select _utf8'Ş' union select _utf8'S') t1 group by t1.s collate utf8_tr_cs_uca;

set names utf8;
drop table if exists t;
create table t(i int,s1 varchar(10),s2 varchar(10) collate utf8_en_cs);
insert into t values(1,'Ab','Ab'),(2,'aa','aa'),(3,'bA','bA'),(4,'bb','bb'),(5,'0','0'),(6,'ß','ß'),(7,'SS','SS'),(8,' ',' ');

select s1 from t group by s1 having s1>'aa' collate utf8_en_ci;
select s2 from t group by s2 having s2>'aa' collate utf8_en_ci; 

select s1 from t group by s1 having cast(s1 as string collate iso88591_en_cs) collate iso88591_en_ci=cast(s1 as string collate iso88591_en_ci) collate iso88591_en_cs;
select s2 from t group by s2 having cast(s2 as string collate iso88591_en_cs) collate iso88591_en_ci=cast(s2 as string collate iso88591_en_ci);
drop t;

set system parameters 'unicode_input_normalization=no';
set system parameters 'unicode_output_normalization=no';

set names iso88591;
commit;
--+ holdcas off;
