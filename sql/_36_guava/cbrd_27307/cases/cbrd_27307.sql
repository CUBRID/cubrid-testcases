/**
 *  This test case verifies CBRD-27307: parallel range-partitioned sort-merge join.
 *
 *  An INNER sort-merge join (USE_MERGE, MERGELIST) used to merge its two sorted input
 *  lists in one thread. It now splits the key range of the sorted inputs into ranges
 *  and merges each range in a parallel worker (px_merge_join). The server parameter
 *  parallel_merge_join (hidden) is on by default. The PARALLEL hint is honored:
 *  PARALLEL(0) runs the merge serially and PARALLEL(n>=2) fixes the degree, but the
 *  hint cannot bypass the page threshold. Outer joins always use the serial merge.
 *
 *  Sizing: the parallel merge needs at least 1000 tuples in each sorted input list
 *  (MIN_TUPLES_PER_SIDE), and the larger list must reach the hash join page threshold,
 *  which the merge join shares. CTP runs with test_mode=yes, which lowers that
 *  threshold to its 2-page floor, so t1 (6000 rows) and t2 (4000 rows) are enough.
 *
 *  Output row order is not guaranteed under parallelism, so every check compares
 *  order-insensitive aggregates of the same join run as USE_MERGE and as USE_NL or
 *  USE_HASH (null-safe <=>), plus constant anchors, and emits PASS or FAIL. The traces
 *  show "parallel merge workers: ?" on MERGELIST only when the parallel merge ran.
 *
 *  Coverage:
 *    Case 1:  inner join on a unique key
 *    Case 2:  duplicate join keys on both sides (groups crossing range boundaries)
 *    Case 3:  NULL join keys on both sides (must not join)
 *    Case 4:  self-join, both inputs equally large
 *    Case 5:  LEFT OUTER join falls back to the serial merge
 *    Case 6:  PARALLEL(0) runs the merge serially
 *    Case 7:  PARALLEL(2) runs the parallel merge
 */

drop table if exists t1, t2;

create table t1 (id int primary key, k int, kn int);
insert into t1
select rownum, mod(rownum, 600), case when mod(rownum, 97) = 0 then null else rownum end
from db_class a, db_class b, db_class c limit 6000;
create index i_t1_k on t1 (k);
create index i_t1_kn on t1 (kn);

create table t2 (id int primary key, k int, kn int);
insert into t2
select rownum, mod(rownum, 400), case when mod(rownum, 97) = 0 then null else rownum end
from db_class a, db_class b, db_class c limit 4000;
create index i_t2_k on t2 (k);
create index i_t2_kn on t2 (kn);

update statistics on t1, t2;

-- Case 1: 4000 matched rows, sum(t1.id + t2.id) = 2 * sum(1..4000)
set trace on;
select /*+ USE_MERGE */ count(*) from t1, t2 where t1.id = t2.id;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c3 <=> n.c3
             and m.c0 <=> h.c0 and m.c1 <=> h.c1
             and m.c0 <=> 4000 and m.c1 <=> 16004000
       then 'PASS' else 'FAIL' end as case1_unique_key
from (select /*+ USE_MERGE */ count(*) c0, sum(t1.id + t2.id) c1, min(t1.id) c2, max(t2.id) c3
      from t1, t2 where t1.id = t2.id) m,
     (select /*+ USE_NL */ count(*) c0, sum(t1.id + t2.id) c1, min(t1.id) c2, max(t2.id) c3
      from t1, t2 where t1.id = t2.id) n,
     (select /*+ USE_HASH */ count(*) c0, sum(t1.id + t2.id) c1
      from t1, t2 where t1.id = t2.id) h;

-- Case 2: 10 rows per key on each side, 400 common keys -> 40000 rows
set trace on;
select /*+ USE_MERGE */ count(*) from t1, t2 where t1.k = t2.k;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c3 <=> n.c3 and m.c4 <=> n.c4
             and m.c0 <=> 40000 and m.c2 <=> 0 and m.c3 <=> 399
       then 'PASS' else 'FAIL' end as case2_duplicate_keys
from (select /*+ USE_MERGE */ count(*) c0, sum(t1.id) + sum(t2.id) c1, min(t1.k) c2, max(t2.k) c3,
             sum(cast(t1.id as bigint) * t2.id) c4
      from t1, t2 where t1.k = t2.k) m,
     (select /*+ USE_NL */ count(*) c0, sum(t1.id) + sum(t2.id) c1, min(t1.k) c2, max(t2.k) c3,
             sum(cast(t1.id as bigint) * t2.id) c4
      from t1, t2 where t1.k = t2.k) n;

