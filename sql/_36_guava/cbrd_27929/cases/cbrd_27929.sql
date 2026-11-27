/**
 *  This test case verifies CBRD-27929: Run a [NOT] EXISTS / [NOT] IN subquery over several tables as the subquery
 *  where running it for each outer row costs far less than the SEMI / ANTI JOIN with a derived table
 *
 *  A WHERE [NOT] EXISTS / [NOT] IN subquery whose FROM joins several tables is unnested into a SEMI / ANTI
 *  JOIN with a derived table (CBRD-27376). With engine PR #8404 such a spec is run as the subquery again when
 *  the subquery, run once for each row of the outer table its ON reads, costs a tenth of building the derived
 *  table. The rows of that table are counted without its own conditions. The subquery comes back as written:
 *  [NOT] EXISTS, or [NOT] IN with its select list item. Every other spec is left the join, as on develop, where
 *  the plan reads the derived table as it is or once without its duplicates (CBRD-27397). A spec is not run as
 *  the subquery when its ON compares anything but columns of the same type, as a subquery evaluates its WHERE
 *  before its tables are joined, nor when an IN subquery is not correlated.
 *
 *  Data, with no index:
 *    tl (ca, cb) 20000 rows with cb = ca. tm (ca, cb, cc) 20000 rows with cb = ca and cc = ca mod 4, tn.ca
 *    2 to 40000 by 2: tm joined to tn keeps the even numbers.
 *  Data, with an index on ca:
 *    tb (ca, cb) 10000 rows with cb = ca, tc.ca 3 to 30000 by 3: tb joined to tc keeps the multiples of 3.
 *  ta (ca, cb) 10 rows with cb = ca but (6, 7), no index: ta.ca 3, 6 and 9 have a match in tb joined to tc,
 *  and ta.cb holds 7 twice.
 *  td (ca, ck) 10 rows (5, 1 to 10). te (ca, cb, cc, ck) with an index on ck: 10 rows (10, -1, 0, 1 to 10) that
 *  join no row of tf, and 10000 rows (10, n, 2, n mod 1000 + 1). tf.ca 1 to 10000 with an index: te.ca / te.cc
 *  is 5 on the rows of te joined to tf and a division by zero on the others.
 *
 *  A statement whose form is under test prints its plan. A statement whose subquery is run as written is
 *  followed by the same query with NO_UNNEST, for the reference result. A prepared statement checks its
 *  results only: the plan printed at an EXECUTE is the one made without the values.
 *
 *  Coverage:
 *    Case 1:  EXISTS / NOT EXISTS over two joined tables on 20000 rows of tl, no index -> SEMI / ANTI JOIN
 *             with the derived table
 *    Case 2:  EXISTS / IN over tm joined to ta on tb -> the join reads the derived table, 10 rows with 7 twice,
 *             once without its duplicates and probes tb by its index. The derived table of the IN has no
 *             DISTINCT of its own
 *    Case 3:  EXISTS and NOT EXISTS in one query on tl -> each spec chosen on its own: the NOT EXISTS kept an
 *             ANTI JOIN, the EXISTS run as its subquery (its derived table would be every pair of tb and tc rows)
 *    Case 4:  EXISTS / NOT EXISTS over two joined tables on 10 rows of ta -> the [NOT] EXISTS subquery
 *    Case 5:  correlated IN / NOT IN on NOT NULL columns on ta -> the [NOT] IN subquery
 *    Case 6:  IN that is not correlated -> the SEMI JOIN: run as written it would not read ta
 *    Case 7:  IN whose select list item divides by a column only the join with tf keeps non-zero -> the IN
 *             subquery, the item computed on the joined rows. The same condition written with EXISTS or NOT
 *             EXISTS puts the division in the ON -> the SEMI / ANTI JOIN, no division by zero
 *    Case 8:  EXISTS and NOT EXISTS in one query on ta -> each run as its subquery
 *    Case 9:  EXISTS / NOT EXISTS whose two tables are joined to ta only, not to each other -> the subquery
 *    Case 10: USE_MERGE names the spec -> the join kept although the subquery costs less
 *    Case 11: a prepared statement with a marker in the subquery or on the outer table -> the results of each
 *             EXECUTE, the spec chosen at the first one
 */

drop table if exists tl, tm, tn, tb, tc, ta, td, te, tf;

-- tl, tm and tn hold 20000 rows each and have no index: a subquery over tm and tn run for each row of tl
-- would read tm in full each time, so building the derived table once costs far less (Cases 1, 3 and 11)
create table tl (ca int not null, cb int);
insert into tl select level, level from db_root connect by level <= 20000;
create table tm (ca int not null, cb int, cc int);
insert into tm select level, level, mod (level, 4) from db_root connect by level <= 20000;
create table tn (ca int);
insert into tn select level * 2 from db_root connect by level <= 20000;
-- tb and tc have an index on ca: a subquery over them run for each row of ta reads a few index entries,
-- far less than building the derived table of tb and tc (Cases 4, 5, 8, 9, 10 and 11). The index on tb.ca
-- also lets Case 2 read tb by the few distinct rows of its derived table instead of reading tb in full
create table tb (ca int not null, cb int);
insert into tb select level, level from db_root connect by level <= 10000;
create index i_tb_ca on tb (ca);
create table tc (ca int);
insert into tc select level * 3 from db_root connect by level <= 10000;
create index i_tc_ca on tc (ca);
-- ta holds 10 rows, and ta.cb holds 7 twice, so that the derived table of Case 2 has a duplicate
create table ta (ca int not null, cb int);
insert into ta values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 7), (7, 7), (8, 8), (9, 9), (10, 10);
-- te.cc is 0 only on rows whose te.cb joins no row of tf: only the join keeps te.ca / te.cc from dividing by
-- zero (Case 7)
create table td (ca int, ck int);
insert into td select 5, level from db_root connect by level <= 10;
create table te (ca int, cb int, cc int, ck int);
insert into te select 10, -1, 0, level from db_root connect by level <= 10;
insert into te select 10, level, 2, mod (level, 1000) + 1 from db_root connect by level <= 10000;
create index i_te_ck on te (ck);
create table tf (ca int);
insert into tf select level from db_root connect by level <= 10000;
create index i_tf_ca on tf (ca);
update statistics on tl, tm, tn, tb, tc, ta, td, te, tf with fullscan;


