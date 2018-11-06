drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
insert into t1 values(5,'fff');
create table t2 (c int,name varchar(10));
insert into t2 values(3,'english'); 
insert into t2 values(4,'english');
insert into t2 values(5,'chinese');

insert into t2
with mycte as
(
 select * from t1 inner join t2 on t1.a=t2.c
) 
select * from t2
where c in 
(
 WITH n_s AS (SELECT a FROM t1) select * from n_s
);
select * from t2;

replace into t2
with mycte as
(
 select * from t1 inner join t2 on t1.a=t2.c
) 
select * from t2
where c in 
(
 select * from (WITH n_s AS (SELECT a FROM t1) select * from n_s order by 1 desc limit 0,2) as x
);
select * from t2 order by 1;


with mycte as
(
 select * from t1 inner join t2 on t1.a=t2.c
)
delete from  t2 
where c not in
(
 select * from (with n_s AS (SELECT a FROM t1) select n_s.a from n_s,mycte where n_s.a=mycte.a) as x
);
select * from t2 order by 1;

with mycte as
(
 select * from t1 inner join t2 on t1.a=t2.c
)
delete from t2 
where c in
(
 select * from (with n_s AS (SELECT a FROM t1) select n_s.a from n_s,mycte where n_s.a=mycte.a) as x
) and c>4;
select * from t2 order by 1;

with mycte as
(
 select t1.a as a,t1.b as b,t2.name as name from t1 inner join t2 on t1.a=t2.c
)
delete t1 from t1,t2,mycte
where t1.a != t2.c and 
t2.c in
(
 select * from (with n_s AS (SELECT a FROM t1) select n_s.a from n_s,mycte where n_s.a=mycte.a) as x
);
select * from t1 order by 1;

with mycte as
(
 select t1.a as a,t1.b as b,t2.name as name from t1 inner join t2 on t1.a=t2.c
)
delete t1,t2 from t1,t2,mycte
where t1.a = t2.c and
c in
(
 select * from (with n_s AS (SELECT a FROM t1) select n_s.a from n_s,mycte where n_s.a=mycte.a) as x
);
select * from t2 order by 1;
select * from t1 order by 1;

drop if exists t1,t2;
