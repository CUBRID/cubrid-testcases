/**
 *  This test case verifies CBRD-27510: fetch takes the domain of every open value from the decision made before the
 *  first row, never from the value it reads.
 *
 *  A value whose domain the compiler leaves open - a bind, the CAST(? AS uncertain) a set operation puts over a
 *  bind, a session variable, a function whose result type depends on its argument - got its domain in develop when
 *  fetch read its first value. CBRD-27510 decides these domains before the first row. The compiler decides what it
 *  can, and the gate (qexec_resolve_domains, run once per execution before the main block) decides the rest from
 *  the types of the bind values and session variables. The execution reads those decisions.
 *
 *  Every answer here is the develop answer except three statements of Case 3, which assign a session variable a
 *  value of another type while reading it. A session variable that a statement reads holds one type for the whole
 *  statement, so such an assignment is an error before any row (-1384, a new error code) and the variable keeps its
 *  value. develop retyped the variable from each value it assigned.
 *
 *  Coverage:
 *    Case 1: the CAST(? AS uncertain) of a set operation over a bind, a user CAST over a bind
 *    Case 2: NULL binds, which carry no type, under arithmetic, common values and fixed-type functions
 *    Case 3: session variables assigned within a statement that reads them
 *    Case 4: ADDTIME over a session variable string and a bind, classified from the value
 *    Case 5: an open sort key under ORDER BY and LIMIT
 *    Case 6: GROUP_CONCAT over a CHAR bind in an expression, an output column and a scalar subquery
 *    Case 7: percentile fractions from a session variable or a bind, scalar subqueries in an index key range
 *    Case 8: binds under compat_mode=mysql
 */
--+ holdcas on;
drop table if exists fg_t;
drop table if exists fg_k;
create table fg_t (i int, c float, s varchar(20), d date);
insert into fg_t values (1, 0.5, 'a', date'2024-01-01'), (2, 1.5, 'b', date'2024-01-02'), (3, 2.5, 'c', null);

-- Case 1 [CAST]. A set operation wraps its bind in CAST(? AS uncertain), whose type each execution's bind gives.
-- The same statement runs with an integer, a string and a NULL. A user CAST over a string bind and a bind
-- concatenated under LIKE follow.
evaluate 'Case 1: set operation and user CAST over binds';
prepare q from 'select ? union all select i from fg_t order by 1';
execute q using 7;
execute q using 'x';
execute q using null;
prepare q from 'select cast(? as int) + i from fg_t order by 1';
execute q using '5';
prepare q from 'select i from fg_t where ? like cast((? + ''%'') as char(11))';
execute q using '', '1234';

-- Case 2 [NOVAL]. A NULL bind has no type, so the gate decides the nodes over it without a value. Arithmetic,
-- COALESCE, NVL2, NULLIF, LEAST, GREATEST and IFNULL run first with every bind NULL and then with a mix, and
-- functions of a fixed result type (HOUR, ASCII, HEX, CONV, STR_TO_DATE) take NULL binds.
evaluate 'Case 2: NULL binds under arithmetic, common values and functions';
prepare q from 'select ? + 1, ? * i, coalesce(?, ?), nvl2(?, ?, ?), nullif(?, ?), least(?, ?), greatest(?, ?), ifnull(?, ?) from fg_t order by i';
execute q using null, null, null, null, null, null, null, null, null, null, null, null, null, null, null;
execute q using 1, 2, null, 3, null, 4, 5, 6, 6, 7, 8, 9, 10, null, 11;
prepare q from 'select hour(?), ascii(?), hex(?), conv(?, 10, 2), str_to_date(?, ''%Y'') from fg_t order by 1';
execute q using null, null, null, null, null;

-- Case 3 [S5]. Three statements read a variable and assign it a value of another type - INTEGER then a string,
-- INTEGER then FLOAT, CHAR then INTEGER. Each fails before any row with -1384 and the variable keeps its value, so
-- the SELECT after the first one shows 1. develop retyped the variable and answered with rows (the SELECT after the
-- first showed 2.5), except for the CHAR variable, which failed with -181. The other statements keep one type per
-- variable and answer as develop - a variable deallocated just before the statement that assigns and reads it, a
-- CHAR variable that grows by CONCAT, a read under COALESCE and an assignment in UPDATE ... SET.
evaluate 'Case 3: session variables assigned within a statement that reads them';
set @v = 1;
select @v := @v + 1, @v := '2.5' from fg_t order by i;
select @v;
set @a = 0;
select @a := @a + c from fg_t order by i;
set @w = 'x';
select @w := 1, @w + 1 from fg_t order by i;
deallocate variable @u;
select @u := 5, @u + 1 from fg_t order by i;
set @b = cast('ab' as char(8));
select @b := concat(@b, 'x') from fg_t order by i;
set @n = 10;
select coalesce(s, @n + 1) from fg_t order by i;
set @tmp = 100;
update fg_t set i = (@tmp := @tmp + 1) order by i desc;
select * from fg_t order by i;

