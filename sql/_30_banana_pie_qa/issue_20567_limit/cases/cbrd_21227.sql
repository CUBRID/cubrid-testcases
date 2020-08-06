--+ holdcas on;

drop table if exists t1 ;
create table t1 ( i int , j varchar(10), k int);
insert into t1 select rownum, substring(class_name,0,10), rownum  from _db_class;
select * from t1 order by 1, 2 limit 0, 3;     
select * from t1 order by 1, 2 limit 0-2, 4;
drop table if exists t1 ; 

--+ holdcas off;

