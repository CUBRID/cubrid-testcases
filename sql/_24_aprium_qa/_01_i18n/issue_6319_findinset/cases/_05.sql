--+ holdcas on;
set names iso88591;

drop table if exists t;
create table t (i int, s char(20) collate iso88591_en_ci);

insert into t values (1,'Ca,ca,,Ec,Ea');
insert into t values (2,',,cE,C ,a,AC,Cx,');
insert into t values (3,'xcE,ca,A,C,E');
insert into t values (4,'Ec,aC,E,C');
insert into t values (5,'Ec,A,aC,E,C');

select i, s, find_in_set ('Ca',s) from t order by 1;
select i, s, find_in_set ('ca',s) from t order by 1;
select i, s, find_in_set ('C',s) from t order by 1;
select i, s, find_in_set ('A',s) from t order by 1;
select i, s, find_in_set ('AC',s) from t order by 1;
select i, s, find_in_set ('Ec',s) from t order by 1;
select i, s, find_in_set ('ce',s) from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
