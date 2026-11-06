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
 * Note: table/column names use letters (ta/tb/tc/td/te/tf), not digits,
 * because CTP masks digits in the trace output to a single question mark --
 * digit-named objects (t1, t2, ...) would all collapse to t-question-mark
 * and become indistinguishable, same convention as cbrd_26522.sql (CBRD-26522).
 *
 * Isolation level: the optimization is gated by transaction isolation level
 * (see CBRD-26705) -- it only applies under READ COMMITTED. The session
 * isolation level is set explicitly right after setup so this file does not
 * depend on the CTP/broker default, and Case 12 exercises the gating itself.
 *
 * Result-order note: a plain UNION (dedup) does not guarantee row order, so
 * any case comparing a UNION (not UNION ALL) result against a fixed .answer
 * wraps the UNION in an outer query with an explicit order by (see Case 3)
 * to keep the comparison deterministic.
 *
 * Coverage:
 *   Case 1: 2-way UNION ALL, count(*) on two PK tables
 *           -> both branches must show the PK count optimization (basic repro)
 *   Case 2: 3-way UNION ALL
 *           -> optimization must hold through the 3rd branch too, not just 1st/2nd
 *   Case 3: plain UNION (dedup)
 *           -> the fix must also apply when the set operator is UNION, not only UNION ALL
 *   Case 4: PK table branch mixed with a non-PK (heap-only) table branch
 *           -> only the PK branch is optimized - the non-PK branch is unaffected
 *              (no false-positive optimization introduced by the fix)
 *   Case 5: empty-table branch (0 rows)
 *           -> count(*) = 0 must still be optimized and return the correct value
 *   Case 6: the same table referenced twice in one UNION ALL (self-union)
 *           -> repeated invalidate/re-fetch of the same PK btree stats must still work
 *   Case 7: an optimizable branch (no WHERE) mixed with a non-optimizable branch
 *           (count(*) with a WHERE clause)
 *           -> each branch eligibility must be judged independently - the fix
 *              must not force optimization onto a branch that legitimately needs a scan
 *   Case 8: DML immediately before the UNION count query
 *           -> since the fix re-acquires the MVCC snapshot, the optimized count
 *              must reflect the latest committed data, not a stale value
 *   Case 9: INTERSECT ALL / EXCEPT ALL (not just UNION), self-referential check
 *           -> UNION, INTERSECT and EXCEPT all share the same XASL UNION proc
 *              internally - the fix must cover all three set operators. Both
 *              branches use the same table and the same literal so a wrong
 *              count on either branch surfaces as a non-matching row instead
 *              of being masked by differing literals (see PR review comment)
 *   Case 10: UNION ALL wrapped inside a subquery (not the top-level statement)
 *           -> the optimization must still apply per branch when the set operation
 *              is not the outermost statement
 *   Case 11: DML immediately before the UNION count, then ROLLBACK (not COMMIT) -
 *           symmetric counterpart to Case 8, split into two checks because the
 *           fix re-reads global B-tree stats (a committed-data aggregate) and
 *           then applies a correction for the current transactions own
 *           uncommitted changes - checking only after rollback (as a single
 *           case) never exercises that correction step, since by then the
 *           stats and the actual data already agree again
 *   Case 11-1: query issued before the ROLLBACK, while the insert is still
 *           pending -> the optimized count must reflect that pending insert
 *   Case 11-2: query issued after the ROLLBACK
 *           -> the optimized count must return to the original data
 *   Case 12: transaction isolation level gating (CBRD-26705)
 *           -> REPEATABLE READ / SERIALIZABLE must turn the optimization off
 *              (heap scan), READ COMMITTED must turn it back on
 *   Case 13: same query shape executed with parallel(0) (serial execution path)
 *           -> the fix must not depend on the parallel-heap-scan execution path
 *   Case 14: two count(*) expressions in the same select list
 *           -> only one of them is expected to be optimized (COS_LOADED guard) -
 *              this records the actual behavior rather than assuming it
 *   Case 15: branch ordering and literal-less variants
 *           -> a non-optimizable branch placed FIRST must not block optimization
 *              of a later PK branch, and the fix must not depend on a literal
 *              being present in the select list
 *   Case 16: unique index but no primary key, split into two checks
 *   Case 16-1: no NULL keys present in the table
 *           -> records whether a unique-index-only branch is optimized the
 *              same way as a primary-key branch
 *   Case 16-2: same table with one NULL-key row inserted
 *           -> count(*) must still include the NULL row when the count is
 *              answered from index statistics rather than a heap scan
 *   Case 17: a partitioned PK table (2 range partitions) as the second
 *           branch of a UNION ALL
 *           -> the fix loops per aggregate over every B-tree it has already
 *              read stats for - every other branch in this file is a
 *              single unpartitioned table, so that loop always runs exactly
 *              once. A partitioned table is the practical way to force it
 *              to visit more than one B-tree for a single branch, and
 *              CBRD-26705s own regression history had 5 of its 8 cases on
 *              the partitioned-table path - this closes a real gap, not a
 *              hypothetical one
 *   Case 18: plan-cache reuse across transactions - every other case in
 *           this file uses recompile, so every execution builds a fresh
 *           plan. The state this fix touches (count_state, snapshot) is
 *           attached to the transaction, not the plan, so reusing a cached
 *           plan across two separate (autocommit) transactions is a
 *           distinct code path that recompile always skips
 *   Case 18-1: first execution, no hint -> populates the plan cache
 *   Case 18-2: the exact same statement text again
 *           -> served from the cached plan - both branches must still be
 *              optimized, not just the one from Case 18-1s own transaction
 */

