/**
 *  This test case verifies CBRD-26722: a scan over a list (a derived table, a view or a CTE result)
 *  runs in parallel and returns the same rows as the serial scan.
 *
 *  Before the fix only heap scans ran in parallel and every list scan was serial. Now a list of
 *  enough pages that is no longer in memory is split among workers, which merge aggregates
 *  (buildvalue) or rows (mergeable list); shapes that cannot be merged stay serial.
 *
 *  The list scan prints a parallel workers line with a temp time under its SCAN line; CTP masks
 *  the digits, so only the line and its gather token are asserted. Each query is followed by its
 *  twin with no_parallel_scan in every block, whose result must be the same.
 *
 *  Coverage:
 *    Case 1:  aggregates over a derived table, gather buildvalue
 *    Case 2:  every aggregate the buildvalue gather supports
 *    Case 3:  COUNT(*) alone over a derived table
 *    Case 4:  a UNION ALL derived table and a view over UNION ALL
 *    Case 5:  rows gathered as a mergeable list: a filter on the list, DISTINCT, GROUP BY
 *    Case 6:  a filter evaluated by the workers: many rows, first middle and last rows, none
 *    Case 7:  the list drives a nested loop join with a heap inner and with a list inner
 *    Case 8:  a materialized CTE and the result of a recursive CTE
 *    Case 9:  rows longer than a page: alone, at the start and end, in the middle of the list
 *    Case 10: serial: a small list, ROWNUM, CONNECT BY, a CTE read by scalar subqueries
 *    Case 11: the JSON trace names the parallel list scan parallel temp
 */

drop table if exists t_heap, t_small, t_mid, t_wide;

-- 100,000 rows of 168 bytes (a 128-character sha2 string that does not compress): 1,177 heap pages,
-- and a derived table over all columns is a list of similar size, 36x the scan threshold of 32 pages
-- under CTP; g puts 1, 2, 4, 8, 16 and 32 of every 63 rows into groups 0 to 5
create table t_heap (id int, g int, v int, pad varchar(128));
insert into t_heap select rownum, case when mod(rownum, 63) < 1 then 0 when mod(rownum, 63) < 3 then 1 when mod(rownum, 63) < 7 then 2 when mod(rownum, 63) < 15 then 3 when mod(rownum, 63) < 31 then 4 else 5 end, mod(rownum, 1000), sha2(rownum, 512) from db_class a, db_class b, db_class c, db_class d limit 100000;
-- one join partner per group
create table t_small (g int, k int);
insert into t_small values (0, 10), (1, 20), (2, 30), (3, 40), (4, 50), (5, 60);
-- ten rows per group
create table t_mid (g int, k int);
insert into t_mid select mod(rownum, 6), rownum from db_class a limit 60;
-- 40 rows of 20,480 characters (160 distinct sha2 strings): every row is longer than a 16 KB page
set system parameters 'group_concat_max_len=40000';
create table t_wide (id int, w varchar(40000));
insert into t_wide select o.id, (select group_concat(sha2(o.id * 1000 + i.id, 512) separator '') from t_heap i where i.id <= 160) from t_heap o where o.id <= 40;
set system parameters 'group_concat_max_len=default';
update statistics on t_heap, t_small, t_mid, t_wide with fullscan;

set trace on;


evaluate 'Case 1: aggregates over a derived table run in parallel with gather buildvalue; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(d.v), min(d.id), max(d.id) from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(d.v), min(d.id), max(d.id) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d;


evaluate 'Case 2: every aggregate the buildvalue gather supports; result = no_parallel_scan';
select /*+ recompile */ count(*), count(d.v), sum(d.v), round(avg(d.v), 2), min(d.pad), max(d.pad), round(stddev(d.v), 2), round(variance(d.v), 2) from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), count(d.v), sum(d.v), round(avg(d.v), 2), min(d.pad), max(d.pad), round(stddev(d.v), 2), round(variance(d.v), 2) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d;


evaluate 'Case 3: COUNT(*) alone over a derived table; result = no_parallel_scan';
select /*+ recompile */ count(*) from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d;


evaluate 'Case 4: a UNION ALL derived table and a view over UNION ALL; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(d.v), min(d.id), max(d.id) from (select id, g, v, pad from t_heap union all select id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(d.v), min(d.id), max(d.id) from (select /*+ no_parallel_scan */ id, g, v, pad from t_heap union all select /*+ no_parallel_scan */ id, g, v, pad from t_heap) d;
create view v_union as select id, g, v, pad from t_heap union all select id, g, v, pad from t_heap;
select /*+ recompile */ count(*), sum(v) from v_union;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(v) from v_union;
drop view v_union;


evaluate 'Case 5: rows are gathered as a mergeable list; result = no_parallel_scan';
select /*+ recompile no_push_pred */ d.id, d.g, d.v from (select /*+ no_merge */ id, g, v, pad from t_heap) d where d.id = 50007;
show trace;
select /*+ recompile no_push_pred no_parallel_scan */ d.id, d.g, d.v from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d where d.id = 50007;
select /*+ recompile */ distinct 1 from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile no_parallel_scan */ distinct 1 from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d;
select /*+ recompile */ d.g, count(*), sum(d.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) d group by d.g order by d.g;
select /*+ recompile no_parallel_scan */ d.g, count(*), sum(d.v) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d group by d.g order by d.g;


