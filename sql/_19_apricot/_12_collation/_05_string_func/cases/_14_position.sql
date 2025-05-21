create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'), ('aa');

insert into t2 values ('Ab'), ('aa');


-- position doesn't take into account collation for searching
select position (s1 in 'xAbcAa') from t1 order by 1;
select position (s1 in 'xAbcAa') from t2 order by 1;


select position (cast (s1 as string collate utf8_en_cs) in 'xAbcAa') from t1 order by 1;
select position (cast (s1 as string collate utf8_en_ci) in 'xAbcAa') from t2 order by 1;


-- late binding
prepare s from 'select position(s1 in ?) from t1 order by 1';
execute s using 'xAbcAa';
deallocate prepare s;

prepare s from 'select position(s1 in ?) from t2 order by 1';
execute s using 'xAbcAa';
deallocate prepare s;


select position(t1.s1 in t2.s1) from t1,t2 order by 1;

select position(t1.s1 in cast (t2.s1 as string collate utf8_en_ci)) from t1,t2 order by 1;


drop table t1;
drop table t2;
