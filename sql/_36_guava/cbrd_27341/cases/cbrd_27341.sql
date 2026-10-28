/**
 *  This test case verifies CBRD-27341: an inner join ON term or a WHERE term that reads a table a preceding outer
 *  join fills with NULL is evaluated after that outer join.
 *
 *  Under standard semantics ((oa RIGHT JOIN ob ON ..) JOIN oc ON t) evaluates t on the NULL-filled oa of unmatched
 *  ob rows, so t drops those rows. Before the fix the optimizer broke this in two ways:
 *    - join order: oc had no ordering dependency, so the planner joined oc with oa first (index join on the oa.p
 *      primary key) and attached ob last with the outer join, i.e. ob LEFT JOIN (oa JOIN oc); t became part of
 *      the outer join ON and the unmatched ob rows survived NULL-filled.
 *    - term placement: an ON term of an inner join was never classified for outer joins, so a term reading only
 *      oa (oa.g = 1, oa.p = 1, oa.g IS NULL) became a scan filter or key range of oa, applied before the outer
 *      join filled oa with NULL. The ORDERED hint gives the same wrong rows for this one.
 *  The fix puts the other tables of such a term after the outer join, evaluates the non-edge ON terms during that
 *  inner join, and keeps such terms out of the implied join equalities.
 *
 *  Every check runs the query (rows in order) and then one row: id, PASS/FAIL, the rows as a sorted string
 *  (column values joined by ':', NULL as N, rows by ','), and the expected string computed by hand from the data
 *  below. The oa.p primary key and the statistics give the cost model the wrong orders the bug needed.
 *
 *  Coverage:
 *    Case 1: join order - RIGHT and LEFT JOIN, a term two joins after the outer join, the LEADING hint
 *    Case 2: term placement - non-indexed, primary key, IS NULL terms on the NULL-filled table, the ORDERED hint
 *    Case 3: implied join equalities through a term on the NULL-filled table
 *    Case 4: the Jira shape - 4-way join with LEFT JOIN, GROUP BY and HAVING IS NOT NULL / no HAVING / IS NULL
 *    Case 5: guards that were already right - an inner join reading only the preserved side (valid reorder),
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

-- Case 1: join order
evaluate 'Case 1: join order';
-- C1-1: RIGHT JOIN, then an inner join ON reading the NULL-filled oa through its primary key
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z order by 1, 2, 3;
select 'C1-1' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z) q) t;

-- C1-2: same with the LEADING hint putting oc before oa
select /*+ leading(oc oa) */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z order by 1, 2, 3;
select 'C1-2' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select /*+ leading(oc oa) */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z) q) t;

-- C1-3: LEFT JOIN direction, the inner join ON reads the preserved ob and the NULL-filled oa
select ob.y c1, oa.x c2, oc.z c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y and oa.p = oc.z order by 1, 2, 3;
select 'C1-3' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y and oa.p = oc.z) q) t;

-- C1-4: the term on the NULL-filled oa is in the ON of the second inner join
select ob.y c1, oa.x c2, oc.z c3, oe.q c4 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y join oe on oa.p = oe.q and oe.q = oc.z order by 1, 2, 3, 4;
select 'C1-4' id, case when nvl(t.r, 'EMPTY') = '1:1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3, oe.q c4 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y join oe on oa.p = oe.q and oe.q = oc.z) q) t;

-- Case 2: term placement
evaluate 'Case 2: term placement';
-- C2-1: non-indexed term on the NULL-filled oa in the inner join ON
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1 order by 1, 2, 3;
select 'C2-1' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1) q) t;

-- C2-2: same with the ORDERED hint
select /*+ ordered */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1 order by 1, 2, 3;
select 'C2-2' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select /*+ ordered */ ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1) q) t;

-- C2-3: LEFT JOIN direction
select ob.y c1, oa.x c2, oc.z c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1 order by 1, 2, 3;
select 'C2-3' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y and oa.g = 1) q) t;

-- C2-4: term on the primary key of the NULL-filled oa (must not become a key range of oa)
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.p = 1 order by 1, 2, 3;
select 'C2-4' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y and oa.p = 1) q) t;

-- C2-5: IS NULL term on the NULL-filled oa (keeps the NULL-filled row)
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = -1 and oa.g is null order by 1, 2, 3;
select 'C2-5' id, case when nvl(t.r, 'EMPTY') = '2:2:-1,3:N:-1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '2:2:-1,3:N:-1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = -1 and oa.g is null) q) t;

-- C2-6: term on the NULL-filled oa in the ON of the second inner join
select ob.y c1, oa.x c2, oc.z c3, oe.q c4 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y join oe on oe.q = oc.z and oa.g = 1 order by 1, 2, 3, 4;
select 'C2-6' id, case when nvl(t.r, 'EMPTY') = '1:1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3, oe.q c4 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y join oe on oe.q = oc.z and oa.g = 1) q) t;

-- Case 3: implied join equalities
evaluate 'Case 3: implied join equalities';
-- C3-1: LEFT JOIN, oa.p = oe.q and oe.q = oc.z must not imply a join of oc and oa before the outer join
select ob.y c1, oa.x c2, oc.z c3, oe.q c4 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y join oe on oa.p = oe.q and oe.q = oc.z order by 1, 2, 3, 4;
select 'C3-1' id, case when nvl(t.r, 'EMPTY') = '1:1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3, oe.q c4 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y join oe on oa.p = oe.q and oe.q = oc.z) q) t;

