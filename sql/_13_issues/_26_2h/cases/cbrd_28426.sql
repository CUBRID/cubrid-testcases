/**
 *  This test case verifies CBRD-28426: a scan starts no other statement while it holds an
 *  index leaf or a heap page, and its queries return the rows they returned before.
 *
 *  A key filter was evaluated under the index leaf. An uncorrelated table subquery in it ran
 *  at its first evaluation, and a stored function in it ran its SQL there, which could wait
 *  for a page of the same index until the page latch timed out. The fix runs such a subquery
 *  once before the scan opens, once also for the workers of a parallel scan, and it keeps a
 *  term that calls a stored function out of the key filter.
 *
 *  Each tested query is followed by a twin that must print the same block: the same query
 *  with the index ignored, with no_parallel_scan, or without the stored function. Cases 2
 *  and 3 count the runs of a subquery by the value a serial gives next, and case 4 shows the
 *  term as sargs in its plan. CTP masks the digits of a plan and a trace, so they are read
 *  by their tokens. The page latch timeout itself needs two sessions and is a shell case.
 *
 *  Coverage:
 *    Case 1:  table subquery in a key filter (NOT IN, ALL, SOME, NULL, empty set)
 *    Case 2:  a table subquery runs once when no key reaches the key filter
 *    Case 3:  a table subquery runs once for all workers of a parallel scan
 *    Case 4:  a stored function term is a data filter (sargs), not a key filter
 *    Case 5:  ORDER BY with LIMIT over an IN list keeps its rows next to such a term
 *    Case 6:  outer join ON condition with a stored function over a covering inner scan
 *    Case 7:  GROUPBY_NUM, START WITH and CONNECT BY conditions with a stored function
 */

drop table if exists t_key, t_left, t_right, t_tree, t_big;
drop serial if exists s_cnt;

-- index (a, b, c): a is 1 to 3, b is 1 to 10 for each a, c is 1 for an odd b and 0 for an even b; 30 rows
create table t_key (a int, b int, c int, d varchar (10));
insert into t_key select mod (rownum - 1, 3) + 1, mod ((rownum - 1) / 3, 10) + 1, mod (mod ((rownum - 1) / 3, 10) + 1, 2), 'd' from db_class limit 30;
create index i_key on t_key (a, b, c);
-- join tables: the index of t_right holds every column the queries read from it, so its scans are covering
create table t_left (a int, b int);
insert into t_left values (1, 1), (2, 0), (3, 5);
create table t_right (a int, b int);
insert into t_right values (1, 1), (2, 2), (3, 3);
create index i_right on t_right (a, b);
-- hierarchy: id 1 is the root and each id has the parent id / 2; 15 rows on 4 levels
create table t_tree (id int, pid int);
insert into t_tree select rownum, nullif (rownum / 2, 0) from db_class limit 15;
-- parallel table: 100000 rows, about 220 heap pages, about 7 times the parallel heap scan threshold of test_mode (32 pages)
create table t_big (a int, b int);
insert into t_big select rownum, mod (rownum, 1000) from db_class x, db_class y, db_class z, db_class w limit 100000;
create serial s_cnt;
create or replace function f_same (x int) return int as begin return x; end;
update statistics on t_key, t_left, t_right, t_tree, t_big with fullscan;


evaluate 'Case 1: table subquery in a key filter (NOT IN, ALL, SOME, NULL, empty set); result = index ignored';
--@queryplan
select /*+ recompile */ a, b from t_key where a >= 2 and b not in (select b from t_key where c = 1) order by a, b;
select a, b from t_key ignore index (i_key) where a >= 2 and b not in (select b from t_key where c = 1) order by a, b;
select a, b from t_key where a >= 2 and b + 5 > all (select b from t_key where c = 0) order by a, b;
select a, b from t_key ignore index (i_key) where a >= 2 and b + 5 > all (select b from t_key where c = 0) order by a, b;
select a, b from t_key where a >= 2 and not (b + 7 > all (select b from t_key where c = 1)) order by a, b;
select a, b from t_key ignore index (i_key) where a >= 2 and not (b + 7 > all (select b from t_key where c = 1)) order by a, b;
select a, b from t_key where a >= 2 and b not in (select nullif (b, 3) from t_key where c = 1) order by a, b;
select a, b from t_key ignore index (i_key) where a >= 2 and b not in (select nullif (b, 3) from t_key where c = 1) order by a, b;
select count(*), sum (b) from t_key where a >= 2 and b > all (select b from t_key where c > 1);
select count(*), sum (b) from t_key ignore index (i_key) where a >= 2 and b > all (select b from t_key where c > 1);


