/**
 *  This test case verifies CBRD-26722: an index scan that drives its query block runs in parallel
 *  and returns the same rows as the serial index scan.
 *
 *  Before the fix every index scan was serial. Now the driving index scan gets a degree from the
 *  range estimate or a PARALLEL(N) hint, workers walk the leaves of every key range and merge
 *  aggregates (buildvalue) or rows (mergeable list), and order or early-stop shapes stay serial.
 *
 *  A parallel index scan prints a parallel workers line with an index time under its SCAN line.
 *  CTP masks the digits, so only the line and its tokens (gather, covered, lookup) are asserted.
 *  Each query is followed by its no_parallel_scan twin, whose result must be the same.
 *
 *  Coverage:
 *    Case 1:  no hint, a wide range over a large index: lookup, covering, count only, data filter
 *    Case 2:  PARALLEL(4) on smaller indexes: lookup, covering, count only, data filter
 *    Case 3:  rows gathered as a mergeable list for a derived table: equality, IN list, GROUP BY
 *    Case 4:  each range operator and ranges below and above every key
 *    Case 5:  IN lists with duplicates and absent values, overlapping OR ranges
 *    Case 6:  a descending index: a range, OR ranges, an IN list
 *    Case 7:  USE_DESC_IDX on an ascending and on a descending index
 *    Case 8:  a composite index: NULL key parts, a range on the second column, a key filter
 *    Case 9:  string, date and function index keys
 *    Case 10: an index built by inserts, whose leaves hold fence keys, and one built by bulk load
 *    Case 11: a partitioned table with an empty partition, with and without pruning
 *    Case 12: deleted and updated rows of the open transaction, NULL values in aggregates
 *    Case 13: a prepared statement executed with two ranges
 *    Case 14: an index scan in a derived table, in a join, in a UNION ALL arm
 *    Case 15: serial: KEYLIMIT, MIN/MAX, order skip, ROWNUM, analytic, hints
 *    Case 16: the JSON trace names the parallel index scan parallel index
 */

drop table if exists t_idx, t_small, t_fence, t_bulk, t_part;

-- 200,000 rows; a = id mod 4000 and d give every key 50 rows, an OID list inside the leaf record (100
-- rows a key spill to overflow pages); b puts 1, 2, 4 ... 64 of every 127 rows into groups 0 to 6;
-- e = id. SHOW INDEX CAPACITY: i_a, i_s, i_d and i_fn 110 to 190 pages, i_ab 123, i_e 209, at least
-- 3x the 32 pages develop needs for a hinted scan; i_pad on (id, pad), whose pad is two sha2 strings
-- that do not compress, 3,781, so a one-sided range estimated at 0.1 without a histogram still asks
-- for 378 pages, 11x the index threshold of 32
create table t_idx (id int, a int, b int, e int, s varchar(16), d date, pad varchar(256));
insert into t_idx select rownum, mod(rownum, 4000), case when mod(rownum, 127) < 1 then 0 when mod(rownum, 127) < 3 then 1 when mod(rownum, 127) < 7 then 2 when mod(rownum, 127) < 15 then 3 when mod(rownum, 127) < 31 then 4 when mod(rownum, 127) < 63 then 5 else 6 end, rownum, 'k' || lpad(mod(rownum, 5000), 5, '0'), date'2026-01-01' + mod(rownum, 4000), concat(sha2(rownum, 512), sha2(-rownum, 512)) from db_class a, db_class b, db_class c, db_class d limit 200000;
-- rows with NULL key parts for the composite index
insert into t_idx values (200001, null, 1, 200001, null, null, 'n'), (200002, 5, null, 200002, 'k', null, 'n'), (200003, null, null, 200003, null, null, 'n');
create index i_a on t_idx (a);
create index i_ab on t_idx (a, b);
create index i_e on t_idx (e desc);
create index i_s on t_idx (s);
create index i_d on t_idx (d);
create index i_pad on t_idx (id, pad);
create index i_fn on t_idx (lower(s));
-- one join partner for groups 0 to 5
create table t_small (g int, k int);
insert into t_small values (0, 10), (1, 20), (2, 30), (3, 40), (4, 50), (5, 60);
-- 100,000 distinct keys inserted after the index exists: leaf splits leave 510 fence keys (257 pages)
create table t_fence (id int, a int);
create index i_fa on t_fence (a);
insert into t_fence select rownum, mod(rownum * 7919, 100003) from db_class a, db_class b, db_class c, db_class d limit 100000;
-- the same keys loaded before the index is built: no fence keys (122 to 156 pages)
create table t_bulk (id int, a int);
insert into t_bulk select id, a from t_fence;
create index i_ba on t_bulk (a);
-- three partitions of 40,000 rows with a local index of 232 to 242 pages each, and an empty partition
create table t_part (id int, a int, c varchar(64)) partition by range (id) (partition pa values less than (40001), partition pb values less than (80001), partition pc values less than (120001), partition pd values less than maxvalue);
insert into t_part select rownum, mod(rownum, 2000), sha2(rownum, 256) from db_class a, db_class b, db_class c, db_class d limit 120000;
create index i_pa on t_part (a, c);
update statistics on t_idx, t_small, t_fence, t_bulk, t_part with fullscan;

