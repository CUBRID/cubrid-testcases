--+ holdcas on;
set names utf8;

drop table if exists t;
create table t(s1 char(10) charset utf8);
insert into t values('¥'),('￥'),('8'),('9');
select max(s1 collate utf8_ja_exp),if (((min(s1 collate utf8_ja_exp_cbm)='￥')||(min(s1 collate utf8_ja_exp_cbm)='¥'))<>0,'ok','nok') as m from t;  
drop t;

create table t(s1 char(5) charset utf8,s2 string collate utf8_tr_cs_uca);
insert into t values('TRY','TRY'),('ş','ş');
select concat(s1,s2 collate utf8_tr_cs) from t order by 1;
select concat(s1 collate utf8_tr_cs,s2) from t order by 1;
select concat(s1 collate utf8_tr_cs,s2 collate utf8_tr_cs) from t order by 1;
select concat(s1,s2 collate utf8_tr_cs_uca) from t order by 1;
select ('TRY' collate utf8_tr_cs)||(s1 collate utf8_tr_cs) from t order by 1;
select 'TRY'||(s1 collate utf8_tr_cs) from t order by 1; 
drop t;

select t1.s collate utf8_de_exp_ai_ci from (select chr(97) as s union select chr(65) as s union select chr(100) as s) t1 order by 1 desc;
select * from (select chr(97) collate utf8_de_exp_ai_ci union select chr(65) collate utf8_de_exp_ai_ci union select chr(100) collate utf8_de_exp_ai_ci) t1 order by 1;

select field('a' collate utf8_en_ci,'A' collate utf8_en_ci,'a' collate utf8_en_ci);
select field('a' collate utf8_en_ci,'A','a');
create table t(s1 string charset utf8,s2 string charset utf8,s3 string charset utf8);
insert into t values('a','A','a');
select field(s1 collate utf8_en_ci,s2 collate utf8_en_ci,s3 collate utf8_en_ci) from t;
drop t;

select lcase('A' collate iso88591_en_ci);
select lcase('A' collate utf8_en_ci);
select left('AaaD' collate utf8_en_ci,2);
select mid('ABbD' collate utf8_en_ci,2,2);

create table t(s string charset utf8);
insert into t values('AaaD');
select left(s collate utf8_en_ci,2) from t;
drop t;

set names iso88591;
commit;
--+ holdcas off;