drop table if exists ta, tb, tc, td, te, tf, tg;
create table ta (id int primary key, cola varchar(20));
create table tb (id int primary key, colb int);
create table tc (id int primary key);
create table td (id int, cold varchar(20));
create table te (id int primary key);
create table tf (id int, colf varchar(20));
create unique index idx_tf_id on tf(id);
create table tg (id int primary key, colg int)
partition by range (id) (
  partition p0 values less than (100),
  partition p1 values less than (200));

insert into ta values (1,'a'), (2,'b'), (3,'c'), (4,'d'), (5,'e');
insert into tb values (1,10), (2,20), (3,30);
insert into tc values (1), (2);
insert into td values (1,'x'), (2,'y'), (3,'z'), (4,'w');
insert into tf values (1,'a'), (2,'b'), (3,'c');
insert into tg values (1,1), (2,2), (101,101), (102,102), (103,103);
commit;

set transaction isolation level read committed;

set trace on;


evaluate 'Case 1: 2-way UNION ALL, count(*) on two PK tables -> both branches must be PK-count-optimized';
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 2: 3-way UNION ALL -> optimization must hold through the 3rd branch too';
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb union all select 'tc', count(*) from tc;
show trace;


evaluate 'Case 3: plain UNION (dedup) -> optimization must also apply for UNION, not only UNION ALL';
select * from (select /*+ recompile */ 'ta', count(*) from ta union select 'tb', count(*) from tb) x order by 1;
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


evaluate 'Case 9: INTERSECT ALL, same table/same literal -> a wrong count on either branch must surface as a non-matching row';
select /*+ recompile */ 'x', count(*) from tc intersect all select 'x', count(*) from tc;
show trace;


evaluate 'Case 9b: EXCEPT ALL, same table/same literal -> matching branches must yield an empty result';
select /*+ recompile */ 'x', count(*) from tc except all select 'x', count(*) from tc;
show trace;


evaluate 'Case 10: UNION ALL wrapped inside a subquery (not the top-level statement)';
select * from (select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb) x order by 1;
show trace;


evaluate 'Case 11-1: uncommitted DML must be visible to the optimized count';
autocommit off;
insert into tb values (200, 200);
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 11-2: after ROLLBACK -> the optimized count must return to the original data';
rollback;
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;
autocommit on;


evaluate 'Case 12-1: REPEATABLE READ -> the PK count optimization must be OFF (heap scan)';
set transaction isolation level repeatable read;
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 12-2: SERIALIZABLE -> the PK count optimization must be OFF (heap scan)';
set transaction isolation level serializable;
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 12-3: back to READ COMMITTED -> the optimization must come back on both branches';
set transaction isolation level read committed;
select /*+ recompile */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 13-1: serial execution, parallel(0) on the wrapped UNION ALL';
select /*+ recompile parallel(0) */ * from (select 'ta', count(*) from ta union all select 'tb', count(*) from tb) x order by 1;
show trace;


evaluate 'Case 13-2: serial execution, parallel(0) on the top-level UNION ALL';
select /*+ recompile parallel(0) */ 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 14: two count(*) in one select list -> records whether both, one, or neither are optimized';
select /*+ recompile */ 'ta', count(*), count(*) from ta union all select 'tb', count(*), count(*) from tb;
show trace;


evaluate 'Case 15-1: non-optimizable branch FIRST (no PK) -> the following PK branch must still be optimized';
select /*+ recompile */ 'td', count(*) from td union all select 'ta', count(*) from ta;
show trace;


evaluate 'Case 15-2: non-optimizable branch FIRST (WHERE clause) -> the following PK branch must still be optimized';
select /*+ recompile */ 'ta-filtered', count(*) from ta where id > 1 union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 15-3: same table, plain UNION, no literal in the select list';
select /*+ recompile */ count(*) from ta union select count(*) from ta;
show trace;


evaluate 'Case 15-4: no literal in the select list, control shape';
select /*+ recompile */ count(*) from ta union all select count(*) from tb order by 1;
show trace;


evaluate 'Case 16-1: unique index but no primary key -> records whether such a branch is optimized';
select /*+ recompile */ 'ta', count(*) from ta union all select 'tf', count(*) from tf;
show trace;


evaluate 'Case 16-2: unique-index-only table containing a NULL key -> count(*) must include the NULL row';
insert into tf values (null, 'd');
commit;
select /*+ recompile */ 'ta', count(*) from ta union all select 'tf', count(*) from tf;
show trace;


evaluate 'Case 17: partitioned PK table as the second branch of a UNION ALL';
select /*+ recompile */ 'ta', count(*) from ta union all select 'tg', count(*) from tg;
show trace;


evaluate 'Case 18-1: first execution, no recompile hint -> the plan gets cached';
select 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;


evaluate 'Case 18-2: identical statement text -> served from the plan cache, both branches must stay optimized';
select 'ta', count(*) from ta union all select 'tb', count(*) from tb;
show trace;

set transaction isolation level read committed;
set trace off;

drop table if exists ta, tb, tc, td, te, tf, tg;