set trace on;


evaluate 'Case 1: without a hint a wide range over a large index runs in parallel; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(cast(e as bigint)) from t_idx where id >= 100 using index i_pad;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where id >= 100 using index i_pad;
select /*+ recompile */ count(*), max(pad) from t_idx where id >= 100 using index i_pad;
show trace;
select /*+ recompile no_parallel_scan */ count(*), max(pad) from t_idx where id >= 100 using index i_pad;
select /*+ recompile */ count(*) from t_idx where id >= 100 using index i_pad;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_idx where id >= 100 using index i_pad;
select /*+ recompile */ count(*), sum(cast(e as bigint)) from t_idx where id >= 100 and e < 30000 using index i_pad;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where id >= 100 and e < 30000 using index i_pad;


evaluate 'Case 2: PARALLEL(4) runs smaller indexes in parallel; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 using index i_a;
select /*+ recompile parallel(4) */ count(*), max(b), sum(a) from t_idx where a >= 0 using index i_ab;
show trace;
select /*+ recompile no_parallel_scan */ count(*), max(b), sum(a) from t_idx where a >= 0 using index i_ab;
select /*+ recompile parallel(4) */ count(*) from t_idx where a >= 0 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_idx where a >= 0 using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 and e < 30000 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 and e < 30000 using index i_a;


evaluate 'Case 3: rows are gathered as a mergeable list; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(x.id), min(x.id), max(x.id) from (select /*+ no_merge parallel(4) */ id from t_idx force index (i_a) where a = 77) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(x.id), min(x.id), max(x.id) from (select /*+ no_merge no_parallel_scan */ id from t_idx force index (i_a) where a = 77) x;
select /*+ recompile */ count(*), sum(x.id), sum(x.b), max(x.id) from (select /*+ no_merge parallel(4) */ id, b from t_idx force index (i_a) where a in (2, 3777)) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(x.id), sum(x.b), max(x.id) from (select /*+ no_merge no_parallel_scan */ id, b from t_idx force index (i_a) where a in (2, 3777)) x;
select /*+ recompile parallel(4) */ b, count(*), sum(cast(e as bigint)) from t_idx force index (i_a) where a >= 100 group by b order by b;
select /*+ recompile no_parallel_scan */ b, count(*), sum(cast(e as bigint)) from t_idx force index (i_a) where a >= 100 group by b order by b;


evaluate 'Case 4: each range operator and ranges below and above every key; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a > 10 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a > 10 using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a >= 10 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a >= 10 using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a < 10 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a < 10 using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a <= 10 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a <= 10 using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a = 10 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a = 10 using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a > 10 and a < 20 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a > 10 and a < 20 using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a >= -5 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a >= -5 using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a > 3999 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a > 3999 using index i_a;


evaluate 'Case 5: IN lists with duplicates and absent values and overlapping OR ranges; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a in (7, 3, 7, 5, 3) using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a in (7, 3, 7, 5, 3) using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a in (-1, 1500, 9999) using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a in (-1, 1500, 9999) using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a in (0, 1500, 3999) using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a in (0, 1500, 3999) using index i_a;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where (a between 10 and 100 or a between 50 and 200 or a > 3900) using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where (a between 10 and 100 or a between 50 and 200 or a > 3900) using index i_a;


evaluate 'Case 6: a descending index with a range, OR ranges and an IN list; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(a as bigint)) from t_idx where e > 100 and e <= 190000 using index i_e;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(a as bigint)) from t_idx where e > 100 and e <= 190000 using index i_e;
select /*+ recompile parallel(4) */ count(*), sum(cast(a as bigint)) from t_idx where (e between 10 and 1000 or e between 500 and 3000) using index i_e;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(a as bigint)) from t_idx where (e between 10 and 1000 or e between 500 and 3000) using index i_e;
select /*+ recompile parallel(4) */ count(*), sum(cast(a as bigint)) from t_idx where e in (300, 5, 100, 5) using index i_e;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(a as bigint)) from t_idx where e in (300, 5, 100, 5) using index i_e;


