--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

insert into t1 values ('가'), ('伽');

insert into t2 values ('가'), ('伽');


select lpad (s1,4,'刻') from t1 order by 1;
select lpad (s1,4,'刻') from t2 order by 1;


select lpad (cast (s1 as string collate utf8_gen),4,'刻') from t1 order by 1;
select lpad (cast (s1 as string collate utf8_ko_cs_uca),4,'刻') from t2 order by 1;


-- late binding
prepare s from 'select lpad(s1 , ?, ?) from t1 order by 1';
execute s using 4,'刻';
DEALLOCATE PREPARE s;

prepare s from 'select lpad(? , ?, s1) from t1 order by 1';
execute s using '刻',4;
DEALLOCATE PREPARE s;

prepare s from 'select lpad(s1 + ?,?,?) from t1 order by 1';
execute s using '각','4','刻';
DEALLOCATE PREPARE s;

prepare s from 'select lpad(s1 + ?,?,?) from t2 order by 1';
execute s using '각',4,'刻';
DEALLOCATE PREPARE s;

prepare s from 'select lpad(cast ((s1 + ?) as string collate utf8_ko_cs_uca),?, ?) from t2 order by 1';
execute s using '각',4,'刻';
DEALLOCATE PREPARE s;

drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
