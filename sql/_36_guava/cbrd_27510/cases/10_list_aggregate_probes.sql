/**
 *  This test case verifies CBRD-27510: list files, sorts, GROUP BY, aggregates and analytic functions take their
 *  domains from the plan before the first row.
 *
 *  develop updated an open list file column's type from the values written into it, and resolved an aggregate's or
 *  analytic function's domain from its first value (qexec_resolve_domains_for_aggregation). CBRD-27510 opens list
 *  files with the plan's column domains, and sorts, GROUP BY positions and list scans read the plan. Aggregates and
 *  analytic functions are set up from the plan before the first row, and the gate (qexec_resolve_domains) decides
 *  the domains over binds and session variables once per execution.
 *
 *  The answers are develop's except in four cases. Case 10 - a statement that assigns a session variable another
 *  type while reading it fails before any row with -1384. Case 11 - MEDIAN over a session variable classifies its
 *  string by the value the variable holds when the execution starts, so the values a derived table assigns before
 *  the scan fail their conversion (-181). Case 17 - a MEDIAN value that no class takes is -1118 even over no row.
 *  Case 18 - a set operation or CTE column whose branch binds differ in type is rejected before any row (-456). Two
 *  executions stop develop's debug server on an assertion, and CBRD-27510 answers them - the GROUP_CONCAT DISTINCT
 *  over NULL binds in Case 15 and the set operation over an integer and a NULL bind in Case 18.
 *
 *  Coverage:
 *    Case 1: list columns over binds - derived table, set operation, sort
 *    Case 2: DISTINCT and ORDER BY over bind expressions
 *    Case 3: GROUP BY keys and aggregates over binds
 *    Case 4: aggregates without GROUP BY (BUILDVALUE) over binds and their output
 *    Case 5: analytic functions over binds
 *    Case 6: list scans reading bind columns
 *    Case 7: a hash join over bind columns
 *    Case 8: GROUPBY_NUM beside other aggregates
 *    Case 9: NULL binds under arithmetic, aggregates, DISTINCT and a set operation
 *    Case 10: session variables whose type changes within the statement
 *    Case 11: MEDIAN over a session variable whose content changes its class before the first read
 *    Case 12: aggregates over a session variable that is NULL when the statement starts
 *    Case 13: PERCENTILE_DISC and MEDIAN over NUMERIC columns of several precisions
 *    Case 14: GROUPBY_NUM with DISTINCT and ORDER BY aggregates, a session variable counter
 *    Case 15: DISTINCT and ORDER BY lists over binds, NULL binds and literals
 *    Case 16: LEAD and LAG over a NULL operand
 *    Case 17: MEDIAN over a bind or a literal that no class takes, over no row too
 *    Case 18: set operation and CTE columns whose branch binds differ in type
 */
--+ holdcas on;
drop table if exists la_t;
drop table if exists la_u;
create table la_t (i int, g int, c float, s varchar(20), d date, n numeric(10,2), ds varchar(20));
insert into la_t values (1, 1, 0.5, 'a', date'2024-01-01', 1.25, '2024-01-01'),
                     (2, 1, 1.5, 'b', date'2024-01-02', 2.50, '2024-01-03'),
                     (3, 2, 2.5, 'c', null, 3.75, '2024-02-01'),
                     (4, 2, 3.5, null, date'2024-01-04', null, null);
create table la_u (j int, v varchar(10));
insert into la_u values (1, 'x'), (2, 'y'), (3, 'z');

-- Case 1 [LIST]. A list column over a bind - a derived table column, a set operation column, a sort key - takes the
-- bind's type at each execution - an integer, a decimal, a string.
evaluate 'Case 1: list columns over binds';
prepare q from 'select x from (select ? + i x from la_t) dt order by x';
execute q using 1;
execute q using 1.5;
execute q using '2';
prepare q from 'select ? k, i from la_t union all select i, ? from la_t order by 1, 2';
execute q using 1, 2;
execute q using 'a', 'b';
prepare q from 'select * from (select ? a from la_t union select ? from la_u) x order by 1';
execute q using 'p', 'q';
execute q using 1, 2.5;

-- Case 2 [SORT]. DISTINCT and ORDER BY over a bind expression.
evaluate 'Case 2: DISTINCT and ORDER BY over bind expressions';
prepare q from 'select distinct i + ? from la_t order by 1';
execute q using 1;
execute q using 0.5;
prepare q from 'select s || ? k from la_t order by k';
execute q using 'z';

