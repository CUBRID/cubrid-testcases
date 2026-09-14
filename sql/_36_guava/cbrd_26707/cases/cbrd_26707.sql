/**
 *  This test case verifies CBRD-26707: Allow parallel heap scan::mergeable list
 *  when 'not exists' clause and filter subquery (follow-up of CBRD-25447).
 *
 *  Before the fix, a non-EXISTS if_pred or a regu-linked aptr subquery
 *  (IN / scalar subquery in WHERE) blocked parallel heap scan. The fix inspects
 *  the predicate and the aptr_list recursively and allows the mergeable-list
 *  optimization when no truly-unparallelizable element is present. The driving
 *  heap scan of the outer table then runs in parallel; "show trace" shows the
 *  (parallel workers ...) line and the "gather:" mode (mergeable list /
 *  buildvalue for count-only / row by row when topn prevents merging).
 *
 *  CTP runs SQL tests with test_mode=yes, which lowers parallel_scan_page_
 *  threshold to 32 (ta below is 4000 rows, well over 32 heap pages, so its heap
 *  scan is parallelized) and masks volatile trace values and identifier digits
 *  to '?'. Table/column names use letters (ta/tb, cola..) so they are not all
 *  collapsed to 't?'/'col?' by that masking.
 *
 *  Correctness: each parallel case is followed by the same query with the
 *  NO_PARALLEL_SCAN hint (serial); the two result blocks must match, proving the
 *  parallel mergeable-list/buildvalue gather returns no missing/duplicate rows.
 *
 *  Coverage (mirrors the developer's attached scenario, cbrd_26707.sql):
 *    Case 1-5:  NOT EXISTS / EXISTS correlated subquery in WHERE
 *    Case 6-8:  filter subquery (regu-linked aptr) with min / max / avg
 *    Case 9:    NOT IN + subquery
 *    Case 10-15: combined with GROUP BY / DISTINCT / ORDER BY+LIMIT / JOIN /
 *               UNION ALL / SELECT-list correlated subquery
 *    Case 16:   explicit PARALLEL(2) hint
 *    Case 17:   NO_PARALLEL_SCAN hint -> not parallelized
 *    Case 18:   NOT EXISTS on a partitioned table (parallelized on this build)
 *    Case 19:   INSERT ... SELECT + NOT EXISTS
 *    Case 20:   complex AND/OR predicate + NOT EXISTS
 *    Case 21-22: an unparallelizable element (stored procedure / session
 *               variable) inside a correlated subquery predicate -> the fix's
 *               recursive check still blocks parallel heap scan (NOT parallelized)
 *    Case 23:   SP inside a correlated scalar (regu-linked aptr) subquery
 *               predicate -> NOT parallelized (aptr branch; Case 6 is the control)
 *    Case 24:   SP inside a correlated IN-subquery predicate -> NOT parallelized
 *               (Case 29 is the same query without the SP -> parallel: the SP is the blocker)
 *    Case 25:   SP inside an UNcorrelated IN-subquery predicate -> parallel (the IN is unnested
 *               into a join); contrast Case 28 -> the block follows unnesting, not correlation
 *    Case 26:   NOT EXISTS mergeable list folded into per-column sums (no limit) -> full-row check
 *    Case 27:   trailing set-scan spec blocks list merge -> parallel heap scan (row by row)
 *    Case 28:   SP inside an UNcorrelated SCALAR subquery predicate -> NOT parallelized (a scalar
 *               subquery is not unnested, so the aptr remains and the SP still blocks)
 *    Case 29:   correlated IN-subquery without a blocking element -> parallel (buildvalue)
 */

drop table if exists ta, tb;

create table ta (id int, cola varchar(20), colb varchar(20), colc varchar(20), cold varchar(20));
insert into ta select rownum, lpad(rownum, 20, '0'), lpad(rownum % 5, 20, '0'), lpad(rownum, 20, '0'), lpad(rownum, 20, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e limit 4000;

create table tb (id int, cola varchar(20), colb varchar(20));
insert into tb select rownum, lpad(rownum, 20, '0'), lpad(rownum % 10, 20, '0')
from db_class a, db_class b, db_class c, db_class d limit 500;

create or replace function sp_f(n integer) return integer deterministic is
begin
    return n + 1;
end;

set trace on;


evaluate 'Case 1: NOT EXISTS + correlated subquery -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a where not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001');
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile no_parallel_scan */ count(*) from ta a where not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001');
show trace;


evaluate 'Case 2: EXISTS + correlated subquery -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a where exists (select 1 from tb b where b.id = a.id);
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a where exists (select 1 from tb b where b.id = a.id);
show trace;