-- C3-2: equality chain through a LEFT JOIN ON with a term on the NULL-filled oa
select ob.y c1, oa.x c2, oc.z c3 from ob left join oa on oa.x = ob.y and oa.g = 1 join oc on oc.z = ob.y and oc.z = oa.x order by 1, 2, 3;
select 'C3-2' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from ob left join oa on oa.x = ob.y and oa.g = 1 join oc on oc.z = ob.y and oc.z = oa.x) q) t;

-- Case 4: the Jira shape
evaluate 'Case 4: the Jira shape';
-- C4-1: 4-way join, LEFT JOIN od, GROUP BY od.w HAVING od.w IS NOT NULL
select od.w c1, count(*) c2 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z left join od on ob.y = od.w group by od.w having od.w is not null order by 1, 2;
select 'C4-1' id, case when nvl(t.r, 'EMPTY') = '1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') order by 1 separator ',') r
      from (select od.w c1, count(*) c2 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z left join od on ob.y = od.w group by od.w having od.w is not null) q) t;

-- C4-2: same without HAVING
select od.w c1, count(*) c2 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z left join od on ob.y = od.w group by od.w order by 1, 2;
select 'C4-2' id, case when nvl(t.r, 'EMPTY') = '1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') order by 1 separator ',') r
      from (select od.w c1, count(*) c2 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z left join od on ob.y = od.w group by od.w) q) t;

-- C4-3: same with HAVING od.w IS NULL
select od.w c1, count(*) c2 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z left join od on ob.y = od.w group by od.w having od.w is null order by 1, 2;
select 'C4-3' id, case when nvl(t.r, 'EMPTY') = 'EMPTY' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, 'EMPTY' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') order by 1 separator ',') r
      from (select od.w c1, count(*) c2 from oa right join ob on oa.x = ob.y join oc on oa.p = oc.z left join od on ob.y = od.w group by od.w having od.w is null) q) t;

-- Case 5: guards
evaluate 'Case 5: guards';
-- C5-1: RIGHT JOIN, the inner join reads only the preserved ob (reordering it before the outer join is valid)
select ob.y c1, oc.z c2, oa.x c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y order by 1, 2, 3;
select 'C5-1' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:2:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:2:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oc.z c2, oa.x c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y) q) t;

-- C5-2: LEFT JOIN, the inner join reads only the preserved ob
select ob.y c1, oc.z c2, oa.x c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y order by 1, 2, 3;
select 'C5-2' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:2:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:2:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oc.z c2, oa.x c3 from ob left join oa on oa.x = ob.y join oc on oc.z = ob.y) q) t;

-- C5-3: HAVING moved to WHERE turns the LEFT JOIN into an inner join
select oa.p c1, count(*) c2 from ob left join oa on oa.x = ob.y group by oa.p having oa.p is not null order by 1, 2;
select 'C5-3' id, case when nvl(t.r, 'EMPTY') = '1:1,7:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1,7:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') order by 1 separator ',') r
      from (select oa.p c1, count(*) c2 from ob left join oa on oa.x = ob.y group by oa.p having oa.p is not null) q) t;

-- C5-4: WHERE on the NULL-filled oa turns the RIGHT JOIN into an inner join
select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y where oa.g = 1 order by 1, 2, 3;
select 'C5-4' id, case when nvl(t.r, 'EMPTY') = '1:1:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa right join ob on oa.x = ob.y join oc on oc.z = ob.y where oa.g = 1) q) t;

-- C5-5: outer join ON reading the NULL-filled oa
select ob.y c1, oa.x c2, od.w c3 from oa right join ob on oa.x = ob.y left join od on od.w = oa.p order by 1, 2, 3;
select 'C5-5' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:2:N,3:N:N' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:2:N,3:N:N' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, od.w c3 from oa right join ob on oa.x = ob.y left join od on od.w = oa.p) q) t;

-- C5-6: LEFT JOIN chain
select ob.y c1, oa.x c2, oc.z c3, od.w c4 from ob left join oa on oa.x = ob.y left join oc on oc.z = oa.p left join od on od.w = oc.z order by 1, 2, 3, 4;
select 'C5-6' id, case when nvl(t.r, 'EMPTY') = '1:1:1:1,2:2:N:N,3:N:N:N' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1:1,2:2:N:N,3:N:N:N' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3, od.w c4 from ob left join oa on oa.x = ob.y left join oc on oc.z = oa.p left join od on od.w = oc.z) q) t;

-- C5-7: RIGHT JOIN chain
select oa.x c1, ob.y c2, oc.z c3 from oc right join ob on oc.z = ob.y right join oa on oa.x = ob.y order by 1, 2, 3;
select 'C5-7' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:2:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:2:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select oa.x c1, ob.y c2, oc.z c3 from oc right join ob on oc.z = ob.y right join oa on oa.x = ob.y) q) t;

-- C5-8: inner join with a term on oa before the RIGHT JOIN
select ob.y c1, oa.x c2, oc.z c3 from oa join oc on oa.p = oc.z and oa.g = 1 right join ob on oa.x = ob.y order by 1, 2, 3;
select 'C5-8' id, case when nvl(t.r, 'EMPTY') = '1:1:1,2:N:N,3:N:N' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:1:1,2:N:N,3:N:N' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select ob.y c1, oa.x c2, oc.z c3 from oa join oc on oa.p = oc.z and oa.g = 1 right join ob on oa.x = ob.y) q) t;

drop table if exists oa, ob, oc, od, oe;
