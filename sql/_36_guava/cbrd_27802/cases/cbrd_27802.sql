/**
 *  This test case verifies CBRD-27802: a hash GROUP BY whose groups leave the hash table returns the same groups
 *  whether or not it keeps a copy of each group's first row.
 *
 *  Before the change every group that left the 2 MB hash table was written twice, its first row to one list and its
 *  partial aggregates to another, and both lists were sorted and merged. Now the first row goes into the aggregates
 *  and the copy is kept only when the output reads more than the group keys and aggregates.
 *
 *  Each tested query is followed by the same query with no_hash_aggregate (the sort GROUP BY, which never kept a
 *  copy), and the two result blocks must match. The pre-fix build also passes (correctness TC). Checksums weight
 *  every aggregate by its own key, so aggregates moved to another group change them. CTP masks digits, so only the
 *  parallel workers line and the hash word of the trace are asserted.
 *
 *  Coverage:
 *    Case 1:  4 consecutive rows per key, serial scan, groups listed and summed (TPC-H Q18 subquery shape)
 *    Case 2:  the same under a parallel heap scan, each worker hashes its own rows
 *    Case 3:  the Q18 IN subquery with HAVING over the aggregates, serial and parallel
 *    Case 4:  every key in two blocks far apart, so one key leaves the hash table twice
 *    Case 5:  two keys, one descending, groups listed in GROUP BY order
 *    Case 6:  a key expression in the select list, nested in an expression and in HAVING
 *    Case 7:  NULL keys
 *    Case 8:  300-byte MAX aggregates, serial and parallel
 *    Case 9:  hash aggregation given up after unique keys, hash partial
 *    Case 10: rows longer than a page and rows with a SET value, which bypass the hash table
 *    Case 11: copy kept, a non-key column in the select list, HAVING or ORDER BY
 *    Case 12: copy kept, correlated subquery, analytic function and WITH ROLLUP
 *    Case 13: agg_hash_respect_order=no
 *    Case 14: empty input, serial and parallel
 *    Case 15: LIMIT and GROUPBY_NUM stop the output, serial, parallel, after giving up and with unhashed rows
 */

drop table if exists t_grp, t_wide, t_uniq, t_big, t_set, t_ref;

-- 200,000 rows in about 820 heap pages (25 times the 32-page parallel scan threshold of CTP). k: 50,000 groups of 4
-- consecutive rows, more than the 2 MB hash table holds, at a group per row ratio of 0.25 that never gives up hashing.
-- kc: 25,000 keys, each in two blocks 100,000 rows apart. kn: k with every 10th row NULL. kd = 3 * k
create table t_grp (id int, k int, kd int, kc int, kb int, kn int, v int, n numeric(12,2));
insert into t_grp select rownum, (rownum - 1) / 4, ((rownum - 1) / 4) * 3, mod((rownum - 1) / 4, 25000), mod(rownum, 3),
  case when mod(rownum, 10) = 0 then null else (rownum - 1) / 4 end, mod(rownum, 113), mod(rownum, 1000) / 8.0
  from db_class a, db_class b, db_class c, db_class d limit 200000;

-- 20,000 groups of 2 rows, each MAX holding a 300-byte string: 6 MB of aggregates, 3 times the hash table
create table t_wide (k int, pad varchar(400));
insert into t_wide select (rownum - 1) / 2, lpad(to_char(rownum), 300, '0') from db_class a, db_class b, db_class c, db_class d limit 40000;

-- 50,000 unique keys first (the hash gives up at its first check after 2,000 rows), then 50,000 rows over 20,000 of them
create table t_uniq (k int, v int);
insert into t_uniq select rownum, mod(rownum, 17) from db_class a, db_class b, db_class c, db_class d limit 50000;
insert into t_uniq select mod(rownum, 20000), mod(rownum, 19) from db_class a, db_class b, db_class c, db_class d limit 50000;

