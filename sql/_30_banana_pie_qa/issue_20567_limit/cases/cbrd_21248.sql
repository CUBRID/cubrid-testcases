--+ holdcas on;
drop view if exists v1;
drop table if exists t1;

create table t1 (a int);
insert into t1 select rownum from db_class limit 20;

create view v1 as select * from t1 order by 1 limit 0, (2+2)/2 ;
select * from v1;

alter view v1 add query select * from t1 order by 1 limit 0+1*(1-1)/1, (2+2*3)/(2-1);
select * from v1 limit 3+3;
show create view v1;

alter view v1 as select * from t1 order by t1.a limit 0, (2+2)/2 ;
select * from v1;

alter view v1 add query select * from t1 order by t1.a limit 0+1*(1-1)/1, (2+2*3)/(2-1);
select * from v1;
show create view v1;

drop view if exists v1;
drop table if exists t1;
--+ holdcas off;
