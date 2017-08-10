--+ holdcas on;
set names utf8;

select coercibility('¥' collate utf8_ja_exp),coercibility('¥' collate utf8_ja_exp_cbm);

drop table if exists t;
create table t(s1 string charset utf8,s2 string collate utf8_tr_cs_uca);
insert into t values('TRY','TRY'),('ş','ş');
select charset(concat(s1,s2 collate utf8_tr_cs)),collation(concat(s1,s2 collate utf8_tr_cs)),coercibility(concat(s1,s2 collate utf8_tr_cs)) from t order by 1;
select charset(concat(s1 collate utf8_tr_cs,s2)),collation(concat(s1 collate utf8_tr_cs,s2)),coercibility(concat(s1 collate utf8_tr_cs,s2)) from t order by 1;
select collation(concat(s1 collate utf8_tr_cs,s2 collate utf8_tr_cs)),coercibility(concat(s1 collate utf8_tr_cs,s2 collate utf8_tr_cs)) from t order by 1;
select collation(('TRY' collate utf8_tr_cs)||(s1 collate utf8_tr_cs)),coercibility(('TRY' collate utf8_tr_cs)||(s1 collate utf8_tr_cs)),coercibility('TRY' collate utf8_tr_cs),coercibility(s1 collate utf8_tr_cs) from t order by 1;
select collation('TRY'||(s1 collate utf8_tr_cs)) from t order by 1; 
drop t;

select collation(chr(97) collate utf8_de_exp_ai_ci),coercibility(chr(97) collate utf8_de_exp_ai_ci);

select collation(lcase('A' collate iso88591_en_ci)),coercibility(lcase('A' collate iso88591_en_ci));
select collation(mid('ABbD' collate utf8_en_ci,2,2));

set names iso88591;
commit;
--+ holdcas off;
