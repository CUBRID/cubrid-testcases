-- TEST CASE For:
-- [CBRD-20509] Inline View Update : Update via view 

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

drop view if exists vw_select;
drop view if exists vw_diff;
drop view if exists vw_inter;
drop view if exists vw_union;
drop view if exists vw_unall;
drop view if exists vw_unall_3tables;
drop view if exists vw_alias;

create table t1 (f1 int, f2 int);
create table t2 (f1 int, f2 int);
create table t3 (f1 int, f2 int);

create view vw_select as select f2 from t1;
create view vw_diff as select f2 from t1 difference select f2 from t2;
create view vw_inter as select f2 from t1 intersection select f2 from t2;
create view vw_union as select f2 from t1 union select f2 from t2;
create view vw_unall as select f2 from t1 union all select f2 from t2;
create view vw_unall_3tables as select f2 from t1 union all select f2 from t2 union all select f2 from t3;
create view vw_alias as select f2 t1_f2 from t1;

insert into t1 values(1,1);
insert into t2 values(1,1), (2,2);
insert into t3 values(1,1), (2,2), (3,3);
select * from vw_unall;

--[OK] view update 
update vw_select set f2=f2+1;
select * from vw_unall;
update vw_alias set t1_f2=t1_f2+1;
select * from vw_unall;
update vw_unall set f2=f2+1;
select * from vw_unall;

--[NOK] view update restriction  : set operators
update vw_diff set f2=f2+1;
update vw_inter set f2=f2+1;
update vw_union set f2=f2+1;
select * from vw_unall;

--[NOK] view update error  : when a inline view contains 3 or more 'UNION ALL's [legacy error]  
update vw_unall_3tables set f2=f2+1;
select * from vw_unall;

drop table t1;
drop table t2;
drop table t3;

drop view vw_select;
drop view vw_diff;
drop view vw_inter;
drop view vw_union;
drop view vw_unall;
drop view vw_unall_3tables;

