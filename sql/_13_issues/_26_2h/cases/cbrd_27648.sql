/**
 *  CBRD-27648: an analytic function inside CASE, IF or DECODE must run when its argument or its
 *  OVER clause uses an expression instead of a bare column.
 *
 *  A SELECT with analytic functions collects the values to read before the sort into one list:
 *  the CASE condition, the analytic arguments and the OVER sort expressions. Converting the CASE
 *  condition, a logical expression, to a predicate also took the following items of that list, so
 *  an expression there (x * 2) failed with "Internal error- reporting semantic error". Bare
 *  columns and constants there did not fail.
 *
 *  Coverage:
 *  1    the reported queries: an expression column of a merged derived table, the same
 *       expression written directly, and a bare derived column as the reference
 *  2    CASE whose condition does not contain the argument expression
 *  3    a conditional function: IF, DECODE
 *  4    the analytic function inside the condition, after AND; alone in the condition as reference
 *  5    a bare argument with an expression in the OVER clause
 *  6    analytic functions other than LAG: SUM, ROW_NUMBER
 *  7    the derived column is a CASE
 *  8    the derived table is a LEFT OUTER JOIN
 *  9    two levels of derived tables
 *  10   reference: the NO_MERGE hint
 *  11   reference: the analytic function outside CASE
 *  12   reference: the analytic function inside NVL
 *  13   reference: bare columns in the argument and the OVER clause
 *  14   INSERT ... SELECT, which failed with "System error (generate predicate)"
 *  15   the OVER order covered by a forced index scan, where the list is also read during the scan
 */

drop table if exists p, r8, s;

create table p (g int, x int);
insert into p values (1, 1), (1, 2), (1, 3);


evaluate 'Case 1: the reported queries -- an expression column of a merged derived table, the same expression written directly, and a bare derived column';
select /*+ recompile */ case when v > 2 then lag(v) over (partition by g order by x) end as r, x from (select g, x, x * 2 as v from p) m order by x;
select /*+ recompile */ case when x * 2 > 2 then lag(x * 2) over (partition by g order by x) end as r, x from p order by x;
select /*+ recompile */ case when v > 2 then lag(v) over (partition by g order by x) end as r, x from (select g, x, x as v from p) m order by x;


evaluate 'Case 2: CASE whose condition does not contain the argument expression';
select /*+ recompile */ case when x > 1 then lag(x * 2) over (partition by g order by x) end as r, x from p order by x;


evaluate 'Case 3: a conditional function -- IF and DECODE';
select /*+ recompile */ if(v = 2, lag(v) over (partition by g order by x), -1) as r, x from (select g, x, x * 2 as v from p) m order by x;
select /*+ recompile */ decode(x, 2, lag(x * 2) over (partition by g order by x), -1) as r, x from p order by x;


evaluate 'Case 4: the analytic function inside the CASE condition, after AND, and alone in the condition';
select /*+ recompile */ case when x > 1 and lag(x * 2) over (partition by g order by x) = 2 then 1 end as r, x from p order by x;
select /*+ recompile */ case when lag(x * 2) over (partition by g order by x) = 2 then 1 end as r, x from p order by x;


evaluate 'Case 5: a bare argument with an expression in the OVER clause';
select /*+ recompile */ case when x > 1 then lag(x) over (partition by g order by x * 2) end as r, x from p order by x;


evaluate 'Case 6: analytic functions other than LAG -- SUM and ROW_NUMBER';
select /*+ recompile */ case when x > 1 then sum(x * 2) over (partition by g order by x) end as r, x from p order by x;
select /*+ recompile */ case when x > 1 then row_number() over (partition by g order by x * 2) end as r, x from p order by x;


evaluate 'Case 7: the derived column is a CASE';
select /*+ recompile */ case when v > 2 then lag(v) over (partition by g order by x) end as r, x from (select g, x, case when x > 1 then x * 2 else 0 end as v from p) m order by x;


evaluate 'Case 8: the derived table is a LEFT OUTER JOIN';
select /*+ recompile */ case when v > 2 then lag(v) over (partition by g order by x) end as r, x from (select p.g, p.x, p.x * 2 as v from p left outer join p p2 on p2.x = p.x + 10) m order by x;


evaluate 'Case 9: two levels of derived tables';
select /*+ recompile */ case when v > 2 then lag(v) over (partition by g order by x) end as r, x from (select g, x, v from (select g, x, x * 2 as v from p) m1) m2 order by x;


evaluate 'Case 10: reference -- the NO_MERGE hint keeps the derived table, which already ran';
select /*+ recompile */ case when v > 2 then lag(v) over (partition by g order by x) end as r, x from (select /*+ no_merge */ g, x, x * 2 as v from p) m order by x;


evaluate 'Case 11: reference -- the analytic function outside CASE, which already ran';
select /*+ recompile */ lag(v) over (partition by g order by x) as r1, v + lag(v) over (partition by g order by x) as r2, x from (select g, x, x * 2 as v from p) m order by x;


evaluate 'Case 12: reference -- the analytic function inside NVL, which already ran';
select /*+ recompile */ nvl(lag(x * 2) over (partition by g order by x), -1) as r, x from p order by x;


evaluate 'Case 13: reference -- bare columns in the argument and the OVER clause, which already ran';
select /*+ recompile */ case when x * 2 > 2 then lag(x) over (partition by g order by x) end as r, x from p order by x;


evaluate 'Case 14: INSERT ... SELECT';
create table r8 (r int, x int);
insert into r8 select /*+ recompile */ case when v > 2 then lag(v) over (partition by g order by x) end, x from (select g, x, x * 2 as v from p) m;
select r, x from r8 order by x;


evaluate 'Case 15: the OVER order covered by a forced index scan, so the values are also read during the scan';
create table s (g int, x int);
insert into s values (1, 1), (1, 2), (1, 3), (2, 4), (2, 5);
create index i_s_gx on s (g, x);
select /*+ recompile */ case when x * 2 > 2 then lag(x * 2) over (partition by g order by x) end as r, g, x from s where g > 0 using index i_s_gx(+);


drop table p, r8, s;
