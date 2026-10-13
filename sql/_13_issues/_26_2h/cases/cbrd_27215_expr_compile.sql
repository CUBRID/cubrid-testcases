/**
 * CBRD-27215 (PR #7658) expression programs -- every regression case of the PR in one file, one section per
 * former case (the section name is the former case name).  Each section creates and drops its own tables.
 */

-- ======== hoist_chain ========
/**
 * CBRD-27215 (PR #7658): two refinements of the compiled expression program.
 *
 * 1. A computing step whose inputs are all fixed is hoisted: "? * 2" and "1 + 2" run once per
 *    execution (per program for literals only) instead of once per row, the way the leaf publish and
 *    its coercion already did.  A host variable bound to a new value must still be seen by the hoisted
 *    step on the next execution, a step that can fail is hoisted only from the main loop (never from a
 *    right-hand side the interpreter may skip, never from a CASE branch), and every result and every
 *    error equals the interpreter's.
 *
 * 2. A chain of AND (or OR) in a scan filter is one flattened node evaluated in a loop rather than a
 *    descent through nested pairs.  Evaluation order, short-circuit points, three-valued results and
 *    the point at which an error is raised are those of the nested form, and the values the filter hands
 *    to the projection are unchanged.
 */
drop table if exists hc;
create table hc (id int, a int, b bigint, c int, n numeric(10,2), d double, dt date);
insert into hc values
 (1, 1, 100, 1, 1.50, 1.5, date'2026-01-15'),
 (2, 3, 200, 0, 12.34, 2.5, date'2025-06-30'),
 (3, NULL, NULL, 2, NULL, NULL, NULL),
 (4, 7, 400, 4, -7.25, -3.5, date'2024-12-01'),
 (5, -2, -500, 5, 99.99, 1e10, date'2026-09-11');

-- hoisted host-variable arithmetic sees the new binding on every execution
prepare h1 from 'select id, a * (? * 2), a + (? + 1), (? - 1) * n, cast(? as int) * 3 from hc order by id';
execute h1 using 2, 2, 2, 2;
execute h1 using 5, 5, 5, 5;
execute h1 using 2, 2, 2, 2;
execute h1 using NULL, NULL, NULL, NULL;
execute h1 using 2.5, 2.5, 2.5, 2.5;
execute h1 using 2, 2, 2, 2;
deallocate prepare h1;

-- literal-only arithmetic, run once per program
select id, a + (1 + 2), n * (10 / 4.0), cast('7' as int) + 1, extract(year from date'2026-01-01') + a from hc order by id;

-- extract over a host variable
prepare h2 from 'select id, extract(year from ?) + a, extract(month from ?) from hc order by id';
execute h2 using date'2026-03-05', date'2026-03-05';
execute h2 using date'1999-12-31', date'1999-12-31';
deallocate prepare h2;

-- a right-hand side the interpreter may skip is not hoisted: a NULL a skips 1 / ? even for a zero divisor
prepare h3 from 'select id, a + 1 / ? from hc where id = 3';
execute h3 using 0;
deallocate prepare h3;
-- the same division as a left operand is always computed: the error is raised as before
prepare h4 from 'select id, 1 / ? + a from hc where id = 3';
execute h4 using 0;
execute h4 using 2;
deallocate prepare h4;
-- a hoisted division that fails is raised when a row is evaluated, never when no row is
prepare h4b from 'select id, 1 / ? from hc where id = ?';
execute h4b using 0, 99;
execute h4b using 0, 1;
execute h4b using 4, 1;
deallocate prepare h4b;
select id, 10 / 4 from hc where id = 1;

-- inside a CASE branch the arithmetic stays in the row loop
prepare h5 from 'select id, case when a > 1 then ? * 2 else ? - 1 end from hc order by id';
execute h5 using 10, 10;
execute h5 using 3, 3;
deallocate prepare h5;

-- aggregate operands with hoisted parts
prepare h6 from 'select sum(a * (? * 2)), avg((? + 1) * n), max(cast(? as int) + b) from hc';
execute h6 using 2, 2, 2;
execute h6 using 3, 3, 3;
deallocate prepare h6;

-- AND chains: order, short-circuit, three-valued result
select id from hc where a > 0 and b > 0 and n * 2 > 3 and d < 100 order by id;
select id from hc where a > 0 and b > 150 and n > 0 and d > 0 and c >= 0 order by id;
select id from hc where (a > 0 and b > 0) and (n > 0 and d > 0) order by id;
select id from hc where a > 0 and (b > 0 and (n > 0 and d > 0)) order by id;
-- a NULL operand makes the chain UNKNOWN only when no operand is FALSE
select id from hc where a is null or (a > 0 and n > 0) order by id;
select id, (a > 0 and b > 0 and n > 0) from hc order by id;
-- an error in a later operand is reached only when the earlier ones did not stop the chain
select id from hc where a > 0 and 10 / c > 1 and b > 0 order by id;
select id from hc where c > 0 and 10 / c > 1 and b > 0 order by id;
select id from hc where a = 3 and 10 / c > 1;

-- OR chains
select id from hc where a = 1 or b = 200 or n > 90 or d < -3 order by id;
select id from hc where (a = 1 or b = 200) or (n > 90 or d < -3) order by id;
select id from hc where a = 999 or c = 0 or 10 / c > 100 order by id;
-- mixed nesting keeps the connectives apart
select id from hc where (a > 0 or b < 0) and (n > 0 or d > 0) and c >= 0 order by id;
select id from hc where a > 0 and (b < 0 or n > 10) and not (c = 4) order by id;

-- the filter's values still feed the projection
select id, n * 2, a + b from hc where n * 2 > 3 and a + b > 0 order by id;
select id, n * 2 from hc where n * 2 > 3 and a > 0 and b > 0 order by id;

-- host variables inside a chain
prepare h7 from 'select id from hc where a > ? and b > ? and n > ? order by id';
execute h7 using 0, 0, 0;
execute h7 using 0, 150, 0;
execute h7 using 0.5, 0, 0;
execute h7 using NULL, 0, 0;
execute h7 using 0, 0, 0;
deallocate prepare h7;

-- error order is the interpreter's: a hoisted step that fails (1 / ? with 0 bound) is not reported
-- ahead of an earlier column or operand that fails on the same row at run time (the cast of 'abc'
-- to int), and it is when it comes first.  The cast fails at run time, not at semantic check.
drop table if exists hce;
create table hce (id int, s varchar(10));
insert into hce values (1, 'abc'), (2, '7');
prepare h8 from 'select cast(s as int), 1 / ? from hce where id = 1';
execute h8 using 0;
deallocate prepare h8;
prepare h9 from 'select 1 / ?, cast(s as int) from hce where id = 1';
execute h9 using 0;
deallocate prepare h9;
prepare h10 from 'select cast(s as int) + 1 / ? from hce where id = 1';
execute h10 using 0;
deallocate prepare h10;
prepare h11 from 'select 1 / ? + cast(s as int) from hce where id = 1';
execute h11 using 0;
deallocate prepare h11;
prepare h12 from 'select id from hce where cast(s as int) > 0 and 1 / ? > 0';
execute h12 using 0;
deallocate prepare h12;
prepare h13 from 'select id from hce where 1 / ? > 0 and cast(s as int) > 0';
execute h13 using 0;
deallocate prepare h13;
drop table hce;

drop table hc;

-- ======== hostvar_prog ========
/**
 * CBRD-27215 (PR #7658): an expression over a host variable is compiled in the projection and in the
 * data filter too, not only as an aggregate operand.  The optimizer cannot type such a node -- its
 * result domain stays DB_TYPE_VARIABLE in the plan -- so the compiler lets the interpreted path
 * resolve it on the first row and compiles from the next one, and the program resolves that domain
 * from its own result once per execution (the clone restores DB_TYPE_VARIABLE at every execution
 * end, and without that a re-executed prepared statement failed with "Cannot coerce value of domain
 * integer to domain *variable*").
 *
 * Two distinct host variables are separate cells even when they are bound to the same value: the
 * compiler shares literals by value but host variables by position, so binding (3, 3) and then
 * (3, 5) to the same statement must give 3 and 5, never 3 and 3.  Every result equals the
 * interpreter's, including the NUMERIC scale that changes with the binding, the overflow boundary
 * and the rows a NULL first row leaves unresolved.
 */
drop table if exists hp;
create table hp (id int, a int, b bigint, n numeric(10,2), m numeric(20,6), d double, s varchar(20), g int);
insert into hp values
 (1, 1, 100, 1.50, 1.250000, 1.5, 'aa', 1),
 (2, 3, 200, 12.34, 123.456789, 2.5, 'bb', 1),
 (3, NULL, NULL, NULL, NULL, NULL, NULL, 2),
 (4, 7, 400, -7.25, -0.000001, -3.5, 'dd', 2),
 (5, -2, -500, 99999999.99, 999999.999999, 1e10, 'ee', 1);

-- two distinct host variables bound to the same value are not one cell
prepare p1 from 'select id, a * ?, a * ?, a + ?, ? + a from hp order by id';
execute p1 using 3, 3, 3, 3;
execute p1 using 3, 5, 7, 9;
execute p1 using 3, 3, 3, 3;
deallocate prepare p1;

prepare p2 from 'select sum(a * ?), sum(a * ?), max(a + ?), min(? + a) from hp';
execute p2 using 2, 2, 2, 2;
execute p2 using 2, 3, 4, 5;
execute p2 using 2, 2, 2, 2;
deallocate prepare p2;

