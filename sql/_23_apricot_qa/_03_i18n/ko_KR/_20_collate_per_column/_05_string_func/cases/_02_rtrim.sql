--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

insert into t1 values ('가伽각'), ('가가각');

insert into t2 values ('가伽각'), ('가가각');


select rtrim (s1,'각') from t1 order by 1;
select rtrim (s1,'각') from t2 order by 1;


select rtrim (cast (s1 as string collate utf8_gen),'각') from t1 order by 1;
select rtrim (cast (s1 as string collate utf8_ko_cs_uca),'각') from t2 order by 1;


-- late binding
prepare s from 'select rtrim(s1 ,?) from t1 order by 1';
execute s using '각';
DEALLOCATE PREPARE s;

prepare s from 'select rtrim(s1 + ?,?) from t1 order by 1';
execute s using '가','각';
DEALLOCATE PREPARE s;

prepare s from 'select rtrim(s1 + ?,?) from t2 order by 1';
execute s using '가','각';
DEALLOCATE PREPARE s;

prepare s from 'select rtrim(cast ((s1 + ?) as string collate utf8_ko_cs_uca),?) from t2 order by 1';
execute s using '가','각';
DEALLOCATE PREPARE s;

drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
