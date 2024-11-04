create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'), ('aa');

insert into t2 values ('Ab'), ('aa');


select lpad (s1,4,'c') from t1 order by 1;
select lpad (s1,4,'c') from t2 order by 1;


select lpad (cast (s1 as string collate utf8_en_cs),4,'c') from t1 order by 1;
select lpad (cast (s1 as string collate utf8_en_ci),4,'c') from t2 order by 1;


-- late binding
prepare s from 'select lpad(s1 , ?, ?) from t1 order by 1';
execute s using 4,'c';
deallocate prepare s;

prepare s from 'select lpad(? , ?, s1) from t1 order by 1';
execute s using 'c',4;
deallocate prepare s;

prepare s from 'select lpad(s1 + ?,?,?) from t1 order by 1';
execute s using 'A','4','c';
deallocate prepare s;

prepare s from 'select lpad(s1 + ?,?,?) from t2 order by 1';
execute s using 'A',4,'c';
deallocate prepare s;


prepare s from 'select lpad(cast ((s1 + ?) as string collate utf8_en_ci),?, ?) from t2 order by 1';
execute s using 'A',4,'c';
deallocate prepare s;


drop table t1;
drop table t2;
