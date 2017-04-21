-- TEST CASE For:
-- [CBRD-20509] Inline View Update : Update by using column aliases on "ON" condition of innner join in a inline view. 
--   additional TC: inner join usage, lowercase/uppercase

drop view if exists v1;
drop view if exists v2;
drop view if exists v3;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists tt1;
drop table if exists tt2;
drop table if exists tt3;

create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int, j int);
insert into t3 values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

create view v1 as select * from t1 where i >= 3;
create view v2 as select * from t2 where i <= 5;
create view v3 as select t1.i as i1, t3.i as i3 from t1 inner join t3 on t1.i=t3.i;

--- basic TC ----
-- [OK] 
update v2 inner join v3 on v2.i=v3.i1 set v3.i1=v3.i3 + 1;		
select * from v3; 

-- [OK]
update ( (select t3.i t3_i, t3.j t3_j  from t3) v3 inner join (select i t2_i from t2) v2 on v3.t3_i = v2.t2_i) set t2_i = t2_i +1 ;
select * from t2;

update ( (select t3.i as i1, t3.j as i3 from t3) v3 inner join ( select i as ii from t2 ) v2 on v2.ii = v3.i3 ) set  v2.ii=v2.ii+1;
select * from t2;

update ( (select t3.i t3_i, t3.j t3_j  from t3) v3 inner join (select i t2_i from t2) v2 on v3.t3_i = v2.t2_i) set t2_i = t2_i +1 ;
select * from t2;

update ( select i1, i3 from (select t3.i as i1, t3.j as i3 from t3) v3, ( select i as ii from t2 ) v2 where v3.i3 = v2.ii) set i3 = i3 +1;
select * from t3;
update (select t2.i t2_i, t3.i t3_i, t3.j t3_j  from (t3 inner join t2 on t3.i = t2.i) ) set t2_i = t2_i +1 ;
select * from t2;


--- additional TC ----
----- Another DDL ---
create table tt1 (f1 int, f2 int);
create table tt2 (f1 int, f2 int);
create table tt3 (f1 int, f2 int);

insert into tt1 values (1,1);
insert into tt2 values (1,1), (2,2);
insert into tt3 values (1,1), (2,2), (3,3);

-- [OK] column name: lower/upper case 
update ( select tt2.f2 tt2_f2 from tt2 inner join tt1 on tt2.f1 = tt1.f1 ) set tt2_f2 = tt2_f2 + 1;
select * from tt2;	 
update ( select tt2.f2 tt2_f2 from tt2 inner join tt1 on tt2.f1 = tt1.f1 ) set tt2_F2 = TT2_f2 + 1;   --- upper case : tt2_F2, T2_f2
select * from tt2;	 

-- [NOK] usage error (inner join)
update (tt1 inner join tt2 on tt1.f1 = tt2.f1) tt1tt2  set tt1tt2.f2 = tt1tt2.f2+ 1;	

-- [OK] usage OK (inner join)
update (select tt1.f1, tt1.f2 from tt1 inner join tt2 on tt1.f1 = tt2.f1) tt1tt2  set tt1tt2.f2 = tt1tt2.f2+ 1;    
select * from tt1;	 


-- [OK] complex inner join and column alias
update (select tt1tt2.tt22_f2 from ( (select tt2.f2 tt2_f2 from tt2 inner join tt1 on tt2.f1 = tt1.f1)  ) tt1tt2(tt22_f2) inner join tt3 on tt1tt2.tt22_f2=tt3.f2) set tt22_f2 = tt22_f2+ 1;
select * from tt2;

update ( (select tt1_tt2.f1, tt1_tt2.f2 from (select tt1.f1, tt1.f2 from tt1 inner join tt2 on tt1.f1=tt2.f1) tt1_tt2 inner join tt3 on tt1_tt2.f1 = tt3.f1)) tt1_tt2_2nd(f1,f2) set tt1_tt2_2nd.f2 = tt1_tt2_2nd.f2 + 1;
select * from tt1;

drop view v1;
drop view v2;
drop view v3;
drop table t1;
drop table t2;
drop table t3;

drop table tt1;
drop table tt2;
drop table tt3;
