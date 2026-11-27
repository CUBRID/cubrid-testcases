/**
 *  This test case verifies CBRD-27674: an aggregate without GROUP BY over a nested loop join whose
 *  inner side is JSON_TABLE, a collection or a class attribute scan returns its serial result under
 *  a parallel heap scan.
 *
 *  Before the fix such a query was given to the parallel workers as one value each (gather
 *  buildvalue), and a worker cannot open that inner scan, so the query failed with an internal
 *  assertion (-588) or aborted the server. Now the outer heap scan stays parallel and the leader
 *  runs the join (gather row by row). Inner heaps, indexes and derived tables keep buildvalue.
 *
 *  Every tested query is followed by its no_parallel_scan twin and the two result blocks must
 *  match. The line (parallel workers: ?, ... gather: ...) under the scan of t_outer shows the
 *  gather kind. CTP masks digits, so only that token is checked.
 *
 *  Coverage:
 *    Case 1:  JSON_TABLE inner (the issue), row by row
 *    Case 2:  SET and LIST column inner through TABLE (), row by row
 *    Case 3:  other aggregates over the JSON_TABLE and SET inners
 *    Case 4:  constant SET and constant JSON_TABLE inner
 *    Case 5:  JSON_TABLE inner that returns no rows
 *    Case 6:  JSON_TABLE inner first, middle and last among other inners
 *    Case 7:  class attribute inner (CLASS ...), row by row
 *    Case 8:  heap, index and derived table inner keep buildvalue
 */

drop table if exists t_outer, t_heap, t_keyed, t_meta;

-- 20000 rows of about 290 bytes: about 400 heap pages, 12x the 32-page parallel scan threshold of test_mode
-- the row id decides how many elements j, st and ls hold (1, 2 or 3), so a lost or doubled row changes the sums
create table t_outer (id int, j json, st set (int), ls list (int), pad varchar (200));
insert into t_outer select rownum, case mod (rownum, 3) when 0 then '[1]' when 1 then '[1, 2]' else '[1, 2, 3]' end, case mod (rownum, 3) when 0 then {1} when 1 then {1, 2} else {1, 2, 3} end, case mod (rownum, 3) when 0 then {5} when 1 then {5, 5} else {5, 6, 7} end, repeat ('x', 150) from db_class a, db_class b, db_class c limit 20000;
-- seven rows read by every outer row: one page, never scanned in parallel itself
create table t_heap (k int, v int);
insert into t_heap select rownum - 1, rownum * 10 from db_class limit 7;
create table t_keyed (k int primary key, v int);
insert into t_keyed select k, v from t_heap;
create class t_meta class attribute (ca int) (x int);
update class t_meta set ca = 7;
update statistics on t_outer, t_heap, t_keyed with fullscan;

set trace on;


evaluate 'Case 1: JSON_TABLE inner, row by row; result = no_parallel_scan';
select /*+ recompile */ count (*), sum (jt.x), sum (cast (t.id as bigint) * jt.x) from t_outer t, json_table (t.j, '$[*]' columns (x int path '$')) as jt;
show trace;
select /*+ recompile no_parallel_scan */ count (*), sum (jt.x), sum (cast (t.id as bigint) * jt.x) from t_outer t, json_table (t.j, '$[*]' columns (x int path '$')) as jt;


evaluate 'Case 2: SET and LIST column inner, row by row; result = no_parallel_scan';
select /*+ recompile */ count (*), sum (s.v), sum (cast (t.id as bigint) * s.v) from t_outer t, table (t.st) as s (v);
show trace;
select /*+ recompile no_parallel_scan */ count (*), sum (s.v), sum (cast (t.id as bigint) * s.v) from t_outer t, table (t.st) as s (v);
select /*+ recompile */ count (*), sum (l.v), sum (cast (t.id as bigint) * l.v) from t_outer t, table (t.ls) as l (v);
show trace;
select /*+ recompile no_parallel_scan */ count (*), sum (l.v), sum (cast (t.id as bigint) * l.v) from t_outer t, table (t.ls) as l (v);


evaluate 'Case 3: other aggregates over the JSON_TABLE and SET inners; result = no_parallel_scan';
select /*+ recompile */ min (jt.x), max (t.id), round (avg (jt.x), 4), count (distinct jt.x), min (t.id * jt.x) from t_outer t, json_table (t.j, '$[*]' columns (x int path '$')) as jt;
select /*+ recompile no_parallel_scan */ min (jt.x), max (t.id), round (avg (jt.x), 4), count (distinct jt.x), min (t.id * jt.x) from t_outer t, json_table (t.j, '$[*]' columns (x int path '$')) as jt;
select /*+ recompile */ max (s.v), round (avg (cast (t.id as bigint) * s.v), 4), group_concat (distinct s.v order by s.v) from t_outer t, table (t.st) as s (v) having count (*) > 0;
select /*+ recompile no_parallel_scan */ max (s.v), round (avg (cast (t.id as bigint) * s.v), 4), group_concat (distinct s.v order by s.v) from t_outer t, table (t.st) as s (v) having count (*) > 0;


