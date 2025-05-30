--+ holdcas on;
set names utf8;

select 1,collation('8'),coercibility('8'),collation('¥' collate utf8_ja_exp),coercibility('¥' collate utf8_ja_exp) from db_class where '8' > '¥' collate utf8_ja_exp limit 1;
select 1,collation('8' collate utf8_ja_exp),coercibility('8' collate utf8_ja_exp),collation('¥'),coercibility('¥') from db_class where '8' collate utf8_ja_exp > '¥' limit 1;
select 1,collation(('8' > '¥') collate utf8_ja_exp),coercibility(('8' > '¥') collate utf8_ja_exp) from db_class where ('8' > '¥') collate utf8_ja_exp limit 1;

drop table if exits t;
create table t(s string charset iso88591);
insert into t values('D'),('d'),('a');
select case when s>'¥' collate iso88591_en_ci then 'big' when s<'¥' then 'small' end from t;
prepare st from 'select case when s>? collate iso88591_en_ci then 1 when s<? then 2 end from t;';
deallocate prepare st;
drop t;

set names iso88591;
commit;
--+ holdcas off;
