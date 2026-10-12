/*
 * This test case verifies CBRD-27404 : index scans and list (temp) scans that
 * feed the two inputs of a sort-merge join may run as parallel scans, while
 * the merge itself stays serial.
 *
 * Before: the parallel scan checker flagged every index-access and list spec
 * below a MERGELIST_PROC input with NO_PARALLEL_SCAN, so those input scans
 * always ran serially (heap inputs were never blocked).
 * Fix: the subtree block was removed. Each input is still materialized and
 * re-sorted on the join columns, so the scan order of an input cannot change
 * the merge result.
 *
 * Coverage
 *   Case 1: index inputs (covered index scan with a range on the join key)
 *           -> trace shows parallel workers under both index scans of the
 *              MERGELIST inputs; result equals the serial-scan merge and the
 *              per-key count truth
 *   Case 2: list inputs (GROUP BY derived tables materialized to temp lists)
 *           -> trace shows parallel workers under both temp scans of the
 *              MERGELIST inputs; result equals the hash join
 *   Case 3: index inputs on a nullable join key (NULLs must not join)
 *           -> result equals the serial-scan merge and the per-key count truth
 *
 * Sizing: the CTP server runs with test_mode=yes, which lowers
 * parallel_scan_page_threshold to 32 pages. That threshold is also the
 * server-side gate on the b-tree size for a parallel index scan and the page
 * gate for a parallel list scan. 40000 rows with 30000 distinct keys give
 * indexes of 37-41 pages; with fewer distinct keys the OIDs are deduplicated
 * and the index stays below the gate. The derived tables select the pad column
 * so their temp lists stay above 32 pages.
 *
 * NO_PARALLEL_SUBQUERY keeps the two merge inputs on the main thread. When
 * they are built concurrently, an input built by a subquery worker skips the
 * parallel scan whenever the leader happens to be inside a system operation
 * (for example while creating a temp file), so the trace would vary per run.
 */
drop table if exists mj;

create table mj (k int, kn int, g int, pad varchar(32));
insert into mj
select mod(rownum, 30000),
       case when mod(rownum, 101) = 0 then null else mod(rownum, 30000) end,
       mod(rownum * 7, 40000),
       md5(rownum)
from db_class a, db_class b, db_class c limit 40000;
create index i_mj_k on mj(k);
create index i_mj_kn on mj(kn);
update statistics on mj;

-- Case 1
set trace on;
select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*)
from mj a force index (i_mj_k), mj b force index (i_mj_k)
where a.k = b.k and a.k between 100 and 29900 and b.k between 100 and 29900;
show trace;
set trace off;

select case when p.c <=> s.c and p.s <=> s.s and p.c <=> n.c and p.s <=> n.s then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*) c, sum(cast(a.k as bigint) + b.k) s
      from mj a force index (i_mj_k), mj b force index (i_mj_k)
      where a.k = b.k and a.k between 100 and 29900 and b.k between 100 and 29900) p,
     (select /*+ USE_MERGE NO_PARALLEL_SCAN */ count(*) c, sum(cast(a.k as bigint) + b.k) s
      from mj a force index (i_mj_k), mj b force index (i_mj_k)
      where a.k = b.k and a.k between 100 and 29900 and b.k between 100 and 29900) s,
     (select sum(cast(c as bigint) * c) c, sum(cast(c as bigint) * c * 2 * k) s
      from (select k, count(*) c from mj where k between 100 and 29900 group by k) x) n;

-- Case 2
set trace on;
select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*), sum(length(d1.p) + length(d2.p))
from (select g, max(pad) p from mj where g < 20000 group by g) d1, (select g, min(pad) p from mj where g < 20000 group by g) d2
where d1.g = d2.g;
show trace;
set trace off;

select case when p.c <=> n.c and p.s <=> n.s then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*) c, sum(length(d1.p) + length(d2.p)) s
      from (select g, max(pad) p from mj where g < 20000 group by g) d1, (select g, min(pad) p from mj where g < 20000 group by g) d2
      where d1.g = d2.g) p,
     (select /*+ USE_HASH NO_PARALLEL_SCAN */ count(*) c, sum(length(d1.p) + length(d2.p)) s
      from (select g, max(pad) p from mj where g < 20000 group by g) d1, (select g, min(pad) p from mj where g < 20000 group by g) d2
      where d1.g = d2.g) n;

-- Case 3
select case when p.c <=> s.c and p.s <=> s.s and p.c <=> n.c and p.s <=> n.s then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*) c, sum(cast(a.kn as bigint) + b.kn) s
      from mj a force index (i_mj_kn), mj b force index (i_mj_kn)
      where a.kn = b.kn and a.kn between 100 and 29900 and b.kn between 100 and 29900) p,
     (select /*+ USE_MERGE NO_PARALLEL_SCAN */ count(*) c, sum(cast(a.kn as bigint) + b.kn) s
      from mj a force index (i_mj_kn), mj b force index (i_mj_kn)
      where a.kn = b.kn and a.kn between 100 and 29900 and b.kn between 100 and 29900) s,
     (select sum(cast(c as bigint) * c) c, sum(cast(c as bigint) * c * 2 * kn) s
      from (select kn, count(*) c from mj where kn between 100 and 29900 group by kn) x) n;

drop table mj;