evaluate 'Case 7: USE_DESC_IDX on an ascending and on a descending index; result = no_parallel_scan';
select /*+ recompile parallel(4) use_desc_idx */ count(*), sum(cast(e as bigint)) from t_idx where a > 100 using index i_a;
show trace;
select /*+ recompile no_parallel_scan use_desc_idx */ count(*), sum(cast(e as bigint)) from t_idx where a > 100 using index i_a;
select /*+ recompile parallel(4) use_desc_idx */ count(*), sum(cast(a as bigint)) from t_idx where e between 1000 and 90000 using index i_e;
show trace;
select /*+ recompile no_parallel_scan use_desc_idx */ count(*), sum(cast(a as bigint)) from t_idx where e between 1000 and 90000 using index i_e;
select /*+ recompile parallel(4) use_desc_idx */ count(*), sum(cast(a as bigint)) from t_idx where (e between 10 and 1000 or e between 500 and 3000) using index i_e;
show trace;
select /*+ recompile no_parallel_scan use_desc_idx */ count(*), sum(cast(a as bigint)) from t_idx where (e between 10 and 1000 or e between 500 and 3000) using index i_e;
select /*+ recompile parallel(4) use_desc_idx */ count(*), sum(cast(a as bigint)) from t_idx where e in (300, 5, 100, 5) using index i_e;
show trace;
select /*+ recompile no_parallel_scan use_desc_idx */ count(*), sum(cast(a as bigint)) from t_idx where e in (300, 5, 100, 5) using index i_e;


evaluate 'Case 8: a composite index skips NULL key parts and takes a second-column range and a key filter; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a < 10 using index i_ab;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a < 10 using index i_ab;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a = 5 and b < 3 using index i_ab;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a = 5 and b < 3 using index i_ab;
select /*+ recompile parallel(4) */ count(*), sum(b) from t_idx where a >= 0 and b > 2 using index i_ab;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(b) from t_idx where a >= 0 and b > 2 using index i_ab;


evaluate 'Case 9: string, date and function index keys; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where s between 'k00100' and 'k00200' using index i_s;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where s between 'k00100' and 'k00200' using index i_s;
select /*+ recompile parallel(4) */ count(*), min(s), max(s) from t_idx where s >= '' using index i_s;
show trace;
select /*+ recompile no_parallel_scan */ count(*), min(s), max(s) from t_idx where s >= '' using index i_s;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where d between date'2026-03-01' and date'2026-03-31' using index i_d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where d between date'2026-03-01' and date'2026-03-31' using index i_d;
select /*+ recompile parallel(4) */ count(*), min(d), max(d) from t_idx where d >= date'2026-01-01' using index i_d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), min(d), max(d) from t_idx where d >= date'2026-01-01' using index i_d;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where lower(s) < 'k00500' using index i_fn;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where lower(s) < 'k00500' using index i_fn;


evaluate 'Case 10: an index built by inserts holds fence keys, which are not rows, and a bulk-built one has none; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)) from t_fence force index (i_fa) where a >= 0;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)) from t_fence force index (i_fa) where a >= 0;
select /*+ recompile parallel(4) */ count(a), max(a), min(a) from t_fence force index (i_fa) where a > 0;
show trace;
select /*+ recompile no_parallel_scan */ count(a), max(a), min(a) from t_fence force index (i_fa) where a > 0;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)) from t_fence force index (i_fa) where a <= 600;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)) from t_fence force index (i_fa) where a <= 600;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)) from t_fence force index (i_fa) where a between 40000 and 60000;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)) from t_fence force index (i_fa) where a between 40000 and 60000;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)) from t_fence force index (i_fa) where a >= 99500;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)) from t_fence force index (i_fa) where a >= 99500;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)) from t_bulk force index (i_ba) where a >= 0;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)) from t_bulk force index (i_ba) where a >= 0;


evaluate 'Case 11: a partitioned table with an empty partition, with and without pruning; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)) from t_part where a >= 0 using index i_pa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)) from t_part where a >= 0 using index i_pa;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)) from t_part where a >= 0 and id > 50000 using index i_pa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)) from t_part where a >= 0 and id > 50000 using index i_pa;


evaluate 'Case 12: rows the open transaction deleted or updated, and aggregates that start at NULL values; result = no_parallel_scan';
autocommit off;
delete from t_idx where id <= 1000 or id between 90000 and 91000 or id > 199000;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 using index i_a;
select /*+ recompile parallel(4) */ count(*), max(b), sum(a) from t_idx where a >= 0 using index i_ab;
show trace;
select /*+ recompile no_parallel_scan */ count(*), max(b), sum(a) from t_idx where a >= 0 using index i_ab;
update t_idx set b = null where a < 100;
select /*+ recompile parallel(4) */ count(b), sum(b), round(avg(b), 2), min(b), max(b), round(stddev(b), 2) from t_idx where a >= 0 using index i_ab;
show trace;
select /*+ recompile no_parallel_scan */ count(b), sum(b), round(avg(b), 2), min(b), max(b), round(stddev(b), 2) from t_idx where a >= 0 using index i_ab;
rollback;
autocommit on;