evaluate 'Case 6: a filter on the list is evaluated by the workers; result = no_parallel_scan';
select /*+ recompile no_push_pred */ count(*), sum(d.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) d where d.v < 500;
show trace;
select /*+ recompile no_push_pred no_parallel_scan */ count(*), sum(d.v) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d where d.v < 500;
select /*+ recompile no_push_pred */ count(*), sum(d.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) d where d.id in (1, 50000, 100000);
show trace;
select /*+ recompile no_push_pred no_parallel_scan */ count(*), sum(d.v) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d where d.id in (1, 50000, 100000);
select /*+ recompile no_push_pred */ count(*), sum(d.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) d where d.v < 0;
show trace;
select /*+ recompile no_push_pred no_parallel_scan */ count(*), sum(d.v) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d where d.v < 0;


evaluate 'Case 7: the list drives a nested loop join with a heap inner and with a list inner; result = no_parallel_scan';
select /*+ recompile ordered use_nl */ count(*), sum(s.k) from (select /*+ no_merge */ id, g, v, pad from t_heap) d, t_small s where d.g = s.g;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(s.k) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d, t_small s where d.g = s.g;
select /*+ recompile ordered use_nl */ count(*), sum(e.k) from (select /*+ no_merge */ id, g, v, pad from t_heap) d, (select /*+ no_merge */ g, k from t_mid) e where d.g = e.g;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(e.k) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d, (select /*+ no_merge no_parallel_scan */ g, k from t_mid) e where d.g = e.g;


evaluate 'Case 8: a materialized CTE and the result of a recursive CTE; result = no_parallel_scan';
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile */ count(*), sum(v), max(id) from c;
show trace;
with c as (select /*+ materialize no_parallel_scan */ id, g, v, pad from t_heap) select /*+ recompile no_parallel_scan */ count(*), sum(v), max(id) from c;
with recursive r(n, p) as (select 1, concat(sha2(1, 512), sha2(-1, 512), sha2(1001, 512), sha2(-1001, 512)) from db_root union all select n + 1, concat(sha2(n + 1, 512), sha2(-n - 1, 512), sha2(n + 1001, 512), sha2(-n - 1001, 512)) from r where n < 2000) select /*+ recompile */ count(*), sum(n), max(p) from r;
show trace;
with recursive r(n, p) as (select 1, concat(sha2(1, 512), sha2(-1, 512), sha2(1001, 512), sha2(-1001, 512)) from db_root union all select n + 1, concat(sha2(n + 1, 512), sha2(-n - 1, 512), sha2(n + 1001, 512), sha2(-n - 1001, 512)) from r where n < 2000) select /*+ recompile no_parallel_scan */ count(*), sum(n), max(p) from r;


evaluate 'Case 9: rows longer than a page alone, at the start and end, and in the middle of the list; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(length(d.w)), min(d.id), max(d.id) from (select /*+ no_merge */ id, w from t_wide) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(length(d.w)), min(d.id), max(d.id) from (select /*+ no_merge no_parallel_scan */ id, w from t_wide) d;
select /*+ recompile */ count(*), sum(length(d.w)), sum(d.id) from (select id, w from t_wide where id <= 20 union all select id, pad from t_heap where id <= 5000 union all select id, w from t_wide where id > 20) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(length(d.w)), sum(d.id) from (select /*+ no_parallel_scan */ id, w from t_wide where id <= 20 union all select /*+ no_parallel_scan */ id, pad from t_heap where id <= 5000 union all select /*+ no_parallel_scan */ id, w from t_wide where id > 20) d;
select /*+ recompile */ count(*), sum(length(d.w)), sum(d.id) from (select id, pad w from t_heap where id <= 3000 union all select id, w from t_wide union all select id, pad from t_heap where id > 97000) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(length(d.w)), sum(d.id) from (select /*+ no_parallel_scan */ id, pad w from t_heap where id <= 3000 union all select /*+ no_parallel_scan */ id, w from t_wide union all select /*+ no_parallel_scan */ id, pad from t_heap where id > 97000) d;


evaluate 'Case 10: a small list, ROWNUM, CONNECT BY and a CTE read by scalar subqueries keep the list scan serial; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(d.v) from (select /*+ no_merge */ id, v from t_heap where id <= 1000) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(d.v) from (select /*+ no_merge no_parallel_scan */ id, v from t_heap where id <= 1000) d;
select /*+ recompile */ count(*) from (select /*+ no_merge */ id, g, v, pad from t_heap) d where rownum <= 50000;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d where rownum <= 50000;
select /*+ recompile */ count(*) from (select /*+ no_merge */ id, v from t_heap) d start with d.id = 1 connect by nocycle prior d.id = d.v;
show trace;
select /*+ recompile no_parallel_scan */ count(*) from (select /*+ no_merge no_parallel_scan */ id, v from t_heap) d start with d.id = 1 connect by nocycle prior d.id = d.v;
with c as (select id, g, v, pad from t_heap where v < 500) select /*+ recompile */ (select count(*) from c) cnt, (select sum(v) from c) total from db_root;
show trace;
with c as (select /*+ no_parallel_scan */ id, g, v, pad from t_heap where v < 500) select /*+ recompile no_parallel_scan */ (select /*+ no_parallel_scan */ count(*) from c) cnt, (select /*+ no_parallel_scan */ sum(v) from c) total from db_root;


evaluate 'Case 11: the JSON trace names the parallel list scan parallel temp; result = Case 1';
set trace on output json;
select /*+ recompile */ count(*), sum(d.v), min(d.id), max(d.id) from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;
-- the next file of the shard starts with text output and trace off
set trace on output text;
set trace off;


drop table t_heap, t_small, t_mid, t_wide;