evaluate 'Case 3: NOT EXISTS + column output -> parallel heap scan (mergeable list)';
select /*+ recompile */ * from (select /*+ NO_MERGE */ cola, colb from ta a where not exists (select 1 from tb b where b.id = a.id)) order by 1 limit 3;
show trace;
-- serial reference
select /*+ recompile */ * from (select /*+ NO_MERGE no_parallel_scan */ cola, colb from ta a where not exists (select 1 from tb b where b.id = a.id)) order by 1 limit 3;
show trace;


evaluate 'Case 4: NOT EXISTS + extra WHERE condition -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a where a.cola like '%1' and not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001');
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a where a.cola like '%1' and not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001');
show trace;


evaluate 'Case 5: multiple NOT EXISTS -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a
where not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001')
  and not exists (select 1 from tb c where c.id = a.id and c.colb = '00000000000000000002');
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a
where not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001')
  and not exists (select 1 from tb c where c.id = a.id and c.colb = '00000000000000000002');
show trace;


evaluate 'Case 6: filter subquery + min() compare -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a where a.cola >= (select min(b.cola) from tb b where b.id = a.id);
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a where a.cola >= (select min(b.cola) from tb b where b.id = a.id);
show trace;


evaluate 'Case 7: filter subquery + max() compare + column output -> parallel heap scan (mergeable list)';
select /*+ recompile */ * from (select /*+ NO_MERGE */ cola, colb from ta a where a.colb = (select max(b.colb) from tb b where b.id = a.id)) order by 1 limit 3;
show trace;
-- serial reference
select /*+ recompile */ * from (select /*+ NO_MERGE no_parallel_scan */ cola, colb from ta a where a.colb = (select max(b.colb) from tb b where b.id = a.id)) order by 1 limit 3;
show trace;


evaluate 'Case 8: filter subquery + avg() compare -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a where a.id > (select avg(b.id) from tb b where b.colb = a.colb);
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a where a.id > (select avg(b.id) from tb b where b.colb = a.colb);
show trace;


evaluate 'Case 9: NOT IN + subquery -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a where a.id not in (select b.id from tb b where b.colb = '00000000000000000001');
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a where a.id not in (select b.id from tb b where b.colb = '00000000000000000001');
show trace;


evaluate 'Case 10: NOT EXISTS + GROUP BY -> parallel heap scan (mergeable list)';
select /*+ recompile */ colb, count(*) from ta a where not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001') group by colb order by 1 limit 3;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ colb, count(*) from ta a where not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001') group by colb order by 1 limit 3;
show trace;


evaluate 'Case 11: NOT EXISTS + DISTINCT -> parallel heap scan (mergeable list)';
select /*+ recompile */ distinct colb from ta a where not exists (select 1 from tb b where b.id = a.id) order by 1 limit 3;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ distinct colb from ta a where not exists (select 1 from tb b where b.id = a.id) order by 1 limit 3;
show trace;


evaluate 'Case 12: NOT EXISTS + ORDER BY + LIMIT -> parallel heap scan (mergeable list)';
select /*+ recompile */ cola from ta a where not exists (select 1 from tb b where b.id = a.id) order by cola limit 3;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ cola from ta a where not exists (select 1 from tb b where b.id = a.id) order by cola limit 3;
show trace;


evaluate 'Case 13: NOT EXISTS + JOIN -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a join tb b on a.id = b.id where not exists (select 1 from tb c where c.id = a.id and c.colb = '00000000000000000001');
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a join tb b on a.id = b.id where not exists (select 1 from tb c where c.id = a.id and c.colb = '00000000000000000001');
show trace;


evaluate 'Case 14: NOT EXISTS + UNION ALL -> parallel heap scan (buildvalue, both sides)';
select /*+ recompile */ count(*) from ta a where not exists (select 1 from tb b where b.id = a.id)
union all
select /*+ recompile */ count(*) from ta a where exists (select 1 from tb b where b.id = a.id);
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a where not exists (select 1 from tb b where b.id = a.id)
union all
select /*+ recompile no_parallel_scan */ count(*) from ta a where exists (select 1 from tb b where b.id = a.id);
show trace;


evaluate 'Case 15: SELECT-list correlated subquery + WHERE NOT EXISTS -> parallel heap scan (mergeable list)';
select /*+ recompile */ * from (select /*+ NO_MERGE */ a.cola, (select count(*) from tb b where b.id = a.id) as cnt
from ta a where not exists (select 1 from tb c where c.id = a.id and c.colb = '00000000000000000001')) order by 1 limit 3;
show trace;
-- serial reference
select /*+ recompile */ * from (select /*+ NO_MERGE no_parallel_scan */ a.cola, (select count(*) from tb b where b.id = a.id) as cnt
from ta a where not exists (select 1 from tb c where c.id = a.id and c.colb = '00000000000000000001')) order by 1 limit 3;
show trace;


