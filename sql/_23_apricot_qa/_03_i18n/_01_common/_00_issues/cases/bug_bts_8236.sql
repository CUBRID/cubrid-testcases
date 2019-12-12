--+ holdcas on;
set names utf8;
create table t(a set string collate utf8_ko_cs_uca);
insert into t values({'가','伽'});
select * from t where a SETEQ {cast('가' as string collate utf8_gen),cast('伽' as string collate utf8_gen)};
drop table t;
set names iso88591;
commit;
--+ holdcas off;

