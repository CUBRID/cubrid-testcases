/**
 *  This test case verifies CBRD-27307: parallel range-partitioned sort-merge join.
 *
 *  An INNER sort-merge join (USE_MERGE, MERGELIST) used to merge its two sorted input
 *  lists in one thread. It now splits the key range of the sorted inputs into ranges
 *  and merges each range in a parallel worker (px_merge_join). The server parameter
 *  parallel_merge_join (hidden) is on by default. The PARALLEL hint is honored:
 *  PARALLEL(0) runs the merge serially and PARALLEL(n>=2) fixes the degree, but the
 *  hint cannot bypass the page threshold. Outer joins and key pairs of different types
 *  (except CHAR/VARCHAR) always use the serial merge.
 *
 *  Sizing: the parallel merge needs at least 1000 tuples in each sorted input list
 *  (MIN_TUPLES_PER_SIDE), and the larger list must reach the hash join page threshold,
 *  which the merge join shares. CTP runs with test_mode=yes, which lowers that
 *  threshold to its 2-page floor, so t1 (6000 rows) and t2 (4000 rows) are enough.
 *  The tables of Cases 9 to 12 are filled from t1 and t2 and keep at least 2000 rows.
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
 *    Case 8:  a merge join under an index join follows the PARALLEL hint
 *             (PARALLEL(0) serial, PARALLEL(2) parallel)
 *    Case 9:  two-column key with NULLs in the second column, inside each first-column group
 *             and filling the whole first group (range 0 skips its unbound-key prefix)
 *    Case 10: VARCHAR = CHAR(10) keys mixing '', ' ' and trailing-space values
 *    Case 11: INT = BIGINT keys fall back to the serial merge
 *    Case 12: the first range has no matching keys on the smaller side
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

-- Case 8: merge join as the outer of an index join; PARALLEL(0) has no parallel merge workers, PARALLEL(2) has them
set trace on;
select /*+ ORDERED USE_MERGE(b) USE_IDX(c) PARALLEL(0) */ count(*) from t1 a, t2 b, t1 c where a.k = b.k and b.id = c.id;
show trace;
select /*+ ORDERED USE_MERGE(b) USE_IDX(c) PARALLEL(2) */ count(*) from t1 a, t2 b, t1 c where a.k = b.k and b.id = c.id;
show trace;
set trace off;

select case when m0.c0 <=> h.c0 and m0.c1 <=> h.c1 and m0.c2 <=> h.c2
             and m2.c0 <=> h.c0 and m2.c1 <=> h.c1 and m2.c2 <=> h.c2 and h.c0 <=> 40000
       then 'PASS' else 'FAIL' end as case8_nested_parallel_hint
from (select /*+ ORDERED USE_MERGE(b) USE_IDX(c) PARALLEL(0) */ count(*) c0, sum(a.id) + sum(b.id) c1,
             sum(cast(a.id as bigint) * c.id) c2
      from t1 a, t2 b, t1 c where a.k = b.k and b.id = c.id) m0,
     (select /*+ ORDERED USE_MERGE(b) USE_IDX(c) PARALLEL(2) */ count(*) c0, sum(a.id) + sum(b.id) c1,
             sum(cast(a.id as bigint) * c.id) c2
      from t1 a, t2 b, t1 c where a.k = b.k and b.id = c.id) m2,
     (select /*+ USE_HASH */ count(*) c0, sum(a.id) + sum(b.id) c1,
             sum(cast(a.id as bigint) * c.id) c2
      from t1 a, t2 b, t1 c where a.k = b.k and b.id = c.id) h;

-- Case 9: two-column key (k, kn); kn is NULL for k = 0 and for every 7th / 11th row, so the (k, NULL) tuples sort inside each k group
drop table if exists mj_ca, mj_cb;
create table mj_ca (id int primary key, k int, kn int);
insert into mj_ca
select id, mod(id, 8), case when mod(id, 8) = 0 or mod(id, 7) = 0 then null else mod(id, 300) end from t1;
create index i_mj_ca on mj_ca (k, kn);

create table mj_cb (id int primary key, k int, kn int);
insert into mj_cb
select id, mod(id, 8), case when mod(id, 8) = 0 or mod(id, 11) = 0 then null else mod(id, 300) end from t2;
create index i_mj_cb on mj_cb (k, kn);

update statistics on mj_ca, mj_cb;

set trace on;
select /*+ USE_MERGE */ count(*) from mj_ca a, mj_cb b where a.k = b.k and a.kn = b.kn;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c3 <=> n.c3
             and m.c0 <=> h.c0 and m.c1 <=> h.c1 and m.c2 <=> h.c2
             and m.c0 <=> 27276 and m.c3 <=> 1
       then 'PASS' else 'FAIL' end as case9_composite_null_keys
