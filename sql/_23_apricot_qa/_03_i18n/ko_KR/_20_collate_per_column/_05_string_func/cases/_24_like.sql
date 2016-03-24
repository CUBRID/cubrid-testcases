--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca, i integer);
create table t2 (s1 string collate utf8_gen, i integer);

insert into t1 values ('가가각', 1), ('가伽각',10);
insert into t1 values ('가가각', 2), ('가伽각',20);

insert into t2 values ('가가각', 1), ('가伽각',10);
insert into t2 values ('가가각', 2), ('가伽각',20);

select s1,i from t1 where s1 like '가%' order by 1;


select s1,i from t2 where s1 like '가%' order by 1;


prepare s from 'select s1,i from t1 where s1 like ? order by 1'
execute s using '가%';
DEALLOCATE PREPARE s;

prepare s from 'select s1,i from t2 where s1 like ? order by 1'
execute s using '가%';
DEALLOCATE PREPARE s;

select 1 from db_root where cast ('伽각' as string collate utf8_ko_cs_uca) like '伽%';

select 1 from db_root where cast ('伽' as string collate utf8_ko_cs_uca) like '伽%';

drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
