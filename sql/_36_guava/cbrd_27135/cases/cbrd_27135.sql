/*
 * This test case verifies CBRD-27135 : the parallel heap scan keeps its fast
 * "gather: mergeable list" path for queries that use ROWNUM.
 *
 * Before: any ROWNUM (inst_num) in the query blocked the mergeable list path,
 * so the heap scan was demoted to "gather: row by row".
 *
 * Fix (engine PR #7567): two ROWNUM forms are now accepted.
 *   - SELECT ROWNUM, ... (pass-through output column): workers leave the value
 *     empty and the main thread assigns 1..N when it merges the worker lists.
 *   - WHERE ROWNUM <= N / < N (single upper-bound term): workers draw global
 *     numbers from a shared atomic counter and stop once the quota is used.
 * Other uses (ROWNUM in an expression or a CASE condition, ORDER BY ... LIMIT,
 * GROUP BY or aggregates in the same block) stay off the mergeable list path.
 *
 * Existing coverage: cbrd_25447 Case 20 already pins "gather: mergeable list"
 * for count(*) over a NO_MERGE derived table with ROWNUM in its select list.
 * This case adds what that one does not check: the numbers really form 1..N,
 * the WHERE ROWNUM quota (also fractional bounds and partitions), and the
 * shapes that must stay blocked.
 *
 * Self-checking: value checks compare PARALLEL(8) with NO_PARALLEL_SCAN using
 * the null-safe <=> and emit PASS/FAIL. The mapping between rows and numbers
 * depends on worker scheduling and is never asserted, only that the k
 * qualifying rows get exactly 1..k. Every check runs under trace, because two
 * traps make a check pass while testing nothing:
 *   - a derived table without NO_MERGE is folded into the enclosing aggregate,
 *     and the aggregate rule blocks the fast path before the ROWNUM rule runs.
 *   - a ROWNUM that nobody reads is folded to the constant 1.
 * RECOMPILE keeps a cached plan from an earlier run out of the picture.
 *
 * Table sizing: three md5 strings per row (incompressible) put px_rn (20000
 * rows) at about 190 heap pages and each px_pt partition (10000 rows) at about
 * 95, all above the parallel scan threshold that the CTP test_mode=yes sets (32
 * pages). Every partition has to clear it on its own or it is scanned
 * serially. val = id % 1000.
 *
 * Coverage:
 *   Case 1:  SELECT ROWNUM, no qualifying row -> mergeable list
 *   Case 2:  20 qualifying rows spread over the workers -> numbers 1..20
 *   Case 3:  all rows: count/sum/min/max/count distinct of ROWNUM vs serial
 *   Case 4:  WHERE ROWNUM <= 5 -> numbers 1..5, mergeable list
 *   Case 5:  WHERE ROWNUM folded into an aggregate -> stays off, count exact
 *   Case 6:  fractional bounds (<= 0.6, < 1.4, <= 2.5) vs serial
 *   Case 7:  ROWNUM + 1 (expression) -> stays row by row, result vs serial
 *   Case 8:  ROWNUM in a CASE condition -> stays row by row, result vs serial
 *   Case 9:  ORDER BY ... LIMIT with ROWNUM -> stays blocked, count exact
 *   Case 10: GROUP BY with max(ROWNUM) -> stays blocked, totals vs serial
 *   Case 11: partitioned table -> numbers stay 1..N across partitions
 *   Case 12: partitioned table -> the WHERE ROWNUM quota is global
 */

drop table if exists px_rn;
create table px_rn (id int, val int, pad varchar(100));
insert into px_rn
select rownum, rownum % 1000, concat(md5(rownum), md5(rownum + 7919), md5(rownum * 31 + 7))
from db_class a, db_class b, db_class c, db_class d, db_class e limit 20000;

set trace on;

evaluate 'Case 1: SELECT ROWNUM with no qualifying row -> gather: mergeable list';
select /*+ recompile PARALLEL(8) */ rownum, id from px_rn where id > 20000;
show trace;

evaluate 'Case 2: 20 qualifying rows over all workers -> numbers 1..20';
select /*+ recompile PARALLEL(8) */ rownum from px_rn where val = 7 order by 1;
show trace;

evaluate 'Case 3: all rows, ROWNUM statistics vs serial';
select /*+ recompile */ case when p.c<=>s.c and p.sm<=>s.sm and p.mn<=>s.mn and p.mx<=>s.mx and p.dc<=>s.dc
            then 'PASS' else 'FAIL' end as result
from (select count(*) c, sum(rn) sm, min(rn) mn, max(rn) mx, count(distinct rn) dc
      from (select /*+ PARALLEL(8) NO_MERGE */ rownum rn, id from px_rn) t) p,
     (select count(*) c, sum(rn) sm, min(rn) mn, max(rn) mx, count(distinct rn) dc
      from (select /*+ NO_PARALLEL_SCAN NO_MERGE */ rownum rn, id from px_rn) t) s;
show trace;

evaluate 'Case 4: WHERE ROWNUM <= 5 -> numbers 1..5';
-- only rn is printed: which rows are drawn depends on the workers
select /*+ recompile */ rn
from (select /*+ PARALLEL(8) NO_MERGE */ rownum rn, id from px_rn where rownum <= 5) t order by rn;
show trace;

