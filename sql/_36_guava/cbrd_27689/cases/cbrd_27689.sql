/**
 *  This test case verifies CBRD-27689: Allow parallel index scan when the first ORDER BY column is DESC but the order is not skipped
 *
 *  A DESC first ORDER BY or GROUP BY column used to turn the parallel index scan off even when the sort is not done
 *  by the index. The parallel scan check no longer refuses an index scan for that reason alone: an ORDER BY skipped
 *  by the index still keeps the scan serial, and a GROUP BY skipped by the index runs in parallel since CBRD-27664
 *  (ascending) and CBRD-27728 (DESC first column).
 *
 *  The name prefix groups (Char000 .. Char009) have different sizes, so ORDER BY count DESC and ASC give different
 *  orders. CTP masks digits, so the proof of a parallel scan is the parallel workers line under the index SCAN line of
 *  the trace. Each parallel query of Case 1, 3, 4 and 8 is followed by its twin with NO_PARALLEL_SCAN, and the two
 *  result blocks must match.
 *
 *  Coverage:
 *    Case 1: GROUP BY expression with ORDER BY aggregate DESC, not skipped, runs a parallel index scan
 *    Case 2: the same query with ORDER BY aggregate ASC runs a parallel index scan as before (control)
 *    Case 3: ORDER BY group key DESC, not skipped, runs a parallel index scan
 *    Case 4: GROUP BY expression DESC, not skipped, runs a parallel index scan
 *    Case 5: ORDER BY skipped by a descending index scan stays serial even with a PARALLEL hint, rows in descending order (control)
 *    Case 6: GROUP BY skipped by a descending index scan runs in parallel since CBRD-27728, groups in descending order
 *    Case 7: ORDER BY skipped by an ascending index scan stays serial even with a PARALLEL hint, rows in ascending order (control)
 *    Case 8: a query without GROUP BY, ORDER BY first column DESC, not skipped, runs a parallel index scan
 */

drop table if exists t_27689;
-- 150000 rows: the index i_27689_name has 313 pages, about 10 times the 32 pages that a parallel index scan needs under CTP
-- (the index size at run time is checked against parallel_scan_page_threshold, 256 by default and 32 under CTP, whose
-- sql.conf sets test_mode=yes, and the optimizer estimate of the pages to read against parallel_index_scan_page_threshold,
-- 32), so that the scans of Cases 1 to 4 run in parallel without a hint, and above the default 256 as well
create table t_27689 (id int primary key, name varchar(40) not null, v int not null);
insert into t_27689
with recursive cte (n) as (
    select 1
    union all
    select n + 1 from cte where n < 400
  )
select rownum, 'Char' || lpad (cast (floor (sqrt (rownum - 1) / 40) as int), 3, '0') || '_' || lpad (rownum, 10, '0'), mod (rownum, 1000)
from cte a, cte b
limit 150000;
create index i_27689_name on t_27689 (name);
update statistics on t_27689 with fullscan;

set trace on;

evaluate 'Case 1: GROUP BY expression, ORDER BY aggregate DESC -> parallel index scan';
select /*+ recompile */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by c desc, p;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by c desc, p;

evaluate 'Case 2: same query, ORDER BY aggregate ASC -> parallel index scan (unchanged)';
select /*+ recompile */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by c asc, p;
show trace;

evaluate 'Case 3: ORDER BY group key DESC, not skipped -> parallel index scan';
select /*+ recompile */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by p desc;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ substr (name, 1, 7) p, count (*) c from t_27689 where name like 'Char%' group by substr (name, 1, 7) order by p desc;

evaluate 'Case 4: GROUP BY expression DESC, not skipped -> parallel index scan';
select /*+ recompile */ mod (v, 3) m, count (*) c from t_27689 use index (i_27689_name) where name >= 'Char' group by mod (v, 3) desc;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ mod (v, 3) m, count (*) c from t_27689 use index (i_27689_name) where name >= 'Char' group by mod (v, 3) desc;

-- Cases 5 to 8 read only the last 5 or 10 rows of the index. Without a hint the optimizer keeps such a small range serial
-- (its estimate of the pages to read is below parallel_index_scan_page_threshold), so these cases use the PARALLEL hint,
-- which skips that check, and the trace shows what the parallel scan check of the engine decides
evaluate 'Case 5: ORDER BY skipped by a descending index scan -> serial even with a PARALLEL hint, rows in descending order';
select /*+ recompile PARALLEL(4) */ name from t_27689 where name > 'Char009_0000149990' order by name desc;
show trace;

evaluate 'Case 6: GROUP BY skipped by a descending index scan -> parallel since CBRD-27728, groups in descending order';
select /*+ recompile PARALLEL(4) */ name, count (*) from t_27689 where name > 'Char009_0000149995' group by name desc;
show trace;

evaluate 'Case 7: ORDER BY skipped by an ascending index scan -> serial even with a PARALLEL hint, rows in ascending order';
select /*+ recompile PARALLEL(4) */ name from t_27689 where name > 'Char009_0000149990' order by name;
show trace;

evaluate 'Case 8: no GROUP BY, ORDER BY first column DESC, not skipped -> parallel index scan';
select /*+ recompile PARALLEL(4) */ name, v from t_27689 where name > 'Char009_0000149990' order by v desc, name;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ name, v from t_27689 where name > 'Char009_0000149990' order by v desc, name;

set trace off;
drop table t_27689;
