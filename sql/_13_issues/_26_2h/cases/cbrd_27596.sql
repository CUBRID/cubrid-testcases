/**
 *  This test case verifies CBRD-27596: a stored function not declared PARALLEL_ENABLE anywhere in
 *  a subquery of a parallel heap scan no longer runs in the scan workers.
 *
 *  Before the fix the parallel scan checker looked only at the predicates of the first table of the
 *  subquery. A function in its select list, aggregate, GROUP BY, ORDER BY, key range, later join table
 *  or nested block ran in a worker: one that runs SQL never returned, and an optdebug server
 *  aborted at the first call. Now such a scan is serial, or row by row when the subquery is in the
 *  outer select list or an aggregate argument, the rule a function written there follows.
 *
 *  Every tested query is followed by its no_parallel_scan twin and the result blocks must match.
 *  The subqueries read a one-page table, so the hint on the outer block is the whole twin. f_pn and
 *  f_pp differ only in the declaration, and f_sq runs a query and returns the same values. The line
 *  "(parallel workers: ?, ... gather: ...)" under the scan of t_big shows the plan, and CTP masks
 *  digits, so only that line and its gather kind are checked.
 *
 *  Coverage:
 *    Case 1:  subquery select list (the issue), also under an outer GROUP BY, serial
 *    Case 2:  subquery aggregate, GROUP BY, HAVING, ORDER BY LIMIT, PARTITION BY, serial
 *    Case 3:  subquery key range, later NL table, hash join and UNION ALL, serial
 *    Case 4:  nested subquery, derived table and IN subquery inside the subquery, serial
 *    Case 5:  subquery in the outer select list or aggregate argument, row by row
 *    Case 6:  key range of the inner table of an outer NL join, serial
 *    Case 7:  uncorrelated scalar subquery, with ROWNUM and with the select list
 *    Case 8:  the declared function in the same places keeps the parallel plans
 *    Case 9:  subqueries without a function keep their parallel plans
 *    Case 10: function in the predicate of the first table of the subquery, serial as before
 */

drop table if exists t_big, t_small;

-- 65536 rows of (int, int): about 145 heap pages, 4.5x the 32-page parallel scan threshold of test_mode
create table t_big (a int, b int);
insert into t_big select rownum, rownum from db_class x, db_class y, db_class z, db_class w limit 65536;
-- three rows read by every subquery: one page, never scanned in parallel itself
create table t_small (a int primary key, b int);
insert into t_small values (1, 1), (2, 2), (3, 3);
update statistics on t_big, t_small with fullscan;

create function f_pn (n int) return int as begin return n + 1; end;
create function f_pp (n int) return int parallel_enable as begin return n + 1; end;
create function f_sq (n int) return int as v int; begin select b into v from t_small where a = 1; return n + v; end;

set trace on;


evaluate 'Case 1: subquery select list, also under an outer GROUP BY, serial; result = no_parallel_scan';
select /*+ recompile */ count(*) from t_big where a <= 10 and b > (select f_sq (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1);
select /*+ recompile */ count(*) from t_big where a <= 10 and b > (select f_pn (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1);
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where a <= 10 and b > (select f_pn (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1);
select /*+ recompile */ mod (a, 2) g, sum (a) from t_big where a <= 10 and b > (select f_sq (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1) group by mod (a, 2) order by 1;
select /*+ recompile no_parallel_scan */ mod (a, 2) g, sum (a) from t_big where a <= 10 and b > (select f_sq (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1) group by mod (a, 2) order by 1;


evaluate 'Case 2: subquery aggregate, GROUP BY, HAVING, ORDER BY LIMIT, PARTITION BY, serial; result = no_parallel_scan';
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select min (f_pn (z.b)) from t_small z where z.a = mod (t_big.a, 3) + 1);
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select min (f_pn (z.b)) from t_small z where z.a = mod (t_big.a, 3) + 1);
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select max (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1 group by f_pn (z.b));
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select max (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1 group by f_pn (z.b));
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select max (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1 having f_pn (max (z.b)) > 2);
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select max (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1 having f_pn (max (z.b)) > 2);
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select z.b from t_small z where z.a = mod (t_big.a, 3) + 1 order by f_pn (z.b) limit 1);
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select z.b from t_small z where z.a = mod (t_big.a, 3) + 1 order by f_pn (z.b) limit 1);
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select max (z.b) over (partition by f_pn (z.b)) from t_small z where z.a = mod (t_big.a, 3) + 1);
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select max (z.b) over (partition by f_pn (z.b)) from t_small z where z.a = mod (t_big.a, 3) + 1);


evaluate 'Case 3: subquery key range, later NL table, hash join and UNION ALL, serial; result = no_parallel_scan';
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select z.b from t_small z where z.a = f_pn (mod (t_big.a, 3)));
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select z.b from t_small z where z.a = f_pn (mod (t_big.a, 3)));
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select /*+ ordered use_nl */ max (z.b) from t_small z, t_small y where z.a = mod (t_big.a, 3) + 1 and y.a = z.a and f_pn (y.b) > 2);
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select /*+ ordered use_nl */ max (z.b) from t_small z, t_small y where z.a = mod (t_big.a, 3) + 1 and y.a = z.a and f_pn (y.b) > 2);
-- the hash join and the UNION ALL are checked by their results only: show trace over such a
-- subquery without a function crashes a release server (a separate issue)
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select /*+ ordered use_hash */ max (z.b) from t_small z, t_small y where z.a = mod (t_big.a, 3) + 1 and y.a = z.a and f_sq (y.b) > 2);
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select /*+ ordered use_hash */ max (z.b) from t_small z, t_small y where z.a = mod (t_big.a, 3) + 1 and y.a = z.a and f_sq (y.b) > 2);
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select max (u.v) from (select f_sq (z.b) v from t_small z where z.a = mod (t_big.a, 3) + 1 union all select 0 from db_root) u);
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select max (u.v) from (select f_sq (z.b) v from t_small z where z.a = mod (t_big.a, 3) + 1 union all select 0 from db_root) u);


