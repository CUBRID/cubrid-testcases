/*
 * This test case verifies CBRD-27992 : join method hints on a right outer
 * join whose left side is already a join of several tables.
 *
 * A right outer join is planned as a left outer join with the two sides
 * swapped, and the hint is read from the side that becomes the inner. When
 * that side is itself a join (a JOIN b), no single table of it is the inner.
 * Before the fix the hint was not read at all there, so the cost alone chose
 * the outer join method: NO_USE_HASH / USE_NL / USE_NL(c) kept a hash-join on
 * the large tables, and USE_HASH / USE_HASH(c) kept a nl-join on the small
 * tables. Now the hint is read from the table written right of RIGHT OUTER
 * JOIN (c), the same table the merge-join check reads, and a hint without a
 * table is on every table.
 *
 * Each case prints the query plan (plan shape only, cost and card are masked)
 * and counts so that every join method returns the same rows.
 *   Case 1: large tables - no hint keeps the hash-join, NO_USE_HASH, USE_NL
 *           and USE_NL(c) give a nl-join, USE_MERGE gives a m-join
 *   Case 2: small tables - no hint keeps the nl-join, USE_HASH,
 *           USE_HASH(a,b,c) and USE_HASH(c) give a hash-join
 *   Case 3: USE_HASH on two right outer joins in a row makes both hash-joins
 *   Case 4: USE_HASH with no equi-join term in ON cannot be a hash-join, the
 *           nl-join is still planned
 *   Case 5: USE_HASH(c) when the hash-join cannot be built
 *           (max_hash_list_scan_size=0) keeps the nl-join, and the other hints
 *           of the query (USE_MERGE(b), ORDERED) are still honored instead of
 *           being dropped by a failed planning
 */
drop table if exists t_big1, t_big2, t_small1, t_small2;

create table t_big1 (id int, k int, v varchar(20));
create table t_big2 (id int, k int, v varchar(20));
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

insert into t_small1
select rownum, mod(rownum, 20) from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b
limit 100;

insert into t_small2
select rownum, mod(rownum, 25) from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b
limit 100;

update statistics on t_big1, t_big2, t_small1, t_small2 with fullscan;

-- Case 1: large tables, the cost picks the hash-join, the hints win over it
select /*+ recompile */ count(*), count(b.id), count(c.id) from t_big1 a join t_big2 b on a.id = b.id and a.id < 100 right outer join t_big1 c on c.k = b.k;

select /*+ recompile no_use_hash */ count(*), count(b.id), count(c.id) from t_big1 a join t_big2 b on a.id = b.id and a.id < 100 right outer join t_big1 c on c.k = b.k;

select /*+ recompile use_nl */ count(*), count(b.id), count(c.id) from t_big1 a join t_big2 b on a.id = b.id and a.id < 100 right outer join t_big1 c on c.k = b.k;

select /*+ recompile use_nl(c) */ count(*), count(b.id), count(c.id) from t_big1 a join t_big2 b on a.id = b.id and a.id < 100 right outer join t_big1 c on c.k = b.k;

select /*+ recompile use_merge */ count(*), count(b.id), count(c.id) from t_big1 a join t_big2 b on a.id = b.id and a.id < 100 right outer join t_big1 c on c.k = b.k;

-- Case 2: small tables, the cost picks the nl-join, USE_HASH wins over it
select /*+ recompile */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

select /*+ recompile use_hash(a,b,c) */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

select /*+ recompile use_hash(c) */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

-- Case 3: two right outer joins in a row
select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id), count(c.id), count(d.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k right outer join t_small2 d on d.k = c.k;

-- Case 4: no equi-join term in ON, USE_HASH cannot apply and the nl-join stays
select /*+ recompile use_hash */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k > b.k;

-- Case 5: the hash-join cannot be built, the nl-join stays and USE_MERGE(b) is kept
set system parameters 'max_hash_list_scan_size=0';

select /*+ recompile use_hash(c) use_merge(b) */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

select /*+ recompile ordered use_hash(c) use_merge(b) */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

set system parameters 'max_hash_list_scan_size=8M';

-- with the hash-join possible again, USE_HASH(c) and USE_MERGE(b) both apply
select /*+ recompile use_hash(c) use_merge(b) */ count(*), sum(a.id), sum(b.id), count(c.id) from t_small1 a join t_small2 b on a.id = b.id right outer join t_small1 c on c.k = b.k;

drop table t_big1, t_big2, t_small1, t_small2;
