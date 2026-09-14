/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 *                        (co-verifies CBRD-26666: sector work-stealing under load imbalance)
 * Scenario file: many-to-many duplicate keys and heavily skewed key distribution
 * Coverage: two shapes the rest of the suite never produces. (1) N:M - duplicate keys on BOTH
 *           sides, the classic hash-join correctness risk: every left row must pair with every
 *           matching right row, so a partition boundary that dropped or double-counted a bucket
 *           chain shows up immediately in the row count. (2) SKEW - one key holding 80% of the
 *           probe rows, which is the only shape in the suite that makes the partitions genuinely
 *           unequal, exercising the CBRD-26666 work-stealing cursor (next_sector_index) rather
 *           than letting every worker take an equal share.
 * How verified: every parallel case is paired with a single-threaded (no_parallel_hash_join) run
 *           of the same query - the results must be identical. Both runs emit SQL Trace; the
 *           PARALLEL node and the HASHJOIN "parallel workers" attribute appear only in the
 *           parallel case.
 * Note: N:M sizing is deliberate. 20000 rows per side over 2000 distinct keys gives 10 duplicates
 *       per key per side, so the join produces 2000 x 10 x 10 = 200000 rows - large enough to
 *       catch a lost chain, small enough to stay fast. For the skew case the SKEWED table is made
 *       the smaller input (50000 vs 100000 rows) on purpose: the optimizer builds the hash table
 *       from the smaller side no matter how the FROM clause is ordered, and only a skewed BUILD
 *       side produces unequal partitions. Pairing a skewed probe with a small build - the obvious
 *       way to write this - leaves a build that fits in memory, so nothing is partitioned and the
 *       case silently proves nothing. The other side keeps unique keys, so the result is exactly
 *       50000 rows and cannot explode.
 * Source: own addition (not in the JIRA attachment) - generalises A/C (2) to duplicate and skewed keys.
 */

--
-- test data
--

drop table if exists t_nm1, t_nm2, t_sk_skew, t_sk_uniq;

-- N:M - 10 duplicates per key on each side
create table t_nm1 (c1 int, c2 int);
create table t_nm2 (c1 int, c2 int);

insert into t_nm1
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select mod (rownum, 2000), mod (rownum, 7) from cte a, cte b limit 20000;

insert into t_nm2
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select mod (rownum, 2000), mod (rownum, 5) from cte a, cte b limit 20000;

-- SKEW - the SKEWED table is deliberately the SMALLER side. The optimizer always builds the hash
-- table from the smaller input (ORDERED does not override that), and only a skewed BUILD side
-- makes the partitions unequal - a skewed probe against a small build needs no partitioning at all.
create table t_sk_skew (c1 int, c2 int);
create table t_sk_uniq (c1 int, c2 int);

insert into t_sk_skew
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select case when mod (rownum, 10) < 8 then 1 else mod (rownum, 2000) + 1 end, mod (rownum, 5)
  from cte a, cte b limit 50000;

insert into t_sk_uniq
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 7) from cte a, cte b limit 100000;

update statistics on t_nm1, t_nm2, t_sk_skew, t_sk_uniq;

-- lower the threshold so a partition hash join (and sector-based parallel split) is triggered
set system parameters 'max_hash_list_scan_size=256k';

set trace on;


evaluate 'Case 1: N:M duplicate keys on both sides - parallel (expect 200000 pairs)';

select /*+ recompile use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.c1 as bigint)) as s1, sum (b.c2) as s2
from t_nm1 a, t_nm2 b
where a.c1 = b.c1;

show trace;

evaluate 'Case 2: same N:M join single-threaded (NO_PARALLEL_HASH_JOIN) - must match Case 1';

select /*+ recompile use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.c1 as bigint)) as s1, sum (b.c2) as s2
from t_nm1 a, t_nm2 b
where a.c1 = b.c1;

show trace;

evaluate 'Case 3: skewed BUILD side (80% of rows share one key) - parallel, exercises work-stealing';

select /*+ recompile use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (u.c1 as bigint)) as s1, sum (s.c2) as s2
from t_sk_uniq u, t_sk_skew s
where u.c1 = s.c1;

show trace;

evaluate 'Case 4: same skewed join single-threaded - must match Case 3';

select /*+ recompile use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (u.c1 as bigint)) as s1, sum (s.c2) as s2
from t_sk_uniq u, t_sk_skew s
where u.c1 = s.c1;

show trace;

evaluate 'Case 5: N:M LEFT OUTER (duplicate keys on the null-supplying side) - parallel';

select /*+ recompile ordered use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b.c1) as matched
from t_nm1 a left outer join t_nm2 b on a.c1 = b.c1;

show trace;

evaluate 'Case 6: same N:M LEFT OUTER join single-threaded - must match Case 5';

select /*+ recompile ordered use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b.c1) as matched
from t_nm1 a left outer join t_nm2 b on a.c1 = b.c1;

show trace;

set trace off;

--
-- clean up test data
--

drop table t_nm1, t_nm2, t_sk_skew, t_sk_uniq;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