evaluate 'Case 4: constant SET and constant JSON_TABLE inner; result = no_parallel_scan';
select /*+ recompile ordered */ count (*), sum (cast (t.id as bigint) * s.v) from t_outer t, table ({1, 2, 3}) as s (v);
show trace;
select /*+ recompile ordered no_parallel_scan */ count (*), sum (cast (t.id as bigint) * s.v) from t_outer t, table ({1, 2, 3}) as s (v);
select /*+ recompile ordered */ count (*), sum (cast (t.id as bigint) * jt.x) from t_outer t, json_table ('[1, 2, 3]', '$[*]' columns (x int path '$')) as jt;
show trace;
select /*+ recompile ordered no_parallel_scan */ count (*), sum (cast (t.id as bigint) * jt.x) from t_outer t, json_table ('[1, 2, 3]', '$[*]' columns (x int path '$')) as jt;


evaluate 'Case 5: JSON_TABLE inner with no rows; result = no_parallel_scan';
select /*+ recompile */ count (*), sum (jt.x) from t_outer t, json_table (t.j, '$.none[*]' columns (x int path '$')) as jt;
show trace;
select /*+ recompile no_parallel_scan */ count (*), sum (jt.x) from t_outer t, json_table (t.j, '$.none[*]' columns (x int path '$')) as jt;


evaluate 'Case 6: JSON_TABLE inner first, middle and last among other inners; result = no_parallel_scan';
select /*+ recompile ordered use_nl */ count (*), sum (cast (t.id as bigint) * jt.x + h.v) from t_outer t, t_heap h, json_table (t.j, '$[*]' columns (x int path '$')) as jt where h.k = mod (t.id, 7);
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count (*), sum (cast (t.id as bigint) * jt.x + h.v) from t_outer t, t_heap h, json_table (t.j, '$[*]' columns (x int path '$')) as jt where h.k = mod (t.id, 7);
select /*+ recompile ordered use_nl */ count (*), sum (cast (t.id as bigint) * jt.x + h.v) from t_outer t, json_table (t.j, '$[*]' columns (x int path '$')) as jt, t_heap h where h.k = jt.x;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count (*), sum (cast (t.id as bigint) * jt.x + h.v) from t_outer t, json_table (t.j, '$[*]' columns (x int path '$')) as jt, t_heap h where h.k = jt.x;
select /*+ recompile ordered */ count (*), sum (cast (t.id as bigint) * jt.x * s.v) from t_outer t, json_table (t.j, '$[*]' columns (x int path '$')) as jt, table (t.st) as s (v);
show trace;
select /*+ recompile ordered no_parallel_scan */ count (*), sum (cast (t.id as bigint) * jt.x * s.v) from t_outer t, json_table (t.j, '$[*]' columns (x int path '$')) as jt, table (t.st) as s (v);


evaluate 'Case 7: class attribute inner, row by row; result = no_parallel_scan';
select /*+ recompile ordered */ count (*), sum (cast (t.id as bigint) * m.ca) from t_outer t, class t_meta m;
show trace;
select /*+ recompile ordered no_parallel_scan */ count (*), sum (cast (t.id as bigint) * m.ca) from t_outer t, class t_meta m;


evaluate 'Case 8: heap, index and derived table inner keep buildvalue; result = no_parallel_scan';
select /*+ recompile ordered use_nl */ count (*), sum (cast (t.id as bigint) * h.v) from t_outer t, t_heap h where h.k = mod (t.id, 7);
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count (*), sum (cast (t.id as bigint) * h.v) from t_outer t, t_heap h where h.k = mod (t.id, 7);
select /*+ recompile ordered use_nl */ count (*), sum (cast (t.id as bigint) * h.v) from t_outer t, t_keyed h where h.k = mod (t.id, 7);
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count (*), sum (cast (t.id as bigint) * h.v) from t_outer t, t_keyed h where h.k = mod (t.id, 7);
select /*+ recompile ordered use_nl */ count (*), sum (cast (t.id as bigint) * d.v) from t_outer t, (select /*+ no_merge */ k, v from t_heap) d where d.k = mod (t.id, 7);
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile ordered use_nl no_parallel_scan */ count (*), sum (cast (t.id as bigint) * d.v) from t_outer t, (select /*+ no_merge no_parallel_scan */ k, v from t_heap) d where d.k = mod (t.id, 7);

drop table t_outer, t_heap, t_keyed, t_meta;
