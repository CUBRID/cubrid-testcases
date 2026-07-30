-- Verification for CBRD-26104, CBRD-26200, CBRD-26206, CBRD-26178
-- Check if uncorrelated subqueries(inline view) are executed in parallel.
-- Check if queries are executed in the usual way when parallel execution is not possible.
-- NO_PARALLEL_SUBQUERY hint is used to disable parallel execution of uncorrelated subqueries.

drop table if exists tbl_a,tbl_b;
drop view if exists v_tbl_a,v_tbl_b;

create table tbl_a (i int);
create table tbl_b (i int);

insert into tbl_a values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
insert into tbl_b values (11),(12),(13),(14),(15),(16),(17),(18),(19),(20);

create view v_tbl_a as select count(*) cn from tbl_a;
create view v_tbl_b as select count(*) cn from tbl_b;

set trace on;

evaluate 'union all - should work';
select /*+ recompile */ count(*) from tbl_a union all select count(*) from tbl_b;
show trace;

evaluate 'union all in subquery - should work';
select /*+ recompile */ * from (select count(*) from tbl_a union all select count(*) from tbl_b);
show trace;

evaluate 'union all in subquery - NO_PARALLEL_SUBQUERY hint used - should not work';
select /*+ recompile NO_PARALLEL_SUBQUERY */ * from (select count(*) from tbl_a union all select count(*) from tbl_b);
show trace;

evaluate 'parallel(0) hint used - should not work';
select /*+ recompile parallel(0) */ * from (select count(*) from tbl_a union all select count(*) from tbl_b);
show trace;

evaluate 'inline view used - should work';
select /*+ recompile */ * from (select count(*) from tbl_a) a, (select count(*) from tbl_b) b;
show trace;

evaluate 'inline view used - NO_PARALLEL_SUBQUERY hint used - should not work';
select /*+ recompile NO_PARALLEL_SUBQUERY */ * from (select count(*) from tbl_a) a, (select count(*) from tbl_b) b;
show trace;

evaluate 'view used - should work';
select /*+ recompile */ * from v_tbl_a a, v_tbl_b b;
show trace;

evaluate 'view used - NO_PARALLEL_SUBQUERY hint used - should not work';
select /*+ recompile NO_PARALLEL_SUBQUERY */ * from v_tbl_a a, v_tbl_b b;
show trace;

evaluate 'uncorrelated subquery that is not directly connected to the top-level XASL - should not work';
select /*+ recompile */ a.i, (
	select /*+ no_merge */ b.i from 
	(
		select /*+ no_merge */ tbl_b.i - 10 as i from tbl_b
		union all
		select /*+ no_merge */ tbl_b.i + 10 as i from tbl_b
	) b
	where a.i = b.i
) bi from tbl_a a;
show trace;

evaluate 'cte referencing another cte - should not work';
with cte_a as (select /*+ materialize */ count(*) from tbl_a),
cte_b as (select /*+ materialize */ count(*) from cte_a)
select /*+ recompile */ * from cte_b;
show trace;

evaluate 'recursive cte used - should not work';
with recursive cte_a as (select /*+ materialize */ i from tbl_a union all select i + 1 from cte_a where i < 10)
select /*+ recompile */ count(*) from cte_a;
show trace;

evaluate 'when there are references between uncorrelated subqueries due to a derived table - should not work';
with cte_a as (select * from tbl_a),
cte_b as (select * from tbl_b)
select /*+ recompile */ count(*) from tbl_a a left join cte_b b on a.i = b.i right join cte_a c on b.i = c.i;
show trace;

evaluate 'when the scan spec is a set, not a table or index - should not work';
with cte_a as (select /*+ materialize */ * from table({1,2,3}))
,cte_b as (select /*+ materialize */ * from table({4,5,6}))
select /*+ recompile */ * from cte_a, cte_b;
show trace;

CREATE OR REPLACE FUNCTION sp(n INTEGER) RETURN INTEGER DETERMINISTIC
IS
BEGIN
    return n + 1;
END;

evaluate 'case including a stored procedure - should not work';
with cte_a as (select /*+ materialize */ sp(i) from tbl_a),
cte_b as (select /*+ materialize */ sp(i) from tbl_b)
select /*+ recompile */ count(*) from cte_a, cte_b;
show trace;

