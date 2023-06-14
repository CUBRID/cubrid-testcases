set system parameters 'deduplicate_key_level=0';

--+ holdcas on;
set names binary;
create table 테이블(칼럼1 char(10)  collate utf8_ko_cs_uca default'기본' , index 색인1(칼럼1) where 칼럼1>'기본' );
create index 색인2 on 테이블(lower(칼럼1));
select * from _db_index where index_name like'색%' order by index_name;

drop table 테이블;
set names iso88591;
commit;
--+ holdcas off;

set system parameters 'deduplicate_key_level=32';
