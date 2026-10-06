/**
 *  This test case verifies CBRD-27561: a serial NEXTVAL evaluated in a PARALLEL_ENABLE
 *  function argument must not run beside other parallel threads of its transaction.
 *
 *  NEXTVAL updates the serial row in a system operation, and the thread that opens a
 *  system operation holds the transaction mutex rmutex_topop until the operation ends.
 *  While a thread calls a stored function it is registered in the PL session, and the
 *  mutex lets another thread of the transaction re-enter it through a registered owner
 *  instead of waiting. A PARALLEL_ENABLE function evaluates its arguments after that
 *  registration. Two parallel subqueries that updated different serials through such an
 *  argument therefore opened and closed system operations at the same time, and a debug
 *  server aborted on an rmutex assertion. A parallel hash join that evaluates such an
 *  argument in its join predicates has the same exposure.
 *
 *  The fix (engine PR #8106) runs the subqueries of a statement serially when the
 *  statement has both a stored function or method call and a NEXTVAL. It also keeps a
 *  hash join serial when a PARALLEL_ENABLE function argument in its join predicates
 *  holds a NEXTVAL. A PARALLEL_ENABLE function without NEXTVAL, and NEXTVAL without a
 *  stored function, keep their parallel plans.
 *
 *  The abort needs the two serials on different heap pages and two threads inside
 *  serial updates at the same moment, which a test case cannot arrange. The cases
 *  therefore assert the plan. CTP runs with test_mode=yes, which masks volatile trace
 *  values to '?', and the traces show whether the SUBQUERY or HASHJOIN line carries
 *  parallel workers. Every result is a count that does not depend on the serial values.
 *
 *  Coverage:
 *    Case 1:  PARALLEL_ENABLE function over NEXTVAL in both UNION ALL branches,
 *             the subqueries run serially
 *    Case 2:  PARALLEL_ENABLE function over a column, the subqueries stay parallel
 *    Case 3:  NEXTVAL without a stored function, the subqueries stay parallel
 *    Case 4:  the function in one branch and NEXTVAL in the other, the subqueries
 *             run serially (the rule covers the whole statement)
 *    Case 5:  NEXTVAL in a PARALLEL_ENABLE function argument of a hash join
 *             predicate, the hash join runs serially
 *    Case 6:  hash join predicate with the function over a column, or with NEXTVAL
 *             outside the function argument, the hash join stays parallel
 */

drop table if exists t_u, t_h1, t_h2;
drop serial if exists s_a;
drop serial if exists s_b;

-- UNION ALL input, each branch reads 2000 rows
create table t_u (a int);
insert into t_u select rownum from db_class c1, db_class c2, db_class c3 limit 10000;

-- hash join inputs of 100000 rows each, so the build input spans many pages, only ids 99001 to 100000 match
create table t_h1 (id int, v int);
insert into t_h1 select rownum, mod (rownum, 100) from db_class a, db_class b, db_class c, db_class d limit 100000;
create table t_h2 (id int, v int);
insert into t_h2 select rownum + 99000, mod (rownum, 100) from db_class a, db_class b, db_class c, db_class d limit 100000;

create or replace function f_pe (x int) return int parallel_enable as
begin
  return x + 1;
end;

create serial s_a;
create serial s_b;

update statistics on t_u, t_h1, t_h2 with fullscan;

set trace on;


evaluate 'Case 1: PARALLEL_ENABLE function over NEXTVAL in both UNION ALL branches; no parallel workers';
select /*+ recompile */ count(*), count(distinct x) from (select f_pe (s_a.nextval) as x from t_u where a between 1 and 2000 union all select f_pe (s_b.nextval) + 100000 as x from t_u where a between 2001 and 4000) u;
show trace;


evaluate 'Case 2: PARALLEL_ENABLE function over a column in both UNION ALL branches; parallel workers';
select /*+ recompile */ count(*), count(distinct x) from (select f_pe (a) as x from t_u where a between 1 and 2000 union all select f_pe (a) + 100000 as x from t_u where a between 2001 and 4000) u;
show trace;


evaluate 'Case 3: NEXTVAL without a stored function in both UNION ALL branches; parallel workers';
select /*+ recompile */ count(*), count(distinct x) from (select s_a.nextval as x from t_u where a between 1 and 2000 union all select s_b.nextval + 100000 as x from t_u where a between 2001 and 4000) u;
show trace;


evaluate 'Case 4: PARALLEL_ENABLE function in one branch and NEXTVAL in the other; no parallel workers';
select /*+ recompile */ count(*), count(distinct x) from (select f_pe (a) as x from t_u where a between 1 and 2000 union all select s_b.nextval + 100000 as x from t_u where a between 2001 and 4000) u;
show trace;


-- a small hash list budget makes the hash join split its input and join the parts in parallel
set system parameters 'max_hash_list_scan_size=256k';


evaluate 'Case 5: NEXTVAL in a PARALLEL_ENABLE function argument of a hash join predicate; no parallel workers';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_h1 a, t_h2 b where a.id = b.id and a.v + b.v + 0 * f_pe (s_a.nextval) >= 0;
show trace;


evaluate 'Case 6: hash join predicate with the function over a column, or with NEXTVAL outside the function; parallel workers';
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_h1 a, t_h2 b where a.id = b.id and a.v + b.v + 0 * f_pe (a.v) >= 0;
show trace;
select /*+ recompile use_hash no_parallel_scan no_parallel_subquery */ count(*) from t_h1 a, t_h2 b where a.id = b.id and a.v + b.v + 0 * f_pe (a.v) + 0 * s_a.nextval >= 0;
show trace;


set system parameters 'max_hash_list_scan_size=default';
set trace off;

drop function f_pe;
drop serial s_a;
drop serial s_b;
drop table t_u, t_h1, t_h2;
