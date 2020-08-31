--+ holdcas on;
set names utf8;
drop table if exists t;

create table t (i int, s char(10) collate utf8_gen_ai_ci);

insert into t values (1,'Áa,áa,,Eá,');
insert into t values (2,',,áE,Á ,a,');
insert into t values (3,'xáE,áa,A,Á');
insert into t values (4,'Eá,aÁ,E,Á');
insert into t values (5,'Eá,A,aÁ,E,');

select i, s, find_in_set ('Áa',s) from t order by 1;
select i, s, find_in_set ('áa',s) from t order by 1;
select i, s, find_in_set ('Á',s) from t order by 1;
select i, s, find_in_set ('A',s) from t order by 1;
select i, s, find_in_set ('AÁ',s) from t order by 1;
select i, s, find_in_set ('Eá',s) from t order by 1;
select i, s, find_in_set ('áe',s) from t order by 1;


drop table t;
set names iso88591;
commit;
--+ holdcas off;
