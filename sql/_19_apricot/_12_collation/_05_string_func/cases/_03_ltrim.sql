create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('cAbc'), ('caac');

insert into t2 values ('cAb'), ('caac');


select ltrim (s1,'c') from t1 order by 1;
select ltrim (s1,'c') from t2 order by 1;


select ltrim (cast (s1 as string collate utf8_en_cs),'c') from t1 order by 1;
select ltrim (cast (s1 as string collate utf8_en_ci),'c') from t2 order by 1;


-- late binding
prepare s from 'select ltrim(s1 ,?) from t1 order by 1';
execute s using 'c';
deallocate prepare s;

prepare s from 'select ltrim(s1 + ?,?) from t1 order by 1';
execute s using 'A','c';
deallocate prepare s;

prepare s from 'select ltrim(s1 + ?,?) from t2 order by 1';
execute s using 'A','c';
deallocate prepare s;


prepare s from 'select ltrim(cast ((s1 + ?) as string collate utf8_en_ci),?) from t2 order by 1';
execute s using 'A','c';
deallocate prepare s;


drop table t1;
drop table t2;
