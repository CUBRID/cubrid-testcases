/**
 *  This test case verifies CBRD-27376 (engine PR #8309).
 *
 *  CBRD-24043 unnests a WHERE [NOT] EXISTS / [NOT] IN subquery into a SEMI / ANTI JOIN only when the
 *  subquery FROM holds one base table. A subquery over several tables stayed nested and ran once per
 *  outer row. Now such a subquery is wrapped into an uncorrelated derived table that becomes the
 *  SEMI / ANTI JOIN inner: the conjuncts naming the outer query move to the ON and read the inner
 *  columns through the derived table's select list, the rest stays inside with the tables, their join
 *  order and their hints. The derived table runs once, before the outer query, and takes part in the
 *  join order and join method choice of the outer query. The DISTINCT that type checking marks on an
 *  IN subquery is dropped, so EXISTS and IN get the same plan.
 *
 *  A query with the NO_UNNEST hint that follows an unnested one gives the reference result and the
 *  two must match. The data is chosen so that a decision per inner table would be wrong: the first
 *  t_a row of k = 1 (v 100) has no t_b match while the second (v 200) has two, so the outer row k = 1
 *  must come out, and once.
 *
 *  Coverage:
 *    Case 1: EXISTS / NOT EXISTS over two tables (the reported query) -> SEMI / ANTI JOIN with a
 *            derived table inner
 *    Case 2: IN / NOT IN over two tables, both operands NOT NULL; a correlated IN whose ON reads two
 *            inner columns
 *    Case 3: the subquery joins its tables with JOIN ... ON, and with LEFT JOIN plus IS NULL
 *    Case 4: three tables chained by two inner conditions
 *    Case 5: a hint of the subquery (ORDERED) stays with it and orders the derived table
 *    Case 6: kept as written: a derived table with LIMIT inside the subquery FROM; NOT IN on a column
 *            that may be NULL
 *    Case 7: inner tables joined to each other only through the outer query
 *    Case 8: a large indexed outer: the derived table is read first with DISTINCT and probes the outer
 *            by index
 */

drop table if exists t_o, t_a, t_b, t_c, t_n, t_big;

-- t_o: the outer, 10 rows, k 1..10 without an index, g 0..2
create table t_o (id int primary key, k int not null, g int not null);
insert into t_o values (1, 1, 1), (2, 2, 2), (3, 3, 0), (4, 4, 1), (5, 5, 2), (6, 6, 0), (7, 7, 1), (8, 8, 2), (9, 9, 0), (10, 10, 1);
-- t_a: k 1 and 3 twice; the first k = 1 row (v 100) has no t_b match, the second (v 200) has two
create table t_a (k int not null, v int not null);
insert into t_a values (1, 100), (1, 200), (2, 300), (3, 400), (3, 401), (5, 500), (11, 600);
-- t_b: v 200 twice, so a plain join would return the outer row k = 1 twice; index on v
create table t_b (v int not null, w int not null);
insert into t_b values (200, 1), (200, 2), (400, 3), (401, 4), (500, 5), (999, 6);
create index i_t_b_v on t_b (v);
-- t_c: w 1 and 3 of t_b
create table t_c (w int not null);
insert into t_c values (1), (3);
-- t_n: like t_a, but k may be NULL and one row has a NULL k
create table t_n (k int, v int not null);
insert into t_n values (1, 200), (null, 400), (5, 500);
update statistics on t_o, t_a, t_b, t_c, t_n with fullscan;


evaluate 'Case 1: EXISTS / NOT EXISTS over two tables -> SEMI / ANTI JOIN with a derived table inner';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select 1 from t_a, t_b where t_a.k = t_o.k and t_a.v = t_b.v);
select /*+ recompile parallel(0) */ id from t_o where exists (select 1 from t_a, t_b where t_a.k = t_o.k and t_a.v = t_b.v) order by id;
select /*+ recompile parallel(0) */ id from t_o where exists (select /*+ NO_UNNEST */ 1 from t_a, t_b where t_a.k = t_o.k and t_a.v = t_b.v) order by id;
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o where not exists (select 1 from t_a, t_b where t_a.k = t_o.k and t_a.v = t_b.v);
select /*+ recompile parallel(0) */ id from t_o where not exists (select 1 from t_a, t_b where t_a.k = t_o.k and t_a.v = t_b.v) order by id;
select /*+ recompile parallel(0) */ id from t_o where not exists (select /*+ NO_UNNEST */ 1 from t_a, t_b where t_a.k = t_o.k and t_a.v = t_b.v) order by id;


