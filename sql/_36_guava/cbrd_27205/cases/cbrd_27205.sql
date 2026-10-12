/**
 *  This test case verifies CBRD-27205: a query whose FROM clause holds a correlated derived
 *  table (a dptr not linked to a regu variable), e.g.
 *      SELECT count(*) FROM o, (SELECT * FROM i WHERE i.k = o.k) d
 *  scans the outer spec in parallel, and every worker re-executes the derived table per outer
 *  row on its own XASL clone.
 *
 *  Before the fix (engine PR #7794) the px_scan checker rejected every such dptr and the query
 *  ran serially. The checker now walks each dptr subtree and allows the parallel scan only
 *  when the subtree is worker safe; a serial NEXT_VALUE, a session variable write or a PL
 *  function call inside the derived table keeps the query serial. The PR also fixes the
 *  per-row teardown in the worker: it truncated a dptr list instead of destroying it, so a
 *  sort GROUP BY in the dptr (which swaps its list_id for the GROUP BY output list) read the
 *  aggregate operand at a wrong offset from the second outer row on.
 *
 *  Every check runs the same query with PARALLEL(4) and with NO_PARALLEL_SCAN, compares the
 *  commutative aggregates with <=> and, where the value is deterministic, a constant. The
 *  answer holds only PASS/FAIL and the masked traces. Both sides pin the outer index with
 *  "using index ix_o27205(+)" so the comparison cannot fall back to two table scans; Case 10
 *  pins "using index none" on both sides because its select-list subquery reaches the
 *  parallel worker only on a heap scan.
 *
 *  CTP runs with test_mode=yes (parallel_scan_page_threshold 32), and the server compares the
 *  b-tree page count of a parallel index scan with that threshold. o27205 holds 6000 rows with
 *  a (int, varchar(250)) key: about 110 b-tree pages and 120 heap pages. o.k <= 3000 (or 300)
 *  bounds the per-row re-executions of the derived table.
 *
 *  Coverage:
 *    Case 1:  fixture row counts
 *    Case 2:  count(*) over the basic correlated derived table
 *    Case 3:  row-returning derived table, count/sum/min/max over its column
 *    Case 4:  join inside the derived table
 *    Case 5:  sort GROUP BY inside the derived table
 *    Case 6:  scalar aggregate (BUILDVALUE) inside the derived table
 *    Case 7:  serial NEXT_VALUE inside the derived table: serial, row count correct
 *    Case 8:  session variable write (@v :=) inside the derived table: serial, sum correct
 *    Case 9:  PL function call inside the derived table: serial, sum correct
 *    Case 10: select-list scalar subquery with a sort GROUP BY over a non-group-key column,
 *             outer heap scan in parallel (mergeable list), compared row by row
 *    Case 11: the same sort GROUP BY as a correlated derived table
 *  Traces: Case 2 and Case 5 show the parallel index scan of o (buildvalue gather) with the
 *  correlated subquery below it, Case 7 shows the same plan without a parallel line, and
 *  Case 10 shows the parallel heap scan with the mergeable list gather.
 *
 *  For i.k2 = o.k the GROUP BY mod(i.g, 4) of Case 10 and 11 has a single group whose
 *  max(i.v) is o.k + 9000, so over o.k = 1..3000 the sum is 31501500. Case 11 is last
 *  because a broken build can abort the server there.
 */

drop table if exists o27205, i27205, rp27205, rs27205;
drop serial if exists s27205;

create table o27205 (k int, s varchar(250));
insert into o27205 select level, lpad('x', 250, 'x') from db_root connect by level <= 6000;
create index ix_o27205 on o27205 (k, s);

create table i27205 (k int, k2 int, g int, v int);
insert into i27205 select level, mod(level - 1, 3000) + 1, mod(level, 4), level from db_root connect by level <= 12000;
create index ix_i27205_k on i27205 (k);
create index ix_i27205_k2 on i27205 (k2, g, v);

create table rp27205 (k int, mv int);
create table rs27205 (k int, mv int);
create index ix_rs27205 on rs27205 (k);

create serial s27205;

create or replace function f27205 (x int) return int as begin return x + 1; end;

update statistics on o27205, i27205 with fullscan;


evaluate 'Case 1: fixture row counts';
select case when (select count(*) from o27205) = 6000 and (select count(*) from i27205) = 12000
            then 'PASS' else 'FAIL' end as case1;


