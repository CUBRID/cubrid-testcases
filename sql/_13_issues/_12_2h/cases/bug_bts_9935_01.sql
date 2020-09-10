--+ holdcas on;
--
set system parameters 'create_table_reuseoid=no';

drop table if exists t;
create table t(i int) partition by range(i) (partition p0 values less than (10), partition p1 values less than (100));

insert into t__p__p0 values(5);
insert into t__p__p0 values(10);
insert into t__p__p1 values(15);

insert into t values(1);
insert into t values(11);

select * from t order by i;

select * from t partition (p0) order by i;

select * from t partition (p1) order by i;

insert into t partition (p0) values(2);

insert into t partition (p1) values(12);

select * from t order by 1;

select * from t order by i;

drop table if exists t;
--
drop table if exists t;
create table t(i int) partition by range(i) (partition p0 values less than (10), partition p1 values less than (100));

insert into t__p__p0 values(-1);
insert into t__p__p0 values(-111111111111111111111111111111111111111111);
insert into t__p__p0 values(5);
insert into t__p__p0 values(5);
insert into t__p__p0 values(5);
insert into t__p__p0 values(5);
insert into t__p__p0 values(10);
insert into t__p__p1 values(-1);
insert into t__p__p1 values(10);
insert into t__p__p1 values(15);
insert into t__p__p1 values(15);
insert into t__p__p1 values(15);
insert into t__p__p1 values(15);
insert into t__p__p1 values(15);
insert into t__p__p1 values(200);

insert into t values(-11);
insert into t values(1);
insert into t values(10);
insert into t values(99);
insert into t values(100);
insert into t values(101);
insert into t values(11);

select * from t order by i;

select * from t partition (p0) order by i;

select * from t partition (p1) order by i;

insert into t partition (p0) values(2);

insert into t partition (p1) values(12);

select * from t order by 1;

select * from t order by i;

drop table if exists t;
--
drop table if exists t;
create table t(i int) partition by range(i) (partition p1 values less than (10), partition p0 values less than (100));

insert into t__p__p0 values(-1);
insert into t__p__p0 values(-111111111111111111111111111111111111111111);
insert into t__p__p0 values(5);
insert into t__p__p0 values(5);
insert into t__p__p0 values(5);
insert into t__p__p0 values(5);
insert into t__p__p0 values(10);
insert into t__p__p1 values(-1);
insert into t__p__p1 values(10);
insert into t__p__p1 values(15);
insert into t__p__p1 values(15);
insert into t__p__p1 values(15);
insert into t__p__p1 values(15);
insert into t__p__p1 values(15);
insert into t__p__p1 values(200);

insert into t values(-11);
insert into t values(1);
insert into t values(10);
insert into t values(99);
insert into t values(100);
insert into t values(101);
insert into t values(11);

select * from t order by i;

select * from t partition (p0) order by i;

select * from t partition (p1) order by i;

insert into t partition (p0) values(2);
insert into t partition (p0) values(12);

insert into t partition (p1) values(12);
insert into t partition (p1) values(1);

select * from t order by 1;

select * from t order by i;

drop table if exists t;
--
drop table if exists t;

create table t(i int) partition  --test
by range(i)  --test range I'am a tester.
(partition p0 values less than (10),  --less's'''''''''''''''''''
partition p1 values less than (100)); 


insert into t__p__p0 values(5);
insert into t__p__p0 values(10);
insert into t__p__p1 values(15);

select * from t order by i;

drop table if exists t;
--
drop table if exists t;

create table t(i int) partition by range(i) (partition p0 values less than (10), partition p1 values less than (100));
insert into t select level from db_root connect by nocycle level<5 union all select level from db_root connect by nocycle level<10;
select * from t order by 1;
update t set i = 15 where i = 5;
select * from t order by 1;

update t set i = 5 where i = 15;
select * from t order by 1;

update t partition (p0) set i = 10 where i = 15;
select * from t order by 1;

update t partition (p0) set i = 5 where i = 15;

select * from t order by 1;

drop table if exists t;

--

drop table if exists t;

create table t(i int) partition by range(i) (partition p0 values less than (10), partition p1 values less than (100));

insert into t select rownum from _db_class limit 5;
insert into t select level from db_root  CONNECT BY nocycle level<100;
insert into t select level from db_root connect by nocycle level<5 union all select level from db_root connect by nocycle level<10;

select * from t order by 1;

update t set i = 15 where i = 5;

update t partition (p0) set i = 5 where i = 15;

update t partition (p0) set i = 14 where i = 4;

update t partition (p1) set i = 15 where i = 5;

