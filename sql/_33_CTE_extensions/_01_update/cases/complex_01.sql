drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
insert into t1 values(5,'fff');
create table t2 (c int,name varchar(10));
insert into t2 values(3,'english'); 
insert into t2 values(4,'english');
insert into t2 values(5,'chinese');

WITH recursive o_s AS (
SELECT c FROM t2
)
SELECT *
FROM   o_s, (WITH n_s AS (SELECT a FROM t1) select * from n_s) x order by 1;

WITH recursive o_s AS (
SELECT c FROM t2
)
SELECT *
FROM   o_s y, (WITH n_s AS (SELECT a FROM t1) select * from n_s) x where y.c=x.a  order by 1;


with mycte as
(
 select * from t1 inner join t2 on t1.a=t2.c
) 
update t2 set name='french'
where c in 
(
 WITH n_s AS (SELECT a FROM t1) select * from n_s
);
select * from t2;

with mycte as
(
 select * from t1 inner join t2 on t1.a=t2.c
) 
update t2 set name='german'
where c in 
(
 select * from (WITH n_s AS (SELECT a FROM t1) select * from n_s order by 1 desc limit 0,2) as x
);
select * from t2 order by 1;


with mycte as
(
 select * from t1 inner join t2 on t1.a=t2.c
)
update t2 set name='russia'
where c in
(
 select * from (with n_s AS (SELECT a FROM t1) select n_s.a from n_s,mycte where n_s.a=mycte.a) as x
);
select * from t2 order by 1;

with mycte as
(
 select * from t1 inner join t2 on t1.a=t2.c
)
update t2 set name='korea'
where c not in
(
 select * from (with n_s AS (SELECT a FROM t1) select n_s.a from n_s,mycte where n_s.a=mycte.a) as x
);
select * from t2 order by 1;

with mycte as
(
 select t1.a as a,t1.b as b,t2.name as name from t1 inner join t2 on t1.a=t2.c
)
update t1,t2,mycte set t2.name='america',t1.b=t1.b||' updated'
where t1.a != t2.c and 
c not in
(
 select * from (with n_s AS (SELECT a FROM t1) select n_s.a from n_s,mycte where n_s.a=mycte.a) as x
);
select * from t2 order by 1;
select * from t1 order by 1;

with mycte as
(
 select t1.a as a,t1.b as b,t2.name as name from t1 inner join t2 on t1.a=t2.c
)
update t1,t2,mycte set t2.name='india',t1.b=t1.b||' updated'
where t1.a = t2.c and
c in
(
 select * from (with n_s AS (SELECT a FROM t1) select n_s.a from n_s,mycte where n_s.a=mycte.a) as x
);
select * from t2 order by 1;
select * from t1 order by 1;



drop if exists t1,t2;
