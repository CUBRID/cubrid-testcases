/**
 *  This test case verifies CBRD-28009: a RIGHT OUTER JOIN keeps the unmatched rows of the preserved table when
 *  the NULL-padded table carries a path expression and the nested-loop inner is an Object fetch over its scan.
 *
 *  Bug: y RIGHT OUTER JOIN x is planned as a left outer nested-loop join with x as the outer. With a path
 *  expression on y the inner can be "Object fetch(y.r)" over "scan y". gen_inner () put every term passed down
 *  to the inner (ON join and during-join terms, WHERE terms) on the fetch, so the scan of y matched every row,
 *  NULL padding never happened and the unmatched x rows were dropped, and an ON term reading only x was ignored.
 *
 *  Fix: the terms that do not read the fetched object and have no subquery go to the scan under the fetch,
 *  the rest stay on the fetch.
 *
 *  Each check compares count(*) and a checksum weighing x.a, y.a and y.r.a (so a dropped, wrongly matched or
 *  wrongly padded row changes it) with values computed by hand from the data below. One row per check:
 *  id, PASS/FAIL. The join hints steer the planner to the defect plan, and the expected values do not depend on it.
 *
 *  Data t (a, b, r): (1, 1, ->3) (2, 1, NULL) (3, 9, ->1)
 *    x LEFT JOIN y ON x.a = y.b : (x1, y1, r.a 3) (x1, y2, NULL) (x2, NULL) (x3, NULL)
 *
 *  Coverage:
 *    P*: join hints that pick the defect plan, Oracle-style outer join, no hint
 *    D*: ON terms - preserved side only, NULL-padded side only, non-equi, no pair matches
 *    W*, S*: WHERE terms - IS NULL, path value, OR, nvl, NULL-rejecting, correlated subqueries
 *    M*, X1, N1, J2: two-level path, path on both sides, empty NULL-padded table, chain of right outer joins
 *    L*, I1: guards - LEFT JOIN forms, inner join on the path value
 *    K*: an index on the join column
 */
drop table if exists t, e;
create table t (a int, b int, r t) dont_reuse_oid;
insert into t (a, b) values (1, 1), (2, 1), (3, 9);
update t set r = (select s from t s where s.a = 3) where a = 1;
update t set r = (select s from t s where s.a = 1) where a = 3;
create table e (a int, b int, r t);
update statistics on t, e with fullscan;

-- Jira repro: 4 rows
select /*+ recompile use_hash(y) */ x.a, y.a, y.r.a from t y right outer join t x on x.a = y.b order by 1, 2;

-- P1: Jira repro, use_hash(y) (defect)
select /*+ recompile use_hash(y) */ 'P1' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b;

-- P2: use_merge(y) (defect)
select /*+ recompile use_merge(y) */ 'P2' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b;

-- P3: use_idx(y) (defect)
select /*+ recompile use_idx(y) */ 'P3' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b;

-- P8: no hint (guard)
select /*+ recompile */ 'P8' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b;

-- P9: Oracle-style outer join (defect)
select /*+ recompile use_hash(y) */ 'P9' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t y, t x where x.a = y.b(+);

-- D1: ON term on the preserved side only (during-join): x1 is padded, not matched (defect)
select /*+ recompile use_hash(y) */ 'D1' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 600 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b and x.a <> 1;

-- D2: ON term on the NULL-padded side only (defect)
select /*+ recompile use_hash(y) */ 'D2' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 620 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b and y.a > 1;

-- D3: non-equi ON term with an unmatched row (defect)
select /*+ recompile use_hash(y) */ 'D3' id, case when count (*) = 5 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 1166 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a > y.b;

-- D4: ON terms no pair satisfies: every x row padded (defect)
select /*+ recompile use_hash(y) */ 'D4' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 600 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b and y.b = 9;

-- D6: non-equi ON term every x row matches (guard)
select /*+ recompile use_hash(y) */ 'D6' id, case when count (*) = 6 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 1299 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a >= y.b;

