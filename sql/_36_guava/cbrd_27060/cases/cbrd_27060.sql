/**
 * This test case verifies CBRD-27060: the parallel index scan accepts
 * filtered indexes (CREATE INDEX ... WHERE <filter>).
 *
 * Before: filtered indexes were excluded from the parallel index scan as a
 * precaution. The parallel scan walks the leaf slots itself instead of
 * calling btree_range_search, and after an UPDATE that moves a row out of the
 * filter, the old index entry stays until vacuum. If that entry were followed
 * to the newest heap version, a row violating the filter would leak into the
 * result. When WHERE is fully absorbed by the filter there is no residual
 * predicate left to catch it.
 *
 * Fix (engine PR #7467): the exclusion was removed. The leaf and overflow-OID
 * collectors check each entry MVCC info against the snapshot before the heap
 * is touched, the same way the serial scan does, so stale entries are dropped.
 * A WHERE that consists of the filter only produces a plan with no key range
 * at all. The parallel scan synthesizes a single unbounded range for it.
 *
 * Self-checking: each check compares PARALLEL(8) with NO_PARALLEL_SCAN over the
 * same filtered index and, where noted, with a heap scan (USING INDEX NONE),
 * using the null-safe <=> and emitting PASS/FAIL. Every filtered-index side is
 * pinned with "(+)". Without it the optimizer may pick a table scan and the
 * check would compare two table scans. The trace blocks pin the plan shape
 * (INDEX SCAN of the filtered index, parallel workers, gather type) in the
 * answer. Cases 17 and 24 print the values themselves, so they also fail when
 * the parallel, the serial and the heap side go wrong the same way.
 *
 * Stale entries: the filter-exit UPDATE and the checks after it run in one
 * open transaction (auto-commit disabled), so the old entries can never be
 * vacuumed during the checks and the stale-entry path is always taken.
 * The snapshot check drops an entry that this transaction deleted.
 *
 * Entering rows: Cases 18-24 run in a second open transaction, in which rows
 * that were outside the filter enter it. Their new index entries carry the
 * insert MVCCID of this transaction, and the snapshot check must keep them,
 * on the duplicate keys, whose OIDs already spill to overflow OID pages, and
 * on unique keys.
 *
 * Covering: a WHERE del = 0 needs del, so idx_flt (grp) never covers it and
 * every scan on it does a heap lookup. idx_flt_cov (grp, del) carries del in
 * the key and covers Case 2 / 10 / 19. A stale entry there still holds del = 0
 * in its key, so only the entry-level MVCC check can drop it.
 *
 * Coverage (no stale entries / after the filter-exit UPDATE):
 *   Case 1 / 9:   key range, WHERE absorbed by the filter, non-covering
 *   Case 2 / 10:  key range, covering (idx_flt_cov), also vs heap
 *   Case 3 / 11:  partial key range on a descending filtered index
 *   Case 4 / 12:  full range (no key range at all), vs serial and heap
 *   Case 5 / 13:  full range on the descending filtered index
 *   Case 6 / 14:  full range on the multi-column filtered index
 *   Case 7 / 15:  multi-column index, range on a nullable first column
 *   Case 8 / 16:  rows returned through a no_merge derived table, so the
 *                 parallel index scan is gathered as a mergeable list
 *                 instead of a buildvalue (Case 1-7 / 9-15)
 *   Case 17:      after the filter-exit UPDATE, the covering parallel scan
 *                 returns the rows left in the filter, a fixed count and sum
 * Coverage (rows entering the filter in an open transaction):
 *   Case 18:      key range on the overflow keys, non-covering, vs serial and heap
 *   Case 19:      key range on the overflow keys, covering, vs serial and heap
 *   Case 20:      full range, vs serial and heap
 *   Case 21:      full range on the descending filtered index, vs serial and heap
 *   Case 22:      multi-column index, range on a nullable first column
 *   Case 23:      rows through a derived table (mergeable list), key range on
 *                 the overflow keys, vs serial and heap
 *   Case 24:      the covering parallel scan returns the entered rows too,
 *                 a fixed count and sum
 * Plan checks: the Plan labels pin a parallel index scan of the filtered index
 * before and after each UPDATE, and the NO_PARALLEL_SCAN twin of one of them
 * shows no parallel workers line.
 *
 * Related TC: shell/_40_guava/cbrd_27060 in cubrid-testcases-private-ex covers
 * the entries that need a second open transaction, which this sql TC cannot
 * hold: entries deleted or inserted by another transaction in the snapshot, and
 * entries deleted by a transaction committed before the snapshot, not yet
 * vacuumed.
 */

