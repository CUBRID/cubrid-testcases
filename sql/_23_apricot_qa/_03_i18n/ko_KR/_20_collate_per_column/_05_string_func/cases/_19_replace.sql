--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

insert into t1 values ('가'), ('伽');

insert into t2 values ('가'), ('伽');


-- doesn't take into account collation for searching
select replace (s1,'伽','가') from t1 order by 1;
select replace (s1,'가','伽') from t2 order by 1;


-- late binding
prepare s from 'select replace(s1 ,?,?) from t1 order by 1';
execute s using '가','伽';
DEALLOCATE PREPARE s;

prepare s from 'select replace(?, s1 , ?) from t1 order by 1';
execute s using 'aab伽a가bb','XX';
DEALLOCATE PREPARE s;

prepare s from 'select replace(?, s1 , ?) from t2 order by 1';
execute s using 'aab가a伽bb','XX';
DEALLOCATE PREPARE s;

select replace(t1.s1, t2.s1, 'x') from t1,t2 order by 1;

select replace(t1.s1, cast (t2.s1 as string collate utf8_ko_cs_uca),'X') from t1,t2 order by 1;


drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