-- the domain is resolved again on every execution (the projection comes from the program)
prepare p3 from 'select id, n * ?, n + ?, m * ? from hp order by id';
execute p3 using 2.5, 2.5, 2.5;
execute p3 using 2.5, 2.5, 2.5;
execute p3 using 12.345678, 12.345678, 1.5;
execute p3 using 2.5, 2.5, 2.5;
execute p3 using 1, 1, 1;
deallocate prepare p3;

-- a different bind type recompiles the program
prepare p4 from 'select id, a * ?, b * ? from hp order by id';
execute p4 using 2, 2;
execute p4 using 2.5, 2.5;
execute p4 using '3', '3';
execute p4 using NULL, NULL;
execute p4 using 2, 2;
deallocate prepare p4;

-- data filter: a plain comparison and an arithmetic one
prepare p5 from 'select id, a from hp where a > ? order by id';
execute p5 using 0;
execute p5 using 0;
execute p5 using 2;
execute p5 using 0.5;
execute p5 using NULL;
execute p5 using 0;
deallocate prepare p5;

prepare p6 from 'select id, a * ? from hp where a * ? > ? and b > ? order by id';
execute p6 using 2, 2, 1, -1000;
execute p6 using 2, 2, 1, -1000;
execute p6 using 3, 3, 5, 0;
execute p6 using 2, 2, 1, -1000;
deallocate prepare p6;

-- a NULL first row resolves nothing, so the deferral has to outlast it
drop table if exists hn;
create table hn (id int, a int);
insert into hn values (1, NULL), (2, NULL), (3, NULL), (4, NULL), (5, NULL), (6, 6), (7, 7);
prepare p7 from 'select id, a * ? from hn order by id';
execute p7 using 2;
execute p7 using 2;
execute p7 using 3;
deallocate prepare p7;

-- one row and no row at all: the scan ends before the deferral does
prepare p8 from 'select id, a * ? from hp where id = ? order by id';
execute p8 using 5, 1;
execute p8 using 5, 99;
execute p8 using 5, 2;
execute p8 using 5, 99;
deallocate prepare p8;

-- hash and sort GROUP BY
prepare p9 from 'select g, sum(n * ?), count(*) from hp where a is not null group by g order by g';
execute p9 using 2.5;
execute p9 using 2.5;
execute p9 using 12.345678;
deallocate prepare p9;

prepare p10 from 'select /*+ NO_HASH_AGGREGATE */ g, sum(a * ?) from hp where a is not null group by g order by g';
execute p10 using 2;
execute p10 using 3;
deallocate prepare p10;

-- a host variable inside a conditionally evaluated side
prepare p11 from 'select id, case when a is null then ? else a * ? end, nvl(a, ?) from hp order by id';
execute p11 using 0, 2, 9;
execute p11 using 0, 2, 9;
execute p11 using -1, 3, 8;
deallocate prepare p11;

-- string and double operands keep the interpreted path
prepare p12 from 'select id, s || ?, d * ? from hp order by id';
execute p12 using 'x', 2.0;
execute p12 using 'yy', 0.5;
deallocate prepare p12;

drop table hn;
drop table hp;

-- ======== prog_reuse ========
/**
 * CBRD-27215 (PR #7658): compiled expression programs are kept with the XASL clone across executions.
 * A prepared statement re-executed with the same, different (INT -> NUMERIC -> VARCHAR -> NULL) and again
 * the same bind types must return exactly what the interpreter returns: the program is reused when the
 * bound types match its signature and recompiled when they do not (projection, aggregate operand and
 * data filter alike); string-valued slots (private heap) must not survive an execution.
 */
drop table if exists rt;
create table rt (id int, n int, d double, m numeric(10,2), s varchar(20), dt date);
insert into rt values (1, 10, 1.5, 12.34, 'abc', date'2026-01-01'), (2, 20, 2.5, 23.45, 'de', date'2026-02-01'),
                      (3, NULL, NULL, NULL, NULL, NULL), (4, 40, 4.5, 45.67, 'ghij', date'2026-04-01');
-- projection + filter arithmetic + aggregate operand, all with a host variable
prepare p1 from 'select id, n * ?, cast(n * ? as varchar(10)) || s, case when n > ? then s else ''none'' end from rt where n * ? > 15 order by id';
execute p1 using 2, 2, 15, 1;
execute p1 using 2, 2, 15, 1;
execute p1 using 2.5, 2.5, 15.5, 1.0;
execute p1 using '2', '2', '15', '1';
execute p1 using 2, 2, 15, 1;
execute p1 using NULL, NULL, NULL, 1;
execute p1 using 2, 2, 15, 1;
prepare p2 from 'select sum(n * ?), max(m + ?), count(*) from rt where m + ? > 20';
execute p2 using 2, 1, 1;
execute p2 using 2.5, 1.5, 1.5;
execute p2 using 2, 1, 1;
execute p2 using '3', '1', '1';
execute p2 using 2, 1, 1;
-- string-valued slots (private heap) across executions
prepare p3 from 'select id, s || ?, nvl(s, ?), extract(year from dt) + ? from rt order by id';
execute p3 using 'x', 'none', 1;
execute p3 using 'yy', 'n', 2;
execute p3 using 1, 2, 3;
execute p3 using 'x', 'none', 1;
-- no host variables: pure reuse
prepare p4 from 'select id, n * 2 + 1, m * (1 - 0.1), case when n > 15 then s else ''none'' end from rt where n * 2 > 15 order by id';
execute p4;
execute p4;
execute p4;
deallocate prepare p1;
deallocate prepare p2;
deallocate prepare p3;
deallocate prepare p4;
drop table rt;
-- NUMERIC -> INT bind order on a filter with a typed literal (review 2026-10-07): the first execution
-- binds a NUMERIC so the comparison "n * ? > 15" is planned on NUMERIC, the next binds an INT; the
-- program must be recompiled for the INT plan and the literal must be read in its own domain
drop table if exists rt;
create table rt (id int, n int);
insert into rt values (1, 5), (2, 7), (3, NULL), (4, 40), (5, 8);
prepare p5 from 'select id, n from rt where n * ? > 15 order by id';
execute p5 using 1.0;
execute p5 using 2;
execute p5 using 1.0;
execute p5 using 2;
prepare p6 from 'select count(*) from rt where n + ? > 15';
execute p6 using 1.5;
execute p6 using 1;
execute p6 using 1.5;
prepare p7 from 'select id, n from rt where n * ? > 15 order by id';
execute p7 using 2;
execute p7 using 1.0;
execute p7 using 2;
deallocate prepare p5;
deallocate prepare p6;
deallocate prepare p7;
drop table rt;

-- ======== gby_dim_prog ========
/**
 * CBRD-27215 (PR #7658 review): the sorted GROUP BY copies the aggregate list once per dimension
 * (qexec_gby_init_group_dim); every copy compiles its own operand program and may hold a pending
 * deferred NUMERIC sum, and both must be released with the dimension (qexec_gby_clear_group_dim) --
 * on repeated execution, WITH ROLLUP, the hash+sort hybrid and the error exit alike. Results must be
 * identical to develop; the point of the case is that the same statements run many times.
 */

drop table if exists t;
create table t (g int, k int, n numeric(38,0), s varchar(10));
insert into t values (1, 1, 99999999999999999999999999999999999999, 'a');
insert into t values (1, 2, 99999999999999999999999999999999999999, 'b');
insert into t values (1, 3, 1, 'c');
insert into t values (2, 3, 99999999999999999999999999999999999999, 'd');
insert into t values (2, 4, 2, 'e');
insert into t values (3, 5, NULL, NULL);
insert into t values (3, 6, 3, 'f');

-- sorted path (NO_HASH_AGGREGATE): one dimension, program compiled per execution; run repeatedly
select /*+ NO_HASH_AGGREGATE */ g, sum(k * 2), avg(k), max(k + 1), count(k), count(*) from t group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(k * 2), avg(k), max(k + 1), count(k), count(*) from t group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(k * 2), avg(k), max(k + 1), count(k), count(*) from t group by g order by g;

-- deferred-carry NUMERIC sum accumulates on the dimension's own accumulator (sum_state)
select /*+ NO_HASH_AGGREGATE */ g, sum(n), sum(n * 2), avg(n) from t group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(n), sum(n * 2), avg(n) from t group by g order by g;

-- WITH ROLLUP: nkeys + 1 dimensions, each with its own copy of the list (rollup is never hashed)
select g, k, sum(n), sum(k * 2), count(*) from t group by g, k with rollup;
select g, k, sum(n), sum(k * 2), count(*) from t group by g, k with rollup;
select /*+ NO_HASH_AGGREGATE */ g, k, sum(n), min(s), max(s) from t group by g, k with rollup;

-- error while groups are open: HAVING fails on the group with min(k) = 3 while the rollup
-- dimensions above it still carry a pending NUMERIC sum (expected: divide-by-zero error, as on develop)
select /*+ NO_HASH_AGGREGATE */ g, k, sum(n) from t group by g, k with rollup having 10 / (min(k) - 3) > 0;

-- hash pass followed by the sorted pass: the head list is compiled by the hash pass during the scan,
-- then the dimensions are copied from it (respect_order disables the hash-only shortcut)
set system parameters 'agg_hash_respect_order=yes';
select g, sum(k * 2), sum(n), count(k) from t group by g order by g;
select g, sum(k * 2), sum(n), count(k) from t group by g order by g;
set system parameters 'agg_hash_respect_order=no';

