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
 *              MERGELIST inputs; key sum and the number of equal p values
 *              equal the hash join (g is a permutation, one row per g)
 *   Case 3: index inputs on a nullable join key; the key range of each input
 *           excludes the NULL keys
 *           -> trace shows parallel workers under both index scans of the
 *              MERGELIST inputs; result equals the serial-scan merge and the
 *              per-key count truth
 *   Case 4: list inputs grouped on the nullable key (kn < 30000 or NULL), so
 *           the NULL group enters both merge inputs and must not join
 *           -> trace shows parallel workers under both temp scans of the
 *              MERGELIST inputs; result equals the hash join and the count of
 *              distinct non-NULL keys
 *   Case 5: index inputs that are not covered (the sum reads g from the heap)
 *           -> trace shows parallel workers with a lookup under both index
 *              scans of the MERGELIST inputs; result equals the serial-scan
 *              merge and the hash join
 *
 * Sizing: the CTP server runs with test_mode=yes, which lowers
 * parallel_scan_page_threshold to 32 pages. That threshold is also the
 * server-side gate on the b-tree size for a parallel index scan and the page
 * gate for a parallel list scan. 120000 rows with 90000 distinct keys give
 * i_mj_k and i_mj_kn 113 and 109 pages; with fewer distinct keys the OIDs are
 * deduplicated and the index shrinks. The derived tables carry the pad column
 * and every comparison reads it, so it stays in their temp lists: a list
 * reaches 32 pages at about 11500 rows, so the Case 2 (40000 rows) and Case 4
 * (30001 rows) lists hold about 110 and 85 pages. The index gate counts the
 * whole b-tree, so the narrower key range of Case 5 only shortens its serial
 * lookups.
 *
 * NO_PARALLEL_SUBQUERY keeps the two merge inputs on the main thread, and in
 * the outer SELECT of each comparison it keeps the compared joins there too.
 * When they are built concurrently, an input built by a subquery worker skips
 * the parallel scan whenever the leader happens to be inside a system operation
 * (for example while creating a temp file), so the trace would vary per run.
 */
drop table if exists mj;

create table mj (k int, kn int, g int, pad varchar(32));
insert into mj
select mod(rownum, 90000),
       case when mod(rownum, 101) = 0 then null else mod(rownum, 90000) end,
       mod(rownum * 7, 120000),
       md5(rownum)
from db_class a, db_class b, db_class c limit 120000;
create index i_mj_k on mj(k);
create index i_mj_kn on mj(kn);
update statistics on mj;

-- Case 1
set trace on;
select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*)
from mj a force index (i_mj_k), mj b force index (i_mj_k)
where a.k = b.k and a.k between 300 and 89700 and b.k between 300 and 89700;
show trace;
set trace off;

select /*+ NO_PARALLEL_SUBQUERY */ case when p.c <=> s.c and p.s <=> s.s and p.c <=> n.c and p.s <=> n.s then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*) c, sum(cast(a.k as bigint) + b.k) s
      from mj a force index (i_mj_k), mj b force index (i_mj_k)
      where a.k = b.k and a.k between 300 and 89700 and b.k between 300 and 89700) p,
     (select /*+ USE_MERGE NO_PARALLEL_SCAN */ count(*) c, sum(cast(a.k as bigint) + b.k) s
      from mj a force index (i_mj_k), mj b force index (i_mj_k)
      where a.k = b.k and a.k between 300 and 89700 and b.k between 300 and 89700) s,
     (select sum(cast(c as bigint) * c) c, sum(cast(c as bigint) * c * 2 * k) s
      from (select k, count(*) c from mj where k between 300 and 89700 group by k) x) n;

-- Case 2
set trace on;
select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*), sum(cast(d1.g as bigint) + d2.g),
       count(case when d1.p = d2.p then 1 end)
from (select g, max(pad) p from mj where g < 40000 group by g) d1, (select g, min(pad) p from mj where g < 40000 group by g) d2
where d1.g = d2.g;
show trace;
set trace off;

select /*+ NO_PARALLEL_SUBQUERY */ case when p.c <=> n.c and p.s <=> n.s and p.e <=> n.e and p.e <=> p.c then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*) c, sum(cast(d1.g as bigint) + d2.g) s,
             count(case when d1.p = d2.p then 1 end) e
      from (select g, max(pad) p from mj where g < 40000 group by g) d1, (select g, min(pad) p from mj where g < 40000 group by g) d2
      where d1.g = d2.g) p,
     (select /*+ USE_HASH NO_PARALLEL_SCAN */ count(*) c, sum(cast(d1.g as bigint) + d2.g) s,
             count(case when d1.p = d2.p then 1 end) e
      from (select g, max(pad) p from mj where g < 40000 group by g) d1, (select g, min(pad) p from mj where g < 40000 group by g) d2
      where d1.g = d2.g) n;

