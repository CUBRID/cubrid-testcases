/**
 * This test case verifies CBRD-26571 : PK count optimization is not applied
 * from the second branch onward in a UNION / UNION ALL statement.
 *
 * Bug: count(*) on a table with a primary key is normally answered directly
 * from the PK B-tree statistics (trace shows "noscan ..., agl: pk_xxx_id")
 * instead of a full heap scan. In a UNION statement, this optimization was
 * only applied to the FIRST branch -- every branch from the second one
 * onward silently fell back to a full heap scan ("heap ..., readrows: N"),
 * because qexec_evaluate_aggregates_optimize() did not invalidate and
 * re-fetch the MVCC snapshot / btree stats when the snapshot was already
 * valid (which is always true by the time the second branch executes).
 *
 * Fix: invalidate mvccinfo.snapshot and re-run logtb_tran_find_btid_stats
 * before evaluating the optimization for each branch, then re-acquire the
 * MVCC snapshot.
 *
 * Note: table/column names use letters (ta/tb/tc/td/te), not digits,
 * because CTP masks digits in the trace output to '?' -- digit-named
 * objects (t1, t2, ...) would all collapse to "t?" and become
 * indistinguishable, same convention as CBRD-26522's cbrd_26522.sql.
 *
 * Coverage:
 *   Case 1: 2-way UNION ALL, count(*) on two PK tables
 *           -> both branches must show the PK count optimization (basic repro)
 *   Case 2: 3-way UNION ALL
 *           -> optimization must hold through the 3rd branch too, not just 1st/2nd
 *   Case 3: plain UNION (dedup)
 *           -> the fix must also apply when the set operator is UNION, not only UNION ALL
 *   Case 4: PK table branch mixed with a non-PK (heap-only) table branch
 *           -> only the PK branch is optimized; the non-PK branch is unaffected
 *              (no false-positive optimization introduced by the fix)
 *   Case 5: empty-table branch (0 rows)
 *           -> count(*) = 0 must still be optimized and return the correct value
 *   Case 6: the same table referenced twice in one UNION ALL (self-union)
 *           -> repeated invalidate/re-fetch of the same PK btree stats must still work
 *   Case 7: an optimizable branch (no WHERE) mixed with a non-optimizable branch
 *           (count(*) with a WHERE clause)
 *           -> each branch's eligibility must be judged independently; the fix
 *              must not force optimization onto a branch that legitimately needs a scan
 *   Case 8: DML immediately before the UNION count query
 *           -> since the fix re-acquires the MVCC snapshot, the optimized count
 *              must reflect the latest committed data, not a stale value
 *   Case 9: INTERSECT ALL / EXCEPT ALL (not just UNION)
 *           -> UNION, INTERSECT and EXCEPT all share the same XASL UNION proc
 *              internally; the fix must cover all three set operators, not only UNION
 *   Case 10: UNION ALL wrapped inside a subquery (not the top-level statement)
 *           -> the optimization must still apply per branch when the set operation
 *              is not the outermost statement
 *   Case 11: DML immediately before the UNION count, then ROLLBACK (not COMMIT)
 *           -> symmetric counterpart to Case 8: the re-acquired MVCC snapshot must
 *              reflect that the uncommitted change was rolled back, not the
 *              uncommitted (or stale) value
 */

drop table if exists ta, tb, tc, td, te;
create table ta (id int primary key, cola varchar(20));
create table tb (id int primary key, colb int);
create table tc (id int primary key);
create table td (id int, cold varchar(20));
create table te (id int primary key);

insert into ta values (1,'a'), (2,'b'), (3,'c'), (4,'d'), (5,'e');
insert into tb values (1,10), (2,20), (3,30);
insert into tc values (1), (2);
insert into td values (1,'x'), (2,'y'), (3,'z'), (4,'w');
commit;

set trace on;


evaluate 'Case 1: 2-way UNION ALL, count(*) on two PK tables -> both branches must be PK-count-optimized';
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 2: 3-way UNION ALL -> optimization must hold through the 3rd branch too';
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb union all select 'tc', count(*) from tc;
show trace;


evaluate 'Case 3: plain UNION (dedup) -> optimization must also apply for UNION, not only UNION ALL';
select /*+ recompile */ 'ta', count(*) from ta union select 'tb', count(*) from tb;
show trace;


evaluate 'Case 4: PK table branch mixed with non-PK (heap-only) table branch -> only the PK branch is optimized';
select /*+ recompile */ 'ta', count(*) from ta union all select 'td', count(*) from td;
show trace;


evaluate 'Case 5: empty-table branch (0 rows) -> count(*) = 0 must be optimized and correct';
select /*+ recompile */ 'te', count(*) from te union all select 'ta', count(*) from ta;
show trace;


evaluate 'Case 6: the same table referenced twice in one UNION ALL (self-union)';
select /*+ recompile */ 'ta-1', count(*) from ta union all select 'ta-2', count(*) from ta;
show trace;


evaluate 'Case 7: optimizable branch (no WHERE) mixed with non-optimizable branch (count(*) with WHERE)';
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb-filtered', count(*) from tb where id > 1 union all select 'tc', count(*) from tc;
show trace;


evaluate 'Case 8: DML immediately before the UNION count -> optimized result must reflect the latest committed data';
insert into tb values (100, 100);
commit;
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;
delete from tb where id = 100;
commit;


evaluate 'Case 9: INTERSECT ALL / EXCEPT ALL -> the fix must cover all set operators, not only UNION';
select /*+ recompile */ 'ta', count(*) from ta intersect all select 'tb', count(*) from tb;
show trace;
select /*+ recompile */ 'ta', count(*) from ta except all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 10: UNION ALL wrapped inside a subquery (not the top-level statement)';
select * from (select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb) x order by 1;
show trace;


evaluate 'Case 11: DML immediately before the UNION count, then ROLLBACK -> optimized result must reflect the rolled-back (original) data';
;autocommit off
insert into tb values (200, 200);
rollback;
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;
;autocommit on


drop table if exists ta, tb, tc, td, te;
