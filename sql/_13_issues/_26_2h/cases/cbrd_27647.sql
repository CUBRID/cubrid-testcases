/**
 *  CBRD-27647: an analytic function nested in an expression of a non-mergeable derived table
 *  must keep its PARTITION BY / ORDER BY columns when the main query does not reference them.
 *
 *  The OVER clause refers to those columns by their position in the select list. When the
 *  columns the main query does not reference are removed from the derived table, the positions
 *  of an analytic function nested in an expression were not renumbered, so it was partitioned
 *  and sorted by the wrong columns. LAG, LEAD and ROW_NUMBER depend on the partition and the
 *  order, so a wrong column changes their values.
 *
 *  Coverage:
 *  1    the reported queries, and the unchanged select list (g, x, d) as the reference
 *  2    the main query selects some of the columns
 *  3    the main query selects all the columns in another order
 *  4    g and x referenced only in the ORDER BY of the main query
 *  5    g and x referenced only in the WHERE of the main query
 *  6    the analytic function inside an expression in CASE
 *  7    the analytic function as the argument of a generic function (ELT)
 *  8    + 0 around ROW_NUMBER, which hit an assertion on debug builds
 *  9    two analytic functions in one expression
 *  10   the analytic function as the whole select list item, which was already renumbered
 *  11   the same derived table as a named view
 *  12   the same derived table in a WITH clause
 */

drop table if exists t;

create table t (g int, x int);

insert into t values (2, 300), (1, 20), (2, 100), (1, 30), (2, 200), (1, 10);


evaluate 'Case 1: the reported queries -- the main query selects only d, aggregates d, or selects g, x, d in the original order';
select /*+ recompile */ d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by d;
select /*+ recompile */ sum(d) as sd from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s;
select /*+ recompile */ g, x, d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by g, x;


evaluate 'Case 2: the main query selects some of the columns';
select /*+ recompile */ x, d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by x;
select /*+ recompile */ g, d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by g, d;


evaluate 'Case 3: the main query selects all the columns in another order';
select /*+ recompile */ d, g, x from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by g, x;


evaluate 'Case 4: g and x are referenced only in the ORDER BY of the main query';
select /*+ recompile */ d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by g, x;


evaluate 'Case 5: g and x are referenced only in the WHERE of the main query';
select /*+ recompile */ d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s where g = 2 order by d;


evaluate 'Case 6: the analytic function inside an expression in CASE';
select /*+ recompile */ d from (select g, x, case when x > 0 then x - lag(x) over (partition by g order by x) end as d from t) s order by d;


evaluate 'Case 7: the analytic function as the argument of a generic function (ELT)';
select /*+ recompile */ d from (select g, x, elt(1, row_number() over (partition by g order by x)) as d from t) s order by d;


evaluate 'Case 8: + 0 around ROW_NUMBER, which hit an assertion on debug builds';
select /*+ recompile */ d from (select g, x, row_number() over (partition by g order by x) + 0 as d from t) s order by d;


evaluate 'Case 9: two analytic functions in one expression';
select /*+ recompile */ d from (select g, x, lead(x) over (partition by g order by x) - lag(x) over (partition by g order by x) as d from t) s order by d;


evaluate 'Case 10: the analytic function as the whole select list item, which was already renumbered';
select /*+ recompile */ lg from (select g, x, lag(x) over (partition by g order by x) as lg from t) s order by lg;


evaluate 'Case 11: the same derived table as a named view';
create or replace view v1 as select g, x, x - lag(x) over (partition by g order by x) as d from t;
select /*+ recompile */ d from v1 order by d;
select /*+ recompile */ sum(d) as sd from v1;


evaluate 'Case 12: the same derived table in a WITH clause';
with s as (select g, x, x - lag(x) over (partition by g order by x) as d from t)
select /*+ recompile */ sum(d) as sd from s;


drop view v1;
drop table t;
