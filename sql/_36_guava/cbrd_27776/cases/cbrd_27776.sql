/**
 *  This test case verifies CBRD-27776: joining two derived tables that each hash-join
 *  on a function-index expression must not fail while generating the plan.
 *
 *  Table fi_t has the function index (i1, sqrt(d1)), so sqrt(fi_t.d1) is a function-index
 *  expression. When a hash join whose child hash join projects that expression is nested
 *  under another hash join, the list scan reading the join result built its value list
 *  from the expression itself. Only column names can become values there, so the plan came
 *  out NULL: a debug build asserted in check_hashjoin_xasl() and a release build failed
 *  the query.
 *
 *  The fix (engine PR #8408) gives that list scan the expression's argument column (d1)
 *  instead, and the expression is computed again from it.
 *
 *  Every query is written with the ordered and use_hash hints, which produce nested hash
 *  joins, and is followed by the same query with use_nl. The two result blocks must match.
 *
 *  A hash join whose result needs no rewriting hands it straight to the node above, which
 *  skips the failing list scan, so cases 1 to 5 also pass without the fix and stay as
 *  guards. In cases 6 to 8 a subquery predicate is left to the node above a lower join,
 *  which keeps that list scan; without the fix these fail.
 *
 *  Coverage:
 *    Case 1:  the reported query, COUNT(*) over two joined derived tables
 *    Case 2:  the function-index values of both derived tables in the select list
 *    Case 3:  a third derived table joined on top (three levels of nesting)
 *    Case 4:  the function-index expression wrapped in an arithmetic expression
 *    Case 5:  a predicate on the derived function-index column above the nested join
 *    Case 6:  a correlated subquery predicate over both derived tables' i1
 *    Case 7:  a correlated subquery predicate over p.x and s.i1
 *    Case 8:  an uncorrelated subquery in a predicate over both derived tables' i1
 */

drop table if exists fi_t, fi_u;

create table fi_t (i1 int, d1 double, k int);
insert into fi_t select rownum, rownum * rownum * 16, rownum % 3 from db_class limit 20;
create index idx_fi_t on fi_t (i1, sqrt(d1));
create table fi_u (x int, y double);
insert into fi_u values (1, 4), (2, 8), (3, 12), (4, 2);
update statistics on fi_t, fi_u with fullscan;

-- Case 1
select count(*)
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1;

select count(*)
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1;

-- Case 2
select /*+ use_hash */ p.i1, p.r, s.r, p.x, s.x
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
order by 1;

select /*+ use_nl */ p.i1, p.r, s.r, p.x, s.x
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
order by 1;

-- Case 3
select /*+ ordered use_hash */ p.i1, p.r, s.x, q.r
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) q
     on s.i1 = q.i1
order by 1;

select /*+ ordered use_nl */ p.i1, p.r, s.x, q.r
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) q
     on s.i1 = q.i1
order by 1;

-- Case 4
select /*+ use_hash */ p.i1, p.r1, s.r1
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) + 1 r1, u.x from fi_t t, fi_t t2, fi_u u where t.i1 = t2.i1 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) * 2 r1 from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
order by 1;

select /*+ use_nl */ p.i1, p.r1, s.r1
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) + 1 r1, u.x from fi_t t, fi_t t2, fi_u u where t.i1 = t2.i1 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) * 2 r1 from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
order by 1;

-- Case 5
select /*+ use_hash */ p.i1, p.r, s.x
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
where p.r > s.x + 5
order by 1;

select /*+ use_nl */ p.i1, p.r, s.x
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
where p.r > s.x + 5
order by 1;

-- Case 6
select /*+ use_hash */ p.i1, p.r, s.r, p.x
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
where (select p.i1 + s.i1 from db_root) > 0
order by 1;

select /*+ use_nl */ p.i1, p.r, s.r, p.x
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
where (select p.i1 + s.i1 from db_root) > 0
order by 1;

-- Case 7
select /*+ use_hash */ p.i1, p.r, s.r, p.x
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
where (select p.x + s.i1 from db_root) > 0
order by 1;

select /*+ use_nl */ p.i1, p.r, s.r, p.x
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
where (select p.x + s.i1 from db_root) > 0
order by 1;

-- Case 8
select /*+ use_hash */ p.i1, p.r, s.r, p.x
from (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_hash */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
where p.i1 + s.i1 > (select min(x) from fi_u)
order by 1;

select /*+ use_nl */ p.i1, p.r, s.r, p.x
from (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) p
     join (select /*+ ordered use_nl */ t.i1, sqrt(t.d1) r, u.x from fi_t t, fi_u u where t.i1 between 1 and 3 and sqrt(t.d1) = u.y) s
     on p.i1 = s.i1
where p.i1 + s.i1 > (select min(x) from fi_u)
order by 1;

drop table fi_t, fi_u;
