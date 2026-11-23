/**
 *  This test case verifies CBRD-26475: the optimizer selects a hash join by
 *  cost, without a USE_HASH hint.
 *
 *  Before the fix the hash join candidate was discarded unless the query
 *  carried a USE_HASH hint, so a large equi-join without a usable index always
 *  ran as a nested-loop join. The fix lets the hash join compete on cost with
 *  the idx/nl/merge join candidates. Several parts of the cost model are
 *  intentional design decisions and are checked as such:
 *    - a fixed hash-table build cost (HJ_MEM_ALLOC_CONSTANT) keeps small
 *      inputs on the nested-loop join
 *    - when the build side does not fit in max_hash_list_scan_size * 0.8 the
 *      executor spills to a partitioned hash join, so the optimizer adds the
 *      spill cost to the hash-join cost and prefers an index join instead
 *    - the sort-merge join is still never chosen by cost, only by USE_MERGE
 *    - join hints keep their priority over the cost, including on a right
 *      outer join where USE_NL / USE_MERGE / NO_USE_HASH used to be ignored
 *      (the join is swapped to a left outer join and the hint was read from
 *      the wrong node)
 *
 *  Each case prints the query plan (plan shape only, cost and card are masked)
 *  and counts and sums, so that every join method returns the same rows. From
 *  Case 8 on, each query that the cost plans as a hash-join is followed by its
 *  NO_USE_HASH twin, and each query that it plans as an idx-join by its
 *  USE_HASH twin, and the two results must match.
 *
 *  Coverage:
 *    Case 1:  hash-join by cost - inner join, left outer join and right outer
 *             join of two 20,000-row tables without an index on the join column
 *    Case 2:  small inputs (100 rows) stay on nl-join, USE_HASH still forces
 *             the hash-join on them
 *    Case 3:  hints beat the cost - on two 2,000-row tables the cost picks
 *             hash-join, NO_USE_HASH and USE_NL give nl-join, USE_MERGE gives
 *             m-join (smaller tables keep the forced nl-join short)
 *    Case 4:  m-join is not chosen by cost even when it is enabled by
 *             optimizer_enable_merge_join, the hash-join stays cheaper
 *    Case 5:  spill cost - 12,000 rows joined to a 20,000-row table with a
 *             covering index on the join column: the hash-join wins while the
 *             build fits in memory, lowering max_hash_list_scan_size below the
 *             build size adds the spill cost and switches the plan to idx-join
 *    Case 6:  right outer join honors the join-method hints - the hint is read
 *             from the null-supplying table (a): USE_NL(a) / NO_USE_HASH(a) give
 *             nl-join, while USE_NL(b) / NO_USE_HASH(b) on the preserved table do
 *             not apply and the cost keeps the hash-join, and USE_HASH forces
 *             the hash-join on the small tables
 *    Case 7:  the null-supplying side of a right outer join is itself a join
 *             (multi-node), a bare USE_HASH is on all of its tables and forces
 *             the hash-join on the outer join too (CBRD-27992), without the
 *             hint the cost picks nl-join there
 *    Case 8:  NULL join keys, keys that repeat on both sides and keys without a
 *             match - the cost picks hash-join for the inner, left outer and
 *             right outer join, NULL keys never match, and the rows of the
 *             preserved side with a NULL key are kept
 *    Case 9:  the cost picks hash-join on a VARCHAR join key as well
 *    Case 10: hash-joins chosen by cost under GROUP BY and in a three-table
 *             join, both joins of the three-table join are hash-joins
 *    Case 11: an empty table - the cost keeps nl-join, USE_HASH with an empty
 *             build side returns no rows for the inner join, keeps every row
 *             of the preserved side of an outer join, and none when the
 *             preserved side is the empty table
 *    Case 12: a hash-join that spills at run time - with max_hash_list_scan_size
 *             64K the trace shows the SPLIT into partitions, with the default
 *             size it does not, and both return the rows of Case 8
 *    Case 13: the filter on one side changes the choice for the same join -
 *             without a filter the cost picks hash-join, a filter that leaves
 *             1,000 outer rows gives idx-join, and a key range on the indexed
 *             side that leaves a small build input gives hash-join again
 */
