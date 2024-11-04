create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Aby'), ('aay');

insert into t2 values ('Aby'), ('aay');


select insert (s1,3,1,'x') from t1 order by 1;
select insert (s1,3,1,'x') from t2 order by 1;


select insert (cast (s1 as string collate utf8_en_cs),3,1,'x') from t1 order by 1;
select insert (cast (s1 as string collate utf8_en_ci),3,1,'x') from t2 order by 1;


-- late binding
prepare s from 'select insert(? , ?, ?,?)';
execute s using 'Abcde',3,3,'x';
deallocate prepare s;

prepare s from 'select insert(s1 , ?, ?,?) from t1 order by 1';
execute s using 3,1,'x';
deallocate prepare s;

prepare s from 'select insert(s1 , ?, ?,?) from t2 order by 1';
execute s using 3,1,'x';
deallocate prepare s;

prepare s from 'select insert(? , ?, ?,s1) from t1 order by 1';
execute s using 'xxxx',1,2;
deallocate prepare s;

prepare s from 'select insert(? , ?, ?,s1) from t2 order by 1';
execute s using 'xxxx',1,2;
deallocate prepare s;

prepare s from 'select insert(s1 + ?, ?, ?,?) from t1 order by 1';
execute s using 'y',3,1,'x';
deallocate prepare s;

prepare s from 'select insert(s1 + ?, ?, ?,?) from t2 order by 1';
execute s using 'y',3,1,'x';
deallocate prepare s;

prepare s from 'select insert( cast (s1 + ? as string collate utf8_en_ci), ?, ?,?) from t2 order by 1';
execute s using 'y',3,1,'x';
deallocate prepare s;

select insert (t1.s1,3,1,t2.s1) from t1,t2 order by 1;


drop table t1;
drop table t2;
