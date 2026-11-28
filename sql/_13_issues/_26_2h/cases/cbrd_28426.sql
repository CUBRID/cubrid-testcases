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
 *  Cases 8 and 10 read a row and then evaluate what may wait for another page or a lock: the
 *  heap step of a bitmap heap scan evaluated its data filter with the row's heap page held, and
 *  a path expression waited for a class lock with the fetched object's page held. A debug
 *  server checks at those operators that no page is held. Case 9: a scalar subquery that is a
 *  select list item ran when the first row was output, so every worker of a parallel scan ran
 *  it (rows of one result carried different serial values), a worker of a parallel index scan
 *  under its leaf. It runs once before the scan opens now, as a subquery of a WHERE clause does.
 *  The 100 rows of b = 999 lie all over t_big, so every worker outputs some of them.
 *
 *  Case 11: such a subquery runs before the other items of its select list, a serial expression
 *  or a session variable assignment among them, which the first row evaluated before it. Case
 *  12: a table subquery that reads the table of a block beyond its own is not run before the
 *  scan: it would run for every row of that table. The first evaluation of its term runs it,
 *  and the term is no key filter. Case 13: an ON condition with a stored function takes the
 *  covering scan from the padded table of its join only, and from no table of an inner join.
 *
 *  Coverage:
 *    Case 1:  table subquery in a key filter (NOT IN, ALL, SOME, NULL, empty set)
 *    Case 2:  a table subquery runs once when no key reaches the key filter
 *    Case 3:  a table subquery runs once for all workers of a parallel scan
 *    Case 4:  a stored function term is a data filter (sargs), not a key filter
 *    Case 5:  ORDER BY with LIMIT over an IN list keeps its rows next to such a term
 *    Case 6:  outer join ON condition with a stored function over a covering inner scan
 *    Case 7:  GROUPBY_NUM, START WITH and CONNECT BY conditions with a stored function
 *    Case 8:  bitmap heap scan whose data filter reads a serial or an index statistic
 *    Case 9:  a scalar subquery that is a select list item runs once for all workers of a parallel scan
 *    Case 10: path expression with a condition and a subquery on the fetched object
 *    Case 11: a select list subquery runs before a serial expression and a variable of its list
 *    Case 12: a table subquery that reads an outer block's table runs when a row reaches it
 *    Case 13: a stored function in an ON condition and the covering scans of the join
 */

drop table if exists t_key, t_left, t_right, t_tree, t_big, t_ref, t_obj;
drop serial if exists s_cnt;
drop serial if exists s_bm;
drop serial if exists s_sel;
drop serial if exists s_ord;
drop serial if exists s_lazy;

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
-- the range a between 1 and 4000 reads 4 percent of t_big through i_big: a bitmap heap scan
create index i_big on t_big (a);
-- objects: t_ref.o points at the t_obj row of the same x; one t_ref row points at nothing
create table t_obj (x int, y varchar (10)) dont_reuse_oid;
insert into t_obj select rownum, 'p' || rownum from db_class limit 10;
create table t_ref (o t_obj, z int);
insert into t_ref select t_obj, x from t_obj;
insert into t_ref values (null, 99);
create serial s_cnt;
create serial s_bm;
create serial s_sel;
create serial s_ord;
create serial s_lazy;
create or replace function f_same (x int) return int as begin return x; end;
update statistics on t_key, t_left, t_right, t_tree, t_big, t_obj, t_ref with fullscan;


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
--@queryplan
select /*+ recompile */ count(*), sum (b) from (select a, b, c from t_key where a in (1, 2, 3) and c > f_same (0) order by b limit 5) x;
select count(*), sum (b) from (select a, b, c from t_key where a in (1, 2, 3) and c > 0 order by b limit 5) x;
select count(*), sum (b), max (d) from (select * from t_key where a in (1, 2, 3) and c > f_same (0) order by b limit 5) x;
select count(*), sum (b), max (d) from (select * from t_key where a in (1, 2, 3) and c > 0 order by b limit 5) x;
select count(*), sum (b) from (select a, b, c from t_key where a in (1, 2, 3) and c < index_cardinality ('t_key', 'i_key', 0) + 1 order by b limit 4) x;
select count(*), sum (b) from (select a, b, c from t_key where a in (1, 2, 3) and c < 2 order by b limit 4) x;


evaluate 'Case 6: outer join ON condition with a stored function over a covering inner scan; result = no function';
--@queryplan
select /*+ recompile ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on r.a > 0 and r.b > f_same (l.b) order by 1, 2;
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on r.a > 0 and r.b > l.b order by 1, 2;
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on r.a > 0 and f_same (l.b) > 0 order by 1, 2;
select /*+ ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on r.a > 0 and l.b > 0 order by 1, 2;
--@queryplan
select /*+ recompile ordered use_nl */ l.a, r.a, r.b from t_left l left outer join t_right r on l.a = r.a and f_same (r.b) > 1 order by 1, 2;
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


