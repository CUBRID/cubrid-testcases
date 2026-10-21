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
 *  2    the main query selects some of the columns, or all of them in another order
 *  3    g and x referenced only in the WHERE or ORDER BY of the main query
 *  4    the OVER clause written with ordinals
 *  5    deeper nesting: CASE, and a generic function (ELT)
 *  6    + 0 around ROW_NUMBER, which hit an assertion on debug builds
 *  7    two analytic functions in one expression
 *  8    the analytic function as the whole select list item, which was already renumbered
 *  9    the same derived table through a named view and a WITH clause
 */

drop table if exists t;

create table t (g int, x int);

insert into t values (2, 300), (1, 20), (2, 100), (1, 30), (2, 200), (1, 10);


evaluate 'Case 1: the reported queries -- the main query selects only d, aggregates d, or selects g, x, d in the original order';
select /*+ recompile */ d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by d;
select /*+ recompile */ sum(d) as sd from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s;
select /*+ recompile */ g, x, d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by g, x;


evaluate 'Case 2: the main query selects some of the columns, or all of them in another order';
select /*+ recompile */ x, d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by x;
select /*+ recompile */ g, d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by g, d;
select /*+ recompile */ d, g, x from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by g, x;


evaluate 'Case 3: g and x are referenced only in the WHERE or ORDER BY of the main query';
select /*+ recompile */ d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s order by g, x;
select /*+ recompile */ d from (select g, x, x - lag(x) over (partition by g order by x) as d from t) s where g = 2 order by d;


evaluate 'Case 4: the OVER clause written with ordinals';
select /*+ recompile */ d from (select g, x, x - lag(x) over (partition by 1 order by 2) as d from t) s order by d;


evaluate 'Case 5: the analytic function nested two levels down, in CASE and in a generic function';
select /*+ recompile */ d from (select g, x, case when x > 0 then x - lag(x) over (partition by g order by x) end as d from t) s order by d;
select /*+ recompile */ d from (select g, x, elt(1, row_number() over (partition by g order by x)) as d from t) s order by d;


evaluate 'Case 6: + 0 around ROW_NUMBER, which hit an assertion on debug builds';
select /*+ recompile */ d from (select g, x, row_number() over (partition by g order by x) + 0 as d from t) s order by d;


evaluate 'Case 7: two analytic functions in one expression -- the second one must find the columns re-added for the first one';
select /*+ recompile */ d from (select g, x, lead(x) over (partition by g order by x) - lag(x) over (partition by g order by x) as d from t) s order by d;


evaluate 'Case 8: the analytic function as the whole select list item, which was already renumbered';
select /*+ recompile */ lg from (select g, x, lag(x) over (partition by g order by x) as lg from t) s order by lg;


evaluate 'Case 9: the same derived table through a named view and a WITH clause';
create or replace view v1 as select g, x, x - lag(x) over (partition by g order by x) as d from t;
select /*+ recompile */ d from v1 order by d;
select /*+ recompile */ sum(d) as sd from v1;
with s as (select g, x, x - lag(x) over (partition by g order by x) as d from t)
select /*+ recompile */ sum(d) as sd from s;


drop view v1;
drop table t;