evaluate 'Case 13: a prepared statement executed with two ranges; result = no_parallel_scan';
prepare st_par from 'select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a between ? and ? using index i_a';
prepare st_ser from 'select /*+ recompile no_parallel_scan */ count(*), sum(cast(e as bigint)) from t_idx where a between ? and ? using index i_a';
execute st_par using 10, 20;
show trace;
execute st_ser using 10, 20;
execute st_par using 400, 3999;
show trace;
execute st_ser using 400, 3999;
deallocate prepare st_par;
deallocate prepare st_ser;


evaluate 'Case 14: an index scan in a derived table, as the outer and the inner of a join, in a UNION ALL arm; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(cast(d.e as bigint)) from (select /*+ no_merge parallel(4) */ a, e from t_idx force index (i_a) where a >= 0) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(d.e as bigint)) from (select /*+ no_merge no_parallel_scan */ a, e from t_idx force index (i_a) where a >= 0) d;
select /*+ recompile ordered use_nl parallel(4) */ count(*), sum(s.k) from t_idx t force index (i_a), t_small s where t.a >= 0 and s.g = t.b;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(s.k) from t_idx t force index (i_a), t_small s where t.a >= 0 and s.g = t.b;
select /*+ recompile ordered use_nl parallel(4) */ count(*), sum(s.k) from t_small s, t_idx t force index (i_a) where t.a >= 0 and s.g = t.b;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(s.k) from t_small s, t_idx t force index (i_a) where t.a >= 0 and s.g = t.b;
select /*+ recompile ordered use_nl parallel(4) */ count(*), sum(s.k) from t_small s, t_small x, t_idx t force index (i_a) where t.a >= 0 and s.g = x.g and x.g = t.b;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(s.k) from t_small s, t_small x, t_idx t force index (i_a) where t.a >= 0 and s.g = x.g and x.g = t.b;
select /*+ recompile parallel(4) */ count(*) from t_idx where a >= 0 using index i_a union all select /*+ recompile */ count(*) from t_idx where a = 3 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_idx where a >= 0 using index i_a union all select /*+ recompile no_parallel_scan */ count(*) from t_idx where a = 3 using index i_a;


evaluate 'Case 15: KEYLIMIT, MIN/MAX, order skip, ROWNUM, analytic, PARALLEL(1) and NO_PARALLEL_SCAN keep the scan serial, the old hint does not; result = no_parallel_scan';
select /*+ recompile parallel(4) */ id from t_idx where a > 10 using index i_a keylimit 5;
show trace;
select /*+ recompile no_parallel_scan */ id from t_idx where a > 10 using index i_a keylimit 5;
select /*+ recompile parallel(4) */ min(a), max(a) from t_idx;
show trace;
select /*+ recompile no_parallel_scan */ min(a), max(a) from t_idx;
select /*+ recompile parallel(4) */ a, b from t_idx where a >= 3999 and b = 5 using index i_ab order by a, b;
show trace;
select /*+ recompile no_parallel_scan */ a, b from t_idx where a >= 3999 and b = 5 using index i_ab order by a, b;
select /*+ recompile parallel(4) */ count(*) from t_idx where a >= 0 and rownum <= 5000 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_idx where a >= 0 and rownum <= 5000 using index i_a;
select /*+ recompile parallel(4) */ a, rank() over (order by a) from t_idx where a >= 3999 and b = 5 using index i_a;
show trace;
select /*+ recompile no_parallel_scan */ a, rank() over (order by a) from t_idx where a >= 3999 and b = 5 using index i_a;
select /*+ recompile parallel(1) */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 using index i_a;
show trace;
select /*+ recompile no_parallel_scan parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 using index i_a;
show trace;
select /*+ recompile no_parallel_heap_scan parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 using index i_a;
show trace;


evaluate 'Case 16: the JSON trace names the parallel index scan parallel index; result = Case 2';
set trace on output json;
select /*+ recompile parallel(4) */ count(*), sum(cast(e as bigint)) from t_idx where a >= 0 using index i_a;
show trace;
select /*+ recompile parallel(4) */ count(*), max(b), sum(a) from t_idx where a >= 0 using index i_ab;
show trace;
-- the next file of the shard starts with text output and trace off
set trace on output text;
set trace off;


drop table t_idx, t_small, t_fence, t_bulk, t_part;
