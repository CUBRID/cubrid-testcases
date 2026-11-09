/**
 *  This test case verifies CBRD-27762: a WHERE term that reads a table a preceding outer join fills with NULL
 *  and a table joined later is evaluated after that outer join, not merged into it.
 *
 *  For (wa LEFT JOIN wb ON ..), wc WHERE wc.a = nvl(wb.b, 2) AND wc.a = wa.b the term wc.a = nvl(wb.b, 2) must see
 *  the NULL-filled wb of unmatched wa rows. Before the fix the term stayed an ordinary join term, so the planner
 *  joined wc with the preserved wa first and attached the LEFT JOIN on top, merging the term into the outer join
 *  step. The term then only decided whether wb matched, and rows it should reject survived NULL-filled. The fix
 *  classifies a WHERE term that reads a table NULL-filled by a preceding outer join as an after-join term,
 *  regardless of the FROM order, so it is evaluated after the NULL filling, not as that outer join's condition.
 *
 *  Every check runs the query (rows in order) and then one row: id, PASS/FAIL, the rows as a sorted string
 *  (column values joined by ':', NULL as N, rows by ',', EMPTY for no rows), and the expected string, which equals
 *  the result of the same query with the outer join materialized first in a NO_MERGE derived table.
 *
 *  Coverage:
 *    Case 1: WHERE terms reading the NULL-filled side - a RIGHT JOIN followed by a LEFT JOIN with an OR term in
 *            its ON (with and without an extra term on the NULL-filled table), the term joined to a later table
 *            by comma, CROSS JOIN and INNER JOIN, the LEADING hint putting the later table first, a LEFT
 *            JOIN chain, CONNECT BY
 *    Case 2: guards that were already right - single-table terms on the NULL-filled table, the later table
 *            listed first, an IS NULL term, an OR term, the RIGHT JOIN and LEFT JOIN spellings, a null-rejecting
 *            equality that turns the outer join into an inner join, the outer join inside a derived table, an OR
 *            term over a LEFT JOIN's NULL-filled table and a later table
 */
drop table if exists t2, t3, wa, wb, wc, wd, aaa, bbb, ccc, ddd, eee;
create table t2 (a int, b int, c int);
insert into t2 values (1,3,1),(NULL,4,0),(0,NULL,0),(4,4,3),(3,3,2),(NULL,NULL,4),(4,3,0),(1,2,4),(4,2,2),(4,0,4),(3,1,4);
create index i_t2_a on t2(a);
create index i_t2_b on t2(b);
create index i_t2_c on t2(c);
create table t3 (a int, b int, c int);
insert into t3 values (1,2,NULL),(3,NULL,NULL),(2,1,1),(3,NULL,NULL),(3,4,NULL),(NULL,2,1),(2,2,NULL),(NULL,1,2),(1,0,3);
create table wa (a int, b int);
create table wb (a int, b int);
create table wc (a int);
create table wd (a int);
insert into wa values (1, 2), (5, 3);
insert into wb values (5, 7);
insert into wc values (2), (3);
insert into wd values (0), (1);
create index i_wa_b on wa(b);
update statistics on t2, t3, wa, wb, wc, wd with fullscan;

-- Case 1: WHERE terms that read a table NULL-filled by a preceding outer join
evaluate 'Case 1: WHERE terms reading the NULL-filled side';
-- C1-1: RIGHT JOIN, then a LEFT JOIN that WHERE x4.c = 1 turns into an inner join, its OR term reading the NULL-filled x0
select x3.c c1, x0.a c2, x0.b c3, x0.c c4, x4.a c5, x4.b c6 from t2 x0 right outer join t3 x3 on nvl(x0.b, 2) = x3.c left outer join t3 x4 on (x4.b = x0.b or x4.a = x0.c) where x4.c = 1 order by 1, 2, 3, 4, 5, 6;
select 'C1-1' id, case when nvl(t.r, 'EMPTY') = '1:3:1:4:2:1,1:3:1:4:2:1,2:1:2:4:N:2,2:4:2:2:2:1,2:4:2:2:N:2,3:3:3:2:2:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:3:1:4:2:1,1:3:1:4:2:1,2:1:2:4:N:2,2:4:2:2:2:1,2:4:2:2:N:2,3:3:3:2:2:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') || ':' || nvl(to_char(q.c5), 'N') || ':' || nvl(to_char(q.c6), 'N') order by 1 separator ',') r
      from (select x3.c c1, x0.a c2, x0.b c3, x0.c c4, x4.a c5, x4.b c6 from t2 x0 right outer join t3 x3 on nvl(x0.b, 2) = x3.c left outer join t3 x4 on (x4.b = x0.b or x4.a = x0.c) where x4.c = 1) q) t;