-- Case 3: kn is NULL for multiples of 97 -> 4000 - 41 = 3959 rows
set trace on;
select /*+ USE_MERGE */ count(*) from t1, t2 where t1.kn = t2.kn;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c3 <=> n.c3
             and m.c0 <=> 3959
       then 'PASS' else 'FAIL' end as case3_null_keys
from (select /*+ USE_MERGE */ count(*) c0, sum(t1.kn + t2.kn) c1, min(t1.kn) c2, max(t2.kn) c3
      from t1, t2 where t1.kn = t2.kn) m,
     (select /*+ USE_NL */ count(*) c0, sum(t1.kn + t2.kn) c1, min(t1.kn) c2, max(t2.kn) c3
      from t1, t2 where t1.kn = t2.kn) n;

-- Case 4: 6000 rows, sum(a.id + b.id) = 2 * sum(1..6000)
set trace on;
select /*+ USE_MERGE */ count(*) from t1 a, t1 b where a.id = b.id;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c3 <=> n.c3
             and m.c0 <=> 6000 and m.c1 <=> 36006000
       then 'PASS' else 'FAIL' end as case4_self_join
from (select /*+ USE_MERGE */ count(*) c0, sum(a.id + b.id) c1, min(a.k) c2, max(b.kn) c3
      from t1 a, t1 b where a.id = b.id) m,
     (select /*+ USE_NL */ count(*) c0, sum(a.id + b.id) c1, min(a.k) c2, max(b.kn) c3
      from t1 a, t1 b where a.id = b.id) n;

-- Case 5: 6000 rows, 4000 of them with a t2 match; no parallel merge workers on MERGELIST
set trace on;
select /*+ USE_MERGE */ count(*), count(t2.id) from t1 left join t2 on t1.id = t2.id;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c3 <=> n.c3
             and m.c0 <=> 6000 and m.c1 <=> 4000
       then 'PASS' else 'FAIL' end as case5_left_outer
from (select /*+ USE_MERGE */ count(*) c0, count(t2.id) c1, sum(t2.id) c2, sum(t1.id) c3
      from t1 left join t2 on t1.id = t2.id) m,
     (select /*+ USE_NL */ count(*) c0, count(t2.id) c1, sum(t2.id) c2, sum(t1.id) c3
      from t1 left join t2 on t1.id = t2.id) n;

-- Case 6: PARALLEL(0); no parallel merge workers on MERGELIST
set trace on;
select /*+ USE_MERGE PARALLEL(0) */ count(*) from t1, t2 where t1.k = t2.k;
show trace;
set trace off;

select case when m.c0 <=> h.c0 and m.c1 <=> h.c1 and m.c2 <=> h.c2 and m.c0 <=> 40000
       then 'PASS' else 'FAIL' end as case6_parallel_0
from (select /*+ USE_MERGE PARALLEL(0) */ count(*) c0, sum(t1.id) + sum(t2.id) c1,
             sum(cast(t1.id as bigint) * t2.id) c2
      from t1, t2 where t1.k = t2.k) m,
     (select /*+ USE_HASH */ count(*) c0, sum(t1.id) + sum(t2.id) c1,
             sum(cast(t1.id as bigint) * t2.id) c2
      from t1, t2 where t1.k = t2.k) h;

-- Case 7: PARALLEL(2); parallel merge workers on MERGELIST
set trace on;
select /*+ USE_MERGE PARALLEL(2) */ count(*) from t1, t2 where t1.k = t2.k;
show trace;
set trace off;

select case when m.c0 <=> h.c0 and m.c1 <=> h.c1 and m.c2 <=> h.c2 and m.c0 <=> 40000
       then 'PASS' else 'FAIL' end as case7_parallel_2
from (select /*+ USE_MERGE PARALLEL(2) */ count(*) c0, sum(t1.id) + sum(t2.id) c1,
             sum(cast(t1.id as bigint) * t2.id) c2
      from t1, t2 where t1.k = t2.k) m,
     (select /*+ USE_HASH */ count(*) c0, sum(t1.id) + sum(t2.id) c1,
             sum(cast(t1.id as bigint) * t2.id) c2
      from t1, t2 where t1.k = t2.k) h;

drop table if exists t1, t2;