-- Case 3 [GROUP]. A GROUP BY key and COUNT, SUM, MIN, MAX, AVG, COUNT DISTINCT and GROUP_CONCAT over binds, with
-- two sets of bind types.
evaluate 'Case 3: GROUP BY keys and aggregates over binds';
prepare q from 'select i % ? gk, count(*), sum(?), min(?), max(s || ?), avg(i + ?) from la_t group by gk order by gk';
execute q using 2, 1, 'm', 'q', 1;
execute q using 2, 1.5, 3, 'q', 0.5;
prepare q from 'select g, sum(i + ?), count(distinct ?) from la_t group by g order by g';
execute q using 1, 'a';
prepare q from 'select g, group_concat(s + ? order by 1) from la_t group by g order by g';
execute q using 'x';

-- Case 4 [AGG]. Aggregates computed in one pass without GROUP BY (BUILDVALUE) over binds - integers, then a
-- decimal, a string, a date and strings, then NULLs - an expression over aggregates and binds, and a scalar
-- subquery's MAX over a bind.
evaluate 'Case 4: aggregates without GROUP BY over binds';
prepare q from 'select sum(?), avg(?), min(?), max(?), count(distinct ?) from la_t';
execute q using 1, 2, 3, 4, 5;
execute q using 1.5, '2', date'2024-01-01', 'x', 'y';
execute q using null, null, null, null, null;
prepare q from 'select sum(i) + ?, max(s) || ? from la_t';
execute q using 1, 'z';
prepare q from 'select (select max(? + i) from la_t) from la_u order by 1';
execute q using 1;

-- Case 5 [ANALYTIC]. SUM, LEAD, FIRST_VALUE, COUNT DISTINCT and RANK over binds.
evaluate 'Case 5: analytic functions over binds';
prepare q from 'select i, sum(? + i) over (order by i), lead(?, 1) over (order by i), first_value(?) over (partition by g order by i) from la_t order by i';
execute q using 1, 'a', 2;
execute q using 1.5, 3, 'b';
prepare q from 'select i, count(distinct ?) over (partition by g), rank() over (order by i + ?) from la_t order by i';
execute q using 7, 1;

-- Case 6 [LSCAN]. A join of two derived tables over binds, and IN over a subquery, read through list scans.
evaluate 'Case 6: list scans reading bind columns';
prepare q from 'select * from (select ? + i x from la_t) a, (select j + ? y from la_u) b where a.x = b.y order by 1';
execute q using 1, 2;
execute q using 1.5, 2;
prepare q from 'select * from (select ? x from la_t) a where a.x in (select v from la_u) order by 1';
execute q using 'x';

-- Case 7 [HJOIN]. A hash join whose key on one side is a bind expression, run with an integer, a decimal and a
-- string.
evaluate 'Case 7: a hash join over bind columns';
prepare q from 'select /*+ use_hash */ a.x, b.j from (select i + ? x from la_t) a, la_u b where a.x = b.j order by 1';
execute q using 0;
execute q using 0.0;
execute q using '0';

drop table la_t;
drop table la_u;

-- Case 8 [GBNUM]. GROUPBY_NUM beside COUNT, MAX and SUM over a bind, and in HAVING.
evaluate 'Case 8: GROUPBY_NUM beside other aggregates';
drop table if exists la_gb;
create table la_gb (a int, b varchar(10));
insert into la_gb values (1, 'p'), (1, 'q'), (2, 'r'), (3, null);
select a, groupby_num(), count(*), max(b) from la_gb group by a order by a;
prepare q from 'select a, groupby_num(), sum(?) from la_gb group by a having groupby_num() < 3 order by a';
execute q using 1;
execute q using 'z';
drop table la_gb;

-- Case 9 [NOVAL]. NULL binds, which carry no type, under arithmetic in a sort key and a GROUP BY key, under
-- analytic SUM and MEDIAN, under aggregates without GROUP BY, in a set operation, under DISTINCT and under
-- GROUP_CONCAT.
evaluate 'Case 9: NULL binds';
drop table if exists la_nv;
create table la_nv (i int, j int);
insert into la_nv values (1, 10), (2, 20), (2, 30);
prepare q from 'select ? + i x from la_nv order by x';
execute q using null;
prepare q from 'select i, ? + 1 x from la_nv group by i, x order by i';
execute q using null;
prepare q from 'select i, sum(?) over (partition by i), median(? + 1) over () from la_nv order by i';
execute q using null, null;
prepare q from 'select median(? + 1), sum(? * 2), max(?) from la_nv';
execute q using null, null, null;
prepare q from 'select * from (select ? + i x from la_nv) a union all select j from la_nv order by 1';
execute q using null;
prepare q from 'select distinct ? + i from la_nv';
execute q using null;
prepare q from 'select i, group_concat(? order by 1) from la_nv group by i order by i';
execute q using null;
drop table la_nv;

