/*
 * This test case verifies CBRD-26475 : the optimizer selects a hash join by
 * cost, without a USE_HASH hint.
 *
 * Before the fix the hash join candidate was discarded unless the query
 * carried a USE_HASH hint, so a large equi-join without a usable index always
 * ran as a nested-loop join. The fix lets the hash join compete on cost with
 * the idx/nl/merge join candidates. Several parts of the cost model are
 * intentional design decisions and are checked as such:
 *   - a fixed hash-table build cost (HJ_MEM_ALLOC_CONSTANT) keeps small
 *     inputs on the nested-loop join
 *   - when the build side does not fit in max_hash_list_scan_size * 0.8 the
 *     executor spills to a partitioned hash join, so the optimizer adds the
 *     spill IO to the hash-join cost and prefers an index join instead
 *   - the sort-merge join is still never chosen by cost, only by USE_MERGE
 *   - join hints keep their priority over the cost, including on a right
 *     outer join where USE_NL / USE_MERGE / NO_USE_HASH used to be ignored
 *     (the join is swapped to a left outer join and the hint was read from
 *     the wrong node)
 *
 * Each case prints the query plan (plan shape only, cost and card are masked)
 * and a count or sum so that every join method returns the same rows.
 *   Case 1: hash-join by cost - inner join, left outer join and right outer
 *           join of two 20,000-row tables without an index on the join column
 *   Case 2: small inputs (100 rows) stay on nl-join, USE_HASH still forces
 *           the hash-join on them
 *   Case 3: hints beat the cost - on two 2,000-row tables the cost picks
 *           hash-join, NO_USE_HASH and USE_NL give nl-join, USE_MERGE gives
 *           m-join (smaller tables keep the forced nl-join short)
 *   Case 4: m-join is not chosen by cost even when it is enabled by
 *           optimizer_enable_merge_join, the hash-join stays cheaper
 *   Case 5: spill cost - 12,000 rows joined to a 20,000-row table with a
 *           covering index on the join column: the hash-join wins while the
 *           build fits in memory, lowering max_hash_list_scan_size below the
 *           build size adds the spill IO and switches the plan to idx-join
 *   Case 6: right outer join honors the join-method hints - the hint is read
 *           from the null-supplying table (a): USE_NL(a) / NO_USE_HASH(a) give
 *           nl-join, while USE_NL(b) / NO_USE_HASH(b) on the preserved table do
 *           not apply and the cost keeps the hash-join
 *   Case 7: the null-supplying side of a right outer join is itself a join
 *           (multi-node), a bare USE_HASH is on all of its tables and forces
 *           the hash-join on the outer join too (CBRD-27992), without the
 *           hint the cost picks nl-join there
 */
drop table if exists t_big1, t_big2, t_idx, t_mid, t_hint1, t_hint2, t_small1, t_small2;

create table t_big1 (id int, k int, v varchar(20));
create table t_big2 (id int, k int, v varchar(20));
create table t_idx (id int, k int, v varchar(20), index i_t_idx_k (k));
create table t_mid (id int, k int, v varchar(20));
create table t_hint1 (id int, k int, v varchar(20));
create table t_hint2 (id int, k int, v varchar(20));
create table t_small1 (id int, k int);
create table t_small2 (id int, k int);

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

update statistics on t_big1, t_big2, t_idx, t_mid, t_hint1, t_hint2, t_small1, t_small2 with fullscan;

-- Case 1: hash-join by cost without a hint
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_big1 a, t_big2 b where a.k = b.k;

select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(b.id) from t_big1 a left outer join t_big2 b on a.k = b.k and b.id > 10000;

select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(a.id) from t_big1 a right outer join t_big2 b on a.k = b.k and a.id > 10000;

-- Case 2: small inputs stay on nl-join (fixed hash build cost), USE_HASH forces hash-join
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_small1 a, t_small2 b where a.k = b.k;

select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id) from t_small1 a, t_small2 b where a.k = b.k;

-- Case 3: hints beat the cost - without a hint the cost picks hash-join on these tables
select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_hint1 a, t_hint2 b where a.k = b.k;

select /*+ recompile no_use_hash */ count(*), sum(a.id), sum(b.id) from t_hint1 a, t_hint2 b where a.k = b.k;

select /*+ recompile use_nl */ count(*), sum(a.id), sum(b.id) from t_hint1 a, t_hint2 b where a.k = b.k;

select /*+ recompile use_merge */ count(*), sum(a.id), sum(b.id) from t_hint1 a, t_hint2 b where a.k = b.k;

-- Case 4: m-join competes only when enabled, and still loses to the hash-join by cost
set system parameters 'optimizer_enable_merge_join=yes';

select /*+ recompile */ count(*), sum(a.id), sum(b.id) from t_big1 a, t_big2 b where a.k = b.k;

set system parameters 'optimizer_enable_merge_join=no';

-- Case 5: spill cost - the build fits in the default 8MB limit, hash-join wins over the covering idx-join
select /*+ recompile */ count(*) from t_mid a, t_idx b where a.k = b.k;

-- 12,000 build rows do not fit in 64KB * 0.8, the spill IO makes the covering idx-join cheaper
set system parameters 'max_hash_list_scan_size=64K';

select /*+ recompile */ count(*) from t_mid a, t_idx b where a.k = b.k;

set system parameters 'max_hash_list_scan_size=8M';

-- Case 6: right outer join honors the join-method hints - without a hint the cost picks hash-join
select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

select /*+ recompile no_use_hash */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

select /*+ recompile use_nl */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

select /*+ recompile use_merge */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

-- the hint is read from the null-supplying table a
select /*+ recompile use_nl(a) */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

select /*+ recompile no_use_hash(a) */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

-- a hint on the preserved table b does not apply, the cost keeps the hash-join
select /*+ recompile use_nl(b) */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

select /*+ recompile no_use_hash(b) */ count(*), sum(a.id), sum(b.id), count(a.id) from t_hint1 a right outer join t_hint2 b on a.k = b.k and a.id > 1000;

select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id), count(a.id) from t_small1 a right outer join t_small2 b on a.k = b.k;

-- Case 7: multi-node null-supplying side of a right outer join - the bare USE_HASH forces the hash-join on the outer join too, without it the cost picks nl-join for small inputs
select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

drop table t_big1, t_big2, t_idx, t_mid, t_hint1, t_hint2, t_small1, t_small2;