-- 20,000 groups of 4 rows, every 80th row 17 KB (longer than a 16 KB page) and so never hashed
create table t_big (id int, k int, big varchar(20000));
insert into t_big select rownum, (rownum - 1) / 4, case when mod(rownum, 80) = 0 then repeat('x', 17000) || rownum else 'y' || rownum end
  from db_class a, db_class b, db_class c, db_class d limit 80000;

-- 25,000 groups of 4 rows, every row with a SET value, which is never hashed
create table t_set (k int, st set(int));
insert into t_set select (rownum - 1) / 4, {rownum, rownum + 1} from db_class a, db_class b, db_class c, db_class d limit 100000;

-- 300 keys for the correlated subquery of Case 12
create table t_ref (x int);
insert into t_ref select mod(rownum, 300) from db_class a, db_class b, db_class c limit 3000;

update statistics on t_grp, t_wide, t_uniq, t_big, t_set, t_ref with fullscan;

set trace on;


evaluate 'Case 1: 4 consecutive rows per key, serial scan; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ k, count(*), sum(v), sum(n), min(id), max(id), cast(avg(v) as numeric(10, 4)) from t_grp group by k having mod(k, 4999) = 0;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s), sum(k * sn), sum(cast(k as bigint) * mx)
  from (select /*+ no_parallel_scan */ k, count(*) c, sum(v) s, sum(n) sn, max(id) mx from t_grp group by k) d;
show trace;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*), sum(v), sum(n), min(id), max(id), cast(avg(v) as numeric(10, 4)) from t_grp group by k having mod(k, 4999) = 0;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s), sum(k * sn), sum(cast(k as bigint) * mx)
  from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, sum(v) s, sum(n) sn, max(id) mx from t_grp group by k) d;


evaluate 'Case 2: parallel heap scan, parallel workers line under the scan; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s), sum(k * sn), sum(cast(k as bigint) * mx)
  from (select k, count(*) c, sum(v) s, sum(n) sn, max(id) mx from t_grp group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s), sum(k * sn), sum(cast(k as bigint) * mx)
  from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, sum(v) s, sum(n) sn, max(id) mx from t_grp group by k) d;


evaluate 'Case 3: Q18 IN subquery with HAVING over the aggregates; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)), sum(cast(k as bigint)), sum(v) from t_grp
  where k in (select /*+ no_parallel_scan */ k from t_grp group by k having sum(v) > 300);
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)), sum(cast(k as bigint)), sum(v) from t_grp
  where k in (select k from t_grp group by k having sum(v) > 300);
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)), sum(cast(k as bigint)), sum(v) from t_grp
  where k in (select /*+ no_parallel_scan no_hash_aggregate */ k from t_grp group by k having sum(v) > 300);


evaluate 'Case 4: every key in two blocks, one key leaves the hash table twice; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(kc as bigint) * c), sum(cast(kc as bigint) * s), sum(cast(kc as bigint) * mi), sum(cast(kc as bigint) * mx)
  from (select /*+ no_parallel_scan */ kc, count(*) c, sum(v) s, min(id) mi, max(id) mx from t_grp group by kc) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(kc as bigint) * c), sum(cast(kc as bigint) * s), sum(cast(kc as bigint) * mi), sum(cast(kc as bigint) * mx)
  from (select kc, count(*) c, sum(v) s, min(id) mi, max(id) mx from t_grp group by kc) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(kc as bigint) * c), sum(cast(kc as bigint) * s), sum(cast(kc as bigint) * mi), sum(cast(kc as bigint) * mx)
  from (select /*+ no_parallel_scan no_hash_aggregate */ kc, count(*) c, sum(v) s, min(id) mi, max(id) mx from t_grp group by kc) d;


evaluate 'Case 5: two keys, one descending, listed in GROUP BY order; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ kc, kb, count(*), sum(v), min(id) from t_grp group by kc desc, kb having mod(kc, 2500) = 7;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(kc * 3 + kb as bigint) * s) from (select /*+ no_parallel_scan */ kc, kb, count(*) c, sum(v) s from t_grp group by kc desc, kb) d;
select /*+ recompile no_parallel_scan no_hash_aggregate */ kc, kb, count(*), sum(v), min(id) from t_grp group by kc desc, kb having mod(kc, 2500) = 7;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(kc * 3 + kb as bigint) * s) from (select /*+ no_parallel_scan no_hash_aggregate */ kc, kb, count(*) c, sum(v) s from t_grp group by kc desc, kb) d;