update t partition(p0) set i = 9 where  i<=100;


update t partition(p1) set i = 9 where  i<100;

select * from t order by i;

drop table if exists t;

--
drop table if exists t;
drop table if exists a;

create table t(i int) partition by range(i) (partition p0 values less than (10), partition p1 values less than (100));
create table a (i int);

insert into t select rownum from _db_class limit 5;

create trigger tr_bef_upd_t before update on t execute insert into a values(obj.i);

update t set i = 15 where i = 5;

update t partition (p0) set i = 5 where i = 15;

update t partition (p0) set i = 14 where i = 4;

select * from t order by i;

drop table if exists t;
drop table if exists a;
--
drop table if exists t;

create table t(i int, j int, unique(i,j)) partition by range(i) (partition p0 values less than (10), partition p1 values less than(100));
insert into t values(1, 10),(20, 15);
insert into t partition (p0) values (20, 1) on duplicate key update i = 1;
insert into t partition (p0) values(2, 15) on duplicate key update j = 116;
insert into t partition (p0) values(2, 15) on duplicate key update j = 10;

insert into t partition (p1) values(14, 10) on duplicate key update i=20;
select * from t order by i;

insert into t values(14, 10) on duplicate key update i=3;

select * from t order by i;



drop table if exists t;
--
drop table if exists t;

create table t(i int, j int, unique(i,j)) partition by range(i) (partition p0 values less than (10), partition p1 values less than(100));
insert into t values(1, 10),(20, 15);
insert into t values(4, 10) on duplicate key update j=10;
select * from t order by i;
drop table if exists t;


drop table if exists t;
create table t(i int, j int unique) ;
insert into t values(1, 10),(20, 15);
insert into t( i) values(4) on duplicate key update j=10;
select * from t order by i;

drop table if exists t;
--


drop table if exists t;
create table t(i int, j int primary key) ;
insert into t values(1, 10),(20, 15);
insert into t(i,j) values(4,10) on duplicate key update i=10;
select * from t order by i;

drop table if exists t;


drop table if exists t;
create table t(i int, j int, primary key(i,j))  partition by range(i) (partition p0 values less than (10), partition p1 values less than(100));
insert into t values(1, 10),(20, 15);

insert into t partition (p0)  (i,j)  values(1,10) on duplicate key update i=9;
select * from t order by i;

insert into t partition (p1)  (i,j)  values(20,15) on duplicate key update i=10;

insert into t  (i,j)  values(4,10) on duplicate key update i=9;
select * from t order by i;

drop table if exists t;
--

drop table if exists t;
drop table if exists u;


create table t (i integer, j int) partition by range (i)  (partition p0 values less than (10), partition p1 values less than (100));
create table u (i integer);

insert into t select rownum, rownum from _db_class;
insert into u select rownum from _db_class;

merge into t partition (p0) p0
using u
on (p0.j = u.i - 2)
when matched then
update set p0.i = p0.i - 2;

select * from t order by i;

merge into t partition (p0) p0
using u
on (p0.j = u.i - 2)
when matched then
update set p0.i = p0.i + 4;

merge into t partition (p0) p0
using u
on (p0.j = u.i - 2 and u.i > 10)
when matched then
update set p0.i = p0.i - 2
when not matched then
insert values(u.i + 10, u.i);

merge into t p0
using u
on (p0.j = u.i - 2 and u.i > 10)
when matched then
update set p0.i = p0.i - 2
when not matched then
insert values(u.i + 10, u.i);

drop table if exists u;
drop table if exists t;

--
drop table if exists t;
CREATE TABLE t(i INT) PARTITION BY RANGE(i) (PARTITION p0 VALUES LESS THAN(10), PARTITION p1 VALUES LESS THAN(100));
INSERT INTO t VALUES(1);
SELECT t INTO :my_obj FROM t;
UPDATE OBJECT :my_obj SET i = 3;
UPDATE OBJECT :my_obj SET i = 33;
select * from t order by 1;

drop table if exists t;
--
drop table if exists t;
CREATE TABLE t(i INT unique) PARTITION BY RANGE(i) (PARTITION p0 VALUES LESS THAN(10), PARTITION p1 VALUES LESS THAN(100));
INSERT INTO t VALUES(1);
SELECT t INTO :my_obj FROM t;
UPDATE OBJECT :my_obj SET i = 3;
UPDATE OBJECT :my_obj SET i = 33;

insert into t partition (p0) values (3) on duplicate key update i =  OBJECT :my_obj ;

drop table if exists t;

set system parameters 'create_table_reuseoid=yes';
--+ holdcas off;