-- Case 10 [SV]. A statement that assigns a session variable an INTEGER and then a string while reading it fails
-- before any row with -1384, with and without rows. develop answered with rows (2 and 2.5 in the first row). A
-- running INTEGER sum and an assignment from a column keep one type and answer as develop. Each assignment is
-- parenthesized so that an alias can follow it.
evaluate 'Case 10: session variables whose type changes';
set @v = 1;
select (@v := @v + 1) a, (@v := '2.5') b from db_root;
drop table if exists la_sv;
create table la_sv (i int);
insert into la_sv values (1), (2), (3);
set @v = 1;
select (@v := @v + 1) a, (@v := '2.5') b from la_sv order by a;
set @w = 1;
select (@w := @w + i) a from la_sv order by a desc;
deallocate variable @u;
select (@u := i) a, count(*) from la_sv group by a order by a;
drop table la_sv;

drop table if exists la_sv;
create table la_sv (i int, g int);
insert into la_sv values (1, 1), (2, 1), (3, 2);

-- Case 11 [CLASS]. MEDIAN over a session variable classifies its string as DOUBLE, DATETIME or TIME by the value
-- the variable holds when the execution starts. The start value '1.5' is DOUBLE, so '01:00:00', '2024-01-02
-- 10:00:00' and 'abc', which a derived table assigns before the scan, fail with -181. develop took the class of the
-- assigned value and answered a TIME and a DATETIME, and -1118 for 'abc'. A variable that starts NULL takes the
-- class of the assigned '2.5', and PERCENTILE_CONT over the variable answers like MEDIAN.
evaluate 'Case 11: MEDIAN over a session variable whose class changes';
set @m = '1.5';
select median(@m), typeof(median(@m)) from (select (@m := '01:00:00') x from db_root) la_t, la_sv;
set @m = '1.5';
select g, median(@m) from (select (@m := '2024-01-02 10:00:00') x from db_root) la_t, la_sv group by g order by g;
set @m = '1.5';
select median(@m) from (select (@m := 'abc') x from db_root) la_t, la_sv;
set @m = null;
select median(@m), typeof(median(@m)) from (select (@m := '2.5') x from db_root) la_t, la_sv;
set @m = '1.5';
select median(@m), percentile_cont(0.5) within group (order by @m) from la_sv;

-- Case 12 [NULLSTART]. Aggregates over a session variable that is not defined or is NULL when the statement starts,
-- which a derived table assigns before the scan.
evaluate 'Case 12: aggregates over a session variable that starts NULL';
deallocate variable @d;
select count(distinct @d), sum(@d), max(@d), group_concat(@d) from (select (@d := i) x from la_sv) la_t, la_sv s2;
deallocate variable @d;
select s2.g, count(distinct @d), max(@d) from (select (@d := 'k') x from db_root) la_t, la_sv s2 group by s2.g order by 1;
set @e = null;
select avg(@e), min(@e) from (select (@e := 7) x from db_root) la_t, la_sv;

-- Case 13 [NUMDISC]. PERCENTILE_DISC and MEDIAN over NUMERIC columns of different precisions and a FLOAT column,
-- grouped and not.
evaluate 'Case 13: PERCENTILE_DISC and MEDIAN over NUMERIC columns';
drop table if exists la_pn;
create table la_pn (g int, n numeric(10, 2), m numeric(20, 5), f float);
insert into la_pn values (1, 1.25, 10.5, 1.5), (1, 2.50, 20.25, 2.5), (2, 3.75, 30.125, 3.5), (2, 5.00, 40.0625, 4.5);
select percentile_disc(0.5) within group (order by n), percentile_disc(0.5) within group (order by m) from la_pn;
select g, percentile_disc(0.5) within group (order by n), median(m), median(f) from la_pn group by g order by g;
select g, percentile_disc(0.25) within group (order by m desc), percentile_cont(0.25) within group (order by n) from la_pn group by g order by g;
drop table la_pn;

-- Case 14 [GBNUM2]. GROUPBY_NUM with COUNT DISTINCT and GROUP_CONCAT DISTINCT ... ORDER BY, and a session variable
-- counter under COUNT and SUM.
evaluate 'Case 14: GROUPBY_NUM with DISTINCT aggregates and a counter';
drop table if exists la_gb;
create table la_gb (a int, b varchar(10));
insert into la_gb values (1, 'p'), (1, 'q'), (1, 'p'), (2, 'r'), (3, null);
select a, groupby_num(), count(distinct b), group_concat(distinct b order by b) from la_gb group by a order by a;
set @c = 0;
select count(@c := @c + 1), sum(@c) from la_gb;
select @c;
drop table la_gb;

