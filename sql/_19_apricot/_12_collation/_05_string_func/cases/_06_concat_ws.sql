create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'), ('aa');

insert into t2 values ('Ab'), ('aa');


select concat_ws ('+', s1,'c') from t1 order by 1;
select concat_ws ('+', s1,'c') from t2 order by 1;


select concat_ws ('+', cast (s1 as string collate utf8_en_cs),'c') from t1 order by 1;
select concat_ws ('+', cast (s1 as string collate utf8_en_ci),'c') from t2 order by 1;



-- columns with diferent collation
select concat_ws('+', t1.s1, t2.s1) from t1,t2 order by 1;

select concat_ws('+', t1.s1, cast (t2.s1 as string collate utf8_en_ci)) from t1,t2 order by 1;


alter table t1 add column sep char(1) collate utf8_en_ci default '+';

select concat_ws(t1.sep, cast (t1.s1 as string collate utf8_bin), t2.s1) from t1,t2 order by 1;

select concat_ws(cast (t1.sep as string collate utf8_bin), 't1.s1', t2.s1) from t1,t2 order by 1;

-- late binding
prepare s from 'select concat_ws(?, s1 ,?) from t1 order by 1';
execute s using '+', 'c';
deallocate prepare s;


drop table t1;
drop table t2;