-- C1-2: same with a term on the NULL-filled x0 added to the ON of x4
select x3.c c1, x0.a c2, x0.b c3, x0.c c4, x4.a c5, x4.b c6 from t2 x0 right outer join t3 x3 on nvl(x0.b, 2) = x3.c left outer join t3 x4 on (x4.b = x0.b or x4.a = x0.c) and nvl(x0.c, 0) = 0 where x4.c = 1 order by 1, 2, 3, 4, 5, 6;
select 'C1-2' id, case when nvl(t.r, 'EMPTY') = 'EMPTY' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, 'EMPTY' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') || ':' || nvl(to_char(q.c5), 'N') || ':' || nvl(to_char(q.c6), 'N') order by 1 separator ',') r
      from (select x3.c c1, x0.a c2, x0.b c3, x0.c c4, x4.a c5, x4.b c6 from t2 x0 right outer join t3 x3 on nvl(x0.b, 2) = x3.c left outer join t3 x4 on (x4.b = x0.b or x4.a = x0.c) and nvl(x0.c, 0) = 0 where x4.c = 1) q) t;

-- C1-3: WHERE term reads the NULL-filled wb and the comma-joined wc
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b order by 1, 2, 3, 4;
select 'C1-3' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b) q) t;

-- C1-4: same with CROSS JOIN wc
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a cross join wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b order by 1, 2, 3, 4;
select 'C1-4' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a cross join wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b) q) t;

-- C1-5: same with INNER JOIN wc ON wc.a = wa.b
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a inner join wc on wc.a = wa.b where wc.a = nvl(wb.b, 2) order by 1, 2, 3, 4;
select 'C1-5' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a inner join wc on wc.a = wa.b where wc.a = nvl(wb.b, 2)) q) t;

-- C1-6: same with the LEADING hint putting wc before wa
select /*+ leading(wc, wa) */ wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b order by 1, 2, 3, 4;
select 'C1-6' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select /*+ leading(wc, wa) */ wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b) q) t;

-- C1-7: LEFT JOIN chain wa, wb, wd then comma-joined wc
select wa.a c1, wb.b c2, wd.a c3, wc.a c4 from wa left outer join wb on wb.a = wa.a left outer join wd on wd.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b order by 1, 2, 3, 4;
select 'C1-7' id, case when nvl(t.r, 'EMPTY') = '1:N:1:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:N:1:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wb.b c2, wd.a c3, wc.a c4 from wa left outer join wb on wb.a = wa.a left outer join wd on wd.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b) q) t;

-- C1-8: same as C1-3 with CONNECT BY
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b connect by level <= 1 order by 1, 2, 3, 4;
select 'C1-8' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b connect by level <= 1) q) t;

-- Case 2: guards
evaluate 'Case 2: guards';
-- C2-1: single-table WHERE term on the NULL-filled x0 of a RIGHT JOIN
select x3.c c1, x0.a c2, x0.b c3, x0.c c4 from t2 x0 right outer join t3 x3 on x0.b = x3.c where nvl(x0.c, 0) = 0 order by 1, 2, 3, 4;
select 'C2-1' id, case when nvl(t.r, 'EMPTY') = '3:4:3:0,N:N:N:N,N:N:N:N,N:N:N:N,N:N:N:N,N:N:N:N' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '3:4:3:0,N:N:N:N,N:N:N:N,N:N:N:N,N:N:N:N,N:N:N:N' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select x3.c c1, x0.a c2, x0.b c3, x0.c c4 from t2 x0 right outer join t3 x3 on x0.b = x3.c where nvl(x0.c, 0) = 0) q) t;

-- C2-2: single-table WHERE term on the NULL-filled wb of a LEFT JOIN
select wa.a c1, wa.b c2, wb.b c3 from wa left outer join wb on wb.a = wa.a where nvl(wb.b, 0) = 0 order by 1, 2, 3;
select 'C2-2' id, case when nvl(t.r, 'EMPTY') = '1:2:N' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3 from wa left outer join wb on wb.a = wa.a where nvl(wb.b, 0) = 0) q) t;

-- C2-3: C1-3 with wc listed before the LEFT JOIN
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wc, wa left outer join wb on wb.a = wa.a where wc.a = nvl(wb.b, 2) and wc.a = wa.b order by 1, 2, 3, 4;
select 'C2-3' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wc, wa left outer join wb on wb.a = wa.a where wc.a = nvl(wb.b, 2) and wc.a = wa.b) q) t;

-- C2-4: IS NULL term on the NULL-filled wb and a join term on the preserved wa
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wb.b is null and wc.a = wa.b order by 1, 2, 3, 4;
select 'C2-4' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wb.b is null and wc.a = wa.b) q) t;

-- C2-5: OR term over the NULL-filled wb and wc
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) or wc.a = 99 order by 1, 2, 3, 4;
select 'C2-5' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) or wc.a = 99) q) t;