-- Case 15 [LISTS]. COUNT DISTINCT, SUM DISTINCT and GROUP_CONCAT with DISTINCT or ORDER BY over binds, NULL binds
-- and literals. The first statement's execution with NULL binds is where develop's debug build stops on the
-- collation assertion of qexec_end_one_iteration, as for the NULL binds of 18_collation_gate_probes.
evaluate 'Case 15: DISTINCT and ORDER BY lists over binds and literals';
prepare q from 'select count(distinct ?), group_concat(distinct ? order by 1) from la_sv';
execute q using 1, 'x';
execute q using null, null;
prepare q from 'select g, sum(distinct ? + i), group_concat(? order by 1 desc) from la_sv group by g order by g';
execute q using 10, 'y';
execute q using null, 'z';
select count(distinct 'a'), group_concat(distinct 5 order by 1), median('2.5'), median(null) from la_sv;

-- Case 16 [LEADLAG]. LEAD and LAG over a NULL operand hold only NULLs. A row past the window's end converts the
-- default to the function's NULL or open domain, which rejects a value, as in develop.
evaluate 'Case 16: LEAD and LAG over a NULL operand';
prepare q from 'select i, lead(?, 1, ''x'') over (order by i) from la_sv order by i';
execute q using null;
execute q using 'y';
prepare q from 'select i, lead(?, 1, ?) over (order by i) from la_sv order by i';
execute q using null, null;
execute q using null, 7;
prepare q from 'select i, lag(? + 1, 1, 5) over (order by i) from la_sv order by i';
execute q using null;
execute q using 1;
prepare q from 'select i, lead(?, 0, ''x'') over (order by i) from la_sv order by i';
execute q using null;
select i, lead(null, 1, 'x') over (order by i) from la_sv order by i;
select i, lag(null, 1) over (order by i) from la_sv order by i;

-- Case 17 [UNCLASS]. MEDIAN over a bind or a literal that none of DOUBLE, DATETIME and TIME takes is -1118 before
-- any row, so the literal fails even when no row qualifies. UNdevelop took the class of the assigned value and
-- answered a TIME and a DATETIME, and -1118 for 'abc'.
evaluate 'Case 17: MEDIAN over a value of no class';
prepare q from 'select median(?) from la_sv';
execute q using 'abc';
execute q using '2.5';
prepare q from 'select g, median(?) from la_sv group by g order by g';
execute q using 'abc';
execute q using '01:00:00';
select median('abc') from la_sv;
select median('abc') from la_sv where i > 5;
drop table la_sv;

-- Case 18 [SETOP]. A set operation or CTE column over binds of different types (an integer and a string) is
-- rejected before any row with -456, whether the branches hold rows or not. develop rejected it only when both
-- branches held rows, and otherwise took the type of the branch that had them. Binds of one type answer as develop,
-- except the first statement with an integer and a NULL, where develop's debug build stops on an assertion in
-- qfile_unify_types.
evaluate 'Case 18: set operation and CTE columns over binds of different types';
drop table if exists la_so;
create table la_so (i int);
insert into la_so values (1);
prepare q from 'select ? x from la_so where i = 1 union all select ? from la_so where i = 1';
execute q using 1, 'a';
execute q using 'a', 'bcd';
execute q using 1, 2;
execute q using 1, null;
prepare q from 'select ? x from la_so where i = 1 union all select ? from la_so where i > 5';
execute q using 1, 'a';
execute q using 'a', 1;
execute q using 1, 2;
prepare q from 'select x, typeof(x) from (select ? x from la_so where i = 1 union all select ? from la_so where i > 5) s';
execute q using 1, 'a';
execute q using 1, 2;
prepare q from 'select ? x from la_so where i > 5 union all select ? from la_so where i > 5';
execute q using 1, 'a';
prepare q from 'select ? x from la_so difference select ? from la_so where i > 5';
execute q using 1, 'a';
prepare q from 'with cte(x) as (select ? from la_so where i = 1 union all select ? from la_so where i > 5) select x, typeof(x) from cte';
execute q using 'a', 1;
execute q using 'a', 'b';
drop table la_so;
deallocate variable @c, @d, @e, @m, @u, @v, @w;
--+ holdcas off;