evaluate 'Case 1: EXISTS / NOT EXISTS on a large outer, no index -> SEMI / ANTI JOIN';
--@queryplan
select /*+ recompile */ count(*) from tl where exists (select 1 from tm, tn where tm.ca = tl.ca and tm.cb = tn.ca);
--@queryplan
select /*+ recompile */ count(*) from tl where not exists (select 1 from tm, tn where tm.ca = tl.ca and tm.cb = tn.ca);


evaluate 'Case 2: EXISTS / IN on an indexed outer, a derived table of few rows -> the derived table read without its duplicates';
--@queryplan
select /*+ recompile */ count(*) from tb where exists (select 1 from tm, ta where tm.cb = tb.ca and tm.ca = ta.cb);
--@queryplan
select /*+ recompile */ count(*) from tb where tb.ca in (select tm.cb from tm, ta where tm.ca = ta.cb);


evaluate 'Case 3: EXISTS and NOT EXISTS in one query on a large outer -> the ANTI JOIN kept, the EXISTS run as its subquery';
--@queryplan
select /*+ recompile */ count(*) from tl where exists (select 1 from tb, tc where tb.ca = tl.ca and tc.ca = tl.cb) and not exists (select 1 from tm, tn where tm.ca = tl.ca and tm.cb = tn.ca);


evaluate 'Case 4: EXISTS / NOT EXISTS on a small outer -> the [NOT] EXISTS subquery';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where not exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where not exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);


evaluate 'Case 5: correlated IN / NOT IN on a small outer -> the [NOT] IN subquery';
--@queryplan
select /*+ recompile */ count(*) from ta where ta.ca in (select tb.ca from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where ta.ca in (select /*+ NO_UNNEST */ tb.ca from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where ta.ca not in (select tb.ca from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where ta.ca not in (select /*+ NO_UNNEST */ tb.ca from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);


evaluate 'Case 6: IN that is not correlated -> the SEMI JOIN';
--@queryplan
select /*+ recompile */ count(*) from ta where ta.ca in (select tb.ca from tb, tc where tb.cb = tc.ca);


evaluate 'Case 7: a division only the join keeps from zero -> the IN subquery, the SEMI / ANTI JOIN for [NOT] EXISTS';
--@queryplan
select /*+ recompile */ count(*) from td where td.ca in (select te.ca / te.cc from te, tf where te.cb = tf.ca and te.ck = td.ck);
select /*+ recompile */ count(*) from td where td.ca in (select /*+ NO_UNNEST */ te.ca / te.cc from te, tf where te.cb = tf.ca and te.ck = td.ck);
--@queryplan
select /*+ recompile */ count(*) from td where exists (select 1 from te, tf where te.cb = tf.ca and te.ck = td.ck and td.ca = te.ca / te.cc);
--@queryplan
select /*+ recompile */ count(*) from td where not exists (select 1 from te, tf where te.cb = tf.ca and te.ck = td.ck and td.ca = te.ca / te.cc);


evaluate 'Case 8: EXISTS and NOT EXISTS in one query on a small outer -> each run as its subquery';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca) and not exists (select 1 from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca) and not exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);


evaluate 'Case 9: EXISTS / NOT EXISTS whose two tables are joined to ta only -> the subquery';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tc.ca = ta.cb);
select /*+ recompile */ count(*) from ta where exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tc.ca = ta.cb);
--@queryplan
select /*+ recompile */ count(*) from ta where not exists (select 1 from tb, tc where tb.ca = ta.ca and tc.ca = ta.cb);
select /*+ recompile */ count(*) from ta where not exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tc.ca = ta.cb);


evaluate 'Case 10: USE_MERGE names the spec -> the join kept';
--@queryplan
select /*+ recompile use_merge */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);


evaluate 'Case 11: a prepared statement -> the results of each EXECUTE';
prepare st from 'select count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca and tc.ca > ?)';
execute st using 0;
execute st using 6;
deallocate prepare st;
prepare st from 'select count(*) from ta where not exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca and tc.ca > ?)';
execute st using 0;
execute st using 6;
deallocate prepare st;
prepare st from 'select count(*) from tl where tl.cb > ? and exists (select 1 from tm, tn where tm.ca = tl.ca and tm.cb = tn.ca)';
execute st using 0;
execute st using 19990;
deallocate prepare st;


drop table tl, tm, tn, tb, tc, ta, td, te, tf;
