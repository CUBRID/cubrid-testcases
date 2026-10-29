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
 *  The data is chosen so that a decision per inner table would be wrong: the first tb row of ca = 1
 *  (cb 100) has no tc match while the second (cb 200) has two, so the outer row cb = 1 must come out,
 *  and once. A missing row shows as count 2, a duplicated one as count 4.
 *
 *  Coverage:
 *    Case 1: EXISTS / NOT EXISTS over two tables (the reported query) -> SEMI / ANTI JOIN with a
 *            derived table inner
 *    Case 2: IN / NOT IN over two tables, both operands NOT NULL; a correlated IN whose ON reads two
 *            inner columns
 *    Case 3: the subquery joins its tables with JOIN ... ON, and with LEFT JOIN plus IS NULL
 *    Case 4: a hint of the subquery (ORDERED) stays with it and orders the derived table
 *    Case 5: NOT IN on a column that may be NULL is kept as written
 *    Case 6: inner tables joined to each other only through the outer query
 *    Case 7: a large indexed outer: the derived table is read first with DISTINCT and probes the outer
 *            by index
 */

drop table if exists ta, tb, tc, td, te, t_big;

-- ta: the outer, 10 rows, cb 1..10 without an index, cc 0..2
create table ta (ca int primary key, cb int not null, cc int not null);
insert into ta values (1, 1, 1), (2, 2, 2), (3, 3, 0), (4, 4, 1), (5, 5, 2), (6, 6, 0), (7, 7, 1), (8, 8, 2), (9, 9, 0), (10, 10, 1);
-- tb: ca 1 and 3 twice; the first ca = 1 row (cb 100) has no tc match, the second (cb 200) has two
create table tb (ca int not null, cb int not null);
insert into tb values (1, 100), (1, 200), (2, 300), (3, 400), (3, 401), (5, 500), (11, 600);
-- tc: ca 200 twice, so a plain join would return the outer row cb = 1 twice; index on ca
create table tc (ca int not null, cb int not null);
insert into tc values (200, 1), (200, 2), (400, 3), (401, 4), (500, 5), (999, 6);
create index i_tc_ca on tc (ca);
-- td: ca 1 and 3, matched by ta.cc + 1
create table td (ca int not null);
insert into td values (1), (3);
-- te: like tb, but ca may be NULL and one row has a NULL ca
create table te (ca int, cb int not null);
insert into te values (1, 200), (null, 400), (5, 500);
update statistics on ta, tb, tc, td, te with fullscan;


evaluate 'Case 1: EXISTS / NOT EXISTS over two tables -> SEMI / ANTI JOIN with a derived table inner';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where not exists (select 1 from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);


evaluate 'Case 2: IN / NOT IN over two tables; a correlated IN whose ON reads two inner columns';
--@queryplan
select /*+ recompile */ count(*) from ta where ta.cb in (select tb.ca from tb, tc where tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where ta.cb not in (select tb.ca from tb, tc where tb.cb = tc.ca);
-- tc.cb <= ta.cc + 2 reads tc through the ON too: only cb = 1 (cc 1, tc.cb 1) passes
select /*+ recompile */ ca from ta where ta.cb in (select tb.ca from tb, tc where tb.cb = tc.ca and tc.cb <= ta.cc + 2);


evaluate 'Case 3: the subquery joins its tables with JOIN ... ON, and with LEFT JOIN plus IS NULL';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb join tc on tb.cb = tc.ca where tb.ca = ta.cb);
-- the tb rows without a tc match are ca 1, 2 and 11
select /*+ recompile */ ca from ta where exists (select 1 from tb left join tc on tb.cb = tc.ca where tb.ca = ta.cb and tc.ca is null) order by ca;


evaluate 'Case 4: a hint of the subquery stays with it: ORDERED puts tc first inside the derived table';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select /*+ ordered */ 1 from tc, tb where tb.ca = ta.cb and tb.cb = tc.ca);


evaluate 'Case 5: NOT IN on a column that may be NULL is kept as written';
-- the subquery returns a NULL ca, so NOT IN is UNKNOWN for every outer row: no row
select /*+ recompile */ ca from ta where ta.cb not in (select te.ca from te, tc where te.cb = tc.ca);


evaluate 'Case 6: inner tables joined to each other only through the outer query';
select /*+ recompile */ ca from ta where exists (select 1 from tb, td where tb.ca = ta.cb and td.ca = ta.cc + 1) order by ca;


evaluate 'Case 7: a large indexed outer: the derived table is read first with DISTINCT and probes the outer by index';
-- t_big 3000 rows, cb 1..20 (150 rows each), index on cb; cb 1, 3 and 5 are matched: 450 rows
create table t_big (ca int primary key, cb int not null);
insert into t_big select rownum, mod(rownum, 20) + 1 from db_class a, db_class b, db_class c limit 3000;
create index i_t_big_cb on t_big (cb);
update statistics on t_big with fullscan;
--@queryplan
select /*+ recompile */ count(*) from t_big where exists (select 1 from tb, tc where tb.ca = t_big.cb and tb.cb = tc.ca);


drop table ta, tb, tc, td, te, t_big;