drop table if exists ft;
-- 40,000 rows. grp = id % 3 for id <= 3000, else id: 3 keys with 1,000 entries each, whose OIDs spill to overflow OID pages (9 pages in total), and 37,000 unique keys
-- each grp index has about 50 pages (42 leaf pages), past the parallel_scan_page_threshold of 32 pages under the CTP test_mode=yes, so that PARALLEL(8) runs the index scan in parallel
-- grp2 = id % 15, NULL when id % 7 = 0: the nullable first column of the multi-column index
create table ft (id int primary key, grp int not null, grp2 int, del int);
insert into ft
select rownum, case when rownum <= 3000 then rownum % 3 else rownum end, case when rownum % 7 = 0 then null else rownum % 15 end, 0
from db_class a, db_class b, db_class c, db_class d, db_class e limit 40000;

create index idx_flt on ft (grp) where del = 0;
create index idx_flt_desc on ft (grp desc) where del = 0;
create index idx_flt_mc on ft (grp2, grp) where del = 0;
create index idx_flt_cov on ft (grp, del) where del = 0;
commit;

set trace on;

evaluate 'Plan: key range on the filtered index -> parallel index scan';
select /*+ recompile PARALLEL(8) */ count(*), sum(cast(id as bigint))
from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+);
show trace;

evaluate 'Plan: WHERE is the filter only -> parallel index scan with no key range';
select /*+ recompile PARALLEL(8) */ count(*), sum(cast(grp as bigint))
from ft where del = 0 using index idx_flt(+);
show trace;

evaluate 'Plan: descending filtered index, partial key range';
select /*+ recompile PARALLEL(8) */ count(*), sum(cast(id as bigint))
from ft where del = 0 and grp between 2 and 20000 using index idx_flt_desc(+);
show trace;

evaluate 'Plan: multi-column filtered index, range on the nullable first column';
select /*+ recompile PARALLEL(8) */ count(*), sum(cast(id as bigint))
from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+);
show trace;

evaluate 'Plan: rows returned through a derived table -> parallel index scan gathered as a mergeable list';
select /*+ recompile */ count(*), sum(cast(x as bigint))
from (select /*+ no_merge PARALLEL(8) */ id x from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) t;
show trace;

set trace off;

evaluate 'Case 1: key range, non-covering';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.s3<=>s.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) s;

evaluate 'Case 2: key range, covering, vs heap';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index none) h;

evaluate 'Case 3: partial key range, descending filtered index';
select case when p.c<=>s.c and p.s1<=>s.s1 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1
      from ft where del = 0 and grp between 2 and 20000 using index idx_flt_desc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where del = 0 and grp between 2 and 20000 using index idx_flt_desc(+)) s;

evaluate 'Case 4: full range, vs serial and heap';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index none) h;

evaluate 'Case 5: full range, descending filtered index';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_desc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_desc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c from ft where del = 0 using index none) h;

evaluate 'Case 6: full range, multi-column filtered index';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_mc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_mc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index none) h;

evaluate 'Case 7: multi-column filtered index, NULLs in the first key column';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.c<=>h.c and p.s1<=>h.s1 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index none) h;

evaluate 'Case 8: rows through a derived table (mergeable list), vs serial and heap';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.c<=>h.c and p.s1<=>h.s1 then 'PASS' else 'FAIL' end as result
from (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge PARALLEL(8) */ id x from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) t) p,
     (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge NO_PARALLEL_SCAN */ id x from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) t) s,
     (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge NO_PARALLEL_SCAN */ id x from ft where del = 0 and grp between 0 and 30000 using index none) t) h;

autocommit off;

-- 10% of the rows leave the filter. Their old entries stay in the index until this transaction ends
update ft set del = 1 where id % 10 = 3;

set trace on;

evaluate 'Plan after the UPDATE: full range on the filtered index is still a parallel index scan';
select /*+ recompile PARALLEL(8) */ count(*), sum(cast(grp as bigint))
from ft where del = 0 using index idx_flt(+);
show trace;

evaluate 'Plan after the UPDATE: key range on the covering filtered index is a covered parallel index scan';
select /*+ recompile PARALLEL(8) */ count(*), sum(cast(grp as bigint))
from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+);
show trace;

