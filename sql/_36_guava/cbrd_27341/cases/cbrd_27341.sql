/**
 *  This test case verifies CBRD-27341: an inner join ON term that reads only tables a preceding outer join fills
 *  with NULL is evaluated during that inner join, after the outer join has filled them.
 *
 *  Under standard semantics ((oa RIGHT JOIN ob ON ..) JOIN oc ON oc.z = ob.y AND t) evaluates t on the
 *  NULL-filled oa of unmatched ob rows, so t drops those rows. Before the fix a non-edge ON term t of an inner
 *  join was never classified against the outer joins: a term reading only oa (oa.g = 1, oa.p = 1, oa.g IS NULL)
 *  became a scan filter or key range of oa, and a term reading oa and the outer join's preserved ob (oa.g = ob.y)
 *  or two NULL-filled tables (oa and od) was absorbed by the outer join step. Either way t ran before the NULL
 *  filling, so the unmatched rows survived NULL-filled. The ORDERED, USE_HASH and USE_MERGE hints do not help.
 *  The fix classifies such terms as evaluated during the inner join.
 *
 *  Join order for these queries (and the HAVING query of the Jira issue) was fixed by CBRD-27340, so those checks
 *  are not repeated here.
 *
 *  Every check runs the query (rows in order) and then one row: id, PASS/FAIL, the rows as a sorted string
 *  (column values joined by ':', NULL as N, rows by ','), and the expected string computed by hand from the data
 *  below.
 *
 *  Coverage:
 *    Case 1: term placement - non-indexed, primary key, IS NULL terms on the NULL-filled table, the ORDERED hint,
 *            the LEFT JOIN direction, a term in the ON of the second inner join, a term on the NULL-filled and
 *            the preserved table with hash and merge joins, a term on two NULL-filled tables
 *    Case 2: guards that were already right - an inner join reading only the preserved side (valid reorder),
 *            HAVING moved to WHERE turning LEFT JOIN into inner join, WHERE turning RIGHT JOIN into inner join,
 *            an outer join ON reading the NULL-filled table, LEFT and RIGHT JOIN chains, an inner join before
 *            the outer join
 */
drop table if exists oa, ob, oc, od, oe;
create table oa (x int, p int primary key, g int);
create table ob (y int);
create table oc (z int);
create table od (w int);
create table oe (q int);
insert into oa values (1, 1, 1), (2, 7, null);
insert into ob values (1), (2), (3);
insert into oc values (1), (2), (-1);
insert into od values (1), (null);
insert into oe values (1), (2);
update statistics on oa, ob, oc, od, oe with fullscan;

-- Case 1: term placement
evaluate 'Case 1: term placement';
-- C1-1: non-indexed term on the NULL-filled oa in the inner join ON
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1 order by 1, 2, 3;
select 'C1-1' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1) q) t;

-- C1-2: same with the ORDERED hint
select /*+ ordered */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1 order by 1, 2, 3;
select 'C1-2' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select /*+ ordered */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1) q) t;

-- C1-3: LEFT JOIN direction
select ob.y c1, oa.x c2, oc.z c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1 order by 1, 2, 3;
select 'C1-3' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1) q) t;

-- C1-4: term on the primary key of the NULL-filled oa (must not become a key range of oa)
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.p = 1 order by 1, 2, 3;
select 'C1-4' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.p = 1) q) t;

-- C1-5: IS NULL term on the NULL-filled oa (keeps the NULL-filled row)
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = -1 and oa.g is null order by 1, 2, 3;
select 'C1-5' id, case when nvl(t.r, 'EMPTY') = '2:2:-1,3:N:-1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '2:2:-1,3:N:-1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = -1 and oa.g is null) q) t;

-- C1-6: term on the NULL-filled oa in the ON of the second inner join
select ob.y c1, oa.x c2, oc.z c3, oe.q c4 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y join oe on oe.q = oc.z and oa.g = 1 order by 1, 2, 3, 4;
select 'C1-6' id, case when nvl(t.r, 'EMPTY') = '1:1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3, oe.q c4 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y join oe on oe.q = oc.z and oa.g = 1) q) t;