drop table if exists t_big1, t_big2, t_idx, t_mid, t_hint1, t_hint2, t_small1, t_small2, t_nula, t_nulb, t_empty;

create table t_big1 (id int, k int, v varchar(20));
create table t_big2 (id int, k int, v varchar(20));
create table t_idx (id int, k int, v varchar(20), index i_t_idx_k (k));
-- t_mid: 12,000 rows, the build of Case 5 - 12,000 hash entries of 52 bytes (about 624KB) fit in the default 8M * 0.8
-- and not in 64K * 0.8 (about 1,000 entries), so that Case 5 adds the spill cost only under 64K
create table t_mid (id int, k int, v varchar(20));
create table t_hint1 (id int, k int, v varchar(20));
create table t_hint2 (id int, k int, v varchar(20));
create table t_small1 (id int, k int);
create table t_small2 (id int, k int);
-- 2,000 rows each, as t_hint1 and t_hint2, so that the cost picks hash-join on them
-- t_nula: 100 NULL keys, 380 keys of 5 rows each, 12 of them without a match in t_nulb
-- t_nulb: 80 NULL keys, 480 keys of 4 rows each, 112 of them without a match in t_nula
-- the hash entry of a build row takes 52 bytes, so max_hash_list_scan_size 64K (64K * 0.8 = about 1,000 entries) splits a 2,000-row build in Case 12
-- and the default 8M (about 129,000 entries) does not
create table t_nula (id int, k int, kv varchar(20));
create table t_nulb (id int, k int, kv varchar(20));
create table t_empty (id int, k int, kv varchar(20));

insert into t_big1
select rownum, mod(rownum, 5000), 'big1_' || rownum
from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c,
     table({0,1,2,3,4,5,6,7,8,9}) d, table({0,1,2,3,4,5,6,7,8,9}) e
limit 20000;

insert into t_big2
select rownum, mod(rownum * 3, 5000), 'big2_' || rownum
from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c,
     table({0,1,2,3,4,5,6,7,8,9}) d, table({0,1,2,3,4,5,6,7,8,9}) e
limit 20000;

insert into t_idx select id, k, v from t_big2;
insert into t_mid select id, k, v from t_big1 where id <= 12000;

insert into t_hint1
select rownum, mod(rownum, 500), 'hint1_' || rownum
from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c,
     table({0,1,2,3,4,5,6,7,8,9}) d
limit 2000;

insert into t_hint2
select rownum, mod(rownum * 3, 500), 'hint2_' || rownum
from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c,
     table({0,1,2,3,4,5,6,7,8,9}) d
limit 2000;

insert into t_small1
select rownum, mod(rownum, 20) from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b
limit 100;

insert into t_small2
select rownum, mod(rownum, 25) from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b
limit 100;

insert into t_nula
select n, k, 'key_' || k
from (select rownum n, case when mod(rownum, 20) = 0 then null else mod(rownum, 400) end k
      from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c,
           table({0,1,2,3,4,5,6,7,8,9}) d
      limit 2000) s;

insert into t_nulb
select n, k, 'key_' || k
from (select rownum n, case when mod(rownum, 25) = 0 then null else mod(rownum * 7, 500) end k
      from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c,
           table({0,1,2,3,4,5,6,7,8,9}) d
      limit 2000) s;

update statistics on t_big1, t_big2, t_idx, t_mid, t_hint1, t_hint2, t_small1, t_small2, t_nula, t_nulb, t_empty with fullscan;

evaluate 'Case 1: hash-join by cost without a hint - inner, left outer and right outer join';
--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_big1 a, t_big2 b where a.k = b.k;

