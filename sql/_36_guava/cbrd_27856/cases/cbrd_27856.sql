/*
 * This test case verifies CBRD-27856 : the row estimate of an outer join
 * skipped its lower bound when a WHERE condition was applied after the join.
 *
 * Bug: planner_visit_node () multiplied the selectivity of the after-join
 * terms together with the ON clause and set the lower bound of the outer
 * join result (the rows of the preserved side) only when there was no
 * after-join term. A WHERE condition true for every row of
 * t_a left join t_s therefore estimated the 20,000 rows as about 10, and a
 * query joining that derived table to t_o picked a nested loop join.
 *
 * Fix: the after-join terms are multiplied after the lower bound, so the
 * estimate is 20,000 times their selectivity.
 *
 * Data: t_a 20,000 rows, t_s 100 rows matching t_a.a 1..100,
 * t_o 1,000 rows without an index.
 *   Case 1: left join, (select max (b) from t_s) >= 0 -> hash join
 *           (the bug picks a nested loop join)
 *   Case 2: right join, the same condition -> hash join
 *   Case 3: left join, ifnull (t_s.b, t_a.b) >= 0 -> hash join
 *   Case 4: control, no WHERE -> hash join, the same before and after the fix
 *   Case 5: control, t_s.b is null -> nested loop join, the same before and
 *           after the fix (the NULL-extended rows are CBRD-27897)
 */
drop table if exists t_a, t_s, t_o;

create table t_a (a int, b int);
create table t_s (a int, b int);
create table t_o (k int, m int);

insert into t_a
  with recursive x (n) as (select 0 union all select n + 1 from x where n < 199)
  select x.n * 100 + y.n + 1, mod (x.n * 100 + y.n, 1000) + 1
    from x, x y
   where y.n < 100;

insert into t_s
  with recursive x (n) as (select 1 union all select n + 1 from x where n < 100)
  select n, n from x;

insert into t_o
  with recursive x (n) as (select 1 union all select n + 1 from x where n < 1000)
  select n, n from x;

update statistics on t_a, t_s, t_o with fullscan;

select count (*) from t_a;
select count (*) from t_s;
select count (*) from t_o;

evaluate '[1] left join, a WHERE condition true for every row: hash join';
--@queryplan
select /*+ recompile */ count (*)
  from (select t_a.a, t_a.b from t_a left join t_s on t_s.a = t_a.a where (select max (b) from t_s) >= 0) d, t_o
 where t_o.k = d.b;

evaluate '[2] right join, the same condition: hash join';
--@queryplan
select /*+ recompile */ count (*)
  from (select t_a.a, t_a.b from t_s right join t_a on t_s.a = t_a.a where (select max (b) from t_s) >= 0) d, t_o
 where t_o.k = d.b;

evaluate '[3] left join, ifnull (t_s.b, t_a.b) >= 0: hash join';
--@queryplan
select /*+ recompile */ count (*)
  from (select t_a.a, t_a.b from t_a left join t_s on t_s.a = t_a.a where ifnull (t_s.b, t_a.b) >= 0) d, t_o
 where t_o.k = d.b;

evaluate '[4] control, no WHERE: hash join';
--@queryplan
select /*+ recompile */ count (*)
  from (select t_a.a, t_a.b from t_a left join t_s on t_s.a = t_a.a) d, t_o
 where t_o.k = d.b;

evaluate '[5] control, t_s.b is null: nested loop join';
--@queryplan
select /*+ recompile */ count (*)
  from (select t_a.a, t_a.b from t_a left join t_s on t_s.a = t_a.a where t_s.b is null) d, t_o
 where t_o.k = d.b;

drop table t_a, t_s, t_o;
