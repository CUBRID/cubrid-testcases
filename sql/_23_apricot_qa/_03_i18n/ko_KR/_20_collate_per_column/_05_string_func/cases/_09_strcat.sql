--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

insert into t1 values ('가'), ('伽');

insert into t2 values ('가'), ('伽');


select s1 || '가' from t1 order by 1;
select s1 || '가' from t2 order by 1;


select cast (s1 as string collate utf8_gen) || '가' from t1 order by 1;
select cast (s1 as string collate utf8_ko_cs_uca) || '가' from t2 order by 1;


-- late binding
prepare s from 'select s1 || ?  from t1 order by 1';
execute s using '가';
DEALLOCATE PREPARE s;

select t1.s1 || t2.s1 from t1,t2 order by 1;

select t1.s1 || cast (t2.s1 as string collate utf8_ko_cs_uca) from t1,t2 order by 1;


drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
