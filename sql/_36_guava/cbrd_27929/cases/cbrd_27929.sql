/**
 *  This test case verifies CBRD-27929 (engine PR #8404).
 *
 *  A WHERE [NOT] EXISTS / [NOT] IN subquery whose FROM joins several tables is unnested into a SEMI / ANTI
 *  JOIN with a derived table (CBRD-27376). The query is now planned with each SEMI / ANTI JOIN spec in each
 *  form it can run in, spec by spec in the order of the FROM, and keeps the cheapest form:
 *    - the SEMI / ANTI JOIN with the derived table
 *    - for a SEMI JOIN, an INNER JOIN with the derived table read once without its duplicates: DISTINCT is
 *      added to the derived table, or kept from an IN subquery
 *    - the subquery itself, run once per outer row as [NOT] EXISTS (an IN form comes back as EXISTS)
 *  A large outer keeps the join. With a few outer rows and an index on the column the subquery joins to the
 *  outer query, running the subquery per outer row reads far less than building the derived table.
 *
 *  Data, with no index:
 *    tl (ca, cb) 20000 rows with cb = ca. tm (ca, cb, cc) 20000 rows with cb = ca and cc = ca mod 4, tn.ca
 *    2 to 40000 by 2: tm joined to tn keeps the even numbers. tx.ca 9999.
 *  Data, with an index on ca:
 *    tb (ca, cb) 10000 rows with cb = ca, tc.ca 3 to 30000 by 3: tb joined to tc keeps the multiples of 3.
 *  ta (ca, cb) 10 rows with cb = ca but (6, 7), no index: ta.ca 3, 6 and 9 have a match in tb joined to tc,
 *  and ta.cb holds 7 twice.
 *
 *  Every statement under test prints its plan (--@queryplan). A statement whose subquery is put back is
 *  followed by the same query with NO_UNNEST, the subquery run as written, for the reference result.
 *
 *  Coverage:
 *    Case 1: EXISTS / NOT EXISTS over two joined tables on 20000 rows of tl, no index -> SEMI / ANTI JOIN
 *            with the derived table
 *    Case 2: EXISTS / IN over tm joined to ta on tb -> the derived table, 10 rows with 7 twice, read without
 *            its duplicates and joined INNER to tb by its index: EXISTS adds DISTINCT, IN keeps its own
 *    Case 3: EXISTS and NOT EXISTS in one query on tl -> the NOT EXISTS kept an ANTI JOIN, the EXISTS put back
 *            as its subquery (its derived table would be every pair of tb and tc rows)
 *    Case 4: EXISTS / NOT EXISTS over two joined tables on 10 rows of ta -> the [NOT] EXISTS subquery run per
 *            row of ta
 *    Case 5: IN / NOT IN on NOT NULL columns over two joined tables on ta -> the [NOT] EXISTS subquery,
 *            without the DISTINCT the derived table of the IN kept
 *    Case 6: IN whose select list item divides by a column the subquery WHERE keeps non-zero, on the one row
 *            of tx -> the EXISTS subquery, its WHERE evaluated before the IN equality on the same scan: no
 *            division by zero
 *    Case 7: EXISTS / NOT EXISTS whose two tables are joined to ta only, not to each other -> the subquery
 *    Case 8: EXISTS and NOT EXISTS in one query on ta -> each put back as its subquery, one after the other
 */

drop table if exists tl, tm, tn, tx, tb, tc, ta;

create table tl (ca int not null, cb int);
insert into tl select level, level from db_root connect by level <= 20000;
create table tm (ca int not null, cb int, cc int);
insert into tm select level, level, mod (level, 4) from db_root connect by level <= 20000;
create table tn (ca int);
insert into tn select level * 2 from db_root connect by level <= 20000;
create table tx (ca int);
insert into tx values (9999);
create table tb (ca int not null, cb int);
insert into tb select level, level from db_root connect by level <= 10000;
create index i_tb_ca on tb (ca);
create table tc (ca int);
insert into tc select level * 3 from db_root connect by level <= 10000;
create index i_tc_ca on tc (ca);
create table ta (ca int not null, cb int);
insert into ta values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 7), (7, 7), (8, 8), (9, 9), (10, 10);
update statistics on tl, tm, tn, tx, tb, tc, ta with fullscan;


