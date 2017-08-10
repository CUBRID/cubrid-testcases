--+ holdcas on;
set names utf8;
Create table t (칼럼 varchar(10) collate utf8_ko_cs_uca);
create index idx  on t(칼럼) where 칼럼>='칼럼';
show index in t;
drop table t;
set names iso88591;
commit;
--+ holdcas off;