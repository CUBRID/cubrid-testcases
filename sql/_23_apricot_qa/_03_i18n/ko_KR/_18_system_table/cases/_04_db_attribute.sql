--+ holdcas on;
set names binary;
create table 테이블(칼럼1 char(10)  collate utf8_ko_cs_uca default'기본' , index 색인(칼럼1) );
select * from _db_attribute where attr_name like'칼%';

drop table 테이블;
set names iso88591;
commit;
--+ holdcas off;
