-- TEST CASE For:
-- [CBRD-20509] Inline View Update : Update by using column aliases

drop view if exists vw_select;
drop view if exists vw_diff;
drop view if exists vw_inter;
drop view if exists vw_union;
drop view if exists vw_unall;
drop view if exists vw_alias;

drop table if exists t1;
drop table if exists t2;

create table t1(f1 int, f2 int);
create table t2(f1 int, f2 int);

create view vw_select as select f2 from t1;
create view vw_diff as select f2 from t1 difference select f2 from t2;
create view vw_inter as select f2 from t1 intersection select f2 from t2;
create view vw_union as select f2 from t1 union select f2 from t2;
create view vw_unall as select f2 from t1 union all select f2 from t2;
create view vw_alias as select f2 t1_f2 from t1;

insert into t1 values(1,1);
insert into t2 values(1,1), (2,2);
select * from vw_unall;

--[OK] inline view update 
update (select f1 f11,  f2 f22 from t1) set f22 = f11;
update (select f1 f11,  f2 f22 from t1) set f22 = f22;
update (select f1 f11,  f2 f22 from t1) set f22 = f22 + 1;
select * from t1;
update (select f1 f11,  f2 f22 from t1) set f22 = 1 + f22;
select * from t1;

update (select f1 f11,  f2 f22 from t1 t11) t111 set f22 = f22;
update (select f1 f11,  f2 f22 from t1 t11) t111 set f22 = f22+1;
select * from t1;
update (select f1 f11,  f2 f22 from t1 t11) t111 set t111.f22 = f22;
update (select f1 f11,  f2 f22 from t1 t11) t111 set t111.f22 = t111.f22;
update (select f1 f11,  f2 f22 from t1 t11) t111 set t111.f22 = f22 + 1;
select * from t1;

update (select f1,  f2 f22 from t1 t11) t111(f111, f222) set t111.f222 = t111.f222;
update (select f1,  f2 f22 from t1 t11) t111(f111, f222) set t111.f222 = 1 + t111.f222;
select * from t1;
update (select f1,  f2 f22 from t1 t11) t111(f111, f222) set t111.f222 = t111.f222 + 1;
select * from t1;
update (select f1,  f2 f22 from t1 t11) t111(f111, f222) set t111.f222 = t111.f222 + 1 + t111.f222;
select * from t1;

update (select f1,  f2 f22 from t1) t111(f111, f222) set t111.f222 = 1 + t111.f222 + 1 - t111.f222 + (select count(*) from t1);
select * from t1;
update (select f1,  f2 f22 from t1) t111(f111, f222) set t111.f222 = 1 + t111.f222 + 1 - t111.f222  + (select f2 f222 from t1);
select * from t1;
update (select f1,  f2 f22 from t1) t111(f111, f222) set t111.f222 = 1  + (select f2 f222 from t1) + t111.f222;
select * from t1;
update (select f1,  f2 f22 from t1) t111(f111, f222) set t111.f222 = 1  + (select f2 f222 from t1) + 1 + t111.f222;
select * from t1;
update (select f1,  f2 f22 from t1) t111(f111, f222) set t111.f222 = 1  + (select f2 f222 from t1) - t111.f222 + (select 10);
select * from t1;

-- path or .dot
update (select f1 f11,  f2 f22 from dba.t1) set f22 = f22;  // dot selector
select * from t1;
update (select f1,  f2 f22 from dba.t1) t111(f111, f222) set t111.f222 = 1 + t111.f222 + 1 - t111.f222 + (select count(*) from dba.t1);
select * from t1;

-- view expansion
update (select f2 f22 from (select f2 from t1 vw_select) ) set f22=f22+1;
select * from t1;
update (select f2 f22 from vw_select ) t111 set t111.f22=t111.f22+1;
select * from t1;

update (select f2 from vw_unall) set f2 = 1;
select * from vw_unall;
update (select f2 from vw_unall) set f2 = f2+1;
select * from vw_unall;
update (select f2 f22 from vw_unall) set f22 = f22+1;
select * from vw_unall;
update (select f2 f22 from vw_unall) t111 set f22 = t111.f22+1;
select * from vw_unall;
update (select f2 f22 from vw_unall) t111 set t111.f22 = f22+1;
select * from vw_unall;
update (select f2 f22 from vw_unall) t111 set t111.f22 = t111.f22+1;
select * from vw_unall;

update (select t11.f2 f22 from vw_unall t11) t111 set f22 = t111.f22+1;
select * from vw_unall;
update (select t11.f2 f22 from vw_unall t11) t111 (f222) set f222 = f222+1;
select * from vw_unall;
update (select t11.f2 f22 from vw_unall t11) t111 (f222) set f222 = t111.f222+1;
select * from vw_unall;

--[NOK] column alias error   (column alias: not defined error) 
update (select f1 f11,  f2 f22 from t1) set t1.f22 = 1 + t1.f22;
update (select f1 f11,  f2 f22 from t1 t11) t111 set t1.f22 = f22;
update (select f1,  f2 f22 from t1 t11) t111(f111, f222) set t111.f222 = 1 + t11.f22;
update (select f1,  f2 f22 from t1) t111(f111, f222) set t111.f222 = 1 + t1.f222 + 1 - t111.f222  + (select count(*) from t1);
update (select t11.f2 f22 from vw_unall t11) t111 (f222) set f22 = t111.f222+1;
select * from vw_unall;

--[NOK] inline view delete: not allowed 
delete from (select * from t2) ;
select * from vw_unall;

drop table t1;
drop table t2;

drop view vw_select;
drop view vw_diff;
drop view vw_inter;
drop view vw_union;
drop view vw_unall;

