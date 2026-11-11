/**
 *  This test case verifies CBRD-27952: an outer join is kept when a WHERE term merged from OR-ed comparisons
 *  (or an IN / op SOME list) can be true without the NULL-padded table.
 *
 *  Bug: qo_rewrite_outerjoin () turned an outer join INNER when a WHERE term reading the NULL-padded spec was
 *  merged from OR-ed comparisons of one column into one RANGE term (wc.a = wb.b or wc.a = wa.b becomes
 *  wc.a range (wb.b = or wa.b =)), or was an IN / op SOME over a list, although such a term is true through
 *  any alternative that does not read the spec. The rows of the preserved table without a match were lost.
 *
 *  Fix: such a term rejects NULL of the spec only when its left operand reads the spec or every alternative
 *  reads it.
 *
 *  Every check compares count(*) of the query with a reference that counts the same FROM without WHERE as
 *  sum(case when <where> then 1 else 0 end) (CASE is never null-rejecting, so the join stays outer) and with
 *  the count computed by hand from the data below. One row per check: id, PASS/FAIL.
 *
 *  Coverage:
 *    P*, Q*: defect cases - OR merged into a range (LEFT and RIGHT JOIN), IN list, = ANY and > SOME over a
 *            collection, a constant alternative, comparison and BETWEEN ranges, three alternatives, HAVING
 *    G*:     guards - every alternative reads the NULL-padded table, the range column is on it, no range
 *            merge, a plain equality, the OR written so that it is not merged
 */
drop table if exists wa, wb, wc, o, i;
create table wa (a int, b int);
create table wb (a int, b int);
create table wc (a int);
insert into wa values (1, 2), (5, 3);
insert into wb values (5, 7);
insert into wc values (2), (3);
create table o (b double);
create table i (c int);
insert into o values (1), (2), (3);
update statistics on wa, wb, wc, o, i with fullscan;

-- P1: OR becomes wc.a range (wb.b = or wa.b =) (defect)
select 'P1' id, case when t.g = t.e and t.e = 2 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a, wc where wc.a = wb.b or wc.a = wa.b) g,
             (select sum(case when wc.a = wb.b or wc.a = wa.b then 1 else 0 end) from wa left outer join wb on wb.a = wa.a, wc) e from db_root) t;

-- P1R: P1 written as RIGHT OUTER JOIN (defect)
select 'P1R' id, case when t.g = t.e and t.e = 2 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wb right outer join wa on wb.a = wa.a, wc where wc.a = wb.b or wc.a = wa.b) g,
             (select sum(case when wc.a = wb.b or wc.a = wa.b then 1 else 0 end) from wb right outer join wa on wb.a = wa.a, wc) e from db_root) t;

-- P2: IN list, converted to the same range (defect)
select 'P2' id, case when t.g = t.e and t.e = 2 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a, wc where wc.a in (wb.b, wa.b)) g,
             (select sum(case when wc.a in (wb.b, wa.b) then 1 else 0 end) from wa left outer join wb on wb.a = wa.a, wc) e from db_root) t;

-- P3: = ANY over a collection (defect)
select 'P3' id, case when t.g = t.e and t.e = 2 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a, wc where wc.a = any {wb.b, wa.b}) g,
             (select sum(case when wc.a = any {wb.b, wa.b} then 1 else 0 end) from wa left outer join wb on wb.a = wa.a, wc) e from db_root) t;

-- P3G: > SOME over a collection (defect)
select 'P3G' id, case when t.g = t.e and t.e = 1 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a, wc where wc.a > some {wb.b, wa.b}) g,
             (select sum(case when wc.a > some {wb.b, wa.b} then 1 else 0 end) from wa left outer join wb on wb.a = wa.a, wc) e from db_root) t;

-- P5: constant disjunct, range on the preserved column (defect)
select 'P5' id, case when t.g = t.e and t.e = 1 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a where wa.b = 2 or wa.b = wb.b) g,
             (select sum(case when wa.b = 2 or wa.b = wb.b then 1 else 0 end) from wa left outer join wb on wb.a = wa.a) e from db_root) t;

-- P7: IN list with a constant (defect)
select 'P7' id, case when t.g = t.e and t.e = 1 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a where wa.b in (2, wb.b)) g,
             (select sum(case when wa.b in (2, wb.b) then 1 else 0 end) from wa left outer join wb on wb.a = wa.a) e from db_root) t;

-- P8: constant disjunct on a third table column (defect)
select 'P8' id, case when t.g = t.e and t.e = 2 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a, wc where wc.a = wb.b or wc.a = 2) g,
             (select sum(case when wc.a = wb.b or wc.a = 2 then 1 else 0 end) from wa left outer join wb on wb.a = wa.a, wc) e from db_root) t;