-- Case 4 [ADDTIME]. ADDTIME takes its result type from the content of a string first argument - a date-time with a
-- zone, a date-time, a time. For a session variable or a bind the gate classifies the value once per execution, as
-- develop did at the first row.
evaluate 'Case 4: ADDTIME over a session variable string and a bind';
set @z = '2020-01-01 10:00:00 +09:00';
select addtime(@z, time'1:00:00');
set @z = '2020-01-01 10:00:00';
select addtime(@z, time'1:00:00');
set @z = '10:00:00';
select addtime(@z, time'1:00:00');
prepare q from 'select addtime(?, time''1:00:00'')';
execute q using '2020-01-01 10:00:00 +09:00';

-- Case 5 [TOPN]. An ORDER BY key over a bind under LIMIT (a top-N sort) takes its domain from the bind, an integer
-- and then a decimal, and a string key sorts in descending order.
evaluate 'Case 5: an open sort key under ORDER BY and LIMIT';
prepare q from 'select i + ? k from fg_t order by k limit 2';
execute q using 1;
execute q using 1.5;
prepare q from 'select s + ? k from fg_t order by k desc limit 2';
execute q using 'z';

-- Case 6 [GCONCAT]. GROUP_CONCAT over a CHAR bind. An expression over the accumulator (COLLATION) reads its
-- compiled VARCHAR under the bind's collation, an output column and a scalar subquery read the function's domain.
-- GROUP_CONCAT's ORDER BY must be its argument, so the last prepare is rejected (-494) as in develop. NULL binds
-- are in 18_collation_gate_probes.
evaluate 'Case 6: GROUP_CONCAT over a CHAR bind';
prepare q from 'select group_concat(?), collation(group_concat(?)) from fg_t';
execute q using 'a', 'a';
prepare q from 'select mod(i, 2) g, group_concat(?), collation(group_concat(?)) from fg_t group by mod(i, 2) order by 1';
execute q using 'ab', 'ab';
prepare q from 'select (select group_concat(?) from fg_t), (select collation(group_concat(?)) from fg_t) from db_root';
execute q using 'z', 'z';
prepare q from 'select group_concat(? order by i desc) from fg_t';
execute q using 'q';

-- Case 7 [PCT]. A percentile fraction from a session variable or a bind is read through the execution's value
-- descriptor. The scalar subqueries in the WHERE clause over the primary key are precomputed by the scan through
-- the regu variable its index key range copies.
evaluate 'Case 7: percentile fractions and scalar subqueries in an index key range';
set @p = 0.5;
select percentile_cont(@p) within group (order by i), percentile_disc(@p) within group (order by c) from fg_t;
prepare q from 'select percentile_cont(?) within group (order by i), percentile_disc(?) within group (order by c) from fg_t';
execute q using 0.25, 0.75;
execute q using '0.5', '0.5';
create table fg_k (i int primary key, c double);
insert into fg_k values (1, 0.5), (2, 1.5), (3, 2.5);
select * from fg_k where i = (select percentile_disc(0.5) within group (order by i) from fg_k) order by 1;
select * from fg_k where i = (select percentile_cont(0.5) within group (order by i) from fg_k) order by 1;
select * from fg_k where i = (select max(i) from fg_k) order by 1;
drop table fg_k;

-- Case 8 [MYSQL]. Binds of strings, numbers, a time and a date under compat_mode=mysql, and binds in a derived
-- table. The mode is restored at the end.
evaluate 'Case 8: binds under compat_mode=mysql';
set system parameters 'compat_mode=mysql';
prepare q from 'select ? + ? from fg_t order by 1';
execute q using '1', '2';
execute q using 1, 2;
prepare q from 'select ? + 1 from fg_t order by 1';
execute q using time'10:00:00';
execute q using date'2024-01-01';
prepare q from 'select ?, x.i, y.a from fg_t x, (select ? + ? as a from fg_t) y order by 2, 3';
execute q using 1, 2, 3;
set system parameters 'compat_mode=cubrid';

deallocate prepare q;
deallocate variable @v, @a, @w, @u, @b, @n, @tmp, @z, @p;
drop table fg_t;
--+ holdcas off;
