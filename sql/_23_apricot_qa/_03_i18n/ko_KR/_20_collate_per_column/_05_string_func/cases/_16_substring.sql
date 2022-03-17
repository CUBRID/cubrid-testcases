--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

insert into t1 values ('Abcd'), ('aaxx');

insert into t2 values ('Abcd'), ('aaxx');


select substring (s1,1,2) from t1 order by 1;
select substring (s1,1,2) from t2 order by 1;


select substring (cast (s1 as string collate utf8_gen),1,2) from t1 order by 1;
select substring (cast (s1 as string collate utf8_ko_cs_uca),1,2) from t2 order by 1;


-- late binding
prepare s from 'select substring(? , 1, ?)';
execute s using 'Abcde',2;
DEALLOCATE PREPARE s;

prepare s from 'select substring(s1 , ?, ?) from t1 order by 1';
execute s using 1,2;
DEALLOCATE PREPARE s;

prepare s from 'select substring(s1 + ?,?,?) from t1 order by 1';
execute s using '٤',1, '2';
DEALLOCATE PREPARE s;

prepare s from 'select substring(s1 + ?,?,?) from t2 order by 1';
execute s using '٤',1,2;
DEALLOCATE PREPARE s;

prepare s from 'select substring(cast ((s1 + ?) as string collate utf8_ko_cs_uca),?,?) from t2 order by 1';
execute s using '٤',1, 2;
DEALLOCATE PREPARE s;

drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