evaluate 'Case 2: count(*) over the correlated derived table; parallel = serial = 3000';
set trace on;
select /*+ recompile parallel(4) */ count(*)
  from o27205 o, (select * from i27205 i where i.k = o.k) d
 where o.k <= 3000 using index ix_o27205(+);
show trace;
set trace off;
select case when p.c <=> s.c and p.c = 3000 then 'PASS' else 'FAIL' end as case2
  from (select /*+ recompile parallel(4) */ count(*) c
          from o27205 o, (select * from i27205 i where i.k = o.k) d
         where o.k <= 3000 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ count(*) c
          from o27205 o, (select * from i27205 i where i.k = o.k) d
         where o.k <= 3000 using index ix_o27205(+)) s;


evaluate 'Case 3: row-returning derived table; parallel = serial';
select case when p.c <=> s.c and p.sm <=> s.sm and p.mn <=> s.mn and p.mx <=> s.mx and p.c = 3000
            then 'PASS' else 'FAIL' end as case3
  from (select /*+ recompile parallel(4) */ count(d.v) c, sum(d.v) sm, min(d.v) mn, max(d.v) mx
          from o27205 o, (select i.v from i27205 i where i.k = o.k) d
         where o.k <= 3000 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ count(d.v) c, sum(d.v) sm, min(d.v) mn, max(d.v) mx
          from o27205 o, (select i.v from i27205 i where i.k = o.k) d
         where o.k <= 3000 using index ix_o27205(+)) s;


evaluate 'Case 4: join inside the derived table; parallel = serial';
select case when p.c <=> s.c and p.sm <=> s.sm and p.c = 3000 then 'PASS' else 'FAIL' end as case4
  from (select /*+ recompile parallel(4) */ count(*) c, sum(d.v1 + d.v2) sm
          from o27205 o, (select i1.v v1, i2.v v2 from i27205 i1, i27205 i2
                           where i1.k = o.k and i2.k = i1.k) d
         where o.k <= 3000 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ count(*) c, sum(d.v1 + d.v2) sm
          from o27205 o, (select i1.v v1, i2.v v2 from i27205 i1, i27205 i2
                           where i1.k = o.k and i2.k = i1.k) d
         where o.k <= 3000 using index ix_o27205(+)) s;


evaluate 'Case 5: sort GROUP BY inside the derived table; parallel = serial';
set trace on;
select /*+ recompile parallel(4) */ count(*)
  from o27205 o, (select mod(i.v, 7) m, count(*) c from i27205 i
                   where i.k2 = o.k group by mod(i.v, 7)) d
 where o.k <= 3000 using index ix_o27205(+);
show trace;
set trace off;
select case when p.c <=> s.c and p.sc <=> s.sc and p.sv <=> s.sv and p.sc = 12000 then 'PASS' else 'FAIL' end as case5
  from (select /*+ recompile parallel(4) */ count(*) c, sum(d.c) sc, sum(d.sv) sv
          from o27205 o, (select mod(i.v, 7) m, count(*) c, sum(i.v) sv from i27205 i
                           where i.k2 = o.k group by mod(i.v, 7)) d
         where o.k <= 3000 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ count(*) c, sum(d.c) sc, sum(d.sv) sv
          from o27205 o, (select mod(i.v, 7) m, count(*) c, sum(i.v) sv from i27205 i
                           where i.k2 = o.k group by mod(i.v, 7)) d
         where o.k <= 3000 using index ix_o27205(+)) s;


evaluate 'Case 6: scalar aggregate inside the derived table; parallel = serial';
select case when p.sv <=> s.sv and p.sc <=> s.sc and p.sc = 12000 then 'PASS' else 'FAIL' end as case6
  from (select /*+ recompile parallel(4) */ sum(d.sv) sv, sum(d.c) sc
          from o27205 o, (select sum(i.v) sv, count(*) c from i27205 i where i.k2 = o.k) d
         where o.k <= 3000 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ sum(d.sv) sv, sum(d.c) sc
          from o27205 o, (select sum(i.v) sv, count(*) c from i27205 i where i.k2 = o.k) d
         where o.k <= 3000 using index ix_o27205(+)) s;


