/**
 *  This test case verifies CBRD-28104: a parallel query whose index scan walks its range backward
 *  from a bound past every key of a leaf failed with "slot N on page P ... is not allocated" when
 *  its aggregate held ROUND.
 *
 *  A parallel index scan that walks a range backward took the slot after the last key of the leaf
 *  as its start when the range bound lay past every key of that leaf. It read that slot, which
 *  holds no record, and skipped it with the error left set. ROUND returns the error it finds set,
 *  so the query failed although every row was read. The scan now starts at the last key. GROUP BY
 *  c0 reads the descending index backward, and GROUP BY c0 DESC reads the ascending index backward.
 *  The grouped rows are counted in a derived table to keep the answer short.
 *
 *  Coverage:
 *    Case 1:  MIN (ROUND (...)) grouped by c0 over c0 > -32000 runs in parallel and returns every group
 *    Case 2:  the reported form MIN (CAST (ROUND (...) AS VARCHAR)) returns every group
 *    Case 3:  a bound between two keys, c0 > -15000 with no key -15000, keeps its result
 *    Case 4:  the ascending index read backward by GROUP BY c0 DESC over c0 < 32000
 *    Case 5:  controls - the serial scan, an aggregate without ROUND, no index and the ascending
 *             index read forward
 */
drop table if exists t_dsc, t_asc;
create table t_dsc (c0 smallint);
-- 60000 keys from -30000 to 30000 without -15000: the index has about 63 leaf pages, over the
-- parallel scan threshold of 32 pages that test_mode sets, and Case 3 bounds the gap
insert into t_dsc select rownum - 30001 from db_class a, db_class b, db_class c limit 15000;
insert into t_dsc select rownum - 15000 from db_class a, db_class b, db_class c limit 45000;
insert into t_dsc values (null), (null);
create unique index i_dsc on t_dsc (c0 desc);
create table t_asc (c0 smallint);
insert into t_asc select c0 from t_dsc;
create unique index i_asc on t_asc (c0);
update statistics on t_dsc, t_asc with fullscan;

evaluate 'Case 1: MIN (ROUND) over c0 > -32000 in parallel; result = 60000, -30000, 30000';
set trace on;
select count (*), min (m), max (m) from (select /*+ parallel(4) */ c0, min (round (cast (c0 as double))) m from t_dsc where c0 > -32000 group by c0) d;
show trace;
set trace off;

evaluate 'Case 2: MIN (CAST (ROUND AS VARCHAR)) over c0 > -32000 in parallel; result = 60000 groups';
select count (*), min (m), max (m) from (select /*+ parallel(4) */ c0, min (cast (round (cast (c0 as double)) as varchar)) m from t_dsc where c0 > -32000 group by c0) d;

evaluate 'Case 3: c0 > -15000, a bound between two keys; result = 45000, -14999, 30000';
select count (*), min (m), max (m) from (select /*+ parallel(4) */ c0, min (round (cast (c0 as double))) m from t_dsc where c0 > -15000 group by c0) d;

evaluate 'Case 4: the ascending index read backward by GROUP BY c0 DESC over c0 < 32000; result = 60000, -30000, 30000';
select count (*), min (m), max (m) from (select /*+ parallel(4) */ c0, min (round (cast (c0 as double))) m from t_asc where c0 < 32000 group by c0 desc) d;

evaluate 'Case 5: controls - serial, no ROUND, no index and the ascending index forward return the groups of Case 1 and 2';
select count (*), min (m), max (m) from (select /*+ parallel(1) */ c0, min (round (cast (c0 as double))) m from t_dsc where c0 > -32000 group by c0) d;
select count (*), min (m), max (m) from (select /*+ parallel(4) */ c0, min (cast (cast (c0 as double) as varchar)) m from t_dsc where c0 > -32000 group by c0) d;
select count (*), min (m), max (m) from (select /*+ parallel(4) */ c0, min (round (cast (c0 as double))) m from t_dsc where c0 > -32000 group by c0 using index none) d;
select count (*), min (m), max (m) from (select /*+ parallel(4) */ c0, min (round (cast (c0 as double))) m from t_asc where c0 > -32000 group by c0) d;

drop table t_dsc, t_asc;