evaluate 'Case 6: key expression in the select list, nested and in HAVING; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(e as bigint) * s) from (select /*+ no_parallel_scan */ k / 8 + 1 e, count(*) c, sum(v) s from t_grp group by k / 8 + 1) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(e as bigint) * c) from (select /*+ no_parallel_scan */ (k / 8 + 1) * 2 e, count(*) c from t_grp group by k / 8 + 1 having k / 8 + 1 > 3000) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(e as bigint) * s) from (select /*+ no_parallel_scan no_hash_aggregate */ k / 8 + 1 e, count(*) c, sum(v) s from t_grp group by k / 8 + 1) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(e as bigint) * c) from (select /*+ no_parallel_scan no_hash_aggregate */ (k / 8 + 1) * 2 e, count(*) c from t_grp group by k / 8 + 1 having k / 8 + 1 > 3000) d;


evaluate 'Case 7: NULL keys; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ kn, count(*), sum(v) from t_grp group by kn having kn is null or kn < 3;
select /*+ recompile no_parallel_scan */ count(*), count(kn), sum(c), sum(cast(nvl(kn, -1) as bigint) * s) from (select /*+ no_parallel_scan */ kn, count(*) c, sum(v) s from t_grp group by kn) d;
select /*+ recompile no_parallel_scan */ count(*), count(kn), sum(c), sum(cast(nvl(kn, -1) as bigint) * s) from (select kn, count(*) c, sum(v) s from t_grp group by kn) d;
select /*+ recompile no_parallel_scan no_hash_aggregate */ kn, count(*), sum(v) from t_grp group by kn having kn is null or kn < 3;
select /*+ recompile no_parallel_scan */ count(*), count(kn), sum(c), sum(cast(nvl(kn, -1) as bigint) * s) from (select /*+ no_parallel_scan no_hash_aggregate */ kn, count(*) c, sum(v) s from t_grp group by kn) d;


evaluate 'Case 8: 300-byte MAX aggregates, serial and parallel; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * to_number(substr(mx, 291))), max(length(mx)) from (select /*+ no_parallel_scan */ k, count(*) c, max(pad) mx from t_wide group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * to_number(substr(mx, 291))), max(length(mx)) from (select k, count(*) c, max(pad) mx from t_wide group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * to_number(substr(mx, 291))), max(length(mx)) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, max(pad) mx from t_wide group by k) d;


evaluate 'Case 9: hash aggregation given up after unique keys, hash partial; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s) from (select /*+ no_parallel_scan */ k, count(*) c, sum(v) s from t_uniq group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s) from (select k, count(*) c, sum(v) s from t_uniq group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, sum(v) s from t_uniq group by k) d;


evaluate 'Case 10: rows longer than a page and rows with a SET value bypass the hash table; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * l), sum(cast(k as bigint) * mx) from (select /*+ no_parallel_scan */ k, count(*) c, sum(length(big)) l, max(id) mx from t_big group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * l), sum(cast(k as bigint) * mx) from (select k, count(*) c, sum(length(big)) l, max(id) mx from t_big group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * cs) from (select /*+ no_parallel_scan */ k, count(*) c, count(st) cs from t_set group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * l), sum(cast(k as bigint) * mx) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, sum(length(big)) l, max(id) mx from t_big group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * cs) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, count(st) cs from t_set group by k) d;