evaluate 'Plan after the UPDATE: rows through a derived table are still gathered as a mergeable list';
select /*+ recompile */ count(*), sum(cast(x as bigint))
from (select /*+ no_merge PARALLEL(8) */ id x from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) t;
show trace;

set trace off;

evaluate 'Case 9: key range, non-covering, after the UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.s3<=>s.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) s;

evaluate 'Case 10: key range, covering, vs heap, after the UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index none) h;

evaluate 'Case 11: partial key range, descending filtered index, after the UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1
      from ft where del = 0 and grp between 2 and 20000 using index idx_flt_desc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where del = 0 and grp between 2 and 20000 using index idx_flt_desc(+)) s;

evaluate 'Case 12: full range, vs serial and heap, after the UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index none) h;

evaluate 'Case 13: full range, descending filtered index, after the UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_desc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_desc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c from ft where del = 0 using index none) h;

evaluate 'Case 14: full range, multi-column filtered index, after the UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_mc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_mc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index none) h;

evaluate 'Case 15: multi-column filtered index, NULLs in the first key column, after the UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.c<=>h.c and p.s1<=>h.s1 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index none) h;

evaluate 'Case 16: rows through a derived table (mergeable list), vs serial and heap, after the UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.c<=>h.c and p.s1<=>h.s1 then 'PASS' else 'FAIL' end as result
from (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge PARALLEL(8) */ id x from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) t) p,
     (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge NO_PARALLEL_SCAN */ id x from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) t) s,
     (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge NO_PARALLEL_SCAN */ id x from ft where del = 0 and grp between 0 and 30000 using index none) t) h;

evaluate 'Case 17: covering parallel scan after the UPDATE returns only the rows left in the filter; result = 27000, 400971600';
select /*+ PARALLEL(8) */ count(*), sum(cast(grp as bigint))
from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+);

rollback;

-- 3,000 rows outside the filter (del = 1), so no filtered index holds them: 1,500 on the duplicate keys 0-2, whose OIDs already spill to overflow OID pages, and 1,500 on unique keys above 41,500
insert into ft
select 40000 + rownum, case when rownum <= 1500 then rownum % 3 else 40000 + rownum end, case when rownum % 7 = 0 then null else rownum % 15 end, 1
from db_class a, db_class b, db_class c, db_class d limit 3000;
commit;

-- half of them enter the filter. Their new entries carry the insert MVCCID of this transaction until the rollback below
update ft set del = 0 where id > 40000 and id % 2 = 0;

set trace on;

evaluate 'Plan after the filter-enter UPDATE: key range on the covering filtered index is a covered parallel index scan';
select /*+ recompile PARALLEL(8) */ count(*), sum(cast(grp as bigint))
from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+);
show trace;

evaluate 'Plan after the filter-enter UPDATE: its NO_PARALLEL_SCAN twin has no parallel workers line';
select /*+ recompile NO_PARALLEL_SCAN */ count(*), sum(cast(grp as bigint))
from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+);
show trace;

set trace off;

evaluate 'Case 18: key range on the overflow keys, non-covering, vs serial and heap, after the filter-enter UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.s3<=>s.s3 and p.c<=>h.c and p.s1<=>h.s1 and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index none) h;

evaluate 'Case 19: key range on the overflow keys, covering, vs serial and heap, after the filter-enter UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index none) h;

evaluate 'Case 20: full range, vs serial and heap, after the filter-enter UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index none) h;

evaluate 'Case 21: full range, descending filtered index, vs serial and heap, after the filter-enter UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_desc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_desc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index none) h;

evaluate 'Case 22: multi-column filtered index, NULLs in the first key column, after the filter-enter UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.c<=>h.c and p.s1<=>h.s1 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index none) h;

evaluate 'Case 23: rows through a derived table (mergeable list), vs serial and heap, after the filter-enter UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.c<=>h.c and p.s1<=>h.s1 then 'PASS' else 'FAIL' end as result
from (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge PARALLEL(8) */ id x from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) t) p,
     (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge NO_PARALLEL_SCAN */ id x from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) t) s,
     (select count(*) c, sum(cast(x as bigint)) s1
      from (select /*+ no_merge NO_PARALLEL_SCAN */ id x from ft where del = 0 and grp between 0 and 30000 using index none) t) h;

evaluate 'Case 24: covering parallel scan after the filter-enter UPDATE returns the entered rows too; result = 30750, 445517250';
select /*+ PARALLEL(8) */ count(*), sum(cast(grp as bigint))
from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+);

rollback;
autocommit on;

drop table if exists ft;
