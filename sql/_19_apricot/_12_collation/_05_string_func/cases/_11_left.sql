create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Abcd'), ('aaxx');

insert into t2 values ('Abcd'), ('aaxx');


select left (s1,2) from t1 order by 1;
select left (s1,2) from t2 order by 1;


select left (cast (s1 as string collate utf8_en_cs),2) from t1 order by 1;
select left (cast (s1 as string collate utf8_en_ci),2) from t2 order by 1;


-- late binding
prepare s from 'select left(? , ?)';
execute s using 'Abcde',2;
deallocate prepare s;

prepare s from 'select left(s1 , ?) from t1 order by 1';
execute s using 2;
deallocate prepare s;

prepare s from 'select left(s1 + ?,?) from t1 order by 1';
execute s using 'A','2';
deallocate prepare s;

prepare s from 'select left(s1 + ?,?) from t2 order by 1';
execute s using 'A',2;
deallocate prepare s;


prepare s from 'select left(cast ((s1 + ?) as string collate utf8_en_ci),?) from t2 order by 1';
execute s using 'A',2;
deallocate prepare s;


drop table t1;
drop table t2;
