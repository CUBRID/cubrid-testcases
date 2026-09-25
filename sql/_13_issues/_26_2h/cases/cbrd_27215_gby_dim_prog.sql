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