evaluate 'Case 2: IN / NOT IN over two tables; a correlated IN whose ON reads two inner columns';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o where t_o.k in (select t_a.k from t_a, t_b where t_a.v = t_b.v);
select /*+ recompile parallel(0) */ id from t_o where t_o.k in (select t_a.k from t_a, t_b where t_a.v = t_b.v) order by id;
select /*+ recompile parallel(0) */ id from t_o where t_o.k in (select /*+ NO_UNNEST */ t_a.k from t_a, t_b where t_a.v = t_b.v) order by id;
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o where t_o.k not in (select t_a.k from t_a, t_b where t_a.v = t_b.v);
select /*+ recompile parallel(0) */ id from t_o where t_o.k not in (select t_a.k from t_a, t_b where t_a.v = t_b.v) order by id;
select /*+ recompile parallel(0) */ id from t_o where t_o.k not in (select /*+ NO_UNNEST */ t_a.k from t_a, t_b where t_a.v = t_b.v) order by id;
-- t_b.w <= t_o.g + 2 reads t_b through the ON too: only k = 1 (g 1, w 1) passes
select /*+ recompile parallel(0) */ id from t_o where t_o.k in (select t_a.k from t_a, t_b where t_a.v = t_b.v and t_b.w <= t_o.g + 2) order by id;
select /*+ recompile parallel(0) */ id from t_o where t_o.k in (select /*+ NO_UNNEST */ t_a.k from t_a, t_b where t_a.v = t_b.v and t_b.w <= t_o.g + 2) order by id;


evaluate 'Case 3: the subquery joins its tables with JOIN ... ON, and with LEFT JOIN plus IS NULL';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select 1 from t_a join t_b on t_a.v = t_b.v where t_a.k = t_o.k);
select /*+ recompile parallel(0) */ id from t_o where exists (select 1 from t_a join t_b on t_a.v = t_b.v where t_a.k = t_o.k) order by id;
select /*+ recompile parallel(0) */ id from t_o where exists (select /*+ NO_UNNEST */ 1 from t_a join t_b on t_a.v = t_b.v where t_a.k = t_o.k) order by id;
-- the t_a rows without a t_b match are k 1, 2 and 11
select /*+ recompile parallel(0) */ id from t_o where exists (select 1 from t_a left join t_b on t_a.v = t_b.v where t_a.k = t_o.k and t_b.v is null) order by id;
select /*+ recompile parallel(0) */ id from t_o where exists (select /*+ NO_UNNEST */ 1 from t_a left join t_b on t_a.v = t_b.v where t_a.k = t_o.k and t_b.v is null) order by id;


evaluate 'Case 4: three tables chained by two inner conditions';
select /*+ recompile parallel(0) */ id from t_o where exists (select 1 from t_a, t_b, t_c where t_a.k = t_o.k and t_a.v = t_b.v and t_b.w = t_c.w) order by id;
select /*+ recompile parallel(0) */ id from t_o where exists (select /*+ NO_UNNEST */ 1 from t_a, t_b, t_c where t_a.k = t_o.k and t_a.v = t_b.v and t_b.w = t_c.w) order by id;


evaluate 'Case 5: a hint of the subquery stays with it: ORDERED puts t_b first inside the derived table';
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_o where exists (select /*+ ordered */ 1 from t_b, t_a where t_a.k = t_o.k and t_a.v = t_b.v);


evaluate 'Case 6: kept as written: a derived table with LIMIT inside the subquery FROM; NOT IN on a column that may be NULL';
select /*+ recompile parallel(0) */ id from t_o where exists (select 1 from t_a, (select v from t_b limit 10) d where t_a.k = t_o.k and t_a.v = d.v) order by id;
-- the subquery returns a NULL k, so NOT IN is UNKNOWN for every outer row: no row
select /*+ recompile parallel(0) */ id from t_o where t_o.k not in (select t_n.k from t_n, t_b where t_n.v = t_b.v) order by id;


evaluate 'Case 7: inner tables joined to each other only through the outer query';
select /*+ recompile parallel(0) */ id from t_o where exists (select 1 from t_a, t_c where t_a.k = t_o.k and t_c.w = t_o.g + 1) order by id;
select /*+ recompile parallel(0) */ id from t_o where exists (select /*+ NO_UNNEST */ 1 from t_a, t_c where t_a.k = t_o.k and t_c.w = t_o.g + 1) order by id;


evaluate 'Case 8: a large indexed outer: the derived table is read first with DISTINCT and probes the outer by index';
-- t_big 3000 rows, k 1..20 (150 rows each), index on k; k 1, 3 and 5 are matched: 450 rows
create table t_big (id int primary key, k int not null);
insert into t_big select rownum, mod(rownum, 20) + 1 from db_class a, db_class b, db_class c limit 3000;
create index i_t_big_k on t_big (k);
update statistics on t_big with fullscan;
--@queryplan
select /*+ recompile parallel(0) */ count(*) from t_big where exists (select 1 from t_a, t_b where t_a.k = t_big.k and t_a.v = t_b.v);
select /*+ recompile parallel(0) */ count(*) from t_big where exists (select /*+ NO_UNNEST */ 1 from t_a, t_b where t_a.k = t_big.k and t_a.v = t_b.v);


drop table t_o, t_a, t_b, t_c, t_n, t_big;