evaluate 'Case 16: NOT EXISTS + PARALLEL(2) hint -> parallel heap scan (buildvalue)';
select /*+ recompile PARALLEL(2) */ count(*) from ta a where not exists (select 1 from tb b where b.id = a.id);
show trace;
-- serial reference: Case 17 runs the identical query with NO_PARALLEL_SCAN


evaluate 'Case 17: NOT EXISTS + NO_PARALLEL_SCAN hint -> not parallelized';
select /*+ recompile NO_PARALLEL_SCAN */ count(*) from ta a where not exists (select 1 from tb b where b.id = a.id);
show trace;


evaluate 'Case 18: NOT EXISTS + partitioned table -> parallel heap scan (buildvalue)';
drop table if exists pl;
create table pl (id int, cola varchar(20), colb int)
PARTITION BY RANGE (colb) (
  PARTITION pa VALUES LESS THAN (5),
  PARTITION pb VALUES LESS THAN (10),
  PARTITION pc VALUES LESS THAN MAXVALUE
);
insert into pl select rownum, lpad(rownum, 20, '0'), rownum % 15
from db_class a, db_class b, db_class c, db_class d limit 40000;
select /*+ recompile PARALLEL(2) */ count(*) from pl a where not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001');
show trace;
-- serial oracle: the count must match the parallel result above
select /*+ recompile no_parallel_scan */ count(*) from pl a where not exists (select 1 from tb b where b.id = a.id and b.colb = '00000000000000000001');
show trace;
drop table if exists pl;


evaluate 'Case 19: INSERT ... SELECT + NOT EXISTS -> parallel heap scan (mergeable list)';
drop table if exists rt;
create table rt (id int, cola varchar(20), colb varchar(20), colc varchar(20), cold varchar(20));
insert into rt select /*+ recompile */ * from ta a where not exists (select 1 from tb b where b.id = a.id) order by id;
show trace;
-- verify the parallel insert produced the same rows an independent serial scan would:
-- per-column sums (not just the row count) must equal the serial NOT EXISTS aggregate, so a value
-- dropped, duplicated, or corrupted by the parallel gather is caught -- not only a lost row.
select count(*), sum(id), sum(cast(cola as bigint)), sum(cast(colb as int)), sum(cast(cold as bigint)) from rt;
select /*+ recompile no_parallel_scan */ count(*), sum(a.id), sum(cast(a.cola as bigint)), sum(cast(a.colb as int)), sum(cast(a.cold as bigint)) from ta a where not exists (select 1 from tb b where b.id = a.id);
show trace;
drop table if exists rt;


evaluate 'Case 20: complex AND/OR predicate + NOT EXISTS -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*) from ta a where (a.cola like '%1' or a.colb like '%2') and not exists (select 1 from tb b where b.id = a.id);
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*) from ta a where (a.cola like '%1' or a.colb like '%2') and not exists (select 1 from tb b where b.id = a.id);
show trace;


evaluate 'Case 21: stored procedure in a correlated subquery predicate -> NOT parallelized';
-- the fix recursively inspects the predicate; an SP makes the driving heap scan
-- non-parallelizable, so parallel heap scan must be blocked (no parallel workers).
select /*+ recompile */ count(*) from ta a where not exists (select 1 from tb b where b.id = a.id and sp_f(b.id) > 0);
show trace;


evaluate 'Case 22: session variable in a correlated subquery predicate -> NOT parallelized';
-- a session-variable assignment in the correlated predicate likewise blocks the
-- parallel heap scan on the driving table.
select /*+ recompile */ count(*) from ta a where not exists (select 1 from tb b where b.id = a.id and (@v:=b.id) is not null);
show trace;


evaluate 'Case 23: SP in a correlated scalar subquery predicate (aptr branch) -> NOT parallelized';
-- the SP sits in the inner WHERE of a correlated scalar (regu-linked aptr) subquery, so the
-- fix's sibling_check propagates CANNOT_PARALLEL to the driving heap scan. Case 6 is the same
-- correlated scalar subquery without the SP and DOES parallelize -> positive control.
select /*+ recompile */ count(*) from ta a where a.cola >= (select min(b.cola) from tb b where b.id = a.id and sp_f(b.id) > 0);
show trace;


