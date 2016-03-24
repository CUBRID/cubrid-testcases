--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca, i integer);
create table t2 (s1 string collate utf8_gen, i integer);

insert into t1 values ('가伽각', 1), ('가가각',1);
insert into t1 values ('가伽각', 2), ('가가각',2);

insert into t2 values ('가伽각', 1), ('가가각',1);
insert into t2 values ('가伽각', 2), ('가가각',2);

select group_concat (s1) from t1 group by i order by 1;
select group_concat (s1) from t2 group by i order by 1;

select group_concat (s1) from t1 group by s1 order by 1;
select group_concat (s1) from t2 group by s1 order by 1;

select group_concat (s1 order by 1) from t1 group by i order by 1;
select group_concat (s1 order by 1) from t2 group by i order by 1;

select group_concat (s1 order by 1) from t1 group by i order by 1;
select group_concat (s1 order by 1) from t2 group by i order by 1;


select group_concat (s1 order by 1 separator '+') from t1 group by i order by 1;
select group_concat (s1 order by 1 separator '+') from t2 group by i order by 1;

drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;