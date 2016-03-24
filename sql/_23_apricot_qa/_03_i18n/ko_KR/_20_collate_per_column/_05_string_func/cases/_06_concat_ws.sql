--+ holdcas on;
set names utf8;
create table t1 (s1 string collate utf8_ko_cs_uca);
create table t2 (s1 string collate utf8_gen);

insert into t1 values ('가'), ('伽');

insert into t2 values ('가'), ('伽');


select concat_ws ('+', s1,'가') from t1 order by 1;
select concat_ws ('+', s1,'가') from t2 order by 1;


select concat_ws ('+', cast (s1 as string collate utf8_gen),'가') from t1 order by 1;
select concat_ws ('+', cast (s1 as string collate utf8_ko_cs_uca),'가') from t2 order by 1;



-- columns with diferent collation
select concat_ws('+', t1.s1, t2.s1) from t1,t2 order by 1;

select concat_ws('+', t1.s1, cast (t2.s1 as string collate utf8_ko_cs_uca)) from t1,t2 order by 1;


alter table t1 add column sep char(1) collate utf8_ko_cs_uca default '+';

select concat_ws(t1.sep, cast (t1.s1 as string collate utf8_bin), t2.s1) from t1,t2 order by 1;

select concat_ws(cast (t1.sep as string collate utf8_bin), 't1.s1', t2.s1) from t1,t2 order by 1;

-- late binding
prepare s from 'select concat_ws(?, s1 ,?) from t1 order by 1'
execute s using '+', '가';
DEALLOCATE PREPARE s;

drop table t1;
drop table t2;
set names iso88591;
commit;
--+ holdcas off;
