--+ holdcas on;
-- workspace#341 (map #312, dpin-15): list files open with the plan's column domains, sorts, GROUP BY positions and
-- list scans read the plan, and aggregates and analytic functions are set up from the plan before the first row
-- (no first-row resolve). Every answer here is develop's but [SETOP] and [CLASS]. [SETOP]: a set-operation or CTE
-- column whose branch binds differ in type is rejected before any row (the user's decision on workspace#341), where
-- develop rejected it only when both branches held rows. [CLASS]: a session variable's string class is the one its
-- value gives when the execution starts (workspace#366), where develop took the first value's.
drop table if exists la_t;
drop table if exists la_u;
create table la_t (i int, g int, c float, s varchar(20), d date, n numeric(10,2), ds varchar(20));
insert into la_t values (1, 1, 0.5, 'a', date'2024-01-01', 1.25, '2024-01-01'),
                     (2, 1, 1.5, 'b', date'2024-01-02', 2.50, '2024-01-03'),
                     (3, 2, 2.5, 'c', null, 3.75, '2024-02-01'),
                     (4, 2, 3.5, null, date'2024-01-04', null, null);
create table la_u (j int, v varchar(10));
insert into la_u values (1, 'x'), (2, 'y'), (3, 'z');

-- [LIST] list columns over binds: derived table, set operation, sort
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

-- [SORT] ORDER BY and DISTINCT over bind expressions
prepare q from 'select distinct i + ? from la_t order by 1';
execute q using 1;
execute q using 0.5;
prepare q from 'select s || ? k from la_t order by k';
execute q using 'z';

-- [GROUP] GROUP BY keys and aggregates over binds
prepare q from 'select i % ? gk, count(*), sum(?), min(?), max(s || ?), avg(i + ?) from la_t group by gk order by gk';
execute q using 2, 1, 'm', 'q', 1;
execute q using 2, 1.5, 3, 'q', 0.5;
prepare q from 'select g, sum(i + ?), count(distinct ?) from la_t group by g order by g';
execute q using 1, 'a';
prepare q from 'select g, group_concat(s + ? order by 1) from la_t group by g order by g';
execute q using 'x';

-- [AGG] BUILDVALUE aggregates and their output
prepare q from 'select sum(?), avg(?), min(?), max(?), count(distinct ?) from t';
execute q using 1, 2, 3, 4, 5;
execute q using 1.5, '2', date'2024-01-01', 'x', 'y';
execute q using null, null, null, null, null;
prepare q from 'select sum(i) + ?, max(s) || ? from t';
execute q using 1, 'z';
prepare q from 'select (select max(? + i) from la_t) from la_u order by 1';
execute q using 1;

-- [ANALYTIC] analytic functions over binds
prepare q from 'select i, sum(? + i) over (order by i), lead(?, 1) over (order by i), first_value(?) over (partition by g order by i) from la_t order by i';
execute q using 1, 'a', 2;
execute q using 1.5, 3, 'b';
prepare q from 'select i, count(distinct ?) over (partition by g), rank() over (order by i + ?) from la_t order by i';
execute q using 7, 1;

-- [LSCAN] list scans reading bind columns
prepare q from 'select * from (select ? + i x from la_t) a, (select j + ? y from la_u) b where a.x = b.y order by 1';
execute q using 1, 2;
execute q using 1.5, 2;
prepare q from 'select * from (select ? x from la_t) a where a.x in (select v from la_u) order by 1';
execute q using 'x';

-- [HJOIN] hash join over bind columns
prepare q from 'select /*+ use_hash */ a.x, b.j from (select i + ? x from la_t) a, la_u b where a.x = b.j order by 1';
execute q using 0;
execute q using 0.0;
execute q using '0';

drop table la_t;
drop table la_u;

-- [GBNUM] GROUPBY_NUM beside other aggregates
drop table if exists la_gb;
create table la_gb (a int, b varchar(10));
insert into la_gb values (1, 'p'), (1, 'q'), (2, 'r'), (3, null);
select a, groupby_num(), count(*), max(b) from la_gb group by a order by a;
prepare q from 'select a, groupby_num(), sum(?) from la_gb group by a having groupby_num() < 3 order by a';
execute q using 1;
execute q using 'z';
drop table la_gb;

-- [NOVAL] consumers of no-value decisions (NULL binds under arithmetic) and NULL binds
drop table if exists la_nv;
create table la_nv (i int, j int);
insert into la_nv values (1, 10), (2, 20), (2, 30);
prepare q from 'select ? + i x from la_nv order by x';
execute q using null;
prepare q from 'select i, ? + 1 x from la_nv group by i, x order by i';
execute q using null;
prepare q from 'select i, sum(?) over (partition by i), median(? + 1) over () from la_nv order by i';
execute q using null, null;
prepare q from 'select median(? + 1), sum(? * 2), max(?) from nv';
execute q using null, null, null;
prepare q from 'select * from (select ? + i x from la_nv) a union all select j from la_nv order by 1';
execute q using null;
prepare q from 'select distinct ? + i from nv';
execute q using null;
prepare q from 'select i, group_concat(? order by 1) from la_nv group by i order by i';
execute q using null;
drop table la_nv;

-- [SV] session variables whose type changes within the statement: -1384 before any row (workspace#366). The
-- unparenthesized `@v := x a` forms here parse as ambiguous (-493), as in develop
set @v = 1;
select @v := @v + 1 a, @v := '2.5' b from db_root;
drop table if exists la_sv;
create table la_sv (i int);
insert into la_sv values (1), (2), (3);
set @v = 1;
select @v := @v + 1 a, @v := '2.5' b from la_sv order by a;
set @w = 1;
select @w := @w + i a from la_sv order by a desc;
deallocate variable @u;
select @u := i a, count(*) from la_sv group by a order by a;
drop table la_sv;

drop table if exists la_sv;
create table la_sv (i int, g int);
insert into la_sv values (1, 1), (2, 1), (3, 2);

-- [CLASS] a MEDIAN over a session variable whose content changes its class before the first read
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

-- [NULLSTART] aggregates over a session variable that is NULL when the statement starts
deallocate variable @d;
select count(distinct @d), sum(@d), max(@d), group_concat(@d) from (select (@d := i) x from la_sv) la_t, la_sv s2;
deallocate variable @d;
select s2.g, count(distinct @d), max(@d) from (select (@d := 'k') x from db_root) la_t, la_sv s2 group by s2.g order by 1;
set @e = null;
select avg(@e), min(@e) from (select (@e := 7) x from db_root) la_t, la_sv;

-- [NUMDISC] PERCENTILE_DISC / MEDIAN over NUMERIC columns of several precisions
drop table if exists la_pn;
create table la_pn (g int, n numeric(10, 2), m numeric(20, 5), f float);
insert into la_pn values (1, 1.25, 10.5, 1.5), (1, 2.50, 20.25, 2.5), (2, 3.75, 30.125, 3.5), (2, 5.00, 40.0625, 4.5);
select percentile_disc(0.5) within group (order by n), percentile_disc(0.5) within group (order by m) from la_pn;
select g, percentile_disc(0.5) within group (order by n), median(m), median(f) from la_pn group by g order by g;
select g, percentile_disc(0.25) within group (order by m desc), percentile_cont(0.25) within group (order by n) from la_pn group by g order by g;
drop table la_pn;

-- [GBNUM2] GROUPBY_NUM with DISTINCT and ORDER BY aggregates, and a session variable counter
drop table if exists la_gb;
create table la_gb (a int, b varchar(10));
insert into la_gb values (1, 'p'), (1, 'q'), (1, 'p'), (2, 'r'), (3, null);
select a, groupby_num(), count(distinct b), group_concat(distinct b order by b) from la_gb group by a order by a;
set @c = 0;
select count(@c := @c + 1), sum(@c) from la_gb;
select @c;
drop table la_gb;

-- [LISTS] DISTINCT / ORDER BY lists over binds, NULL binds and literals
prepare q from 'select count(distinct ?), group_concat(distinct ? order by 1) from sv';
execute q using 1, 'x';
execute q using null, null;
prepare q from 'select g, sum(distinct ? + i), group_concat(? order by 1 desc) from la_sv group by g order by g';
execute q using 10, 'y';
execute q using null, 'z';
select count(distinct 'a'), group_concat(distinct 5 order by 1), median('2.5'), median(null) from la_sv;

-- [LEADLAG] LEAD / LAG over a NULL operand hold only NULLs: a row past the window's end converts the default to the
-- function's NULL or open domain, which rejects a value
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

-- [UNCLASS] MEDIAN over a bind or a literal that none of DOUBLE, DATETIME, TIME takes
prepare q from 'select median(?) from la_sv';
execute q using 'abc';
execute q using '2.5';
prepare q from 'select g, median(?) from la_sv group by g order by g';
execute q using 'abc';
execute q using '01:00:00';
select median('abc') from la_sv;
select median('abc') from la_sv where i > 5;
drop table la_sv;

-- [SETOP] set-operation and CTE columns over binds: branch domains that differ are rejected before any row
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
