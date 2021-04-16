--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(a int primary key, b varchar(10), c char(1));
insert into t1 values (1,'abc', '+');
insert into t1 values (2,'def', '+');
insert into t1 values (3,'abc', '-');
insert into t1 values (4,'def', '-');
insert into t1 values (5,'abc', '+');
insert into t1 values (6,'def', '+');
insert into t1 values (7,'abc', '-');
insert into t1 values (8,'def', '-');
insert into t1 values (9,'abc', '+');
insert into t1 values (10,'def', '+');

select b, count(b), sum(a) from t1 group by b;
select b,c, count(*), sum(a) from t1 group by b, c order by b desc,c asc;

create table t2 as select b,c, count(*) as d, sum(a) as e from t1 group by b, c order by b desc,c asc;
select * from t2 order by b desc, c asc;
drop table t2;

create table t3 as select b,c, count(*) as d, sum(a) as e from t1 group by b desc , c asc;
select * from t3 order by b desc, c asc;
drop table t3;

select a,b,c, count(*), sum(a) from t1 group by a asc with rollup;
select b,c, count(*), sum(a) from t1 group by b desc,c asc with rollup;

select t.* from (select a id, b id from t1) t;
create view v1 as select a id, b id from t1;

select DISTINCTROW b from (select b,c from t1) t order by b desc, c asc;

select distinct b from t1 order by c;
(select b from t1 ) union (select b from t1)order by c;
select distinct b from t1 order by c, 3, 4;
select distinct b from t1 order by 3, 4, c; 
(select b from t1 ) union (select b from t1) order by c, 3, 4;
(select b from t1 ) union (select b from t1) order by 3, 4, c;
select distinct b from t1 order by a, c;
(select b from t1 ) union (select b from t1) order by a, c;

drop table t1;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
