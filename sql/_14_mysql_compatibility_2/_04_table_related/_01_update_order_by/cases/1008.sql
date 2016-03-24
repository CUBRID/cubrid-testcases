-- UPDATE ... ORDER BY    + trigger


------------------------- 1  one key for ORDER BY, different values in SET and ORDER BY
create table t1 (i1 integer ,i2 integer, i3 integer );
create table t2 (a int auto_increment, i integer );

insert into t1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from t1 order by i2;

create trigger tr1_uo before update on t1
execute insert t2 set i=obj.i1;
 
update t1 set i1=0 order by i2;

select * from t1 order by i2;
select * from t2 order by a;

drop trigger tr1_uo;
drop t1;
drop t2;


------------------------  2 - one key for ORDER BY ,  same values in SET and ORDER BY
create table t1 (i1 integer ,i2 integer, i3 integer );
create table t2 (a int auto_increment, i integer );

insert into t1 values (4,4,4), (1,1,1) , (7,7,7),(2,2,2), (3,3,3), (6,6,6),(5,5,5);
select * from t1 order by i3;

create trigger tr1_uo before update on t1
execute insert t2 set i=obj.i1;
 
update t1 set i2=0 order by i2 desc;

select * from t1 order by i3;
select * from t2 order by a;

drop trigger tr1_uo;
drop t1;
drop t2;


------------------------ 3 - two keys for ORDER BY

create table t1 (i1 integer ,i2 integer, i3 integer,i4 integer );
create table t2 (a int auto_increment unique, i integer );
insert into t1 values (4,4,4,4), (1,7,1,7) , (7,1,7,1),(2,6,2,6), (3,5,3,5), (6,2,6,2),(5,3,5,3);
select * from t1 order by i4 desc;

create trigger tr1_uo before update on t1
execute insert t2 set i=obj.i1;

update t1 set i1=0,i2=1,i3=1 order by i1,i2;

select * from t1 order by i4 desc;
select * from t2 order by a;

drop trigger tr1_uo;
drop t1;
drop t2;



------------------------ 4 - two keys for ORDER BY with LIMIT
create table t1 (i1 integer ,i2 integer, i3 integer,i4 integer );
create table t2 (a int auto_increment unique, i integer );
insert into t1 values (4,4,4,4), (1,7,1,7) , (7,1,7,1),(2,6,2,6), (3,5,3,5), (6,2,6,2),(5,3,5,3);
select * from t1 order by i4 desc;

create trigger tr1_uo before update on t1
execute insert t2 set i=obj.i1;

update t1 set i1=0,i2=1,i3=1 order by i1,i2 limit 5;

select * from t1 order by i4 desc;
select * from t2 order by a;

drop trigger tr1_uo;
drop t1;
drop t2;



------------------------ 5 - two keys for ORDER BY with LIMIT  - one value to update
create table t1 (i1 integer ,i2 integer, i3 integer,i4 integer );
create table t2 (a int auto_increment, i integer );
insert into t1 values (4,4,4,4), (1,7,1,7) , (7,1,7,1),(2,6,2,6), (3,5,3,5), (6,2,6,2),(5,3,5,3);
select * from t1 order by i4 desc;

create trigger tr1_uo before update on t1
execute insert t2 set i=obj.i1;

update t1 set i1=0,i2=1,i3=1 order by i1,i2 limit 1;

select * from t1 order by i4 desc;
select * from t2 order by a;

drop trigger tr1_uo;
drop t1;
drop t2;

