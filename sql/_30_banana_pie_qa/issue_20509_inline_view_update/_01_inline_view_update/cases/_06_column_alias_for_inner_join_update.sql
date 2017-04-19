-- TEST CASE For:
-- [CBRD-20509] Inline View Update : Update by using column aliases on "ON" condition of innner join in a inline view. 

drop view if exists v1;
drop view if exists v2;
drop view if exists v3;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int, j int);
insert into t3 values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

create view v1 as select * from t1 where i >= 3;
create view v2 as select * from t2 where i <= 5;
create view v3 as select t1.i as i1, t3.i as i3 from t1 inner join t3 on t1.i=t3.i;


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

update v2 inner join v3 on v2.i=v3.i1 set v3.i1=v3.i3 + 1;		
select * from v3; 
update v2 inner join v3 on v2.i=v3.i3 set v3.i3=v3.i3 + 1;	
select * from v3;	 

drop view v1;
drop view v2;
drop view v3;
drop table t1;
drop table t2;
drop table t3;

