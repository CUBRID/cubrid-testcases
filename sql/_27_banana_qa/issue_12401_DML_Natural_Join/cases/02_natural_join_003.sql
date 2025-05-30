--02_natural_join_03.sql
------------------------------
--test with one or more constant values
-- 2 constants

drop table if exists t1;
drop table if exists t2;

create table t1 (i1 int,d1 double,f1 float);
create table t2 (i2 int,d2 double,f2 float);
insert into t1 values(1,1.2,1);
insert into t1 values(1,1.2,1);
insert into t1 values(2,2.5,2);
insert into t1 values(2,2.5,2);
insert into t1 values(10,1.2e2,3);
insert into t1 values(10,1.2e2,3);
insert into t1 values(10,1.2e2,3);
insert into t1 values(20,2.5e2,4);
insert into t2 values(1,1.2,1);
insert into t2 values(1,1.2,1);
insert into t2 values(2,2.5,2);
insert into t2 values(2,2.5,2);
insert into t2 values(10,1.2e2,3);
insert into t2 values(10,1.2e2,3);
insert into t2 values(10,1.2e2,3);
insert into t2 values(20,2.5e2,4);

select * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 group by d1 order by 1,2,3,4,5,6;

select f1,i1+2 from (select * from t1 order by 1,2)  t1 natural join (select * from t2 order by 1,2)  t2 group by d1 order by 1,2;
prepare st from 'select f1,i1+? from t1 natural join t2 group by d1 order by 1,2';
execute st using 2;
deallocate prepare st;


select t1.f1,bit_and(t1.i1+2), bit_or(t1.i1-2), bit_xor(t1.i1*1) from t1;
select t1.f1,bit_and(t1.i1+2), bit_or(t1.i1-2), bit_xor(t2.i1*1) from t1 nature join t2;

prepare st from 'select t1.f1,bit_and(t1.i1+?), bit_or(t1.i1-?), bit_xor(t2.i1*?) from t1 nature join t2';
execute st using 2,2,1;
deallocate prepare st;

prepare st from 'select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) ? natural join (select * from t2 order by 1,2) ?';
execute st using N't1',N't2';
deallocate prepare st;

prepare st from 'select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) ? join (select * from t2 order by 1,2) ? on ?';
execute st using N't1',N't2',N't1.a';
deallocate prepare st;


prepare st from 'values ( ? nautral join ?)';
execute st using 1,2;
deallocate prepare st;

-- 4 constants
select 1 natural join 2 natural join 3 natural join 4;
values ( 1 natural join 2 natural join 3 natural join 4);

prepare st from 'select ? natural join ? natural join ? natural join ?';
execute st using 1,2;
deallocate prepare st;

prepare st from 'values ( ? nautral join ? natural join ? natural join ?)';
execute st using 1,2,3,4;
deallocate prepare st;

drop table if exists t1;
drop table if exists t2;
------------------------------
-- test with null
drop table a;
drop table b;
create table b as select * from _db_class where rownum < 10;
create table a  as select * from b;

--contain null
select count(*) from a;
select count(*) from b;

select count(*) from a natural join b;

drop table a;
drop table b;

------------------------------


drop table if exists t1;
drop table if exists t2;


create table t1 ( a int, b char(10)); 
create table t2 ( a int, b char(10));

insert into t1 values(3,'hello');
insert into t1 values(1,'hello');
insert into t2 values(3);
insert into t2 values(5);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1) t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1) t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1) t2 order by 1,2,3,4;


drop table if exists t1;
drop table if exists t2;

----------------------------

drop table if exists t1;
drop table if exists t2;

create table t1 (i1 int);
create table t2 (i2 int);
insert into t1 values(1);
insert into t1 values(3);
insert into t2 values(2);

select * from (select i1+1 from t1) t1 order by 1;
select /*+ RECOMPILE*/ * from (select i1+1 from t1 order by 1) t1 natural join (select i2 as x from t2 order by 1) t2 order by 1,2;

drop table if exists t1;
drop table if exists t2;
----------------------------
drop table t1;
drop table t2;

create table t1 (i1 int);
create table t2 (i1 int);
insert into t1 values(1);
insert into t2 values(1);
insert into t2 values(2);

select * from (select i1+1 from t1) t1 order by 1;

select * from (select i1+1 from t1) t1 natural join (select i1+1 from t2) t2 order by 1, 2;

select * from (select i1+1 as i1 from t1) t1 natural join (select i1+1 as i1 from t2) t2 order by 1,2;

drop table t1;
drop table t2;
----------------------------

drop table if exists t1;
drop table if exists t2;

create table t1 (i1 int);
create table t2 (i2 int);
insert into t1 values(1);
insert into t1 values(3);
insert into t2 values(2);

select /*+ RECOMPILE*/ * from (select i1+1 from t1 order by 1) t1 natural join (select i2 as x from t2 order by 1) t2 order by 1,2;

select /*+ RECOMPILE*/ * from (select i1+1 as i2 from t1 order by 1) t1 natural join (select i2 as i1 from t2 order by 1) t2 order by 1,2;


select i2 as i1_1 from t2 order by 1;
drop table t1;
drop table t2;
