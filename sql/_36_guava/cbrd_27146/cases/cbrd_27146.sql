/**
 *  This test case verifies CBRD-27146: the plans of a query without LIMIT are compared by cost, and the plans of equal
 *  cost by a fixed order of their properties
 *
 *  Before, rules picked the plan whenever two costs were less than 50 apart or less than 1.2 times apart: on a small
 *  table an index scan won over a cheaper sequential scan, and as the rules are relations between two plans, the plan
 *  kept could depend on the order the plans were generated in. Now the cheaper plan wins; a plan of one scan that skips
 *  a sort or is covering wins over one that costs less by less than 1%. Of two plans of equal cost the plan that skips
 *  a sort, is covering, has more key range terms, ... wins, then the order of the aliases and of the index names, so
 *  the order of the FROM list or of the index creation does not matter. The plans of a LIMIT query, and of a query
 *  that stops at a ROWNUM, are compared as before.
 *
 *  Coverage:
 *    Case 1:  a range that reads almost all the rows of a small table takes the cheaper sequential scan
 *    Case 2:  a range that reads few rows takes the index scan, the cheaper plan, as before
 *    Case 3:  ORDER BY ... LIMIT still takes the index scan that skips the ORDER BY (a LIMIT query keeps the rules)
 *    Case 4:  two indexes alike in statistics and cost: the same index whatever order they were created in
 *    Case 5:  a join of two tables alike: the same join order whatever the order of the FROM list
 *    Case 6:  WHERE ... ROWNUM <= n still takes the index scan (a query that stops at a ROWNUM keeps the rules)
 */


drop table if exists t27146, t27146_x, t27146_y, t27146_p, t27146_q;

create table t27146 (a int, b int, pad varchar(300));
insert into t27146 (a, b, pad)
  select rn, mod (rn, 10), repeat ('x', 200) from (select rownum as rn from db_class c1, db_class c2, db_class c3 limit 3000) s;
create index i_t27146_a on t27146 (a);
update statistics on t27146 with fullscan;

evaluate 'Case 1: a range that reads almost all the rows takes the sequential scan';
--@queryplan
select /*+ recompile */ count (pad) from t27146 where a > 10;

evaluate 'Case 2: a range that reads few rows takes the index scan';
--@queryplan
select /*+ recompile */ count (pad) from t27146 where a > 2990;

evaluate 'Case 3: ORDER BY ... LIMIT takes the index scan that skips the ORDER BY';
--@queryplan
select /*+ recompile */ a, b from t27146 where a > 0 order by a limit 5;

evaluate 'Case 6: WHERE ... ROWNUM <= n takes the index scan, as before';
--@queryplan
select /*+ recompile */ a, b from t27146 where a > 10 and rownum <= 5;


create table t27146_x (a int, b int, c int);
create table t27146_y (a int, b int, c int);
insert into t27146_x (a, b, c) select a, b, a from t27146;
insert into t27146_y (a, b, c) select a, b, a from t27146;
-- the same two indexes, created in the opposite order
create index i_t27146_ba on t27146_x (b, a);
create index i_t27146_bc on t27146_x (b, c);
create index i_t27146_bc on t27146_y (b, c);
create index i_t27146_ba on t27146_y (b, a);
update statistics on t27146_x with fullscan;
update statistics on t27146_y with fullscan;

evaluate 'Case 4: the same index for both tables';
--@queryplan
select /*+ recompile */ count (*) from t27146_x where b = 5;
--@queryplan
select /*+ recompile */ count (*) from t27146_y where b = 5;


create table t27146_p (k int, v int);
create table t27146_q (k int, v int);
insert into t27146_p (k, v) select a, b from t27146;
insert into t27146_q (k, v) select a, b from t27146;
update statistics on t27146_p with fullscan;
update statistics on t27146_q with fullscan;

evaluate 'Case 5: the same join order for both FROM lists (the outer is p)';
--@queryplan
select /*+ recompile */ count (*) from t27146_p p, t27146_q q where p.k = q.k;
--@queryplan
select /*+ recompile */ count (*) from t27146_q q, t27146_p p where p.k = q.k;


drop table t27146, t27146_x, t27146_y, t27146_p, t27146_q;