--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(b.id) from t_big1 a left outer join t_big2 b on a.k = b.k and b.id > 10000;

--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(a.id) from t_big1 a right outer join t_big2 b on a.k = b.k and a.id > 10000;

evaluate 'Case 2: small inputs stay on nl-join, USE_HASH forces hash-join';
-- the fixed hash build cost keeps the 100-row tables on nl-join
--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_small1 a, t_small2 b where a.k = b.k;

--@queryplan
select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id) from t_small1 a, t_small2 b where a.k = b.k;

evaluate 'Case 3: hints beat the cost - NO_USE_HASH and USE_NL give nl-join, USE_MERGE gives m-join';
-- without a hint the cost picks hash-join on these tables
--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_hint1 a, t_hint2 b where a.k = b.k;

--@queryplan
select /*+ recompile no_use_hash */ count(*), sum(a.id), sum(b.id) from t_hint1 a, t_hint2 b where a.k = b.k;

--@queryplan
select /*+ recompile use_nl */ count(*), sum(a.id), sum(b.id) from t_hint1 a, t_hint2 b where a.k = b.k;

--@queryplan
select /*+ recompile use_merge */ count(*), sum(a.id), sum(b.id) from t_hint1 a, t_hint2 b where a.k = b.k;

evaluate 'Case 4: m-join enabled by the parameter still loses to the hash-join by cost';
set system parameters 'optimizer_enable_merge_join=yes';

--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_big1 a, t_big2 b where a.k = b.k;

set system parameters 'optimizer_enable_merge_join=default';

evaluate 'Case 5: spill cost - hash-join while the build fits in memory, idx-join when it does not';
-- the build fits in the default 8MB limit, hash-join wins over the covering idx-join
--@queryplan
select /*+ recompile */ count(*) from t_mid a, t_idx b where a.k = b.k;

-- 12,000 build rows do not fit in 64KB * 0.8, the spill cost makes the covering idx-join cheaper
set system parameters 'max_hash_list_scan_size=64K';

--@queryplan
select /*+ recompile */ count(*) from t_mid a, t_idx b where a.k = b.k;

set system parameters 'max_hash_list_scan_size=default';

evaluate 'Case 6: right outer join honors the join-method hints read from the null-supplying table';
-- without a hint the cost picks hash-join
--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

--@queryplan
select /*+ recompile no_use_hash */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

--@queryplan
select /*+ recompile use_nl */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

--@queryplan
select /*+ recompile use_merge */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

-- the hint is read from the null-supplying table a
--@queryplan
select /*+ recompile use_nl(a) */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

--@queryplan
select /*+ recompile no_use_hash(a) */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

-- a hint on the preserved table b does not apply, the cost keeps the hash-join
--@queryplan
select /*+ recompile use_nl(b) */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

--@queryplan
select /*+ recompile no_use_hash(b) */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

-- on the small tables, where the cost picks nl-join, USE_HASH forces the hash-join on the right outer join
--@queryplan
select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id), count(a.id) from t_small1 a right outer join t_small2 b on a.k = b.k;

evaluate 'Case 7: USE_HASH applies to a right outer join whose null-supplying side is a join';
-- without the hint the cost picks nl-join for these small inputs
--@queryplan
select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

evaluate 'Case 8: NULL keys, repeated keys and keys without a match - hash-join by cost, same rows as nl-join';
-- the product of the two ids tells whether each row of a was paired with the right rows of b
--@queryplan
select /*+ recompile */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a, t_nulb b where a.k = b.k;

--@queryplan
select /*+ recompile no_use_hash */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a, t_nulb b where a.k = b.k;

--@queryplan
select /*+ recompile */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a left outer join t_nulb b on a.k = b.k;

--@queryplan
select /*+ recompile no_use_hash */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a left outer join t_nulb b on a.k = b.k;

--@queryplan
select /*+ recompile */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a right outer join t_nulb b on a.k = b.k;

--@queryplan
select /*+ recompile no_use_hash */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a right outer join t_nulb b on a.k = b.k;