-- index-driven sorted group by (qexec_groupby_index) uses the same dimension copy
create index i_t_g on t (g);
select /*+ NO_HASH_AGGREGATE */ g, sum(k * 2), sum(n) from t group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(k * 2), sum(n) from t group by g order by g;

drop table t;

-- Expected develop behavior: every SELECT returns the same rows as develop (sum(n) for g=1 and the
-- rollup totals are 39-40 digit NUMERICs; no 38-digit overflow since the sum domain is widened);
-- the HAVING statement raises ER_QPROC_ZERO_DIVIDE (-539, "Attempt to divide by zero") on both.
-- Generate the .answer on the develop baseline (empty .answer -> .result, as for the other cbrd_27215_* cases).
-- Note: agg_hash_respect_order is PRM_FOR_SERVER|PRM_USER_CHANGE (server-wide, dba); the case resets it.
-- max_agg_hash_size is PRM_TEST_CHANGE only, so a forced spill cannot be scripted in a TC.
drop table if exists t;

-- ======== short_circuit ========
/**
 * CBRD-27215 (PR #7658 review): the compiled path must mirror the interpreter's operand fetch order --
 * a NULL left operand skips the right operand of arithmetic and NULLIF, a non-NULL left operand skips
 * the right operand of NVL/IFNULL/COALESCE, and AND/OR short-circuit -- so a right operand that would
 * fail (division by zero) never fails when it is not needed.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');
select a + b / c from t1 where id = 1;
select sum(a + b / c) from t1 where id = 1;
select nvl(a, b / c) from t1 where id = 2;
select nullif(a, b / c) from t1 where id = 1;
select case when a > 0 and b / c > 1 then 1 else 0 end from t1 where id = 4;
select if(a is null or b / c > 1, 1, 0) from t1 where id = 1;
select a * (b / c) from t1 where id = 1;
select a - b / c from t1 where id = 1;
select sum(nvl(a, b / c)) from t1 where id = 2;
select coalesce(a, b / c) from t1 where id = 2;
select ifnull(a, b / c) from t1 where id = 2;
select a + (b / c) + 1 from t1 where id = 1;
select a + b / c from t1 where id = 3;
select a + b / c from t1 where id = 2;
select nvl(a, b / c) from t1 where id = 1;
select id, a + (case when c = 0 then b else b / c end) from t1 order by id;
select id, a + nvl(a, b / c) from t1 order by id;
select id, (a + b / c) + (a * b / c) from t1 order by id;
select id, case when a is not null and a + b / c > 0 then 1 else 0 end from t1 order by id;

-- a single comparison, not an AND/OR chain: the interpreter fetches the right operand only for a
-- non-NULL left one, so a NULL left side must not run b / c (id = 1 has a NULL a and c = 0)
select case when a > b / c then 1 else 0 end from t1 where id = 1;
select if (a > b / c, 1, 0) from t1 where id = 1;
select a > b / c from t1 where id = 1;
select sum(case when a > b / c then 1 else 0 end) from t1 where id = 1;
select id, case when a > b / c then 1 else 0 end from t1 order by id;
-- the same skip through LIKE: the pattern is fetched only for a non-NULL source
insert into t1 values (5, NULL, 7, 0, 1.00, 1, 1.0, NULL, NULL);
select id, s like cast (b / c as varchar) from t1 where id = 5;
select id, case when s like cast (b / c as varchar) then 1 else 0 end from t1 where id = 5;
drop table t1;

-- ======== cmp_rhs ========
/**
 * CBRD-27215 (PR #7658 review round 2): a comparison term fetches its right operand only for a non-NULL
 * left one and LIKE fetches its pattern/escape only for a non-NULL source (eval_pred ()), so a right side
 * that would fail (division by zero) must not fail on the rows whose left side is NULL.  DECODE compares
 * with R_EQ_TORDER, fetches both sides and keeps failing.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, s varchar(20));
insert into t1 values (1, NULL, 1, 0, 'abc');
insert into t1 values (2, 1, 2, 0, 'ABC');
insert into t1 values (3, 2, 3, 1, 'abd');
insert into t1 values (4, 0, 5, 0, NULL);

-- NULL left operand: the interpreted path never fetches b / c
select case when a > b / c then 1 else 0 end from t1 where id = 1;
select if(a > b / c, 1, 0) from t1 where id = 1;
select (a > b / c) from t1 where id = 1;
select sum(case when a > b / c then 1 else 0 end) from t1 where id = 1;
select case when a = b / c then 1 else 0 end from t1 where id = 1;
select id, case when a > b / c then 1 else 0 end from t1 where id in (1, 3) order by id;

-- NULL LIKE source: the pattern (and the escape) are never fetched
select case when s like cast(b / c as varchar) then 1 else 0 end from t1 where id = 4;
select case when s like cast(b / c as varchar) escape '#' then 1 else 0 end from t1 where id = 4;
select if(s like cast(b / c as varchar), 1, 0) from t1 where id = 4;

-- controls: the interpreted path does fetch the right side here, so these fail on develop as well
select case when a > b / c then 1 else 0 end from t1 where id = 2;
select case when s like cast(b / c as varchar) then 1 else 0 end from t1 where id = 2;
select decode(a, b / c, 1, 0) from t1 where id = 1;

-- controls: no fallible right-hand step, still compiled
select id, case when a < b then 1 else 0 end from t1 order by id;
select id, decode(a, b, 1, 0) from t1 order by id;
select id, case when s like '%d' then 1 else 0 end from t1 order by id;

drop table t1;

--   block 1: 0 / 0 / NULL / 0 / 0 / rows (1,0),(3,0)          -- PR head 0acc72bfb: ER_QPROC_ZERO_DIVIDE on all six
--   block 2: 0 / 0 / 0                                          -- PR head: ER_QPROC_ZERO_DIVIDE on all three
--   block 3: Division by zero error x3 on develop AND on the PR (a=1 non-NULL; s='ABC' non-NULL; DECODE fetches both)
--   block 4: (1,0),(2,1),(3,1),(4,1) / (1,0),(2,0),(3,0),(4,0) / (1,0),(2,0),(3,1),(4,0)
--   ESCAPE is grammatically a literal/host variable only (csql_grammar.y:20790), so the escape variant makes the
--   pattern fail; 'ABC' is avoided in the LIKE control ('%d') so the answer does not depend on the collation.
drop table if exists t1;

-- ======== mul_hostvar ========
/**
 * CBRD-27215 (PR #7658 review): SUM(numeric * ?) with an integer-family host variable must coerce
 * the integer side to NUMERIC and multiply with the plain numeric family, as the interpreter does
 * (qdata_multiply_numeric ()) -- not report an overflow, and with the same result scale. Rebinding
 * another type recompiles the program.
 *
 * What the markers below actually bind (CTP sql harness, CubridUtil.getSqlType () +
 * ConsoleDAO): $int -> setInt, $smallint -> setObject, $numeric -> setDouble, and any name the
 * map does not know falls back to VARCHAR -> setString. So this case covers the INTEGER and
 * SMALLINT binds directly, and reaches the NUMERIC and DOUBLE right-hand sides through the
 * column types rather than through the bind. BIGINT and true NUMERIC (BigDecimal) binds are not
 * expressible here; cbrd_27215_hostvar_prog.sql covers them with csql "prepare ... execute ...
 * using", where the literal's own type reaches the server.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');

$int, $2
select sum(n1 * ?) from t1;
select sum(n1 * bi) from t1;
$smallint, $2
select sum(n1 * ?) from t1;
$numeric, $2.00
select sum(n1 * ?) from t1;
$int, $3
select sum(n1 * ?) from t1;
$int, $2
select sum(? * n1) from t1;
select sum(bi * n1) from t1;
$int, $2, $int, $2, $int, $2, $int, $2
select sum(n1 * ?), sum(n1 + ?), sum(n1 - ?), sum(n1 / ?) from t1;
$numeric, $2.5, $numeric, $2.5, $numeric, $2.5, $numeric, $2.5
select sum(n1 * ?), sum(n1 + ?), sum(n1 - ?), sum(n1 / ?) from t1;
$int, $2
select id, n1 * ? from t1 order by id;
select id, n1 * bi from t1 order by id;
select sum(n1 * bi), sum(n1 * a), sum(n1 * 2), sum(bi * n1), sum(n1 * 2.5) from t1;
drop table t1;

-- ======== if_hostvar_domain ========
/**
 * CBRD-27215 (PR #7658 review, 2026-09-22): IF (cond, ?, ?) with both branches bound leaves the
 * parser without a result type, so the column's plan domain is a flagged VARCHAR (collation to be
 * resolved from the value).  The interpreted path resolves that domain from the first non-NULL
 * result and the list's type list follows; the compiled projection did the DB_TYPE_VARIABLE half
 * of that post-processing only, so the flagged domain stayed and the client asserted while reading
 * the string tuple.  The compiled path now mirrors both halves; every result equals the
 * interpreter's for each binding type.
 */
drop table if exists ih;
create table ih (a int);
insert into ih values (1), (0);

prepare p1 from 'select a, if (a > 0, ?, ?) as r from ih order by a';
execute p1 using 1.5, 2.5;
execute p1 using 1, 2;
execute p1 using 'x', 'y';
execute p1 using 1.5e0, 2.5e0;
execute p1 using 1.5, 2.5;
deallocate prepare p1;

-- no table at all
prepare p2 from 'select if (1 > 0, ?, ?)';
execute p2 using 1.5, 2.5;
execute p2 using 'abc', 'def';
deallocate prepare p2;

