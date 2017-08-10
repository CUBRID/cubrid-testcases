--+ holdcas on;
set names binary;
create table 테이블(칼럼1 int, index 색인(칼럼1) );
select * from _db_class where class_name like'테%';

drop table 테이블;
set names iso88591;
commit;
--+ holdcas off;
