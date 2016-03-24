--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

create table t3 (s1 string collate iso88591_en_cs);

insert into t1 values ('가伽伽가'), ('가伽각가');

insert into t2 values ('가伽伽가'), ('가伽각가');

insert into t3 values ('가伽伽가'), ('가伽각가');


select s1,find_in_set (s1,'가伽각가,가伽각가') from t1 order by 1;
select s1,find_in_set (s1,'가伽각가,가伽각가') from t2 order by 1;


-- late binding
prepare s from 'select find_in_set(? , ?)'
execute s using '伽','伽,가';
DEALLOCATE PREPARE s;

prepare s from 'select s1, find_in_set(s1 , ?) from t1 order by 1'
execute s using '가伽각가,가伽각가';
DEALLOCATE PREPARE s;

prepare s from 'select s1, find_in_set(s1 , ?) from t2 order by 1'
execute s using '가伽각가,가伽각가';
DEALLOCATE PREPARE s;

select t1.s1,t2.s1,find_in_set (t1.s1,t2.s1) from t1,t2 order by 1;

select t1.s1,t3.s1,find_in_set (t1.s1,t3.s1) from t1,t3 order by 1;

drop table t1;
drop table t2;
drop table t3;
set names iso88591;
commit;
--+ holdcas off;
