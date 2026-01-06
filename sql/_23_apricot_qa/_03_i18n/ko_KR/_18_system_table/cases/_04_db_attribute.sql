--+ holdcas on;
set names binary;
create table 테이블(칼럼1 char(10)  collate utf8_ko_cs_uca default'기본' , index 색인(칼럼1) );
select class_of, attr_name, attr_type, from_class_of, from_attr_name, def_order, data_type, default_value, domains, is_nullable, comment from _db_attribute where attr_name like'칼%';

drop table 테이블;
set names utf8;
commit;
--+ holdcas off;
