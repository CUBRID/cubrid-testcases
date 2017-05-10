--+ holdcas on;

drop view if exists v1;
drop table if exists t1;

create table t1 (a int);
insert into t1 select rownum from db_class limit 10;

create view v1 as select * from t1 where a=1 or a=2 order by a limit 1;
select * from v1;

alter view v1 as select * from t1 where a=1 xor a=2 order by a limit 1+1;
select * from v1;

alter view v1 as select * from t1 where NOT ( a=1 or a=2 ) order by a limit 8*1/(1+2); 
select * from v1;

set  system parameters 'pipes_as_concat=n';

select * from t1 where  !a || a!=1 && a>5 order by a limit (1+2-3)*4+1/1;

alter view v1 as select * from t1 where  !a || a!=1 && a>5  order by a limit (1+2-3)*4+1/1;
select * from v1;

set  system parameters 'pipes_as_concat=y';

drop view if exists v1;
drop table if exists t1;
--+ holdcas off;