evaluate 'Case 4: nested subquery, derived table and IN subquery inside the subquery, serial; result = no_parallel_scan';
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select (select f_pn (y.b) from t_small y where y.a = z.a) from t_small z where z.a = mod (t_big.a, 3) + 1);
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select (select f_pn (y.b) from t_small y where y.a = z.a) from t_small z where z.a = mod (t_big.a, 3) + 1);
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select max (d.v) from (select y.a, f_pn (y.b) v from t_small y limit 10) d where d.a = mod (t_big.a, 3) + 1);
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select max (d.v) from (select y.a, f_pn (y.b) v from t_small y limit 10) d where d.a = mod (t_big.a, 3) + 1);
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select max (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1 and z.b in (select f_pn (w.b) - 1 from t_small w));
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select max (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1 and z.b in (select f_pn (w.b) - 1 from t_small w));


evaluate 'Case 5: subquery in the outer select list or aggregate argument, row by row; result = no_parallel_scan';
select /*+ recompile */ a, (select f_pn (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1) v from t_big where a <= 3 order by a;
show trace;
select /*+ recompile no_parallel_scan */ a, (select f_pn (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1) v from t_big where a <= 3 order by a;
select /*+ recompile */ a, (select f_sq (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1) v from t_big where a <= 3 order by a;
select /*+ recompile */ max ((select f_pn (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1)), sum (a) from t_big where a <= 10;
show trace;
select /*+ recompile no_parallel_scan */ max ((select f_pn (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1)), sum (a) from t_big where a <= 10;
select /*+ recompile */ mod (a, 3) g, max ((select f_pn (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1)) m, count(*) from t_big where a <= 10 group by mod (a, 3) order by 1;
select /*+ recompile no_parallel_scan */ mod (a, 3) g, max ((select f_pn (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1)) m, count(*) from t_big where a <= 10 group by mod (a, 3) order by 1;


evaluate 'Case 6: key range of the inner table of an outer NL join, serial; result = no_parallel_scan';
select /*+ recompile ordered use_nl */ count(*), sum (t_big.a) from t_big, t_small y where t_big.a <= 10 and y.a = f_pn (mod (t_big.a, 3));
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum (t_big.a) from t_big, t_small y where t_big.a <= 10 and y.a = f_pn (mod (t_big.a, 3));


evaluate 'Case 7: uncorrelated scalar subquery, with ROWNUM and with the select list; result = no_parallel_scan';
-- results only: whether these plans may stay parallel is left to a later change
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select f_sq (z.b) from t_small z where z.a = 1);
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select f_sq (z.b) from t_small z where z.a = 1);
select /*+ recompile */ count(*) from t_big where a <= 10 and b > (select f_sq (z.b) from t_small z where z.a = 1) and rownum <= 100;
select /*+ recompile no_parallel_scan */ count(*) from t_big where a <= 10 and b > (select f_sq (z.b) from t_small z where z.a = 1) and rownum <= 100;
select /*+ recompile */ a, f_pn (b) from t_big where a <= 3 and b > (select f_pn (z.b) from t_small z where z.a = 1) order by a;
select /*+ recompile no_parallel_scan */ a, f_pn (b) from t_big where a <= 3 and b > (select f_pn (z.b) from t_small z where z.a = 1) order by a;


evaluate 'Case 8: the declared function in the same places keeps the parallel plans; result = no_parallel_scan';
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select f_pp (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1);
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select f_pp (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1);
select /*+ recompile */ max ((select f_pp (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1)), sum (a) from t_big where a <= 10;
show trace;
select /*+ recompile no_parallel_scan */ max ((select f_pp (z.b) from t_small z where z.a = mod (t_big.a, 3) + 1)), sum (a) from t_big where a <= 10;
select /*+ recompile ordered use_nl */ count(*), sum (t_big.a) from t_big, t_small y where t_big.a <= 10 and y.a = f_pp (mod (t_big.a, 3));
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum (t_big.a) from t_big, t_small y where t_big.a <= 10 and y.a = f_pp (mod (t_big.a, 3));


evaluate 'Case 9: subqueries without a function keep their parallel plans; result = no_parallel_scan';
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select z.b from t_small z where z.a = mod (t_big.a, 3) + 1 order by abs (z.b) limit 1);
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select z.b from t_small z where z.a = mod (t_big.a, 3) + 1 order by abs (z.b) limit 1);
select /*+ recompile ordered use_nl */ count(*), sum (t_big.a) from t_big, t_small y where t_big.a <= 10 and y.a = abs (mod (t_big.a, 3)) + 1;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum (t_big.a) from t_big, t_small y where t_big.a <= 10 and y.a = abs (mod (t_big.a, 3)) + 1;


evaluate 'Case 10: function in the predicate of the subquery first table, serial as before; result = no_parallel_scan';
select /*+ recompile */ count(*), sum (a) from t_big where a <= 10 and b > (select z.b from t_small z where z.a = mod (t_big.a, 3) + 1 and f_pn (z.b) > 0);
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_scan */ count(*), sum (a) from t_big where a <= 10 and b > (select z.b from t_small z where z.a = mod (t_big.a, 3) + 1 and f_pn (z.b) > 0);

drop function f_pn, f_pp, f_sq;
drop table t_big, t_small;