-- the resolved column feeds a sort and an aggregate
prepare p3 from 'select if (a > 0, ?, ?) as r from ih order by r';
execute p3 using 'b', 'a';
deallocate prepare p3;
prepare p4 from 'select count (distinct if (a > 0, ?, ?)) from ih';
execute p4 using 'b', 'a';
execute p4 using 'a', 'a';
deallocate prepare p4;

-- a NULL first row leaves the domain to the next row, as the interpreter does
insert into ih values (NULL);
prepare p5 from 'select a, if (a > 0, ?, ?) as r from ih order by a';
execute p5 using 'p', 'q';
deallocate prepare p5;

drop table ih;

-- ======== attrinfo_index_default ========
/**
 * CBRD-27215 (PR #7658 review, heap_file.c): the index attrinfo (heap_attrinfo_start_with_index ()) decoding
 * columns that are absent from an old representation -- the default-value branch of heap_attrvalue_read () --
 * and NUMERIC defaults of every on-disk size (4/8/12/16/20 bytes) through the fixed-column decode kernel.
 * Expected: identical to develop -- no error, old-representation rows show the defaults.
 */
drop table if exists t_ai;
create table t_ai (id int primary key, k int, s varchar(10));
create index i_t_ai_k on t_ai (k);
insert into t_ai values (1, 10, 'a'), (2, 20, 'b'), (3, 30, 'c'), (4, 40, 'd');

-- new representation: NUMERIC defaults spanning the 4/8/12/16/20-byte disk sizes, then indexes on them
alter table t_ai add column n1 numeric(1,0) default 9;
alter table t_ai add column n2 numeric(10,2) default -12345.67;
alter table t_ai add column n3 numeric(20,5) default 123456789012345.12345;
alter table t_ai add column n4 numeric(30,0) default 123456789012345678901234567890;
alter table t_ai add column n5 numeric(38,0) default 99999999999999999999999999999999999999;
alter table t_ai add column n6 numeric(38,0) default -99999999999999999999999999999999999999;
create index i_t_ai_n1 on t_ai (n1);
create index i_t_ai_n2 on t_ai (n2);
create index i_t_ai_n5 on t_ai (n5);
create unique index u_t_ai_n4_id on t_ai (n4, id);

-- rows still in the old representation: index maintenance reads n1..n6 through the default-value branch
select id, k, n1, n2, n3, n4, n5, n6 from t_ai order by id;
update t_ai set k = k + 1 where id = 2;
update t_ai set s = 'zz' where k = 31;
delete from t_ai where id = 3;
insert into t_ai (id, k, s) values (5, 50, 'e');
insert into t_ai values (6, 60, 'f', 1, 0.5, 1.00001, 1, 1, -1);
-- REPLACE / ON DUPLICATE KEY UPDATE use query_executor.c's own index attrinfo (qexec_execute_insert, L13144)
replace into t_ai (id, k, s) values (1, 11, 'r');
insert into t_ai (id, k, s) values (4, 44, 'o') on duplicate key update k = k + 100;
select id, k, s, n1, n2, n3, n4, n5, n6 from t_ai order by id;
select id, n1 from t_ai where n1 = 9 order by id;
select id, n2 from t_ai where n2 < 0 order by id;
select id, n5 from t_ai where n5 = 99999999999999999999999999999999999999 order by id;
select count(*), sum(n4), min(n6), max(n5) from t_ai;
-- old- and new-representation rows in one scan: the decoding plan is re-derived on every representation switch
update t_ai set n2 = n2 + 1 where id in (1, 5);
select id, n2 from t_ai order by id;
drop table t_ai;

-- ======== sum_overflow ========
/**
 * CBRD-27215 (PR #7658 review): SUM over a BIGINT accumulator runs the compiled accumulate kernel
 * qdata_acc_kernel_sum_bigint () (;trace shows "agg[0]: sum_bigint").  Crossing DB_BIGINT_MAX /
 * DB_BIGINT_MIN must raise the interpreter's overflow error (-458, "Overflow occurred in addition
 * context.") in an optimized build: the kernel adds and tests the overflow flag in one step
 * (OR_ADD_OVERFLOW) instead of wrapping first, which is undefined behavior for signed operands.
 * Every statement goes through qdata_add_bigint () on develop, where the answers are generated.
 */

drop table if exists t_sum_ovf;
create table t_sum_ovf (id int, g int, b bigint);
insert into t_sum_ovf values (1, 1, 9223372036854775807);
insert into t_sum_ovf values (2, 1, 1);
insert into t_sum_ovf values (3, 2, -9223372036854775807 - 1);
insert into t_sum_ovf values (4, 2, -1);
insert into t_sum_ovf values (5, 3, 9223372036854775807);
insert into t_sum_ovf values (6, 3, -9223372036854775807 - 1);
insert into t_sum_ovf values (7, 4, NULL);
insert into t_sum_ovf values (8, 4, 5000000000);
insert into t_sum_ovf values (9, 5, 9223372036854775807);
insert into t_sum_ovf values (10, 5, 0);

-- DB_BIGINT_MAX + 1 (either accumulation order): develop Error:-458
select sum(b) from t_sum_ovf where g = 1;
-- DB_BIGINT_MIN + (-1): develop Error:-458
select sum(b) from t_sum_ovf where g = 2;
-- MAX + MIN = -1: no overflow in either order -> -1
select sum(b) from t_sum_ovf where g = 3;
-- NULL is skipped, the single non-NULL row takes the first-row copy path -> 5000000000
select sum(b) from t_sum_ovf where g = 4;
-- MAX + 0 lands exactly on the boundary: not an overflow -> 9223372036854775807
select sum(b) from t_sum_ovf where g = 5;
-- hash GROUP BY and sorted GROUP BY over the non-overflowing groups -> (3,-1) (4,5000000000) (5,MAX)
select g, sum(b) from t_sum_ovf where g in (3, 4, 5) group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(b) from t_sum_ovf where g in (3, 4, 5) group by g order by g;
-- an overflowing group fails the whole statement on both paths: Error:-458
select g, sum(b) from t_sum_ovf where g in (1, 3) group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(b) from t_sum_ovf where g in (2, 3) group by g order by g;
-- a computed operand still resolves the BIGINT accumulator kernel: Error:-458 / Error:-458
select sum(b + 0) from t_sum_ovf where g = 1;
select sum(b * 1) from t_sum_ovf where g = 2;
drop table t_sum_ovf;

-- ======== share_conditional ========
/**
 * CBRD-27215 (PR #7658 review, 2026-09-22): a scan-filter value that is computed only
 * conditionally -- the right side of NVL/IFNULL/COALESCE, the branch of CASE/IF/DECODE
 * that was not taken -- must not be shared with the same scan's projection or aggregates.
 * The filter accepts the row without running that node, so its slot still holds the
 * previous row's value; before the fix the second row printed 20 (the first row's b*2)
 * instead of 14 and SUM gave 40 instead of 34.  Every result equals the interpreter's.
 */
drop table if exists sc;
create table sc (a int, b int);
insert into sc values (NULL, 10), (100, 7);

select b * 2 from sc where nvl (a, b * 2) > 8 order by 1;
select b * 2 from sc where ifnull (a, b * 2) > 8 order by 1;
select b * 2 from sc where coalesce (a, b * 2) > 8 order by 1;
select sum (b * 2) from sc where nvl (a, b * 2) > 8;
select sum (b * 2), avg (b * 2), max (b * 2) from sc where coalesce (a, b * 2) > 8;
select b * 2, count (*) from sc where nvl (a, b * 2) > 8 group by b * 2 order by 1;
-- the unconditional root of a side is still shareable: a + 1 is computed for every accepted row
select a + 1, b * 2 from sc where nvl (a + 1, b * 2) > 8 order by 1;

drop table if exists sc2;
create table sc2 (a int, b int);
insert into sc2 values (1, 5), (0, 7);

select b * 2 from sc2 where (case when a > 0 then b * 2 else 0 end) >= 0 order by 1;
select b * 2 from sc2 where if (a > 0, b * 2, 0) >= 0 order by 1;
select b * 2 from sc2 where decode (a, 1, b * 2, 0) >= 0 order by 1;
select b * 2 from sc2 where (case a when 1 then b * 2 else 0 end) >= 0 order by 1;
select sum (b * 2) from sc2 where if (a > 0, b * 2, 0) >= 0;
-- the ELSE side is the conditional one when the WHEN holds
select b * 2 from sc2 where (case when a > 0 then 0 else b * 2 end) >= 0 order by 1;
-- three rows, mixed: only the rows that ran b * 2 may have a current slot, so nothing is shared
insert into sc2 values (1, 9);
select a, b * 2 from sc2 where (case when a > 0 then b * 2 else 0 end) >= 0 order by a, 2;

drop table sc;
drop table sc2;

-- ======== scan_const_drift ========
/**
 * CBRD-27215 (PR #7658 review round 2): a compiled scan-filter leaf must verify the runtime type of a
 * TYPE_CONSTANT operand.  A recursive CTE declares column n as INTEGER (anchor) but the recursive branch
 * refills the slot with the BIGINT of count (); the correlated filter k <= c.n inside the subquery then
 * compares an INTEGER attribute with a BIGINT value.  The interpreter (eval_pred_comp0 () /
 * eval_value_rel_cmp ()) coerces; a typed leaf reading db_get_int () would assert (debug) or compare the
 * low 32 bits (release).  Host-variable sides (TYPE_POS_VALUE) must keep the guard they already have.
 */

drop table if exists r;
create table r (k int, v int);
insert into r values (1, 10), (2, 20), (3, 30), (4, 40), (5, 50);