-- Case 3
set trace on;
select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*)
from mj a force index (i_mj_kn), mj b force index (i_mj_kn)
where a.kn = b.kn and a.kn between 300 and 89700 and b.kn between 300 and 89700;
show trace;
set trace off;

select /*+ NO_PARALLEL_SUBQUERY */ case when p.c <=> s.c and p.s <=> s.s and p.c <=> n.c and p.s <=> n.s then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*) c, sum(cast(a.kn as bigint) + b.kn) s
      from mj a force index (i_mj_kn), mj b force index (i_mj_kn)
      where a.kn = b.kn and a.kn between 300 and 89700 and b.kn between 300 and 89700) p,
     (select /*+ USE_MERGE NO_PARALLEL_SCAN */ count(*) c, sum(cast(a.kn as bigint) + b.kn) s
      from mj a force index (i_mj_kn), mj b force index (i_mj_kn)
      where a.kn = b.kn and a.kn between 300 and 89700 and b.kn between 300 and 89700) s,
     (select sum(cast(c as bigint) * c) c, sum(cast(c as bigint) * c * 2 * kn) s
      from (select kn, count(*) c from mj where kn between 300 and 89700 group by kn) x) n;

-- Case 4
set trace on;
select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*), count(case when d1.p = d2.p then 1 end)
from (select kn, max(pad) p from mj where kn < 30000 or kn is null group by kn) d1, (select kn, min(pad) p from mj where kn < 30000 or kn is null group by kn) d2
where d1.kn = d2.kn;
show trace;
set trace off;

select /*+ NO_PARALLEL_SUBQUERY */ case when p.c <=> n.c and p.e <=> n.e and p.ks <=> n.ks
             and p.c <=> t.c and p.ks <=> t.ks and t.nul = 1 then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*) c, count(case when d1.p = d2.p then 1 end) e,
             sum(cast(d1.kn as bigint) + d2.kn) ks
      from (select kn, max(pad) p from mj where kn < 30000 or kn is null group by kn) d1, (select kn, min(pad) p from mj where kn < 30000 or kn is null group by kn) d2
      where d1.kn = d2.kn) p,
     (select /*+ USE_HASH NO_PARALLEL_SCAN */ count(*) c, count(case when d1.p = d2.p then 1 end) e,
             sum(cast(d1.kn as bigint) + d2.kn) ks
      from (select kn, max(pad) p from mj where kn < 30000 or kn is null group by kn) d1, (select kn, min(pad) p from mj where kn < 30000 or kn is null group by kn) d2
      where d1.kn = d2.kn) n,
     (select count(kn) c, sum(cast(kn as bigint) * 2) ks, count(*) - count(kn) nul
      from (select kn from mj where kn < 30000 or kn is null group by kn) x) t;

-- Case 5
set trace on;
select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*), sum(cast(a.g as bigint) + b.g)
from mj a force index (i_mj_k), mj b force index (i_mj_k)
where a.k = b.k and a.k between 300 and 10000 and b.k between 300 and 10000;
show trace;
set trace off;

select /*+ NO_PARALLEL_SUBQUERY */ case when p.c <=> s.c and p.s <=> s.s and p.c <=> n.c and p.s <=> n.s then 'PASS' else 'FAIL' end as result
from (select /*+ USE_MERGE PARALLEL(4) NO_PARALLEL_SUBQUERY */ count(*) c, sum(cast(a.g as bigint) + b.g) s
      from mj a force index (i_mj_k), mj b force index (i_mj_k)
      where a.k = b.k and a.k between 300 and 10000 and b.k between 300 and 10000) p,
     (select /*+ USE_MERGE NO_PARALLEL_SCAN */ count(*) c, sum(cast(a.g as bigint) + b.g) s
      from mj a force index (i_mj_k), mj b force index (i_mj_k)
      where a.k = b.k and a.k between 300 and 10000 and b.k between 300 and 10000) s,
     (select /*+ USE_HASH NO_PARALLEL_SCAN */ count(*) c, sum(cast(a.g as bigint) + b.g) s
      from mj a, mj b
      where a.k = b.k and a.k between 300 and 10000 and b.k between 300 and 10000) n;

drop table mj;