-- C1-7: term on the NULL-filled oa and the preserved ob, hash join
select /*+ use_hash */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = ob.y order by 1, 2, 3;
select 'C1-7' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select /*+ use_hash */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = ob.y) q) t;

-- C1-8: same with merge join
select /*+ use_merge */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = ob.y order by 1, 2, 3;
select 'C1-8' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select /*+ use_merge */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = ob.y) q) t;

-- C1-9: term on two NULL-filled tables, oa and od
select ob.y c1, oa.x c2, od.w c3, oc.z c4 from oa left join od on od.w = oa.g right join ob on oa.x = ob.y join oc on oc.z = ob.y and coalesce(od.w, oa.g, 0) = 1 order by 1, 2, 3, 4;
select 'C1-9' id, case when nvl(t.r, 'EMPTY') = '1:1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, od.w c3, oc.z c4 from oa left join od on od.w = oa.g right join ob on oa.x = ob.y join oc on oc.z = ob.y and coalesce(od.w, oa.g, 0) = 1) q) t;

-- Case 2: guards
evaluate 'Case 2: guards';
-- C2-1: RIGHT JOIN, the inner join reads only the preserved ob (reordering it before the outer join is valid)
select ob.y c1, oc.z c2, oa.x c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y order by 1, 2, 3;
select 'C2-1' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:2:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:2:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oc.z c2, oa.x c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y) q) t;

-- C2-2: LEFT JOIN, the inner join reads only the preserved ob
select ob.y c1, oc.z c2, oa.x c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y order by 1, 2, 3;
select 'C2-2' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:2:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:2:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oc.z c2, oa.x c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y) q) t;

-- C2-3: HAVING moved to WHERE turns the LEFT JOIN into an inner join
select oa.p c1, count(*) c2 from ob left join oa on oa.x = ob.y group by oa.p having oa.p is not null order by 1, 2;
select 'C2-3' id, case when nvl(t.r, 'EMPTY') = '1:1,7:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1,7:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') order by 1 separator ',') r
      from (select oa.p c1, count(*) c2 from ob left join oa on oa.x = ob.y group by oa.p having oa.p is not null) q) t;

-- C2-4: WHERE on the NULL-filled oa turns the RIGHT JOIN into an inner join
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y where oa.g = 1 order by 1, 2, 3;
select 'C2-4' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y where oa.g = 1) q) t;

-- C2-5: outer join ON reading the NULL-filled oa
select ob.y c1, oa.x c2, od.w c3 from oa right join ob on oa.x = ob.y left join od on od.w = oa.p order by 1, 2, 3;
select 'C2-5' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:2:N,3:N:N' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:2:N,3:N:N' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, od.w c3 from oa right join ob on oa.x = ob.y left join od on od.w = oa.p) q) t;

-- C2-6: LEFT JOIN chain
select ob.y c1, oa.x c2, oc.z c3, od.w c4 from ob left join oa on oa.x = ob.y left join oc on oc.z = oa.p left join od on od.w = oc.z order by 1, 2, 3, 4;
select 'C2-6' id, case when nvl(t.r, 'EMPTY') = '1:1:1:1,2:2:N:N,3:N:N:N' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1:1,2:2:N:N,3:N:N:N' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3, od.w c4 from ob left join oa on oa.x = ob.y left join oc on oc.z = oa.p left join od on od.w = oc.z) q) t;

-- C2-7: RIGHT JOIN chain
select oa.x c1, ob.y c2, oc.z c3 from oc right join ob on oc.z = ob.y right join oa on oa.x = ob.y order by 1, 2, 3;
select 'C2-7' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:2:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:2:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select oa.x c1, ob.y c2, oc.z c3 from oc right join ob on oc.z = ob.y right join oa on oa.x = ob.y) q) t;

-- C2-8: inner join with a term on oa before the RIGHT JOIN
select ob.y c1, oa.x c2, oc.z c3 from oa join oc on oa.p = oc.z and oa.g = 1 right join ob on oa.x = ob.y order by 1, 2, 3;
select 'C2-8' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:N:N,3:N:N' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:N:N,3:N:N' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa join oc on oa.p = oc.z and oa.g = 1 right join ob on oa.x = ob.y) q) t;

drop table if exists oa, ob, oc, od, oe;