-- reviewer's repro: develop 1, 2, 4, 8 (values stay below 2^32, so a low-half read is wrong only in debug)
with recursive c(n) as (select 1 union all select (select count(*) from r where k <= c.n) + c.n from c where n < 5) select * from c;

-- the drifted value exceeds 32 bits: a low-half read compares k <= 0 and yields (3, 0) instead of (3, 21474836480)
with recursive c(i, n) as (select 1, 1 union all select i + 1, (select count(*) from r where k <= c.n) * 4294967296 from c where i < 3) select i, n from c;

-- drift on the other side of the leaf (c.n >= k) and with a different operator
with recursive c(i, n) as (select 1, 1 union all select i + 1, (select count(*) from r where c.n >= k) * 4294967296 from c where i < 3) select i, n from c;

-- host-variable side of a scan filter: the same leaf shape bound to INTEGER, BIGINT and NUMERIC
$int, $3
select k from r where k <= ? order by k;
$bigint, $4294967296
select k from r where k <= ? order by k;
$numeric, $2.5
select k from r where k <= ? order by k;
$int, $3
select k from r where ? >= k order by k;
select k from r where k <= 3 order by k;
select k from r where k <= 4294967296 order by k;

drop table r;

--   hostvar/literal selects: k = 1,2,3 / 1..5 / 1,2 / 1,2,3 / 1,2,3 / 1..5
-- Place in cubrid-testcases sql/_13_issues/_26_2h/cases/cbrd_27215_scan_const_drift.sql (tc/pr-7658, alongside the five cbrd_27215_* cases).

-- ======== literal_sign ========
/**
 * CBRD-27215 (PR #7658): the compiled expression list shares a literal with another occurrence of
 * the SAME value, and a NUMERIC value keeps its sign in the numeric header rather than in the
 * magnitude buffer.  Comparing only the buffer made 1.5 and -1.5 one literal, so "n * 1.5, n * -1.5"
 * collapsed into a single step and returned the first column's value twice, and
 * "cast(-x as numeric(38,0)) - cast(x as numeric(38,0))" returned 0.  Sign, precision and scale all
 * take part in the comparison; equal values still share.  Every result equals the interpreter's.
 */
drop table if exists ls;
create table ls (id int, n numeric(10,2), m numeric(20,6), d double, a int, b bigint);
insert into ls values
 (1, 2.00, 2.000000, 2.0, 2, 2),
 (2, -3.50, -3.500000, -3.5, -3, -3),
 (3, NULL, NULL, NULL, NULL, NULL),
 (4, 0.00, 0.000000, 0.0, 0, 0);

-- the same magnitude with both signs must not collapse into one step
select id, n * 1.5, n * -1.5, n + 1.5, n + -1.5 from ls order by id;
select id, m * 2.500000, m * -2.500000, m - 2.500000, m - -2.500000 from ls order by id;
select id, d * 1.5, d * -1.5 from ls order by id;
select id, a * 3, a * -3, b * 3, b * -3 from ls order by id;

-- equal values still share; differing scale stays separate
select id, n * 1.5, n * 1.5, n * 1.50, n * 2.5 from ls order by id;

-- constants only, no column: the 38-digit boundary the suite caught
select cast(-99999999999999999999999999999999999999 as numeric(38,0)) - cast(99999999999999999999999999999999999999 as numeric(38,0));
select cast(-99999999999999999999999999999999999999 as numeric(38,0)) a, cast(99999999999999999999999999999999999999 as numeric(38,0)) b;
select cast(-5.25 as numeric(10,2)) - cast(5.25 as numeric(10,2));
select cast(-1.5 as double) - cast(1.5 as double);
select cast(-5 as numeric(10,0)) - cast(5 as numeric(10,0));

-- the same pair as aggregate operands and in a data filter
select sum(n * 1.5), sum(n * -1.5), count(*) from ls;
select id, n from ls where n * 1.5 > 0 and n * -1.5 < 0 order by id;
select id, n * -1.5 from ls where n * 1.5 > 0 order by id;

drop table ls;

-- ======== agg_error_order ========
-- CBRD-27215 / PR #7658 review round 2, thread T8 (query_aggregate.cpp:1092)
-- (1) error precedence when one row fails twice: the compiled path evaluates every
--     participating operand before accumulating, so the LATER aggregate's operand error
--     wins over the EARLIER aggregate's accumulate error.
--     develop 5f3a30d09 : ERROR: Overflow occurred in addition context.
--     PR (intended)     : ERROR: Overflow occurred in multiplication context.
-- (2) list order among operand errors is unchanged, and single-failure rows are unchanged.
-- (3) index-boundary MIN/MAX (min_max_optimized) stays on the interpreted path.
drop table if exists u;
create table u (id int primary key, d1 double, b1 bigint, b2 bigint);
insert into u values (1, 1.5e308, 1, 1);
insert into u values (2, 1.5e308, 9223372036854775807, 2);

-- row 2: SUM(d1) 1.5e308 + 1.5e308 overflows in addition AND b1 * b2 overflows in multiplication
select sum(d1), sum(b1 * b2) from u;
-- same row, aggregates swapped: both builds report multiplication (operand errors keep list order)
select sum(b1 * b2), sum(d1) from u;
-- single failure per row: identical on both builds
select sum(d1) from u;
select sum(b1 * b2) from u;
select sum(d1), sum(b1 * b2) from u where id = 2;
select sum(d1), sum(b1 * b2) from u where id = 1;

-- (3) min/max-only list over an index: min_max_optimized, is_ended after the first row
drop table if exists mm;
create table mm (k int not null, v int);
create index i_mm_k on mm (k);
insert into mm values (3, 30), (1, 10), (2, 20), (5, 50), (4, 40);
select min(k) from mm;
select max(k) from mm;
select min(k), max(k) from mm;
-- mixed list: pt_set_access_spec_for_aggregation () clears min_max_optimized, program path
select min(k), max(k), sum(v), sum(k * v) from mm;
select min(k), sum(v) from mm where k > 2;

drop table u;
drop table mm;

-- ======== cse_commute ========
/**
 * CBRD-27215 (PR #7658): the compiled expression list shares a + b with b + a and a * b with b * a
 * (integer, NUMERIC with equal and different scales, DOUBLE) when both operands are evaluated on
 * every row.  Pairs whose right operand is evaluated conditionally must NOT be shared: a + b / c
 * skips b / c for a NULL a while b / c + a always computes it, so the two differ in whether a
 * division by zero raises.  Every result equals the interpreter's.
 */

drop table if exists cm;
create table cm (id int, a int, b int, n numeric(10,2), m numeric(12,4), d double, e double, c int, bi bigint);
insert into cm values (1, 1, 2, 1.50, 2.5000, 1.25, 2.5, 0, 4000000000);
insert into cm values (2, 3, 4, 3.50, 4.2500, 3.25, 4.5, 2, 5000000000);
insert into cm values (3, NULL, 5, NULL, 5.5000, NULL, 6.5, 1, NULL);
insert into cm values (4, 7, NULL, 7.75, NULL, 7.5, NULL, 3, 6000000000);
insert into cm values (5, -2, 9, -2.25, 9.0001, -2.5, 9.75, 4, -7000000000);
insert into cm values (6, NULL, 8, NULL, 8.0000, NULL, 8.0, 0, NULL);

select id, a + b, b + a, a * b, b * a from cm order by id;
select id, n + m, m + n, n * m, m * n from cm order by id;
select id, d + e, e + d, d * e, e * d from cm order by id;
select id, bi + a, a + bi, bi * b, b * bi from cm order by id;
select id, (a + b) * 2, 2 * (b + a), (a + b) * (b + a) from cm order by id;
select id, a * n, n * a, a + n, n + a from cm order by id;
select sum(a * b), sum(b * a), max(a + b), min(b + a), avg(n * m), avg(m * n) from cm;
select id, a + b / c, b / c + a from cm where c > 0 order by id;
select id, a + b / c, b / c + a from cm where id = 3;
select id, a + b / c from cm where id = 1;
select id, b / c + a from cm where id = 1;
-- id 6: a is NULL and c is 0 -- the interpreter skips b / c in a + b / c (NULL) but computes it in b / c + a (error)
select id, a + b / c from cm where id = 6;
select id, b / c + a from cm where id = 6;
select id, a + b / c, b / c + a from cm where id in (2, 6) order by id;
select id, nvl(a, b) + b, b + nvl(a, b) from cm order by id;
select id, a + b, b + a from cm where a + b > 5 and b + a > 5 order by id;
drop table cm;

-- ======== filter_arith ========
/**
 * CBRD-27215 (PR #7658 follow-up): arithmetic operands of scan-filter comparisons are compiled into
 * leaf-owned regions of the filter's program.  Every row must qualify exactly as the interpreter
 * decides, and a right operand (or a later AND/OR term) that would fail must still be skipped
 * where the interpreter skips it -- and still fail where the interpreter evaluates it.
 */

