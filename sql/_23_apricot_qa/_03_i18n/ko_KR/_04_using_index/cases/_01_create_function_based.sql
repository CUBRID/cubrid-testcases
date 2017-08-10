--+ holdcas on;
set names utf8;
Create table 테이블 (칼럼 char(10) collate utf8_ko_cs_uca);
create index idx on 테이블(lower(칼럼));
show index in 테이블;
drop table 테이블;
set names iso88591;
commit;
--+ holdcas off;