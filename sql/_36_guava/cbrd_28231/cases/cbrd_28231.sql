-- CBRD-28231: a query folded to false (pt_to_false_subquery) must return no row and must not fail

drop table if exists t28231_pc;
drop table if exists t28231_pa;
drop view if exists v28231;
drop table if exists t28231_g1, t28231_g3, t28231_zp, t28231_ra, t28231_rb, t28231_ri, t28231_ca, t28231_cb;

create table t28231_g1 (id int primary key, a int, b int);
create table t28231_g3 (id int primary key, a int, b int);
insert into t28231_g1 values (1,1,1),(2,2,NULL);
insert into t28231_g3 values (1,1,1);
create table t28231_zp (id int, c0 int, c1 int);
insert into t28231_zp values (1,1,1),(2,2,2);
create table t28231_ra (id int, c int);
create table t28231_rb (id int, c int);
insert into t28231_ra values (1,1),(2,2);
insert into t28231_rb values (1,1);
create table t28231_ri (x int);
create view v28231 as select id x0, max(c) x1 from t28231_rb group by id having 1=0;
create table t28231_ca (id int, c0 int);
create table t28231_cb (id int, c0 int);
insert into t28231_ca values (1,1),(2,2);
insert into t28231_cb values (1,1);
create table t28231_pa (id int, c int);
create table t28231_pc under t28231_pa (e int);
insert into t28231_pa values (1,1);
insert into t28231_pc values (2,2,2);

-- Case 1: the folded derived table keeps a WHERE that refers to the removed FROM (inner derived table folded)
select g1.id, y.k2 from t28231_g1 g1 left join (select /*+ NO_MERGE */ q.k0 k0, 3 k2 from (select /*+ NO_MERGE */ g.a k0, (select max(a) from t28231_g3) k1 from t28231_g1 g where g.b is null and g.b > 3) q where q.k1 = 0) y on g1.a = y.k0 order by 1;

-- Case 2: the query is false by its HAVING
-- with a WHERE: on the NULL-supplying side, on an inner join next to a LEFT JOIN, on the preserved side
select a.id, d1.x from t28231_zp a left join (select t.c1 x from t28231_zp t where t.c0 > 0 group by t.c1 having 1=0) d1 on a.id = d1.x order by 1;
select a.id, d1.x from t28231_zp a left join (select t.c1 x from t28231_zp t where t.c0 > 0 group by t.c1 having null > 1) d1 on a.id = d1.x order by 1;
select a.id, d1.x from t28231_zp a inner join (select t.c1 x from t28231_zp t where t.c0 > 0 group by t.c1 having 1=0) d1 on a.id = d1.x left join t28231_zp b on a.id = b.id;
select a.id, d1.x from t28231_zp a right join (select t.c1 x from t28231_zp t where t.c0 > 0 group by t.c1 having 1=0) d1 on a.id = d1.x;
-- without a WHERE: no NULL row
select t2.x0 from t28231_ra t1 right outer join (select id x0 from t28231_rb group by id having 1=0) t2 on t1.id = t2.x0;
select count(*) from (select id x0 from t28231_rb group by id having 1=0) t2 left join t28231_ra t1 on t1.id = t2.x0;
select t2.x1, count(t2.x0) from t28231_ra t1 right outer join v28231 t2 on t1.id = t2.x0 group by t2.x1;
-- INSERT ... SELECT inserts no row
insert into t28231_ri select id from t28231_rb group by id having 1=0;
insert into t28231_ri select id from t28231_rb where id > 0 group by id having 1=0;
select count(*) from t28231_ri;
-- false by START WITH, with an analytic function
select a.id, d1.x from t28231_zp a left join (select t.c1 x from t28231_zp t where t.c0 > 0 start with t.id = 1 and 1=0 connect by prior t.id = t.c0) d1 on a.id = d1.x order by 1;
select a.id, d1.x from t28231_zp a left join (select t.c1 x, sum(t.c0) over (partition by t.c1) s from t28231_zp t group by t.c1 having 1=0) d1 on a.id = d1.x order by 1;
-- unchanged: a single-row aggregate, a HAVING that is not false
select a.id, d1.x from t28231_zp a left join (select count(*) x from t28231_zp t where 1=0) d1 on a.id = d1.x order by 1;
select a.id, d1.x from t28231_zp a left join (select count(*) x from t28231_zp t having 1=0) d1 on a.id = d1.x order by 1;
select a.id, d1.x from t28231_zp a left join (select t.c1 x from t28231_zp t where t.c0 > 0 group by t.c1 having 1=1) d1 on a.id = d1.x order by 1;

-- Case 3: a derived table with an analytic function reads a constant-false CTE
with c as (select id x from t28231_cb where 1 = 0) select a.id, d.y from t28231_ca a left join (select count(*) over () y from c w) d on a.id = d.y order by 1;
with c as (select id x from t28231_cb where 1 = 0) select a.id, d.y from t28231_ca a left join (select count(*) over (partition by w.x) y from c w) d on a.id = d.y order by 1;
with c as (select id x from t28231_cb group by id having 1 = 0) select a.id, d.y from t28231_ca a left join (select sum(w.x) over () y from c w) d on a.id = d.y order by 1;

-- Case 4: the operands of a set operation read only a constant-false CTE
select count(*) from (with c as (select id x from t28231_cb where 1 = 0) (select x from c) union (select x from c)) t;
select a.id from t28231_ca a where a.id in (with c as (select id x from t28231_cb where 1 = 0) (select x from c) union all (select x from c));
with c as (select id x from t28231_cb where 1 = 0) select a.id from t28231_ca a where a.id not in ((select x from c) intersect (select id from t28231_cb)) order by 1;
with c as (select id x from t28231_cb where 1 = 0) (select x from c) union (select id from t28231_cb);
with c as (select id x from t28231_cb where 1 = 0) (select id from t28231_cb) difference (select x from c);

-- Case 5: PREPARE of a query folded to false that reads a class hierarchy
prepare st1 from 'select d.x from (select c x from all t28231_pa group by c having count(*) <=> ? and null = null) d';
execute st1 using 2;
prepare st2 from 'select d.x from (select c x from all t28231_pa group by c having count(*) <=> ? and 1 = 0) d';
execute st2 using 2;
prepare st3 from 'select d.x from (select c x from all t28231_pa group by c having count(*) >= ?) d order by 1';
execute st3 using 1;
deallocate prepare st1;
deallocate prepare st2;
deallocate prepare st3;

drop table t28231_pc;
drop table t28231_pa;
drop view v28231;
drop table t28231_g1, t28231_g3, t28231_zp, t28231_ra, t28231_rb, t28231_ri, t28231_ca, t28231_cb;
