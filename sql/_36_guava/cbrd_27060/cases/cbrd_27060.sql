/*
 * This test case verifies CBRD-27060 : the parallel index scan accepts
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
 * (INDEX SCAN of the filtered index, parallel workers) in the answer.
 *
 * Stale entries: the filter-exit UPDATE and the checks after it run in one
 * open transaction (autocommit off), so the old entries can never be
 * vacuumed during the checks and the stale-entry path is always taken.
 *
 * Table sizing: the PARALLEL(N) hint only bypasses the optimizer estimate.
 * The server still runs the index scan serially unless the b-tree has at least
 * parallel_scan_page_threshold user pages (32 under the CTP test_mode=yes).
 * grp mixes 3 keys with 1000 entries each (their OIDs spill to overflow OID
 * pages, 9 pages in total) and 37000 unique keys, so each grp index has about
 * 50 pages (42 leaf pages) to split across workers:
 * grp = id % 3 for id <= 3000, else id.
 * grp2 = id % 15, NULL when id % 7 = 0 (nullable first column of the
 * multi-column index).
 *
 * Covering: a WHERE del = 0 needs del, so idx_flt (grp) never covers it and
 * every scan on it does a heap lookup. idx_flt_cov (grp, del) carries del in
 * the key and covers Case 2 / 9. A stale entry there still holds del = 0 in
 * its key, so only the entry-level MVCC check can drop it.
 *
 * Coverage (no stale entries / after the filter-exit UPDATE):
 *   Case 1 / 8:   key range, WHERE absorbed by the filter, non-covering
 *   Case 2 / 9:   key range, covering (idx_flt_cov), also vs heap
 *   Case 3 / 10:  partial key range on a descending filtered index
 *   Case 4 / 11:  full range (no key range at all), vs serial and heap
 *   Case 5 / 12:  full range on the descending filtered index
 *   Case 6 / 13:  full range on the multi-column filtered index
 *   Case 7 / 14:  multi-column index, range on a nullable first column
 */

drop table if exists ft;
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

evaluate 'Case 4: full range, covering, vs serial and heap';
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

set trace off;

evaluate 'Case 8: key range, non-covering, after the UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.s3<=>s.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt(+)) s;

evaluate 'Case 9: key range, covering, vs heap, after the UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index idx_flt_cov(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3
      from ft where del = 0 and grp between 0 and 30000 using index none) h;

evaluate 'Case 10: partial key range, descending filtered index, after the UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1
      from ft where del = 0 and grp between 2 and 20000 using index idx_flt_desc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where del = 0 and grp between 2 and 20000 using index idx_flt_desc(+)) s;

evaluate 'Case 11: full range, covering, vs serial and heap, after the UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index none) h;

evaluate 'Case 12: full range, descending filtered index, after the UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_desc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_desc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c from ft where del = 0 using index none) h;

evaluate 'Case 13: full range, multi-column filtered index, after the UPDATE';
select case when p.c<=>s.c and p.s3<=>s.s3 and p.c<=>h.c and p.s3<=>h.s3 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_mc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index idx_flt_mc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(grp as bigint)) s3 from ft where del = 0 using index none) h;

evaluate 'Case 14: multi-column filtered index, NULLs in the first key column, after the UPDATE';
select case when p.c<=>s.c and p.s1<=>s.s1 and p.c<=>h.c and p.s1<=>h.s1 then 'PASS' else 'FAIL' end as result
from (select /*+ PARALLEL(8) */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+)) p,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index idx_flt_mc(+)) s,
     (select /*+ NO_PARALLEL_SCAN */ count(*) c, sum(cast(id as bigint)) s1
      from ft where grp2 <= 7 and del = 0 using index none) h;

rollback;
autocommit on;

drop table if exists ft;