evaluate 'Case 24: SP in a correlated IN-subquery predicate -> NOT parallelized';
-- correlated IN is not unnested, so the SP in its predicate blocks the driving heap scan.
-- Case 29 is the same query without the SP and DOES parallelize -> the SP is the blocker.
select /*+ recompile */ count(*) from ta a where a.id in (select b.id from tb b where b.colb = a.colb and sp_f(b.id) > 0);
show trace;


evaluate 'Case 25: SP in an uncorrelated IN-subquery predicate -> parallel heap scan (buildvalue)';
-- identical SP-in-predicate as Case 24 but uncorrelated: the optimizer unnests the uncorrelated
-- IN into a join with a derived table (see the rewritten query in the answer), so no regu-linked
-- aptr subquery remains and the driving heap scan parallelizes. Contrast Case 28 (uncorrelated
-- SCALAR + SP), which is NOT unnested and is blocked -> the block follows unnesting, not correlation.
select /*+ recompile */ count(*) from ta a where a.id in (select b.id from tb b where sp_f(b.id) > 0);
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile no_parallel_scan */ count(*) from ta a where a.id in (select b.id from tb b where sp_f(b.id) > 0);
show trace;


evaluate 'Case 26: NOT EXISTS + mergeable list folded into per-column sums (no limit) -> parallel heap scan (mergeable list)';
-- cases 3/7/11/12/15 all carry "limit 3" and case 19 checks only the row count, so a row lost or
-- corrupted in the middle/tail of the gather is invisible. here the whole 3500-row mergeable gather
-- is folded into per-column sums, which change if any single gathered value is wrong.
select /*+ recompile */ count(*), sum(cast(cola as bigint)), sum(cast(colb as int)), sum(cast(colc as bigint)), sum(cast(cold as bigint))
from (select /*+ NO_MERGE */ cola, colb, colc, cold from ta a where not exists (select 1 from tb b where b.id = a.id));
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile */ count(*), sum(cast(cola as bigint)), sum(cast(colb as int)), sum(cast(colc as bigint)), sum(cast(cold as bigint))
from (select /*+ NO_MERGE no_parallel_scan */ cola, colb, colc, cold from ta a where not exists (select 1 from tb b where b.id = a.id));
show trace;


evaluate 'Case 27: NOT EXISTS + trailing set-scan spec -> parallel heap scan (row by row)';
-- the driving heap scan of ta still parallelizes, but the trailing set spec (table({..})) blocks
-- list merging, so only CANNOT_LIST_MERGE is raised and the gather falls back to "row by row" --
-- the intermediate mode between parallel+merged (cases 1-20) and parallel-blocked (cases 21-24).
select /*+ recompile ordered */ a.id, tset.v
from ta a, table({1, 2, 3}) as tset(v)
where not exists (select 1 from tb b where b.id = a.id) and cast(a.cola as int) < 503
order by 1, 2;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ a.id, tset.v
from ta a, table({1, 2, 3}) as tset(v)
where not exists (select 1 from tb b where b.id = a.id) and cast(a.cola as int) < 503
order by 1, 2;
show trace;


evaluate 'Case 28: SP in an uncorrelated scalar subquery predicate -> NOT parallelized';
-- a scalar subquery is NOT unnested into a join, so it stays a regu-linked aptr even when
-- uncorrelated; the SP in its predicate therefore still blocks the driving heap scan. Contrast
-- Case 25 (uncorrelated IN + SP), which IS unnested and parallelizes.
select /*+ recompile */ count(*) from ta a where a.cola >= (select min(b.cola) from tb b where sp_f(b.id) > 0);
show trace;
-- positive control: the same uncorrelated scalar subquery without the SP parallelizes,
-- proving the SP -- not the uncorrelated-scalar shape -- is what blocks the case above.
select /*+ recompile */ count(*) from ta a where a.cola >= (select min(b.cola) from tb b);
show trace;


evaluate 'Case 29: correlated IN-subquery without a blocking element -> parallel heap scan (buildvalue)';
-- the acceptance criteria names IN (subquery) explicitly, but case 9 is NOT IN and cases 24/25
-- both carry an SP. this is Case 24 with the SP removed: it parallelizes, which covers the plain-IN
-- acceptance criterion and confirms the SP is what blocks Case 24.
select /*+ recompile */ count(*) from ta a where a.id in (select b.id from tb b where b.colb = a.colb);
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile no_parallel_scan */ count(*) from ta a where a.id in (select b.id from tb b where b.colb = a.colb);
show trace;


set trace off;

drop function sp_f;
drop table if exists ta, tb;
