/**
 *  This test case verifies CBRD-26722: a parallel index scan reads keys whose OIDs continue in
 *  overflow pages and returns the same rows as the serial index scan.
 *
 *  A leaf record keeps at most an eighth of a page of OIDs, and the rest of a key's OIDs go to a
 *  chain of overflow pages. In a parallel index scan the worker that reaches such a key reads its
 *  leaf part and hands the chain to a shared pool, and idle workers read the overflow pages of the
 *  chain with their own copy of the key. The cases of cbrd_26722_index keep 50 rows a key, so they
 *  never reach this path.
 *
 *  A parallel index scan prints a parallel workers line with an index time under its SCAN line.
 *  CTP masks the digits, so only the line and its tokens (gather, covered, lookup) are asserted.
 *  Each query is followed by its no_parallel_scan twin, whose result must be the same.
 *
 *  Coverage:
 *    Case 1:  every key: covering, count only, lookup, a data filter
 *    Case 2:  one long chain alone, ranges across short and long chains, an IN list, USE_DESC_IDX
 *    Case 3:  rows gathered as a mergeable list for a derived table, grouped per key
 *    Case 4:  rows the open transaction deleted, moved into a long chain or updated
 */

drop table if exists t_ovf;

-- 150,000 rows: keys 0 to 299 hold 400 rows each and keys 300 to 302 hold 10,000 rows each, while a
-- leaf record holds at most 2 KB of OIDs, so every key continues in overflow pages, one page for a
-- short key and a chain of up to 16 for a long one; b = id mod 7. SHOW INDEX CAPACITY: 364 pages
-- (15 leaf, 348 overflow), 11x the 32 pages a hinted scan needs
create table t_ovf (id int, a int, b int);
insert into t_ovf select rownum, case when rownum <= 120000 then mod(rownum, 300) else 300 + mod(rownum, 3) end, mod(rownum, 7) from db_class a, db_class b, db_class c, db_class d limit 150000;
create index i_oa on t_ovf (a);
update statistics on t_ovf with fullscan;

set trace on;


evaluate 'Case 1: every key with covering, count only, lookup and a data filter; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(a) from t_ovf where a >= 0 using index i_oa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(a) from t_ovf where a >= 0 using index i_oa;
select /*+ recompile parallel(4) */ count(*) from t_ovf where a >= 0 using index i_oa;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_ovf where a >= 0 using index i_oa;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)), sum(b) from t_ovf where a >= 0 using index i_oa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)), sum(b) from t_ovf where a >= 0 using index i_oa;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)) from t_ovf where a >= 0 and b < 3 using index i_oa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)) from t_ovf where a >= 0 and b < 3 using index i_oa;


evaluate 'Case 2: one long chain alone, ranges across short and long chains, an IN list and USE_DESC_IDX; result = no_parallel_scan';
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)), sum(b) from t_ovf where a = 301 using index i_oa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)), sum(b) from t_ovf where a = 301 using index i_oa;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)), sum(a) from t_ovf where a between 150 and 301 using index i_oa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)), sum(a) from t_ovf where a between 150 and 301 using index i_oa;
select /*+ recompile parallel(4) */ count(*), sum(cast(id as bigint)), sum(a) from t_ovf where a in (302, 5, 300, 150, 5) using index i_oa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(id as bigint)), sum(a) from t_ovf where a in (302, 5, 300, 150, 5) using index i_oa;
select /*+ recompile parallel(4) use_desc_idx */ count(*), sum(cast(id as bigint)), sum(a) from t_ovf where a > 100 using index i_oa;
show trace;
select /*+ recompile no_parallel_scan use_desc_idx */ count(*), sum(cast(id as bigint)), sum(a) from t_ovf where a > 100 using index i_oa;


evaluate 'Case 3: rows are gathered as a mergeable list, grouped per key; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(cast(x.id as bigint)), min(x.id), max(x.id) from (select /*+ no_merge parallel(4) */ id from t_ovf force index (i_oa) where a in (0, 301)) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(x.id as bigint)), min(x.id), max(x.id) from (select /*+ no_merge no_parallel_scan */ id from t_ovf force index (i_oa) where a in (0, 301)) x;
select /*+ recompile */ x.a, count(*), sum(cast(x.id as bigint)), sum(x.b) from (select /*+ no_merge parallel(4) */ id, a, b from t_ovf force index (i_oa) where a >= 297) x group by x.a order by x.a;
select /*+ recompile no_parallel_scan */ x.a, count(*), sum(cast(x.id as bigint)), sum(x.b) from (select /*+ no_merge no_parallel_scan */ id, a, b from t_ovf force index (i_oa) where a >= 297) x group by x.a order by x.a;


evaluate 'Case 4: rows the open transaction deleted, moved into a long chain or updated; result = no_parallel_scan';
autocommit off;
-- half of a long chain and every seventh row of keys 0 to 99 go, and the rest of key 0 moves into the chain of key 302
delete from t_ovf where (a = 301 and id <= 135000) or (a < 100 and b = 0);
update t_ovf set a = 302 where a = 0;
update t_ovf set b = null where a = 300;
select /*+ recompile parallel(4) */ count(*), sum(a), count(b), sum(b) from t_ovf where a >= 0 using index i_oa;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(a), count(b), sum(b) from t_ovf where a >= 0 using index i_oa;
select /*+ recompile */ x.a, count(*), sum(cast(x.id as bigint)), count(x.b) from (select /*+ no_merge parallel(4) */ id, a, b from t_ovf force index (i_oa) where a >= 299 or a <= 1) x group by x.a order by x.a;
select /*+ recompile no_parallel_scan */ x.a, count(*), sum(cast(x.id as bigint)), count(x.b) from (select /*+ no_merge no_parallel_scan */ id, a, b from t_ovf force index (i_oa) where a >= 299 or a <= 1) x group by x.a order by x.a;
rollback;
autocommit on;
-- the next file of the shard starts with trace off
set trace off;


drop table t_ovf;