-- W1: WHERE y.a IS NULL keeps only the padded rows (defect)
select /*+ recompile use_hash(y) */ 'W1' id, case when count (*) = 2 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 500 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b where y.a is null;

-- W2: WHERE on the path value, true for NULL (defect)
select /*+ recompile use_hash(y) */ 'W2' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 620 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b where y.r.a is null;

-- W3: WHERE OR of path value and preserved column (defect)
select /*+ recompile use_hash(y) */ 'W3' id, case when count (*) = 2 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 413 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b where y.r.a = 3 or x.a = 3;

-- W5: WHERE nvl of the path value (defect)
select /*+ recompile use_hash(y) */ 'W5' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 620 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b where nvl (y.r.a, 0) = 0;

-- W6: WHERE rejecting NULL of the path value (join becomes inner) (guard)
select /*+ recompile use_hash(y) */ 'W6' id, case when count (*) = 1 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 113 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b where y.r.a is not null;

-- S1: WHERE with a correlated subquery, true for the padded rows (defect)
select /*+ recompile use_hash(y) */ 'S1' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b where nvl (y.a, 0) <= (select max (z.a) from t z where z.a >= x.a);

-- S2: WHERE with a correlated subquery, false for one matched row (defect)
select /*+ recompile use_hash(y) */ 'S2' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 613 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b where nvl (y.a, 0) < (select count (*) from t z where z.a <> x.a);

-- M1: two-level path y.r.r.a (defect)
select /*+ recompile use_hash(y) */ 'M1' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0) + nvl (y.r.r.a, 0) * 1000), 0) = 1733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b;

-- M2: WHERE on the two-level path (defect)
select /*+ recompile use_hash(y) */ 'M2' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 620 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b where y.r.r.a is null;

-- M3: two-level path, WHERE reads only the first hop, during-join ON term (defect)
select /*+ recompile use_hash(y) */ 'M3' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0) + nvl (y.r.r.a, 0) * 1000), 0) = 1613 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b and x.a <> 3 where y.r.a = 3 or x.a > 1;

-- X1: path on both sides (defect)
select /*+ recompile use_hash(y) */ 'X1' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0) + nvl (x.r.a, 0) * 1000), 0) = 7733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b;

-- N1: empty NULL-padded side (defect)
select /*+ recompile use_hash(y) */ 'N1' id, case when count (*) = 3 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 600 then 'PASS' else 'FAIL' end res
  from e y right outer join t x on x.a = y.b;

-- J2: chain of right outer joins (defect)
select /*+ recompile use_hash(y) use_hash(x) */ 'J2' id, case when count (*) = 5 and nvl (sum (w.a * 1000 + nvl (x.a, 0) * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 8433 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b right outer join t w on w.a = x.b;

-- L1: LEFT JOIN form, use_hash(y) (guard)
select /*+ recompile use_hash(y) */ 'L1' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t x left outer join t y on x.a = y.b;

-- L5: path on the preserved side of a LEFT JOIN (guard)
select /*+ recompile use_hash(x) */ 'L5' id, case when count (*) = 3 and nvl (sum (y.a * 100 + nvl (x.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 624 then 'PASS' else 'FAIL' end res
  from t y left outer join t x on x.a = y.b;

-- I1: inner join on the path value (fetch before the join) (guard)
select /*+ recompile */ 'I1' id, case when count (*) = 2 and nvl (sum (x.a * 100 + y.a * 10 + y.r.a), 0) = 444 then 'PASS' else 'FAIL' end res
  from t y, t x where y.r.a = x.a;

create index i_t_b on t (b);
update statistics on t with fullscan;

-- K1: index on y.b, use_hash(y) (defect)
select /*+ recompile use_hash(y) */ 'K1' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b;

-- K2: index on y.b, use_merge(y) (defect)
select /*+ recompile use_merge(y) */ 'K2' id, case when count (*) = 4 and nvl (sum (x.a * 100 + nvl (y.a, 0) * 10 + nvl (y.r.a, 0)), 0) = 733 then 'PASS' else 'FAIL' end res
  from t y right outer join t x on x.a = y.b;

drop table if exists t, e;