from (select /*+ USE_MERGE */ count(*) c0, sum(a.id + b.id) c1, sum(cast(a.id as bigint) * b.id) c2, min(a.k) c3
      from mj_ca a, mj_cb b where a.k = b.k and a.kn = b.kn) m,
     (select /*+ USE_NL */ count(*) c0, sum(a.id + b.id) c1, sum(cast(a.id as bigint) * b.id) c2, min(a.k) c3
      from mj_ca a, mj_cb b where a.k = b.k and a.kn = b.kn) n,
     (select /*+ USE_HASH */ count(*) c0, sum(a.id + b.id) c1, sum(cast(a.id as bigint) * b.id) c2
      from mj_ca a, mj_cb b where a.k = b.k and a.kn = b.kn) h;

-- Case 10: VARCHAR = CHAR(10); only VARCHAR values padded to 10 characters equal a CHAR value, '' / ' ' / 'kN ' do not
drop table if exists mj_vc, mj_ch;
create table mj_vc (id int primary key, s varchar(10));
insert into mj_vc
select id,
       case when mod(id, 60) = 5 then '          '
            else case mod(id, 5) when 0 then '' when 1 then ' ' when 2 then 'k' || mod(id, 250)
                                 when 3 then 'k' || mod(id, 250) || ' '
                                 else rpad ('k' || mod(id, 250), 10, ' ') end end
from t1 where id <= 3000;
create index i_mj_vc on mj_vc (s);

create table mj_ch (id int primary key, s char(10));
insert into mj_ch
select id,
       case when mod(id, 40) = 0 then '' when mod(id, 40) = 20 then ' '
            when mod(id, 2) = 0 then 'k' || mod(id, 250) else 'k' || mod(id, 250) || ' ' end
from t2 where id <= 2000;
create index i_mj_ch on mj_ch (s);

update statistics on mj_vc, mj_ch;

set trace on;
select /*+ USE_MERGE */ count(*) from mj_vc v, mj_ch c where v.s = c.s;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c3 <=> n.c3
             and m.c0 <=> h.c0 and m.c1 <=> h.c1 and m.c2 <=> h.c2 and m.c3 <=> h.c3
             and m.c0 <=> 9800 and m.c4 <=> 10
       then 'PASS' else 'FAIL' end as case10_varchar_char_keys
from (select /*+ USE_MERGE */ count(*) c0, sum(v.id) c1, sum(c.id) c2, count(distinct v.s) c3, min(length(v.s)) c4
      from mj_vc v, mj_ch c where v.s = c.s) m,
     (select /*+ USE_NL */ count(*) c0, sum(v.id) c1, sum(c.id) c2, count(distinct v.s) c3
      from mj_vc v, mj_ch c where v.s = c.s) n,
     (select /*+ USE_HASH */ count(*) c0, sum(v.id) c1, sum(c.id) c2, count(distinct v.s) c3
      from mj_vc v, mj_ch c where v.s = c.s) h;

-- Case 11: INT = BIGINT keys; no parallel merge workers on MERGELIST
drop table if exists mj_big;
create table mj_big (id int primary key, k bigint);
insert into mj_big select id, k from t2;
create index i_mj_big on mj_big (k);
update statistics on mj_big;

set trace on;
select /*+ USE_MERGE */ count(*) from t1, mj_big b where t1.k = b.k;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c0 <=> 40000
       then 'PASS' else 'FAIL' end as case11_int_bigint_serial
from (select /*+ USE_MERGE */ count(*) c0, sum(t1.id) + sum(b.id) c1, sum(cast(t1.id as bigint) * b.id) c2
      from t1, mj_big b where t1.k = b.k) m,
     (select /*+ USE_NL */ count(*) c0, sum(t1.id) + sum(b.id) c1, sum(cast(t1.id as bigint) * b.id) c2
      from t1, mj_big b where t1.k = b.k) n;

-- Case 12: the smaller side's keys start at 450, past the first boundary taken from t1 (keys 0..599), so range 0 joins nothing
drop table if exists mj_shift;
create table mj_shift (id int primary key, k int);
insert into mj_shift select id, k + 450 from t2;
create index i_mj_shift on mj_shift (k);
update statistics on mj_shift;

set trace on;
select /*+ USE_MERGE */ count(*) from t1, mj_shift s where t1.k = s.k;
show trace;
set trace off;

select case when m.c0 <=> n.c0 and m.c1 <=> n.c1 and m.c2 <=> n.c2 and m.c3 <=> n.c3
             and m.c0 <=> 15000 and m.c3 <=> 450
       then 'PASS' else 'FAIL' end as case12_empty_first_range
from (select /*+ USE_MERGE */ count(*) c0, sum(t1.id) + sum(s.id) c1, sum(cast(t1.id as bigint) * s.id) c2, min(s.k) c3
      from t1, mj_shift s where t1.k = s.k) m,
     (select /*+ USE_NL */ count(*) c0, sum(t1.id) + sum(s.id) c1, sum(cast(t1.id as bigint) * s.id) c2, min(s.k) c3
      from t1, mj_shift s where t1.k = s.k) n;

drop table if exists mj_ca, mj_cb, mj_vc, mj_ch, mj_big, mj_shift;

drop table if exists t1, t2;
