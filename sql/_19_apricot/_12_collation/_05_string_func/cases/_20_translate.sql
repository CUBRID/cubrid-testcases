create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'), ('aa');

insert into t2 values ('Ab'), ('aa');


-- doesn't take into account collation for searching
select translate (s1,'a','aA') from t1 order by 1;
select translate (s1,'a','aA') from t2 order by 1;


-- late binding
prepare s from 'select translate(s1 ,?,?) from t1 order by 1';
execute s using 'a','aA';

prepare s from 'select translate(?, s1 , ?) from t1 order by 1';
execute s using 'aabbaabb','XX';

prepare s from 'select translate(?, s1 , ?) from t2 order by 1';
execute s using 'aabbaabb','XX';

select translate(t1.s1, t2.s1, 'x') from t1,t2 order by 1;

select translate(t1.s1, cast (t2.s1 as string collate utf8_en_ci),'X') from t1,t2 order by 1;

drop table t1;
drop table t2;