evaluate 'Case 2: a table subquery runs once when no key reaches the key filter; the serial gives 2 next, and 4 after the twin';
select a, b from t_key where a > 100 and b not in (select s_cnt.next_value from db_root) order by a, b;
select s_cnt.next_value from db_root;
select a, b from t_key ignore index (i_key) where a > 100 and b not in (select s_cnt.next_value from db_root) order by a, b;
select s_cnt.next_value from db_root;


evaluate 'Case 3: a table subquery runs once for all workers of a parallel scan; the serial gives 6 next; result = no_parallel_scan';
set trace on;
select /*+ recompile parallel(4) */ count(*), sum (b) from t_big where b not in (select s_cnt.next_value + 994 from db_root);
show trace;
-- trace goes off before the queries that no show trace reads: the plan of the query above would stay in the session
set trace off;
select s_cnt.next_value from db_root;
select /*+ no_parallel_scan */ count(*), sum (b) from t_big where b not in (select /*+ no_parallel_scan */ 999 from db_root);


evaluate 'Case 4: a stored function term is a data filter (sargs), not a key filter; result = no function';
--@queryplan
select /*+ recompile */ a, b, c from t_key where a = 1 and c = f_same (c) and b > f_same (4) order by b;
select a, b, c from t_key where a = 1 and b > 4 order by b;


evaluate 'Case 5: ORDER BY with LIMIT over an IN list keeps its rows next to such a term; result = no function';
select count(*), sum (b) from (select a, b, c from t_key where a in (1, 2, 3) and c > f_same (0) order by b limit 5) x;
select count(*), sum (b) from (select a, b, c from t_key where a in (1, 2, 3) and c > 0 order by b limit 5) x;
select count(*), sum (b), max (d) from (select * from t_key where a in (1, 2, 3) and c > f_same (0) order by b limit 5) x;
select count(*), sum (b), max (d) from (select * from t_key where a in (1, 2, 3) and c > 0 order by b limit 5) x;
select count(*), sum (b) from (select a, b, c from t_key where a in (1, 2, 3) and c < index_cardinality ('t_key', 'i_key', 0) + 1 order by b limit 4) x;
select count(*), sum (b) from (select a, b, c from t_key where a in (1, 2, 3) and c < 2 order by b limit 4) x;


evaluate 'Case 6: outer join ON condition with a stored function over a covering inner scan; result = no function';
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on r.a > 0 and r.b > f_same (l.b) order by 1, 2;
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on r.a > 0 and r.b > l.b order by 1, 2;
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on r.a > 0 and f_same (l.b) > 0 order by 1, 2;
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on r.a > 0 and l.b > 0 order by 1, 2;
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on l.a = r.a and f_same (r.b) > 1 order by 1, 2;
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on l.a = r.a and r.b > 1 order by 1, 2;
select /*+ ordered use_nl */ l.a from t_left l where exists (select r.a from t_right r where r.a > 0 and r.b > f_same (l.b)) order by 1;
select /*+ ordered use_nl */ l.a from t_left l where exists (select r.a from t_right r where r.a > 0 and r.b > l.b) order by 1;


evaluate 'Case 7: GROUPBY_NUM, START WITH and CONNECT BY conditions with a stored function; result = no function';
select a, count(*), sum (b) from t_key where a >= 1 group by a having groupby_num () <= f_same (2) order by a;
select a, count(*), sum (b) from t_key where a >= 1 group by a having groupby_num () <= 2 order by a;
select id, level from t_tree start with f_same (id) = 2 connect by prior id = pid order by id;
select id, level from t_tree start with id = 2 connect by prior id = pid order by id;
select id, level from t_tree start with id = 1 connect by prior id = pid and f_same (id) < 12 order by id;
select id, level from t_tree start with id = 1 connect by prior id = pid and id < 12 order by id;

drop function f_same;
drop serial s_cnt;
drop table t_key, t_left, t_right, t_tree, t_big;
