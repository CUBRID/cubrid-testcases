--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

insert into t1 values ('가伽각'), ('가가각');

insert into t2 values ('가伽각'), ('가가각');


select insert (s1,3,1,'x') from t1 order by 1;
select insert (s1,3,1,'x') from t2 order by 1;


select insert (cast (s1 as string collate utf8_gen),3,1,'x') from t1 order by 1;
select insert (cast (s1 as string collate utf8_ko_cs_uca),3,1,'x') from t2 order by 1;


-- late binding
prepare s from 'select insert(? , ?, ?,?)'
execute s using '가伽각가',3,3,'x';
DEALLOCATE PREPARE s;

prepare s from 'select insert(s1 , ?, ?,?) from t1 order by 1'
execute s using 3,1,'x';
DEALLOCATE PREPARE s;

prepare s from 'select insert(s1 , ?, ?,?) from t2 order by 1'
execute s using 3,1,'x';
DEALLOCATE PREPARE s;

prepare s from 'select insert(? , ?, ?,s1) from t1 order by 1'
execute s using '가伽伽가',1,2;
DEALLOCATE PREPARE s;

prepare s from 'select insert(? , ?, ?,s1) from t2 order by 1'
execute s using '가伽伽가',1,2;
DEALLOCATE PREPARE s;

prepare s from 'select insert(s1 + ?, ?, ?,?) from t1 order by 1'
execute s using 'y',3,1,'x';
DEALLOCATE PREPARE s;

prepare s from 'select insert(s1 + ?, ?, ?,?) from t2 order by 1'
execute s using 'y',3,1,'x';
DEALLOCATE PREPARE s;

prepare s from 'select insert( cast (s1 + ? as string collate utf8_ko_cs_uca), ?, ?,?) from t2 order by 1'
execute s using 'y',3,1,'x';
DEALLOCATE PREPARE s;

select insert (t1.s1,3,1,t2.s1) from t1,t2 order by 1;


drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
