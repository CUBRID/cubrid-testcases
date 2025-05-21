--+ holdcas on;
set names utf8;

select 1 from db_class where '8' > '¥' collate utf8_ja_exp limit 1;
select 1 from db_class where '8' collate utf8_ja_exp > '¥' limit 1;
select 1 from db_class where ('8' > '¥') collate utf8_ja_exp limit 1;

drop table if exists t;
create table t(s string charset iso88591);
insert into t values('D'),('d'),('a');
select * from t where s>'a' collate iso88591_en_ci order by 1 desc;
select * from t where s collate iso88591_en_ci > 'a' order by 1;
select * from t where (s>'a') collate iso88591_en_ci order by s collate iso88591_bin;
drop t;

create table t(s1 string collate utf8_bin,s2 string collate utf8_ko_cs_uca);
insert into t values('金','金'),('끽','金'),('납','金'),('年','金');
select * from t where s1>s2 collate utf8_bin order by s1 desc,s2 collate utf8_bin;
select * from t where s1 collate utf8_ko_cs_uca > s2 order by s1 collate utf8_ko_cs_uca;
select * from t where (s1>s2) collate utf8_ko_cs_uca order by 1;

prepare st from 'select * from t where s1>s2 collate ?';
deallocate prepare st;
prepare st from 'select * from t where (s>?) collate iso88591_en_ci order by 1 collate iso88591_bin';
deallocate prepare st;

drop t;
set names iso88591;
commit;
--+ holdcas off;
