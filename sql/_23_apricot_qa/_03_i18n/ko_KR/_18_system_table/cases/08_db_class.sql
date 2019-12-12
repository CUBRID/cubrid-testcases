--+ holdcas on;
set names binary;
create table 테이블(칼럼1 char(10)  collate utf8_ko_cs_uca default'기본' , index 색인1(칼럼1) where 칼럼1>'기본',칼럼2 varchar(10)  collate utf8_ko_cs_uca default'기본'  ) REUSE_OID;
create index 색인2 on 테이블(lower(칼럼2),칼럼1);
select * from db_class where class_name like'테이%' order by class_name;

drop table 테이블;
set names iso88591;
commit;
--+ holdcas off;
