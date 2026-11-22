/**
 *  This test case verifies CBRD-28206: a merge RIGHT OUTER JOIN whose ON clause has a term besides the merge key
 *  (a during-join term) returns a NULL-extended row only for a right row that no left row of its key matched.
 *
 *  Bug: the outer merge decided the NULL-extended row of a right row on the first left row of the key group only.
 *  When that left row failed the during-join term, (NULL, right) was added at once, so a right row matched by a
 *  later left row of the same key came back twice: once matched and once NULL-extended.
 *
 *  Fix: each right row of the key group records whether any left row matched it, and the NULL-extended rows are
 *  added when the key group ends.
 *
 *  The USE_MERGE hint picks the merge join. The rows of J* and M1 are the correct results (the same as the
 *  USE_NL hint). The other checks compare count(*), count of the left id and a checksum of the merge join with
 *  the same query under the USE_NL hint and print one row: id, PASS/FAIL.
 *
 *  Coverage:
 *    J1, J2, J3: the reported queries (the left side of J2 is a LEFT JOIN result)
 *    M1, M2: many-to-many key groups where the passing left row is the first, a middle or the last one, a group
 *            where every left row fails, NULL keys and keys on one side only
 *    L1: LEFT OUTER JOIN of the same tables (guard, was already correct)
 *    O1: the left side is a LEFT JOIN result and the term reads only the left side
 *    B1: one key group of 20 x 200 rows whose right list spans several pages
 */
drop table if exists tx, ty, tz, ga, gb, la, rb, hl, hr;

create table tx (id int, k int, v int);
create table ty (id int, k int);
create table tz (id int, v int);
insert into tx values (1, null, 1), (2, 5, 1), (3, null, 2);
insert into ty values (10, 1);
insert into tz values (100, 1), (200, 2), (300, 3);

create table ga (a int, b int);
create table gb (a int, b int);
insert into ga values (1, 1), (1, 2);
insert into gb values (1, 2), (2, 2);

create table la (id int, k int, p int);
create table rb (id int, k int, q int);
insert into la values
  (1, null, 1), (2, null, 1),
  (11, 1, 1), (12, 1, 0), (13, 1, 0),
  (21, 2, 0), (22, 2, 1), (23, 2, 0),
  (31, 3, 0), (32, 3, 0), (33, 3, 1),
  (41, 4, 0), (42, 4, 0), (43, 4, 0),
  (51, 5, 1), (52, 5, 1), (53, 5, 1),
  (71, 7, 0),
  (111, 11, 0), (112, 11, 0), (113, 11, 1), (114, 11, 0);
insert into rb values
  (1000, null, 1),
  (1001, 0, 1),
  (1011, 1, 1), (1012, 1, 2), (1013, 1, null),
  (1021, 2, 1), (1022, 2, 2),
  (1031, 3, 1), (1032, 3, 2),
  (1041, 4, 1), (1042, 4, 2),
  (1051, 5, 1), (1052, 5, 2),
  (1071, 7, 1),
  (1101, 10, 1),
  (1111, 11, 1), (1112, 11, 1), (1113, 11, 2);

create table hl (id int, k int, pad varchar (200));
create table hr (id int, k int, pad varchar (200));
insert into hl select rownum, 1, lpad (cast (rownum as varchar), 200, 'x') from db_class a, db_class b limit 20;
insert into hr select rownum, 1, lpad (cast (rownum as varchar), 200, 'y') from db_class a, db_class b limit 200;

-- J1
select /*+ USE_MERGE */ tx.id, tz.id from tx right outer join tz on tx.v = tz.v and tx.k > tz.id - 100 order by 2, 1;

-- J2
select /*+ USE_MERGE */ tx.id, ty.id, tz.id
from (tx left outer join ty on tx.v = ty.k) right outer join tz on tx.v = tz.v and tx.k > 3
order by 3, 1, 2;

-- J3
select /*+ USE_MERGE */ ga.b, gb.a, gb.b from ga right join gb on ga.a = gb.a and ga.b <> gb.a order by 2, 1;

-- M1
select /*+ USE_MERGE */ la.id, la.p, rb.id, rb.q from la right join rb on la.k = rb.k and la.p - rb.q = 0 order by 3, 1;

-- M2
select 'M2' id, case when m.c = n.c and m.cl = n.cl and m.s = n.s then 'PASS' else 'FAIL' end res
from (select /*+ USE_MERGE */ count (*) c, count (la.id) cl, sum (nvl (la.id, 0) * 10000 + rb.id) s
      from la right join rb on la.k = rb.k and la.p < rb.q) m,
     (select /*+ USE_NL */ count (*) c, count (la.id) cl, sum (nvl (la.id, 0) * 10000 + rb.id) s
      from la right join rb on la.k = rb.k and la.p < rb.q) n;

-- L1
select 'L1' id, case when m.c = n.c and m.cl = n.cl and m.s = n.s then 'PASS' else 'FAIL' end res
from (select /*+ USE_MERGE */ count (*) c, count (la.id) cl, sum (nvl (la.id, 0) * 10000 + rb.id) s
      from rb left join la on la.k = rb.k and la.p - rb.q = 0) m,
     (select /*+ USE_NL */ count (*) c, count (la.id) cl, sum (nvl (la.id, 0) * 10000 + rb.id) s
      from rb left join la on la.k = rb.k and la.p - rb.q = 0) n;

-- O1
select 'O1' id, case when m.c = n.c and m.cl = n.cl and m.s = n.s then 'PASS' else 'FAIL' end res
from (select /*+ USE_MERGE */ count (*) c, count (la.id) cl, sum (nvl (la.id, 0) * 10000 + nvl (ty.id, 0) * 100 + rb.id) s
      from (la left outer join ty on la.p = ty.k) right outer join rb on la.k = rb.k and la.p > 0) m,
     (select /*+ USE_NL */ count (*) c, count (la.id) cl, sum (nvl (la.id, 0) * 10000 + nvl (ty.id, 0) * 100 + rb.id) s
      from (la left outer join ty on la.p = ty.k) right outer join rb on la.k = rb.k and la.p > 0) n;

-- B1: hr rows 10, 20, ..., 200 match hl rows 1 .. 20; the other 180 hr rows are NULL-extended
select 'B1' id, case when m.c = 200 and m.cl = 20 and m.c = n.c and m.cl = n.cl and m.s = n.s and m.pl = n.pl
                     then 'PASS' else 'FAIL' end res
from (select /*+ USE_MERGE */ count (*) c, count (hl.id) cl, sum (nvl (hl.id, 0) * 1000 + hr.id) s,
             sum (nvl (length (hl.pad), 0) + length (hr.pad)) pl
      from hl right join hr on hl.k = hr.k and hl.id * 10 - hr.id = 0) m,
     (select /*+ USE_NL */ count (*) c, count (hl.id) cl, sum (nvl (hl.id, 0) * 1000 + hr.id) s,
             sum (nvl (length (hl.pad), 0) + length (hr.pad)) pl
      from hl right join hr on hl.k = hr.k and hl.id * 10 - hr.id = 0) n;

drop table if exists tx, ty, tz, ga, gb, la, rb, hl, hr;
