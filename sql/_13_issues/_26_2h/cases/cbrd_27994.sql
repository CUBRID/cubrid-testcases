/**
 *  This test case verifies CBRD-27994: a GROUP BY whose aggregates read the expression of the WHERE clause
 *  no longer aborts a debug build in expr_valptr_prog_settle
 *
 *  A projection program may read a value that the compiled data filter of its scan already computes, through
 *  a shared cell. When the compiler rejected an expression after it had wired such a cell, it dropped the cell
 *  but kept it counted, so the program image claimed more shared cells than it held and the server refused
 *  the image - a debug build aborted, a release build ran the list interpreted. Each case runs a query that
 *  shares the filter value cast(c1 as double) and then the same query filtered by c1 > 0, which shares nothing,
 *  and the two results match.
 *
 *  Coverage:
 *    Case 1:  the reported GROUP BY on an empty table returns no rows
 *    Case 2:  the GROUP BY on rows returns the groups of the query filtered by c1 > 0
 *    Case 3:  the aggregates without GROUP BY return the values of the query filtered by c1 > 0
 *    Case 4:  the projection without aggregates returns the rows of the query filtered by c1 > 0
 *    Case 5:  the forms that never aborted - a constant WHEN, one aggregate, IS NOT NULL - keep their results
 */

drop table if exists t_gby;
create table t_gby (c0 double, c1 int, c2 bigint);

-- the table is still empty: the debug build aborted while it set up the GROUP BY, before it read a row
evaluate 'Case 1: the reported GROUP BY on an empty table returns no rows';
select c1, count(least(cast(c1 as double), case c1 when c2 then c0 else c0 end)), min(cast(c1 as double)) from t_gby where cast(c1 as double) > 0 group by c1;

-- c1 is INT, so cast(c1 as double) > 0 and c1 > 0 keep the same rows - rows with c1 = c2, c1 <> c2, and a NULL c0, c1, or c2
insert into t_gby values (1.5, 1, 1), (2.5, 1, 2), (null, 1, 1), (3.0, 2, 2), (4.0, 2, 3), (5.0, -1, -1), (6.0, null, 1), (7.0, 0, 0), (8.0, 3, null);

evaluate 'Case 2: the GROUP BY on rows returns the groups of the query filtered by c1 > 0';
select c1, count(least(cast(c1 as double), case c1 when c2 then c0 else c0 end)), min(cast(c1 as double)) from t_gby where cast(c1 as double) > 0 group by c1 order by c1;
select c1, count(least(cast(c1 as double), case c1 when c2 then c0 else c0 end)), min(cast(c1 as double)) from t_gby where c1 > 0 group by c1 order by c1;

evaluate 'Case 3: the aggregates without GROUP BY return the values of the query filtered by c1 > 0';
select count(least(cast(c1 as double), case c1 when c2 then c0 else c0 end)), min(cast(c1 as double)) from t_gby where cast(c1 as double) > 0;
select count(least(cast(c1 as double), case c1 when c2 then c0 else c0 end)), min(cast(c1 as double)) from t_gby where c1 > 0;

evaluate 'Case 4: the projection without aggregates returns the rows of the query filtered by c1 > 0';
select least(cast(c1 as double), case c1 when c2 then c0 else c0 end), cast(c1 as double) from t_gby where cast(c1 as double) > 0 order by 2, 1;
select least(cast(c1 as double), case c1 when c2 then c0 else c0 end), cast(c1 as double) from t_gby where c1 > 0 order by 2, 1;

-- the three forms that the report found not to abort: a constant WHEN, one aggregate, and IS NOT NULL in the WHERE clause
evaluate 'Case 5: the forms that never aborted - a constant WHEN, one aggregate, IS NOT NULL - keep their results';
select c1, count(least(cast(c1 as double), case c1 when 1 then c0 else c0 end)), min(cast(c1 as double)) from t_gby where cast(c1 as double) > 0 group by c1 order by c1;
select c1, count(least(cast(c1 as double), case c1 when c2 then c0 else c0 end)) from t_gby where cast(c1 as double) > 0 group by c1 order by c1;
select c1, count(least(cast(c1 as double), case c1 when c2 then c0 else c0 end)), min(cast(c1 as double)) from t_gby where cast(c1 as double) is not null group by c1 order by c1;

drop table t_gby;