-- C2-6: C1-3 written as wb RIGHT JOIN wa
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wb right outer join wa on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b order by 1, 2, 3, 4;
select 'C2-6' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wb right outer join wa on wb.a = wa.a, wc where wc.a = nvl(wb.b, 2) and wc.a = wa.b) q) t;

-- C2-7: C1-1 written as x3 LEFT JOIN x0
select x3.c c1, x0.a c2, x0.b c3, x0.c c4, x4.a c5, x4.b c6 from t3 x3 left outer join t2 x0 on nvl(x0.b, 2) = x3.c left outer join t3 x4 on (x4.b = x0.b or x4.a = x0.c) where x4.c = 1 order by 1, 2, 3, 4, 5, 6;
select 'C2-7' id, case when nvl(t.r, 'EMPTY') = '1:3:1:4:2:1,1:3:1:4:2:1,2:1:2:4:N:2,2:4:2:2:2:1,2:4:2:2:N:2,3:3:3:2:2:1' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:3:1:4:2:1,1:3:1:4:2:1,2:1:2:4:N:2,2:4:2:2:2:1,2:4:2:2:N:2,3:3:3:2:2:1' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') || ':' || nvl(to_char(q.c5), 'N') || ':' || nvl(to_char(q.c6), 'N') order by 1 separator ',') r
      from (select x3.c c1, x0.a c2, x0.b c3, x0.c c4, x4.a c5, x4.b c6 from t3 x3 left outer join t2 x0 on nvl(x0.b, 2) = x3.c left outer join t3 x4 on (x4.b = x0.b or x4.a = x0.c) where x4.c = 1) q) t;

-- C2-8: null-rejecting equality on wb turns the LEFT JOIN into an inner join
select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = wb.b and wc.a = wa.b order by 1, 2, 3, 4;
select 'C2-8' id, case when nvl(t.r, 'EMPTY') = 'EMPTY' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, 'EMPTY' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select wa.a c1, wa.b c2, wb.b c3, wc.a c4 from wa left outer join wb on wb.a = wa.a, wc where wc.a = wb.b and wc.a = wa.b) q) t;

-- C2-9: outer join wrapped in a derived table
select d.waa c1, d.wab c2, d.wbb c3, wc.a c4 from (select wa.a waa, wa.b wab, wb.b wbb from wa left outer join wb on wb.a = wa.a) d, wc where wc.a = nvl(d.wbb, 2) and wc.a = d.wab order by 1, 2, 3, 4;
select 'C2-9' id, case when nvl(t.r, 'EMPTY') = '1:2:N:2' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:2:N:2' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') || ':' || nvl(to_char(q.c4), 'N') order by 1 separator ',') r
      from (select d.waa c1, d.wab c2, d.wbb c3, wc.a c4 from (select wa.a waa, wa.b wab, wb.b wbb from wa left outer join wb on wb.a = wa.a) d, wc where wc.a = nvl(d.wbb, 2) and wc.a = d.wab) q) t;

-- C2-10: OR term over the NULL-filled ddd of a LEFT JOIN chain and the later eee
create table aaa (id int primary key);
create table bbb (id int primary key, key1 int, key2 int);
create table ccc (id int);
create table ddd (key1 int, nm varchar(200));
create table eee (key1 int primary key, nm varchar(200));
insert into aaa values (1), (2), (3);
insert into bbb values (1, 1, 9), (2, 2, 2), (3, 3, 3);
insert into ccc values (1), (2), (3);
insert into ddd values (1, 'aaa'), (2, 'aaa'), (3, '333');
insert into eee values (1, 'bbb'), (2, '222'), (3, '333');
update statistics on aaa, bbb, ccc, ddd, eee;
select aaa.id c1, eee.nm c2, ddd.nm c3 from aaa, bbb left outer join ccc on bbb.id = ccc.id left outer join ddd on bbb.key2 = ddd.key1, eee where aaa.id = bbb.id and bbb.key1 = eee.key1 and (ddd.nm = 'aaa' or eee.nm = 'bbb') order by 1, 2, 3;
select 'C2-10' id, case when nvl(t.r, 'EMPTY') = '1:bbb:N,2:222:aaa' then 'PASS' else 'FAIL' end res, nvl(t.r, 'EMPTY') got, '1:bbb:N,2:222:aaa' expected
from (select group_concat(nvl(to_char(q.c1), 'N') || ':' || nvl(to_char(q.c2), 'N') || ':' || nvl(to_char(q.c3), 'N') order by 1 separator ',') r
      from (select aaa.id c1, eee.nm c2, ddd.nm c3 from aaa, bbb left outer join ccc on bbb.id = ccc.id left outer join ddd on bbb.key2 = ddd.key1, eee where aaa.id = bbb.id and bbb.key1 = eee.key1 and (ddd.nm = 'aaa' or eee.nm = 'bbb')) q) t;

drop table if exists t2, t3, wa, wb, wc, wd, aaa, bbb, ccc, ddd, eee;