drop table if exists fa;
create table fa (id int, a int, b int, c int, n numeric(10,2), m numeric(10,2), d double, s varchar(10), dt date);
insert into fa values (1, 1, 2, 0, 1.50, 2.00, 1.5, 'x', date'2024-01-10');
insert into fa values (2, 3, 4, 1, 2.25, 0.50, 2.5, 'y', date'2024-02-10');
insert into fa values (3, NULL, 5, 0, 3.00, NULL, NULL, NULL, date'2024-03-10');
insert into fa values (4, 7, NULL, 2, NULL, 1.00, 4.5, 'z', NULL);
insert into fa values (5, 10, 1, 0, 9.99, 0.01, 0.5, 'w', date'2024-05-10');
select id from fa where (a+1)*b > 5 order by id;
select id from fa where n*2 > 4 and a + 1 > 1 order by id;
select id from fa where a + b/c > 1 order by id;
select id from fa where a > 5 or b/c > 1 order by id;
select id from fa where a > 5 and b/c > 1 order by id;
select id from fa where (n - 0.5) * (m + 1) >= 2 order by id;
select id from fa where a + 1 = b order by id;
select id from fa where d * 2 > 3 order by id;
select id from fa where extract(year from dt) + 1 > 2024 order by id;
select id from fa where a * 2 > 3 and n + m > 1 order by id;
select id, (a+1)*b from fa where (a+1)*b > 5 order by id;
select id from fa where nvl(a, 0) + 1 > 2 order by id;
select id from fa where case when c = 0 then a else b / c end > 2 order by id;
select id from fa where a - 1 > b - 3 order by id;
select id from fa where 1 + a > 2 order by id;
select count(*), sum(a * 2) from fa where a * 2 > 3;
select id from fa where a + 2147483647 > 0 order by id;
select id from fa where 9223372036854775807 + b > 0 order by id;
select id from fa where a > 5 or b/c > 1 order by id;
drop table fa;

-- ======== filter_literal_coerce ========
/**
 * CBRD-27215 (PR #7658 follow-up): a comparison whose literal right operand has another type than the
 * left side is compiled with the literal coerced once to the left side's type (the constant-side
 * coercion eval_value_rel_cmp () applies): numeric literal vs a more general numeric expression,
 * string literal vs a date/time column.  Mixes the interpreter does not coerce that way stay interpreted.
 */

