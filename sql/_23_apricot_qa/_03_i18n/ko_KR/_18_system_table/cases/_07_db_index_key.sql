--+ holdcas on;
set names binary;
create table 테이블(칼럼1 char(10)  collate utf8_ko_cs_uca default'기본' , index 색인1(칼럼1) where 칼럼1>'기본',칼럼2 varchar(10)  collate utf8_ko_cs_uca default'기본'  );
create index 색인2 on 테이블(lower(칼럼2),칼럼1);
select * from _db_index_key where key_attr_name like'칼%' order by key_attr_name, key_order;

drop table 테이블;
set names iso88591;
commit;
--+ holdcas off;