evaluate 'Case 1: EXISTS / NOT EXISTS on a large outer, no index -> SEMI / ANTI JOIN';
--@queryplan
select /*+ recompile */ count(*) from tl where exists (select 1 from tm, tn where tm.ca = tl.ca and tm.cb = tn.ca);
--@queryplan
select /*+ recompile */ count(*) from tl where not exists (select 1 from tm, tn where tm.ca = tl.ca and tm.cb = tn.ca);


evaluate 'Case 2: EXISTS / IN on an indexed outer, a derived table of few rows -> INNER JOIN with a DISTINCT derived table';
--@queryplan
select /*+ recompile */ count(*) from tb where exists (select 1 from tm, ta where tm.cb = tb.ca and tm.ca = ta.cb);
--@queryplan
select /*+ recompile */ count(*) from tb where tb.ca in (select tm.cb from tm, ta where tm.ca = ta.cb);


evaluate 'Case 3: EXISTS and NOT EXISTS in one query on a large outer -> the ANTI JOIN kept, the EXISTS put back';
--@queryplan
select /*+ recompile */ count(*) from tl where exists (select 1 from tb, tc where tb.ca = tl.ca and tc.ca = tl.cb) and not exists (select 1 from tm, tn where tm.ca = tl.ca and tm.cb = tn.ca);


evaluate 'Case 4: EXISTS / NOT EXISTS on a small outer -> the [NOT] EXISTS subquery';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where not exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where not exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca);


evaluate 'Case 5: IN / NOT IN on a small outer -> the [NOT] EXISTS subquery';
--@queryplan
select /*+ recompile */ count(*) from ta where ta.ca in (select tb.ca from tb, tc where tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where ta.ca in (select /*+ NO_UNNEST */ tb.ca from tb, tc where tb.cb = tc.ca);
--@queryplan
select /*+ recompile */ count(*) from ta where ta.ca not in (select tb.ca from tb, tc where tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where ta.ca not in (select /*+ NO_UNNEST */ tb.ca from tb, tc where tb.cb = tc.ca);


evaluate 'Case 6: IN dividing by a column the subquery WHERE keeps non-zero -> the EXISTS subquery';
--@queryplan
select /*+ recompile */ count(*) from tx where tx.ca in (select tm.ca / tm.cc from tm, tn where tm.cc <> 0 and tm.cb = tn.ca);
select /*+ recompile */ count(*) from tx where tx.ca in (select /*+ NO_UNNEST */ tm.ca / tm.cc from tm, tn where tm.cc <> 0 and tm.cb = tn.ca);


evaluate 'Case 7: EXISTS / NOT EXISTS whose two tables are joined to ta only -> the subquery';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tc.ca = ta.cb);
select /*+ recompile */ count(*) from ta where exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tc.ca = ta.cb);
--@queryplan
select /*+ recompile */ count(*) from ta where not exists (select 1 from tb, tc where tb.ca = ta.ca and tc.ca = ta.cb);
select /*+ recompile */ count(*) from ta where not exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tc.ca = ta.cb);


evaluate 'Case 8: EXISTS and NOT EXISTS in one query on a small outer -> each put back as its subquery';
--@queryplan
select /*+ recompile */ count(*) from ta where exists (select 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca) and not exists (select 1 from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);
select /*+ recompile */ count(*) from ta where exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.ca and tb.cb = tc.ca) and not exists (select /*+ NO_UNNEST */ 1 from tb, tc where tb.ca = ta.cb and tb.cb = tc.ca);


drop table tl, tm, tn, tx, tb, tc, ta;