evaluate 'Case 7: serial NEXT_VALUE inside the derived table stays serial; row count = 300';
set trace on;
select /*+ recompile parallel(4) */ count(d.nv)
  from o27205 o, (select i.v + s27205.next_value nv from i27205 i where i.k = o.k) d
 where o.k <= 300 using index ix_o27205(+);
show trace;
set trace off;
select case when p.c <=> s.c and p.c = 300 then 'PASS' else 'FAIL' end as case7
  from (select /*+ recompile parallel(4) */ count(d.nv) c
          from o27205 o, (select i.v + s27205.next_value nv from i27205 i where i.k = o.k) d
         where o.k <= 300 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ count(d.nv) c
          from o27205 o, (select i.v + s27205.next_value nv from i27205 i where i.k = o.k) d
         where o.k <= 300 using index ix_o27205(+)) s;


evaluate 'Case 8: session variable write inside the derived table stays serial; sum = 45150';
select case when p.sm <=> s.sm and p.sm = 45150 then 'PASS' else 'FAIL' end as case8
  from (select /*+ recompile parallel(4) */ sum(d.av) sm
          from o27205 o, (select (@v27205 := i.v) av from i27205 i where i.k = o.k) d
         where o.k <= 300 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ sum(d.av) sm
          from o27205 o, (select (@v27205 := i.v) av from i27205 i where i.k = o.k) d
         where o.k <= 300 using index ix_o27205(+)) s;
deallocate variable @v27205;


evaluate 'Case 9: PL function call inside the derived table stays serial; sum = 45450';
select case when p.sm <=> s.sm and p.sm = 45450 then 'PASS' else 'FAIL' end as case9
  from (select /*+ recompile parallel(4) */ sum(d.fv) sm
          from o27205 o, (select f27205(i.v) fv from i27205 i where i.k = o.k) d
         where o.k <= 300 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ sum(d.fv) sm
          from o27205 o, (select f27205(i.v) fv from i27205 i where i.k = o.k) d
         where o.k <= 300 using index ix_o27205(+)) s;


evaluate 'Case 10: select-list sort GROUP BY subquery, parallel heap scan; rows equal, sum = 31501500';
set trace on;
insert into rp27205
  select /*+ recompile parallel(4) */ o.k, (select /*+ no_hash_aggregate */ max(i.v) from i27205 i
                                            where i.k2 = o.k group by mod(i.g, 4))
    from o27205 o where o.k <= 3000 using index none;
show trace;
set trace off;
insert into rs27205
  select /*+ recompile no_parallel_scan */ o.k, (select /*+ no_hash_aggregate */ max(i.v) from i27205 i
                                                 where i.k2 = o.k group by mod(i.g, 4))
    from o27205 o where o.k <= 3000 using index none;
select case when (select count(*) from rp27205 p, rs27205 s where p.k = s.k and not (p.mv <=> s.mv)) = 0
             and (select count(*) from rp27205) = 3000
             and (select count(*) from rs27205) = 3000
             and (select sum(mv) from rs27205) = 31501500
            then 'PASS' else 'FAIL' end as case10;


evaluate 'Case 11: the same sort GROUP BY as a correlated derived table; parallel = serial';
select case when p.c <=> s.c and p.cm <=> s.cm and p.sm <=> s.sm and p.mn <=> s.mn and p.mx <=> s.mx
             and p.sm = 31501500 and p.c = 3000
            then 'PASS' else 'FAIL' end as case11
  from (select /*+ recompile parallel(4) */ count(*) c, count(d.mv) cm, sum(d.mv) sm, min(d.mv) mn, max(d.mv) mx
          from o27205 o, (select /*+ no_hash_aggregate */ max(i.v) mv from i27205 i
                           where i.k2 = o.k group by mod(i.g, 4)) d
         where o.k <= 3000 using index ix_o27205(+)) p,
       (select /*+ recompile no_parallel_scan */ count(*) c, count(d.mv) cm, sum(d.mv) sm, min(d.mv) mn, max(d.mv) mx
          from o27205 o, (select /*+ no_hash_aggregate */ max(i.v) mv from i27205 i
                           where i.k2 = o.k group by mod(i.g, 4)) d
         where o.k <= 3000 using index ix_o27205(+)) s;


drop function f27205;
drop serial if exists s27205;
drop table if exists o27205, i27205, rp27205, rs27205;
