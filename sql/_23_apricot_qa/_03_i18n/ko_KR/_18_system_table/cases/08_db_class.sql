--+ holdcas on;
set names binary;
create table 테이블(칼럼1 char(10)  collate utf8_ko_cs_uca default'기본' , index 색인1(칼럼1) where 칼럼1>'기본',칼럼2 varchar(10)  collate utf8_ko_cs_uca default'기본'  ) REUSE_OID;
create index 색인2 on 테이블(lower(칼럼2),칼럼1);
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name like'테이%' order by class_name;

drop table 테이블;
set names utf8;
commit;
--+ holdcas off;
