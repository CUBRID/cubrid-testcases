--+ holdcas on;
set names utf8;
create table t1 (s1 string charset utf8 collate 'utf8_ko_cs_uca');
insert into t1 values ('倨去居巨拒据據擧渠炬祛距踞遽鉅鋸呿昛秬筥籧胠腒苣莒蕖蘧袪裾駏');
select * from t1;
SHOW full COLUMNS FROM t1;
create table t2 like t1;
select * from t2;
SHOW full COLUMNS FROM t2;
drop t1,t2;
set names iso88591;
commit;
--+ holdcas off;

