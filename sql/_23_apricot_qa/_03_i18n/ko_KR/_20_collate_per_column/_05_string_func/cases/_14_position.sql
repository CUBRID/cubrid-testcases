--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

insert into t1 values ('가'), ('伽');

insert into t2 values ('가'), ('伽');


-- position doesn't take into account collation for searching
select position (s1 in '가伽伽가') from t1 order by 1;
select position (s1 in '가伽伽가') from t2 order by 1;


select position (cast (s1 as string collate utf8_gen) in '가伽伽가') from t1 order by 1;
select position (cast (s1 as string collate utf8_ko_cs_uca) in '가伽伽가') from t2 order by 1;


-- late binding
prepare s from 'select position(s1 in ?) from t1 order by 1';
execute s using '가伽伽가';
DEALLOCATE PREPARE s;

prepare s from 'select position(s1 in ?) from t2 order by 1';
execute s using '가伽伽가';
DEALLOCATE PREPARE s;

select position(t1.s1 in t2.s1) from t1,t2 order by 1;

select position(t1.s1 in cast (t2.s1 as string collate utf8_ko_cs_uca)) from t1,t2 order by 1;


drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
