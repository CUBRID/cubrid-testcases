-- TEST CASE For:
-- [CBRD-20509] Inline View Update : Update via table 

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1(f1 int, f2 int);
create table t2(f1 int, f2 int);
create table t3(f1 int, f2 int);

insert into t1 values(1,1);
insert into t2 values(1,1), (2,2);
insert into t3 values(1,1), (2,2), (3,3);
select * from t1;

--[OK] inline view update 
update (select f2 from t1) set f2=f2+1;
select * from t1;
update (select t1.f2 from t1, t2 where t1.f1=t2.f1) set f2=f2+1;
select * from t1;

--[NOK] (inline) view update restriction  
update (select distinct f2 from t1) set f2=f2+1;
update (select f1, count(f2) from t1 group by f1) set f1=f1+1;
update (values (1), (2)) as at1(f2) set at1.f2=at1.f2+1;
select * from t1;

--[OK] table alias update 
update (select f2 from t1) as at1 set at1.f2=at1.f2+1;
select * from t1;

--[OK] column alias error
update (select f2 as t1_f2 from t1) set t1_f2=t1_f2+1;
select * from t1;

drop table t1;
drop table t2;
drop table t3;