drop table if exists lc;
create table lc (id int, a int, bi bigint, n numeric(10,2), d double, dt date, ts timestamp, dtt datetime, s varchar(10));
insert into lc values (1, 1, 10000000000, 1.50, 1.5, date'2024-01-10', timestamp'2024-01-10 10:00:00', datetime'2024-01-10 10:00:00.123', '5');
insert into lc values (2, 3, 20000000000, 2.25, 2.5, date'2024-02-10', timestamp'2024-02-10 10:00:00', datetime'2024-02-10 10:00:00.456', '15');
insert into lc values (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert into lc values (4, 7, 30000000000, 9.99, 4.5, date'2024-04-10', timestamp'2024-04-10 10:00:00', datetime'2024-04-10 10:00:00.789', '7');
select id from lc where n * 2 > 4 order by id;
select id from lc where n > 2 order by id;
select id from lc where n * 2 >= 4.5 order by id;
select id from lc where d * 2 > 3 order by id;
select id from lc where bi + 1 > 15000000000 order by id;
select id from lc where bi > 15000000000 order by id;
select id from lc where a > 2.5 order by id;
select id from lc where a + 1 > 2.5 order by id;
select id from lc where dt >= '2024-02-01' order by id;
select id from lc where dt > '2024-01-10' and dt < '2024-04-10' order by id;
select id from lc where ts >= '2024-02-10 10:00:00' order by id;
select id from lc where dtt > '2024-02-10 10:00:00.456' order by id;
select id from lc where s > 6 order by id;
select id from lc where n > '2' order by id;
select id from lc where a * 2 > 2.5 order by id;
select id from lc where n * 2 > 4 and a * 2 > 2 order by id;
select id, n * 2 from lc where n * 2 > 4 order by id;
select sum(n * 2) from lc where n * 2 > 4;
select id from lc where d > 1 order by id;
drop table lc;

-- ======== filter_share ========
/**
 * CBRD-27215 (PR #7658 follow-up): an expression the data filter already computes for the row is
 * read by the same scan's projection and aggregate operands instead of being recomputed.  Only
 * terms every accepted row has evaluated (AND/NOT paths) are shared; OR terms are not.  Results
 * must be identical to the interpreter in every shape.
 */

drop table if exists sh;
create table sh (id int, a int, b int, c int, n numeric(10,2), m numeric(10,2), d double, dt date);
insert into sh values (1, 1, 2, 0, 1.50, 2.00, 1.5, date'2024-01-10');
insert into sh values (2, 3, 4, 1, 2.25, 0.50, 2.5, date'2024-02-10');
insert into sh values (3, NULL, 5, 0, 3.00, NULL, NULL, date'2024-03-10');
insert into sh values (4, 7, NULL, 2, NULL, 1.00, 4.5, NULL);
insert into sh values (5, 10, 1, 0, 9.99, 0.01, 0.5, date'2024-05-10');
insert into sh values (6, 6, 6, 3, 6.00, 6.00, 6.0, date'2024-06-10');
select id, (a+1)*b, a+1 from sh where (a+1)*b > 5 order by id;
select id, n*m, n*m+1 from sh where n*m > 1 and a + b > 3 order by id;
select id, (a+1)*b from sh where (a+1)*b > 5 or c > 1 order by id;
select id, a+b from sh where not (a+b > 5) order by id;
select id, a+b, b/c from sh where a+b > 3 and b/c > 1 order by id;
select sum((a+1)*b), max(a+1), count(*) from sh where (a+1)*b > 5;
select sum(n*m), avg(n*m) from sh where n*m > 1;
select id, extract(year from dt) + 1 from sh where extract(year from dt) + 1 > 2024 order by id;
select id, a*2 from sh where a*2 > 3 group by id, a*2 order by id;
select a*2, count(*) from sh where a*2 > 3 group by a*2 order by 1;
select id, (a+1)*b from sh where (a+1)*b > 5 and (a+1)*b < 100 order by id;
select id, a+1 from sh where a+1 > 2 and b+1 > 2 order by id;
select id, a + 1, b + 1 from sh where a + 1 > b + 1 order by id;
drop table sh;

-- ======== lazy_chain ========
/**
 * CBRD-27215 (PR #7658 follow-up): two lazily-evaluated arithmetic nodes in a row -- the second
 * one's left operand is the first one's result.  A NULL left operand must skip BOTH right
 * operands exactly as the interpreter does, so a right operand that would fail (division by
 * zero) on that row never runs; on other rows both must be evaluated.
 */

drop table if exists t1;
create table t1 (id int, ep numeric(15,2), disc numeric(15,2), tax numeric(15,2), z numeric(15,2), a int, b int, c int);
insert into t1 values (1, 100.00, 0.10, 0.05, 2.00, 1, 2, 2);
insert into t1 values (2, NULL, 0.20, 0.06, 0, NULL, 4, 0);
insert into t1 values (3, 300.00, NULL, 0.07, 1.00, 3, NULL, 0);
insert into t1 values (4, 400.00, 0.40, NULL, 4.00, 7, 8, 1);
select id, ep * (1 - disc), ep * (1 - disc) * (1 / z) from t1 where id <> 2 order by id;
select id, ep * (1 - disc) * (1 / z) from t1 where id = 2;
select id, ep * (1 - disc) * (1 / z) from t1 order by id;
select sum(ep * (1 - disc)), sum(ep * (1 - disc) * (1 / z)) from t1 where id <> 2;
select sum(ep * (1 - disc)), sum(ep * (1 - disc) * (1 / z)) from t1 where id = 2;
select id, a * (b / c) + a * (b / c) * (b / c) from t1 where id in (1, 2) order by id;
select id, a * (b / c) + a * (b / c) * (b / c) from t1 where id = 4;
select id, nvl(a, b / c) + nvl(a, b / c) * 2 from t1 where id in (1, 4) order by id;
select id, nvl(a, b / c) from t1 where id = 2;
select id, nullif(a, b / c) + nullif(a, b / c) * 2 from t1 where id in (1, 2, 4) order by id;
select id, case when c <> 0 then a * (b / c) else 0 end + case when c <> 0 then a * (b / c) else 0 end from t1 order by id;
select id, case when a > 0 then a * (b / c) else -1 end from t1 where id = 2;
drop table t1;

-- ======== step_limit ========
/**
 * CBRD-27215 (PR #7658 review): an expression list that exceeds the compiled program's step/cell
 * cap (128) must fall back to the interpreter, not leave a half-initialized step behind (SIGSEGV).
 * 63 columns compile, 64/65/127/128 columns and 64/128 SUM(a+N) aggregates must return the same rows.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');
select count(*) from (select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63 from t1) x;
select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63 from t1 where id = 2;
select count(*) from (select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63, a+64 from t1) x;
select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63, a+64 from t1 where id = 2;
select count(*) from (select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63, a+64, a+65 from t1) x;
select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63, a+64, a+65 from t1 where id = 2;
select count(*) from (select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63, a+64, a+65, a+66, a+67, a+68, a+69, a+70, a+71, a+72, a+73, a+74, a+75, a+76, a+77, a+78, a+79, a+80, a+81, a+82, a+83, a+84, a+85, a+86, a+87, a+88, a+89, a+90, a+91, a+92, a+93, a+94, a+95, a+96, a+97, a+98, a+99, a+100, a+101, a+102, a+103, a+104, a+105, a+106, a+107, a+108, a+109, a+110, a+111, a+112, a+113, a+114, a+115, a+116, a+117, a+118, a+119, a+120, a+121, a+122, a+123, a+124, a+125, a+126, a+127 from t1) x;
select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63, a+64, a+65, a+66, a+67, a+68, a+69, a+70, a+71, a+72, a+73, a+74, a+75, a+76, a+77, a+78, a+79, a+80, a+81, a+82, a+83, a+84, a+85, a+86, a+87, a+88, a+89, a+90, a+91, a+92, a+93, a+94, a+95, a+96, a+97, a+98, a+99, a+100, a+101, a+102, a+103, a+104, a+105, a+106, a+107, a+108, a+109, a+110, a+111, a+112, a+113, a+114, a+115, a+116, a+117, a+118, a+119, a+120, a+121, a+122, a+123, a+124, a+125, a+126, a+127 from t1 where id = 2;
select count(*) from (select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63, a+64, a+65, a+66, a+67, a+68, a+69, a+70, a+71, a+72, a+73, a+74, a+75, a+76, a+77, a+78, a+79, a+80, a+81, a+82, a+83, a+84, a+85, a+86, a+87, a+88, a+89, a+90, a+91, a+92, a+93, a+94, a+95, a+96, a+97, a+98, a+99, a+100, a+101, a+102, a+103, a+104, a+105, a+106, a+107, a+108, a+109, a+110, a+111, a+112, a+113, a+114, a+115, a+116, a+117, a+118, a+119, a+120, a+121, a+122, a+123, a+124, a+125, a+126, a+127, a+128 from t1) x;
select a+1, a+2, a+3, a+4, a+5, a+6, a+7, a+8, a+9, a+10, a+11, a+12, a+13, a+14, a+15, a+16, a+17, a+18, a+19, a+20, a+21, a+22, a+23, a+24, a+25, a+26, a+27, a+28, a+29, a+30, a+31, a+32, a+33, a+34, a+35, a+36, a+37, a+38, a+39, a+40, a+41, a+42, a+43, a+44, a+45, a+46, a+47, a+48, a+49, a+50, a+51, a+52, a+53, a+54, a+55, a+56, a+57, a+58, a+59, a+60, a+61, a+62, a+63, a+64, a+65, a+66, a+67, a+68, a+69, a+70, a+71, a+72, a+73, a+74, a+75, a+76, a+77, a+78, a+79, a+80, a+81, a+82, a+83, a+84, a+85, a+86, a+87, a+88, a+89, a+90, a+91, a+92, a+93, a+94, a+95, a+96, a+97, a+98, a+99, a+100, a+101, a+102, a+103, a+104, a+105, a+106, a+107, a+108, a+109, a+110, a+111, a+112, a+113, a+114, a+115, a+116, a+117, a+118, a+119, a+120, a+121, a+122, a+123, a+124, a+125, a+126, a+127, a+128 from t1 where id = 2;
select sum(a+1), sum(a+2), sum(a+3), sum(a+4), sum(a+5), sum(a+6), sum(a+7), sum(a+8), sum(a+9), sum(a+10), sum(a+11), sum(a+12), sum(a+13), sum(a+14), sum(a+15), sum(a+16), sum(a+17), sum(a+18), sum(a+19), sum(a+20), sum(a+21), sum(a+22), sum(a+23), sum(a+24), sum(a+25), sum(a+26), sum(a+27), sum(a+28), sum(a+29), sum(a+30), sum(a+31), sum(a+32), sum(a+33), sum(a+34), sum(a+35), sum(a+36), sum(a+37), sum(a+38), sum(a+39), sum(a+40), sum(a+41), sum(a+42), sum(a+43), sum(a+44), sum(a+45), sum(a+46), sum(a+47), sum(a+48), sum(a+49), sum(a+50), sum(a+51), sum(a+52), sum(a+53), sum(a+54), sum(a+55), sum(a+56), sum(a+57), sum(a+58), sum(a+59), sum(a+60), sum(a+61), sum(a+62), sum(a+63), sum(a+64) from t1;
select sum(a+1), sum(a+2), sum(a+3), sum(a+4), sum(a+5), sum(a+6), sum(a+7), sum(a+8), sum(a+9), sum(a+10), sum(a+11), sum(a+12), sum(a+13), sum(a+14), sum(a+15), sum(a+16), sum(a+17), sum(a+18), sum(a+19), sum(a+20), sum(a+21), sum(a+22), sum(a+23), sum(a+24), sum(a+25), sum(a+26), sum(a+27), sum(a+28), sum(a+29), sum(a+30), sum(a+31), sum(a+32), sum(a+33), sum(a+34), sum(a+35), sum(a+36), sum(a+37), sum(a+38), sum(a+39), sum(a+40), sum(a+41), sum(a+42), sum(a+43), sum(a+44), sum(a+45), sum(a+46), sum(a+47), sum(a+48), sum(a+49), sum(a+50), sum(a+51), sum(a+52), sum(a+53), sum(a+54), sum(a+55), sum(a+56), sum(a+57), sum(a+58), sum(a+59), sum(a+60), sum(a+61), sum(a+62), sum(a+63), sum(a+64), sum(a+65), sum(a+66), sum(a+67), sum(a+68), sum(a+69), sum(a+70), sum(a+71), sum(a+72), sum(a+73), sum(a+74), sum(a+75), sum(a+76), sum(a+77), sum(a+78), sum(a+79), sum(a+80), sum(a+81), sum(a+82), sum(a+83), sum(a+84), sum(a+85), sum(a+86), sum(a+87), sum(a+88), sum(a+89), sum(a+90), sum(a+91), sum(a+92), sum(a+93), sum(a+94), sum(a+95), sum(a+96), sum(a+97), sum(a+98), sum(a+99), sum(a+100), sum(a+101), sum(a+102), sum(a+103), sum(a+104), sum(a+105), sum(a+106), sum(a+107), sum(a+108), sum(a+109), sum(a+110), sum(a+111), sum(a+112), sum(a+113), sum(a+114), sum(a+115), sum(a+116), sum(a+117), sum(a+118), sum(a+119), sum(a+120), sum(a+121), sum(a+122), sum(a+123), sum(a+124), sum(a+125), sum(a+126), sum(a+127), sum(a+128) from t1;
drop table t1;

-- ======== numeric_eager_rhs ========
/**
 * CBRD-27215 (PR #7658 follow-up): a pure NUMERIC +, -, * right-hand side whose integer digits
 * provably fit is evaluated eagerly (it cannot fail), so the shared sub-expression of
 * sum(ep * (1 - disc)) and sum(ep * (1 - disc) * (1 + tax)) compiles once.  The results must
 * stay identical to the interpreter for NULL operands, wide products and mixed literals; a
 * right-hand side that can fail (division) must still be skipped for a NULL left operand.
 */

drop table if exists t1;
create table t1 (id int, ep numeric(15,2), disc numeric(15,2), tax numeric(15,2), big numeric(38,0), z numeric(15,2));
insert into t1 values (1, 100.00, 0.10, 0.05, 99999999999999999999999999999999999999, 0);
insert into t1 values (2, NULL, 0.20, 0.06, 99999999999999999999999999999999999999, 0);
insert into t1 values (3, 300.00, NULL, 0.07, NULL, 0);
insert into t1 values (4, 400.00, 0.40, NULL, -99999999999999999999999999999999999999, 0);
select id, ep * (1 - disc), ep * (1 - disc) * (1 + tax) from t1 order by id;
select sum(ep * (1 - disc)), sum(ep * (1 - disc) * (1 + tax)), avg(ep * (1 - disc)) from t1;
select id, ep * (1 - disc) from t1 where ep is null;
select id, ep + big * big, ep - big * big from t1 order by id;
select id, big * big * big from t1 order by id;
select id, ep + (1 - disc) / z from t1 where id = 2;
select id, ep * (1.5 - disc) + (2 * tax) from t1 order by id;
select id, (ep - 0.5) * (disc + 1.25) - (tax * 3) from t1 order by id;
select id, ep * (1 - disc) from t1 where ep * (1 - disc) > 80 order by id;
select sum(ep * (1 - disc)) from t1 group by id > 2 order by 1;
drop table t1;

-- ======== not_between_share ========
/**
 * CBRD-27215 (PR #7658 review, 2026-09-22): NOT BETWEEN compiles to NOT (a >= lo AND a <= hi)
 * after CNF, and the AND chain under the NOT stops at its first FALSE -- which is exactly the
 * accepting case.  So the upper bound's arithmetic (c*2) has not run for an accepted row and
 * must not be shared with the projection or the aggregates; before the fix the first accepted
 * row printed NULL and the next one the previous row's c*2 (SUM 40 instead of 54).
 */
drop table if exists nb;
create table nb (a int, b int, c int, n int);
insert into nb values (1, 5, 10, 1), (100, 1, 7, 1), (3, 9, 4, 1), (50, 2, 6, 1);

select a, c, c * 2 from nb where a not between b * 2 and c * 2 order by a;
select sum (c * 2) from nb where a not between b * 2 and c * 2;
select a, c * 2 from nb where a not between b * 2 and c * 2 and n > 0 order by a;
select a, b * 2 from nb where a not between b * 2 and c * 2 order by a;
-- the compared expression itself is on every leaf's left side and always runs
select c * 2 from nb where c * 2 not between a and b order by 1;
-- the hand-written forms lose the NOT in CNF and were right before too
select a, c * 2 from nb where not (a >= b * 2 and a <= c * 2) order by a;
select a, c * 2 from nb where a < b * 2 or a > c * 2 order by a;
-- a single NOT term over a comparison: its operands always run when the row is accepted
select a, c * 2 from nb where not (c * 2 > 100) order by a;
select c * 2, count (*) from nb where a not between b * 2 and c * 2 group by c * 2 order by 1;

drop table nb;

-- ======== share_cell ========
/**
 * CBRD-27215 (PR #7658) on top of CBRD-27178 (#7763): SUM and AVG share one accumulator not only when their
 * operand regu trees are equal (develop) but also when the compiled operand program resolves both operands
 * to the same cell -- commuted operands (a + b / b + a, n * m / m * n), literals equal by value, common
 * sub-expressions (two distinct host variables stay distinct cells even when bound alike).  Results must equal
 * the interpreter's on every
 * path: BUILDVALUE, filtered BUILDVALUE, hash GROUP BY, sort GROUP BY, prepared statements re-executed with
 * the same and with different bind types (the program is recompiled and the links re-derived).
 */
create table sc (a int, b int, n numeric(10,2), m numeric(10,2), g int);
insert into sc values (1, 2, 1.50, 2.50, 1), (3, 4, 3.50, 4.50, 1), (NULL, 5, NULL, 5.50, 2), (7, NULL, 7.75, NULL, 2), (-2, 9, -2.25, 9.00, 1);
select sum(a + b), avg(b + a), sum(n * m), avg(m * n), count(*) from sc;
select sum(n * (1 - m)), avg(n * (1 - m)), sum((1 - m) * n) from sc;
select sum(a + b), avg(a + b), sum(b + a) from sc where g = 1;
select g, sum(a + b), avg(b + a), sum(n * m), avg(m * n) from sc group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(a + b), avg(b + a) from sc group by g order by g;
prepare p from 'select sum(a + ?), avg(? + a), sum(n * ?), avg(? * n) from sc';
execute p using 1, 1, 2, 2;
execute p using 1, 1, 2, 2;
execute p using 1.5, 1.5, 2.5, 2.5;
execute p using 1, 1, 2, 2;
deallocate prepare p;
drop table sc;

-- ======== type_guard ========
/**
 * CBRD-27215 (PR #7658 review): typed comparison leaves, EXTRACT and NUMERIC kernels verify the runtime
 * value type and fall back when the domain and the value disagree (recursive CTE type drift).
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');
with recursive r(n, m) as (select 1, 1 from db_root union all select n + 1, m * 2147483647 from r where n < 3) select n, m, case when m > 100 then 'big' else 'small' end, extract(year from date'2024-01-01') from r;
with recursive r(n) as (select cast(1 as bigint) from db_root union all select n * 1000000007 from r where n < 1000000000000000) select n, n = 1000000007, n > 5 from r;
select id, extract(year from dt), extract(month from dt), extract(day from dt) from t1 order by id;
select sum(case when bi > 5500000000 then 1 else 0 end), sum(case when d > 2.0 then 1 else 0 end) from t1;
-- the scan filter reads a TYPE_CONSTANT whose run-time value changes type: the anchor is INTEGER
-- and the recursive step turns it into BIGINT, so a leaf compiled for INTEGER must not trust the
-- domain. Anchoring the CTE as BIGINT from the start would not reproduce the change.
with recursive rc(n) as (select 1 from db_root union all select (select count(*) from t1 where id <= rc.n) + rc.n from rc where n < 5) select * from rc;
with recursive rc(n) as (select 1 from db_root union all select (select count(*) from t1 where id <= rc.n) * 4294967296 + rc.n from rc where n < 3) select n, n > 1000000000 from rc;
drop table t1;

-- ======== tpldesc_retry ========

DROP TABLE IF EXISTS t27215_r;
CREATE TABLE t27215_r (k INT PRIMARY KEY, s VARCHAR(20000));
INSERT INTO t27215_r VALUES (1, 'a'), (2, REPEAT('x', 17000)), (3, 'c'), (4, REPEAT('y', 17000)), (5, 'e');

-- 1. SET column: every row leaves the descriptor path with RETRY_SET_TYPE (query_executor.c:1201 -> :1285)
SELECT k * 2 + 1 AS a, {k, k + 1} AS st FROM t27215_r ORDER BY k;

-- 2. oversized rows 2 and 4 take RETRY_BIG_REC through the sorted GROUP BY output list
--    (qexec_gby_finalize_group, query_executor.c:20300 -> :20333) while rows 1, 3, 5 stay on the descriptor path
SELECT a, len FROM (SELECT k * 2 + 1 AS a, LENGTH(s) AS len, s FROM t27215_r GROUP BY k, s) v ORDER BY a;

-- 3. CONNECT BY interleaves a direct copy of xasl->outptr_list (query_executor.c:19748) with the
--    descriptor+copy pair (:19769 -> qexec_insert_tuple_into_list) on the same list, row after row
SELECT k * 2 + 1 AS a, {k, LEVEL} AS st FROM t27215_r START WITH k = 1 CONNECT BY PRIOR k + 1 = k ORDER BY k;

-- 4. the same statement twice: the mark must not survive into a later execution of the cached clone
SELECT k * 2 + 1 AS a, {k, k + 1} AS st FROM t27215_r WHERE k >= 4 ORDER BY k;
SELECT k * 2 + 1 AS a, {k, k + 1} AS st FROM t27215_r WHERE k >= 4 ORDER BY k;

DROP TABLE t27215_r;

-- ======== proj_shared_root ========
/**
 * CBRD-27215 (PR #7658 follow-up): an output column that CSE resolves entirely to an earlier
 * column's chain ("(a+1)*b" after "(a+1)*b+1") must stay on the compiled program and read the
 * shared cell; a repeated literal and a repeated sub-expression are computed once per row.
 * Results must be identical to the interpreter, NULLs and hidden ORDER BY columns included.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, n numeric(10,2), s varchar(10));
insert into t1 values (1, 1, 2, 1.50, 'x'), (2, 3, 4, 2.25, 'y'), (3, NULL, 5, 3.00, NULL), (4, 7, NULL, NULL, 'z');
select id, a+1, (a+4)*b+1, b+1 from t1 order by id;
select id, a+1, (a+1)*b+1, b+1, (a+1)*b from t1 order by id;
select id, (a+1)*b, a+1, (a+1)*b+1 from t1 order by id;
select id, n*2, n*2+1, (n*2)*(n*2), n*2 from t1 order by id;
select id, a+b, a+b, (a+b)*(a+b), nvl(a, b)+1, nvl(a, b) from t1 order by id;
select id, case when a > 1 then a+1 else b+1 end, a+1, b+1 from t1 order by id;
select id, a+1, s, a+1 || s from t1 order by id;
select (a+1)*b from t1 order by (a+1)*b+1;
select a+1, (a+1)*b from t1 where (a+1)*b > 5 order by 1;
drop table t1;

-- ======== collate ========
/**
 * CBRD-27215 (PR #7658 review): a node flagged REGU_VARIABLE_APPLY_COLLATION (COLLATE modifier) is not
 * compiled; the interpreter re-labels the value's collation instead of casting it.
 */

drop table if exists t1;
create table t1 (id int, a int, b int, c int, n1 numeric(15,2), bi bigint, d double, s varchar(20), dt date);
insert into t1 values (1, NULL, 1, 0, 100000003.89, 5000000000, 1.5, 'abc', date'2024-01-15');
insert into t1 values (2, 1, 2, 0, 100000003.89, 6000000000, 2.5, 'ABC', date'2023-12-31');
insert into t1 values (3, 2, 3, 1, 0.01, 7000000000, 3.5, 'abd', NULL);
insert into t1 values (4, 0, 5, 0, 1.00, 8000000000, 4.5, 'xyz', date'2025-06-30');
select id, case when s = 'abc' collate utf8_bin then 1 else 0 end from t1 order by id;
select max(s collate utf8_bin), min(s collate utf8_bin) from t1;
select cast(s as varchar(5)) collate utf8_bin from t1 order by id;
select id, nvl(s, 'zzz') collate utf8_bin from t1 order by id;
select id, s collate utf8_bin || 'x' from t1 order by id;
select count(*) from t1 where s collate utf8_bin = 'abc';
select id, if(s collate utf8_bin = 'abc', 'y', 'n') from t1 order by id;
drop table t1;

-- ======== numeric_sum_rounding ========
/**
 * CBRD-27215 (PR #7658) with CBRD-27178 (#7763) and the CBRD-27408 rule: NUMERIC SUM/AVG accumulate in the
 * resident word accumulator (SUM_ACC) and, when the running sum reaches 41 digits, round that row exactly
 * like binary addition does, so SUM(n) equals the same values added with +.  The values are therefore the
 * legacy per-row rounding results:
 *   3036 x (10^38 - 1) -> 303599999999999999999999999999999999999900   (exact 303599999999999999999999999999999999996964)
 *   2024 x (10^38 - 1) -> 202399999999999999999999999999999999999900
 *   1012 x (10^38 - 1) -> 101199999999999999999999999999999999999900
 * The same values must come from the serial path, the hash GROUP BY, the sort GROUP BY, the filtered path and
 * the parallel BUILDVALUE_OPT path (compiled operand cells feed the same accumulator).
 * History: review round 2 T6 first kept the once-rounded sum (...7000); superseded 2026-09-11 to match + (CBRD-27408).
 */
drop table if exists nn;
create table nn (n numeric(38,0), g int default 1);
insert into nn (n) select cast('99999999999999999999999999999999999999' as numeric(38,0)) from db_class a, db_class b, db_class c limit 3036;
update nn set g = 2 where rownum % 3 = 0;
select sum(n), avg(n), count(*) from nn;
select g, sum(n), avg(n) from nn group by g order by g;
select /*+ NO_HASH_AGGREGATE */ g, sum(n) from nn group by g order by g;
select sum(n) from nn where n > 0;
drop table nn;