evaluate 'Case 5: WHERE ROWNUM folded into an aggregate -> not mergeable list, count exact';
select /*+ recompile */ case when (select count(*) from (select /*+ PARALLEL(8) */ id from px_rn where rownum <= 3) t) = 3
       then 'PASS' else 'FAIL' end as result;
show trace;

evaluate 'Case 6: fractional WHERE ROWNUM bounds vs serial';
select /*+ recompile */ case when p1.c<=>s1.c and p2.c<=>s2.c and p3.c<=>s3.c then 'PASS' else 'FAIL' end as result
from (select count(*) c from (select /*+ PARALLEL(8) NO_MERGE */ id from px_rn where rownum <= 0.6) t) p1,
     (select count(*) c from (select /*+ NO_PARALLEL_SCAN NO_MERGE */ id from px_rn where rownum <= 0.6) t) s1,
     (select count(*) c from (select /*+ PARALLEL(8) NO_MERGE */ id from px_rn where rownum < 1.4) t) p2,
     (select count(*) c from (select /*+ NO_PARALLEL_SCAN NO_MERGE */ id from px_rn where rownum < 1.4) t) s2,
     (select count(*) c from (select /*+ PARALLEL(8) NO_MERGE */ id from px_rn where rownum <= 2.5) t) p3,
     (select count(*) c from (select /*+ NO_PARALLEL_SCAN NO_MERGE */ id from px_rn where rownum <= 2.5) t) s3;
show trace;

evaluate 'Case 7: ROWNUM + 1 -> stays row by row, result vs serial';
select /*+ recompile */ case when p.c<=>s.c and p.mn<=>s.mn and p.mx<=>s.mx then 'PASS' else 'FAIL' end as result
from (select count(*) c, min(r) mn, max(r) mx
      from (select /*+ PARALLEL(8) NO_MERGE */ rownum + 1 r, id from px_rn) t) p,
     (select count(*) c, min(r) mn, max(r) mx
      from (select /*+ NO_PARALLEL_SCAN NO_MERGE */ rownum + 1 r, id from px_rn) t) s;
show trace;

evaluate 'Case 8: ROWNUM in a CASE condition -> stays row by row, result vs serial';
-- unblocked, every worker would tag its own first row as first
select /*+ recompile */ case when p.c<=>s.c and p.f<=>s.f then 'PASS' else 'FAIL' end as result
from (select count(*) c, sum(case tag when 'first' then 1 else 0 end) f
      from (select /*+ PARALLEL(8) NO_MERGE */ rownum rn, case when rownum = 1 then 'first' else 'other' end tag, id
            from px_rn) t) p,
     (select count(*) c, sum(case tag when 'first' then 1 else 0 end) f
      from (select /*+ NO_PARALLEL_SCAN NO_MERGE */ rownum rn, case when rownum = 1 then 'first' else 'other' end tag, id
            from px_rn) t) s;
show trace;

evaluate 'Case 9: ORDER BY ... LIMIT with ROWNUM -> stays blocked, count exact';
-- count(distinct rn) keeps ROWNUM referenced, otherwise it is folded to a constant
select /*+ recompile */ case when (select count(distinct rn)
                                   from (select /*+ PARALLEL(8) NO_MERGE */ rownum rn, id from px_rn order by id limit 3) t) = 3
       then 'PASS' else 'FAIL' end as result;
show trace;

evaluate 'Case 10: GROUP BY with max(ROWNUM) -> stays blocked, totals vs serial';
select /*+ recompile */ case when p.g<=>s.g and p.tot<=>s.tot and p.gmx<=>s.gmx then 'PASS' else 'FAIL' end as result
from (select count(*) g, sum(cnt) tot, max(mr) gmx
      from (select /*+ PARALLEL(8) */ val, count(*) cnt, max(rownum) mr from px_rn group by val) t) p,
     (select count(*) g, sum(cnt) tot, max(mr) gmx
      from (select /*+ NO_PARALLEL_SCAN */ val, count(*) cnt, max(rownum) mr from px_rn group by val) t) s;
show trace;

set trace off;

drop table if exists px_rn;

drop table if exists px_pt;
create table px_pt (id int, val int, pad varchar(100))
partition by range (id) (
  partition pa values less than (10001),
  partition pb values less than (20001)
);
insert into px_pt
select rownum, rownum % 1000, concat(md5(rownum), md5(rownum + 7919), md5(rownum * 31 + 7))
from db_class a, db_class b, db_class c, db_class d, db_class e limit 20000;

set trace on;

evaluate 'Case 11: partitioned table, numbers stay 1..N across partitions';
select /*+ recompile */ case when p.c<=>s.c and p.d<=>s.d and p.mn<=>s.mn and p.mx<=>s.mx then 'PASS' else 'FAIL' end as result
from (select count(*) c, count(distinct rn) d, min(rn) mn, max(rn) mx
      from (select /*+ PARALLEL(8) NO_MERGE */ rownum rn, id from px_pt) t) p,
     (select count(*) c, count(distinct rn) d, min(rn) mn, max(rn) mx
      from (select /*+ NO_PARALLEL_SCAN NO_MERGE */ rownum rn, id from px_pt) t) s;
show trace;

evaluate 'Case 12: partitioned table, the WHERE ROWNUM quota is global';
select /*+ recompile */ rn
from (select /*+ PARALLEL(8) NO_MERGE */ rownum rn, id from px_pt where rownum <= 5) t order by rn;
show trace;

set trace off;

drop table if exists px_pt;
