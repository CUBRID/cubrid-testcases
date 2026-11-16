/**
 *  This test case verifies CBRD-27376 (engine PR #8309).
 *
 *  A WHERE [NOT] EXISTS / [NOT] IN subquery whose FROM holds several base tables is now unnested into a
 *  SEMI / ANTI JOIN: the subquery is wrapped into an uncorrelated derived table that becomes the inner,
 *  the conditions reading the outer query move to the ON, and the derived table selects the inner
 *  columns the ON reads. Before, such a subquery stayed nested and ran once per outer row.
 *
 *  A statement that must be unnested prints its plan (--@queryplan), as its result is the same when the
 *  subquery stays nested. A statement that must stay nested checks its result only: unnesting it would
 *  change the result.
 *
 *  Base data: ta.ca 1, 2, 3 / tb (ca, cb) (1, 200), (2, 300), (3, 400) / tc.ca 200, 200, 400.
 *  ta.ca 1 and 3 have a match through tb and tc, ta.ca 1 twice. ta.ca 2 has a tb row but no tc row.
 *  ta.ca and tb.ca are NOT NULL for the NOT IN of Case 3, the index on tc.ca is there for Case 8.
 *
 *  Coverage:
 *    Case 1:  EXISTS / NOT EXISTS over two tables -> SEMI / ANTI JOIN with a derived table inner
 *    Case 2:  NOT EXISTS whose table joined to the outer query is the second in the subquery FROM: still unnested
 *    Case 3:  IN / NOT IN over two tables: the IN equality joins the ON, the derived table has no DISTINCT, and
 *             NOT IN on NOT NULL columns becomes an ANTI JOIN
 *    Case 4:  NOT IN on a column that may be NULL stays nested: an ANTI JOIN would return every outer row
 *    Case 5:  a correlated IN whose condition on ta reads tc: the condition joins the ON and the derived table
 *             selects tb.ca and tc.ca
 *    Case 6:  the subquery joins with JOIN ... ON: the derived table selects only the column its ON reads
 *    Case 7:  ORDERED of the subquery stays inside the derived table and reads tc first
 *    Case 8:  NO_COVERING_IDX and USING INDEX NONE stay inside the derived table and apply there
 *    Case 9:  USING INDEX ... KEYLIMIT keeps the subquery nested. tg holds 1000 rows matching nothing and
 *             th.ca > 0 lets i_th_ca read th, so a derived table would read th first and stop at its first
 *             key 200: no row instead of 3
 *    Case 10: a large indexed outer: the derived table is read first with DISTINCT and probes t_big by index
 */

drop table if exists ta, tb, tc, te, tf, tg, th, t_big;

create table ta (ca int not null);
insert into ta values (1), (2), (3);
create table tb (ca int not null, cb int);
insert into tb values (1, 200), (2, 300), (3, 400);
create table tc (ca int);
insert into tc values (200), (200), (400);
create index i_tc_ca on tc (ca);
update statistics on ta, tb, tc with fullscan;


evaluate 'Case 1: EXISTS / NOT EXISTS over two tables -> SEMI / ANTI JOIN with a derived table inner';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where not exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);


evaluate 'Case 2: NOT EXISTS whose table joined to the outer query is not the first in the subquery FROM';
--@queryplan
select /*+ recompile */ count(*) from ta where not exists (select 1 from tc, tb where tb.ca = ta.ca and tb.cb = tc.ca);


evaluate 'Case 3: IN / NOT IN over two tables';
--@queryplan
select /*+ recompile */ count(*) from ta where ta.ca in (select tb.ca from tb, tc where tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where ta.ca not in (select tb.ca from tb, tc where tb.cb = tc.ca);


evaluate 'Case 4: NOT IN on a column that may be NULL stays nested';
create table te (ca int, cb int);
insert into te values (null, 200);
select /*+ recompile */ count(*) from ta where ta.ca not in (select te.ca from te, tc where te.cb = tc.ca);


evaluate 'Case 5: a correlated IN whose ON reads a column of the second inner table';
--@queryplan
select /*+ recompile */ count(*) from ta where ta.ca in (select tb.ca from tb, tc where tb.cb = tc.ca and tc.ca < ta.ca + 300);


evaluate 'Case 6: the subquery joins its tables with JOIN ... ON';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb join tc on tb.cb = tc.ca where tb.ca = ta.ca);


evaluate 'Case 7: a hint of the subquery (ORDERED) stays inside the derived table';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select /*+ ordered */ 1 from tc, tb where tb.ca = ta.ca and tb.cb = tc.ca);


evaluate 'Case 8: a hint applying to the whole SELECT stays inside the derived table';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select /*+ no_covering_idx */ 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca using index none);


evaluate 'Case 9: USING INDEX ... KEYLIMIT keeps the subquery nested';
create table tf (ca int);
insert into tf values (3);
create table tg (ca int, cb int);
insert into tg values (3, 400);
insert into tg select -level, -level from db_root connect by level <= 1000;
create index i_tg_ca on tg (ca);
create table th (ca int);
insert into th values (200), (400);
create index i_th_ca on th (ca);
update statistics on tg, th;
select /*+ recompile */ ca from tf where exists (select 1 from tg, th where tg.ca = tf.ca and tg.cb = th.ca and th.ca > 0 using index i_th_ca keylimit 1);


evaluate 'Case 10: a large indexed outer: the derived table is read first with DISTINCT';
create table t_big (ca int);
insert into t_big select mod(rownum, 20) + 1 from db_class a, db_class b, db_class c limit 3000;
create index i_t_big_ca on t_big (ca);
update statistics on t_big with fullscan;
--@queryplan
select /*+ recompile */ count(*) from t_big where exists (select 1 from tb, tc where tb.ca = t_big.ca and tb.cb = tc.ca);


drop table ta, tb, tc, te, tf, tg, th, t_big;