evaluate 'Case 11: copy kept, non-key column in the select list, HAVING or ORDER BY; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(kd as bigint) * c), sum(cast(k as bigint) * s) from (select /*+ no_parallel_scan */ k, kd, count(*) c, sum(v) s from t_grp group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c) from (select /*+ no_parallel_scan */ k, count(*) c from t_grp group by k having kd > 300) d;
select /*+ recompile no_parallel_scan */ k, count(*) from t_grp group by k having mod(k, 4999) = 0 order by kd desc;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(kd as bigint) * c), sum(cast(k as bigint) * s) from (select /*+ no_parallel_scan no_hash_aggregate */ k, kd, count(*) c, sum(v) s from t_grp group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c from t_grp group by k having kd > 300) d;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*) from t_grp group by k having mod(k, 4999) = 0 order by kd desc;


evaluate 'Case 12: copy kept, correlated subquery, analytic function, WITH ROLLUP; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * r) from (select /*+ no_parallel_scan */ k, count(*) c, (select count(*) from t_ref where t_ref.x = t_grp.k) r from t_grp group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * rk) from (select /*+ no_parallel_scan */ k, count(*) c, rank() over (order by sum(v) desc, k) rk from t_grp group by k) d;
select /*+ recompile no_parallel_scan */ kb, count(*), sum(v), sum(n) from t_grp group by kb with rollup;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * r) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, (select count(*) from t_ref where t_ref.x = t_grp.k) r from t_grp group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * rk) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, rank() over (order by sum(v) desc, k) rk from t_grp group by k) d;
select /*+ recompile no_parallel_scan no_hash_aggregate */ kb, count(*), sum(v), sum(n) from t_grp group by kb with rollup;


evaluate 'Case 13: agg_hash_respect_order=no; result = no_hash_aggregate';
set system parameters 'agg_hash_respect_order=no';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s) from (select /*+ no_parallel_scan */ k, count(*) c, sum(v) s from t_grp group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s) from (select k, count(*) c, sum(v) s from t_grp group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * l) from (select /*+ no_parallel_scan */ k, count(*) c, sum(length(big)) l from t_big group by k) d;
set system parameters 'agg_hash_respect_order=default';
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * c), sum(cast(k as bigint) * s) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, sum(v) s from t_grp group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(cast(k as bigint) * l) from (select /*+ no_parallel_scan no_hash_aggregate */ k, count(*) c, sum(length(big)) l from t_big group by k) d;


evaluate 'Case 14: empty input, serial and parallel; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ k, count(*), sum(v) from t_grp where id < 0 group by k;
select /*+ recompile */ k, count(*), sum(v) from t_grp where id < 0 group by k;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*), sum(v) from t_grp where id < 0 group by k;


evaluate 'Case 15: LIMIT and GROUPBY_NUM stop the output; result = no_hash_aggregate';
select /*+ recompile no_parallel_scan */ k, count(*), sum(v), sum(n) from t_grp group by k limit 5;
select /*+ recompile no_parallel_scan */ k, count(*), sum(v) from t_grp group by k limit 30000, 4;
select /*+ recompile no_parallel_scan */ groupby_num(), kc, count(*), sum(v) from t_grp group by kc having groupby_num() between 24998 and 25003;
select /*+ recompile */ k, count(*), sum(v) from t_grp group by k having groupby_num() < 4;
select /*+ recompile no_parallel_scan */ k, count(*), sum(v) from t_uniq group by k limit 49990, 6;
select /*+ recompile no_parallel_scan */ k, count(*), sum(length(big)) from t_big group by k limit 3;
select /*+ recompile no_parallel_scan */ k, count(*), sum(length(big)) from t_big group by k limit 19, 3;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*), sum(v), sum(n) from t_grp group by k limit 5;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*), sum(v) from t_grp group by k limit 30000, 4;
select /*+ recompile no_parallel_scan no_hash_aggregate */ groupby_num(), kc, count(*), sum(v) from t_grp group by kc having groupby_num() between 24998 and 25003;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*), sum(v) from t_grp group by k having groupby_num() < 4;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*), sum(v) from t_uniq group by k limit 49990, 6;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*), sum(length(big)) from t_big group by k limit 3;
select /*+ recompile no_parallel_scan no_hash_aggregate */ k, count(*), sum(length(big)) from t_big group by k limit 19, 3;

drop table t_grp, t_wide, t_uniq, t_big, t_set, t_ref;
