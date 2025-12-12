--+ holdcas on;
set names binary;
create table 테이블(칼럼1 char(10)  collate utf8_ko_cs_uca default'기본' , index 색인1(칼럼1) where 칼럼1>'기본' );
create index 색인2 on 테이블(lower(칼럼1));
select class_of, index_name, is_unique, key_count, key_attrs, is_reverse, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status from _db_index where index_name like'색%' order by index_name;

drop table 테이블;
set names utf8;
commit;
--+ holdcas off;