evaluate 'Case 9: hash-join by cost on a VARCHAR join key, same rows as nl-join';
--@queryplan
select /*+ recompile */ count(*), count(a.kv), count(b.kv), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a, t_nulb b where a.kv = b.kv;

--@queryplan
select /*+ recompile no_use_hash */ count(*), count(a.kv), count(b.kv), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a, t_nulb b where a.kv = b.kv;

evaluate 'Case 10: hash-joins by cost under GROUP BY and in a three-table join, same rows as nl-join';
--@queryplan
select /*+ recompile */ mod(b.k, 7) g, count(*), sum(a.id), sum(b.id) from t_nula a, t_nulb b where a.k = b.k group by mod(b.k, 7) order by g;

--@queryplan
select /*+ recompile no_use_hash */ mod(b.k, 7) g, count(*), sum(a.id), sum(b.id) from t_nula a, t_nulb b where a.k = b.k group by mod(b.k, 7) order by g;

--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id), sum(c.id) from t_nula a, t_nulb b, t_hint1 c where a.k = b.k and b.k = c.k;

--@queryplan
select /*+ recompile no_use_hash */ count(*), sum(a.id), sum(b.id), sum(c.id) from t_nula a, t_nulb b, t_hint1 c where a.k = b.k and b.k = c.k;

evaluate 'Case 11: an empty table - nl-join by cost, USE_HASH with an empty input';
--@queryplan
select /*+ recompile */ count(*), count(e.id) from t_hint1 a, t_empty e where a.k = e.k;

--@queryplan
select /*+ recompile use_hash */ count(*), count(e.id) from t_hint1 a, t_empty e where a.k = e.k;

--@queryplan
select /*+ recompile use_hash */ count(*), count(e.id), sum(a.id) from t_hint1 a left outer join t_empty e on a.k = e.k;

--@queryplan
select /*+ recompile use_hash */ count(*), count(a.id) from t_empty e left outer join t_hint1 a on a.k = e.k;

evaluate 'Case 12: a hash-join that spills at run time returns the rows of Case 8';
-- PARALLEL(0) keeps the hash-join serial, so that the trace has the same lines on any number of cores
set system parameters 'max_hash_list_scan_size=64K';
set trace on;

--@queryplan
select /*+ recompile use_hash parallel(0) */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a, t_nulb b where a.k = b.k;

show trace;

--@queryplan
select /*+ recompile use_hash parallel(0) */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a right outer join t_nulb b on a.k = b.k;

show trace;

set system parameters 'max_hash_list_scan_size=default';

-- with the default size the same build fits in memory and the trace has no SPLIT line
--@queryplan
select /*+ recompile use_hash parallel(0) */ count(*), count(a.k), count(b.k), sum(a.id), sum(b.id), sum(cast(a.id as bigint) * b.id) from t_nula a, t_nulb b where a.k = b.k;

show trace;

set trace off;

evaluate 'Case 13: the filter on one side switches the same join between hash-join and idx-join';
-- unlike Case 5 the select list reads b.id, so the index on t_idx.k does not cover the query
--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_mid a, t_idx b where a.k = b.k;

--@queryplan
select /*+ recompile no_use_hash */ count(*), sum(a.id), sum(b.id) from t_mid a, t_idx b where a.k = b.k;

--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_mid a, t_idx b where a.k = b.k and a.id <= 1000;

--@queryplan
select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id) from t_mid a, t_idx b where a.k = b.k and a.id <= 1000;

--@queryplan
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_mid a, t_idx b where a.k = b.k and b.k < 10;

--@queryplan
select /*+ recompile no_use_hash */ count(*), sum(a.id), sum(b.id) from t_mid a, t_idx b where a.k = b.k and b.k < 10;

drop table t_big1, t_big2, t_idx, t_mid, t_hint1, t_hint2, t_small1, t_small2, t_nula, t_nulb, t_empty;
