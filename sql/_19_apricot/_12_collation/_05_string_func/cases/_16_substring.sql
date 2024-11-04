create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Abcd'), ('aaxx');

insert into t2 values ('Abcd'), ('aaxx');


select substring (s1,1,2) from t1 order by 1;
select substring (s1,1,2) from t2 order by 1;


select substring (cast (s1 as string collate utf8_en_cs),1,2) from t1 order by 1;
select substring (cast (s1 as string collate utf8_en_ci),1,2) from t2 order by 1;


-- late binding
prepare s from 'select substring(? , 1, ?)';
execute s using 'Abcde',2;
deallocate prepare s;

prepare s from 'select substring(s1 , ?, ?) from t1 order by 1';
execute s using 1,2;
deallocate prepare s;

prepare s from 'select substring(s1 + ?,?,?) from t1 order by 1';
execute s using 'A',1, '2';
deallocate prepare s;

prepare s from 'select substring(s1 + ?,?,?) from t2 order by 1';
execute s using 'A',1,2;
deallocate prepare s;


prepare s from 'select substring(cast ((s1 + ?) as string collate utf8_en_ci),?,?) from t2 order by 1';
execute s using 'A',1, 2;
deallocate prepare s;


drop table t1;
drop table t2;