evaluate 'stored procedure excluded case - should work';
with cte_a as (select /*+ materialize */ * from tbl_a),
cte_b as (select /*+ materialize */ * from tbl_b)
select /*+ recompile */ count(*) from cte_a, cte_b;
show trace;

evaluate 'stored procedure excluded case - NO_PARALLEL_SUBQUERY hint used - should not work';
with cte_a as (select /*+ materialize */ * from tbl_a),
cte_b as (select /*+ materialize */ * from tbl_b)
select /*+ recompile NO_PARALLEL_SUBQUERY */ count(*) from cte_a, cte_b;
show trace;

evaluate 'path expression used - should not work';
with cte_a as (select /*+ materialize */ owner.name from _db_class where class_name = 'tbl_a'),
cte_b as (select /*+ materialize */ owner.name from _db_class where class_name = 'tbl_b')
select /*+ recompile */ count(*) from cte_a, cte_b;
show trace;

evaluate 'path expression not used - should work';
with cte_a as (select /*+ materialize */ owner from _db_class where class_name = 'tbl_a'),
cte_b as (select /*+ materialize */ owner from _db_class where class_name = 'tbl_b')
select /*+ recompile */ count(*) from cte_a, cte_b;
show trace;

evaluate 'when running the show statement - should not work';
show tables like 'tbl_%';
show trace;

evaluate 'when a JSON_TABLE is used - should not work';
with cte_a as (SELECT /*+ materialize */ * FROM JSON_TABLE (
        '{"a":[1,[2,3]]}',
        '$.a[*]' COLUMNS ( col INT PATH '$')
    )   AS jt),
cte_b as (SELECT /*+ materialize */ * FROM JSON_TABLE (
        '{"a":[1,[2,3]]}',
        '$.a[*]' COLUMNS ( col INT PATH '$')
    )   AS jt)
select /*+ recompile */ count(*) from cte_a, cte_b;
show trace;

evaluate 'scalar subquery in SELECT list - should not work';
select /*+ recompile */
(select count(*) from tbl_a) as a_cnt,
(select count(*) from tbl_b) as b_cnt
from db_root;
show trace;

evaluate 'predicate subquery in WHERE clause - should not work';
select /*+ recompile */ count(*)
from tbl_a
where i > (select count(*) from (select count(*) as cn from tbl_a) a, (select count(*) as cn from tbl_b) b where a.cn = b.cn);
show trace;

evaluate 'group by subquery - should work';
select /*+ recompile */ count(*)
from
(
select count(*) from tbl_a group by i
) a,
(
select count(*) from tbl_b group by i
) b;
show trace;

evaluate 'correlated subquery - should not work';
select /*+ recompile */ count(*) from tbl_a aa, (select count(*) as cn from tbl_a where aa.i=i union all select count(*) as cn from tbl_b) a;
show trace;

drop table if exists tbl_a,tbl_b;
drop view if exists v_tbl_a,v_tbl_b;

evaluate 'Before the fix, a hang occurred when sp was included in the WHERE clause. for CBRD-26206';
drop table if exists tmp;

create table tmp (cola varchar(20), colb varchar(20), colc varchar(20),cold varchar(20),cole varchar(20),colf varchar(20));

insert into tmp select lpad(rownum,20,'0'),lpad(rownum % 5,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0') from db_class a, db_class b, db_class c, db_class d, db_class e limit 200000;

with cte_a as (
	select /*+ recompile materialize parallel(0) */ colf from tmp where cast(colb as int) = sp(cast(colb as int))
),
cte_b as (
	select /*+ recompile materialize parallel(0) */ colf from tmp
)
 select /*+ recompile parallel(2) */ 1 from cte_a, cte_b limit 1;
show trace;

drop function sp;
drop table if exists tmp;

evaluate 'Segmentation fault occurred before the fix. for CBRD-26178';
drop table if exists tta, ttb, ttc, ttd;

create table tta (ca int);
create table ttb (ca int);
create table ttc (ca int);
create table ttd (ca int);

insert into tta values (1);
insert into ttb values (1);
insert into ttc values (1);
insert into ttd values (1);

select /*+ recompile use_hash */ *
from tta, ttb, ttc
where (select ca from ttd) > 0 and tta.ca = ttb.ca and ttb.ca = ttc.ca;
show trace;

drop table if exists tta, ttb, ttc, ttd;