evaluate 'Case 8: bitmap heap scan whose data filter reads a serial or an index statistic; result = index ignored';
--@queryplan
select /*+ recompile no_parallel_scan */ count(*), sum (b) from t_big where a between 1 and 4000 and b < index_cardinality ('t_big', 'i_big', 0);
select /*+ no_parallel_scan */ count(*), sum (b) from t_big ignore index (i_big) where a between 1 and 4000 and b < index_cardinality ('t_big', 'i_big', 0);
select /*+ recompile no_parallel_scan */ count(*), sum (b) from t_big where a between 1 and 4000 and b < s_bm.next_value + 1000;
select /*+ no_parallel_scan */ count(*), sum (b) from t_big ignore index (i_big) where a between 1 and 4000 and b < s_bm.next_value + 1000;
select s_bm.next_value from db_root;


evaluate 'Case 9: a scalar subquery that is a select list item runs once for all workers of a parallel heap scan (one value, 1) and of a parallel index scan (2); the serial gives 3 next';
set trace on;
select /*+ recompile parallel(4) */ distinct (select s_sel.next_value from db_root) from t_big ignore index (i_big) where b = 999 order by 1;
show trace;
select /*+ recompile parallel(4) */ distinct (select s_sel.next_value from db_root) from t_big where b = 999 and a > 0 using index i_big(+) order by 1;
show trace;
-- trace goes off before the query that no show trace reads
set trace off;
select s_sel.next_value from db_root;


evaluate 'Case 10: path expression with a condition and a subquery on the fetched object; result = join';
select /*+ recompile */ z, o.x, o.y from t_ref where o.x > 5 order by z;
select r.z, p.x, p.y from t_ref r, t_obj p where r.o = p and p.x > 5 order by r.z;
select /*+ recompile */ z, (select count(*) from t_key k where k.b = t_ref.o.x) from t_ref where o.x < 4 order by z;
select r.z, (select count(*) from t_key k where k.b = p.x) from t_ref r, t_obj p where r.o = p and p.x < 4 order by r.z;


evaluate 'Case 11: a select list subquery runs before a serial expression and a variable of its list; rows (2, 1), (3, 1), (4, 1), then (11, 10), (12, 10), (13, 10)';
select /*+ recompile */ s_ord.next_value, (select s_ord.next_value from db_root) from t_left order by 1;
set @v_ord = 1;
select /*+ recompile */ (@v_ord := @v_ord + 1), (select @v_ord := @v_ord * 10 from db_root) from t_left order by 1;


evaluate 'Case 12: a table subquery that reads an outer block table runs when a row reaches it; no row of t_right: the serial gives 1 next; one row for each row of t_left: it gives 5 next';
--@queryplan
select /*+ recompile */ l.a, (select count(*) from t_right r where r.a = l.a + 10 and r.b not in (select s_lazy.next_value from db_root where l.b >= 0)) from t_left l order by 1;
select s_lazy.next_value from db_root;
select /*+ recompile */ l.a, (select count(*) from t_right r where r.a = l.a and r.b not in (select s_lazy.next_value from db_root where l.b >= 0)) from t_left l order by 1;
select s_lazy.next_value from db_root;


evaluate 'Case 13: a stored function in an ON condition and the covering scans of the join; left outer join: the preserved table stays covered; inner join: both do, as with the condition in WHERE; result = no function';
--@queryplan
select /*+ recompile ordered use_nl */ o.a, o.b, i.b from t_right o left outer join t_right i on i.a = o.a and i.b < f_same (o.b) + 1 where o.a > 0 order by 1;
select /*+ ordered use_nl */ o.a, o.b, i.b from t_right o left outer join t_right i on i.a = o.a and i.b < o.b + 1 where o.a > 0 order by 1;
--@queryplan
select /*+ recompile ordered use_nl */ o.a, o.b, i.b from t_right o inner join t_right i on i.a = o.a and i.b < f_same (3) where o.a > 0 order by 1;
--@queryplan
select /*+ recompile ordered use_nl */ o.a, o.b, i.b from t_right o, t_right i where i.a = o.a and i.b < f_same (3) and o.a > 0 order by 1;
select /*+ ordered use_nl */ o.a, o.b, i.b from t_right o, t_right i where i.a = o.a and i.b < 3 and o.a > 0 order by 1;

drop function f_same;
drop serial s_cnt;
drop serial s_bm;
drop serial s_sel;
drop serial s_ord;
drop serial s_lazy;
drop table t_ref;
drop table t_key, t_left, t_right, t_tree, t_big, t_obj;