-- Q1: comparisons merged into range (0 ge_inf max or i.c ge_inf max) (defect)
select 'Q1' id, case when t.g = t.e and t.e = 3 then 'PASS' else 'FAIL' end res
from (select (select count(*) from o left outer join i on i.c = o.b where (o.b >= 0) or (o.b >= i.c)) g,
             (select sum(case when (o.b >= 0) or (o.b >= i.c) then 1 else 0 end) from o left outer join i on i.c = o.b) e from db_root) t;

-- Q2: Q1 with the second comparison flipped to o.b <= i.c (defect)
select 'Q2' id, case when t.g = t.e and t.e = 3 then 'PASS' else 'FAIL' end res
from (select (select count(*) from o left outer join i on i.c = o.b where (o.b >= 0) or (i.c >= o.b)) g,
             (select sum(case when (o.b >= 0) or (i.c >= o.b) then 1 else 0 end) from o left outer join i on i.c = o.b) e from db_root) t;

-- Q3: the same OR in HAVING (defect)
select 'Q3' id, case when t.g = t.e and t.e = 3 then 'PASS' else 'FAIL' end res
from (select (select count(*) from (select o.b, i.c from o left outer join i on i.c = o.b group by o.b, i.c having (o.b >= o.b) or (o.b >= i.c)) z) g,
             (select count(*) from (select o.b, i.c from o left outer join i on i.c = o.b group by o.b, i.c) z where case when (z.b >= z.b) or (z.b >= z.c) then 1 else 0 end = 1) e from db_root) t;

-- Q5: BETWEEN disjuncts (defect)
select 'Q5' id, case when t.g = t.e and t.e = 3 then 'PASS' else 'FAIL' end res
from (select (select count(*) from o left outer join i on i.c = o.b where o.b between 0 and 5 or o.b between i.c and 9) g,
             (select sum(case when o.b between 0 and 5 or o.b between i.c and 9 then 1 else 0 end) from o left outer join i on i.c = o.b) e from db_root) t;

-- Q6: three disjuncts, one reads i (defect)
select 'Q6' id, case when t.g = t.e and t.e = 2 then 'PASS' else 'FAIL' end res
from (select (select count(*) from o left outer join i on i.c = o.b where o.b = 1 or o.b = 2 or o.b >= i.c) g,
             (select sum(case when o.b = 1 or o.b = 2 or o.b >= i.c then 1 else 0 end) from o left outer join i on i.c = o.b) e from db_root) t;

-- G1: every disjunct reads wb: still null-rejecting (guard)
select 'G1' id, case when t.g = t.e and t.e = 1 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a, wc where wc.a = wb.b or wc.a = wb.b - 4) g,
             (select sum(case when wc.a = wb.b or wc.a = wb.b - 4 then 1 else 0 end) from wa left outer join wb on wb.a = wa.a, wc) e from db_root) t;

-- G2: range column itself is wb.b: still null-rejecting (guard)
select 'G2' id, case when t.g = t.e and t.e = 1 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a where wb.b in (7, 8)) g,
             (select sum(case when wb.b in (7, 8) then 1 else 0 end) from wa left outer join wb on wb.a = wa.a) e from db_root) t;

-- G3: the alternatives compare different columns: no range merge (guard)
select 'G3' id, case when t.g = t.e and t.e = 3 then 'PASS' else 'FAIL' end res
from (select (select count(*) from o left outer join i on i.c = o.b where (o.b >= 0) or (i.c >= 1)) g,
             (select sum(case when (o.b >= 0) or (i.c >= 1) then 1 else 0 end) from o left outer join i on i.c = o.b) e from db_root) t;

-- G4: every disjunct reads i: still null-rejecting (guard)
select 'G4' id, case when t.g = t.e and t.e = 0 then 'PASS' else 'FAIL' end res
from (select (select count(*) from o left outer join i on i.c = o.b where o.b >= i.c or o.b <= i.c) g,
             (select sum(case when o.b >= i.c or o.b <= i.c then 1 else 0 end) from o left outer join i on i.c = o.b) e from db_root) t;

-- G5: plain equality on wb: still null-rejecting (guard)
select 'G5' id, case when t.g = t.e and t.e = 0 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a, wc where wc.a = wb.b) g,
             (select sum(case when wc.a = wb.b then 1 else 0 end) from wa left outer join wb on wb.a = wa.a, wc) e from db_root) t;

-- G6: wc.a + 0 keeps the OR from being merged (guard)
select 'G6' id, case when t.g = t.e and t.e = 2 then 'PASS' else 'FAIL' end res
from (select (select count(*) from wa left outer join wb on wb.a = wa.a, wc where wc.a + 0 = wb.b or wc.a = wa.b) g,
             (select sum(case when wc.a + 0 = wb.b or wc.a = wa.b then 1 else 0 end) from wa left outer join wb on wb.a = wa.a, wc) e from db_root) t;

drop table if exists wa, wb, wc, o, i;
