/*
 * This test case verifies CBRD-27274 : histogram range selectivity counted a
 * bucket's equality mass as "less than".
 *
 * Bug: comp_parts () in histogram_cl.cpp returned ONE non-MCV bucket share and
 * documented it as "< v", but computed "<= v": when the probe value is a bucket's
 * stored endpoint (a value that exists in the data) the whole bucket -- the
 * endpoint's own rows included -- was attributed to the strictly-less side.
 * Only the MCV share was split into lt/le. So for a probe that is NOT an MCV
 * but IS a bucket endpoint, "col >= v" (= 1 - P(col < v)) lost the rows equal
 * to v and "col < v" gained them, ">=" came out equal to ">" and "<" equal to
 * "<=". The column whose rows all carry one value shows it completely: such a
 * value is rejected as an MCV by the sampling criterion and becomes the single
 * bucket's endpoint, so the whole table sat on the "<" side -- "col >= v" was
 * estimated at ~0 rows and "col < v" (which matches nothing) at every row.
 * Fix: comp_parts () returns the "<" and "<=" shares separately, the "<" share
 * removes the endpoint's rows (bucket rows / bucket distinct count), exact for a
 * single-value bucket.
 *
 * This is NOT the CBRD-27039 operator-direction defect (there the flags of a
 * reversed 'const OP attr' were inverted, the MCV path priced boundaries
 * correctly). Here the operator is written normally and the error is in which
 * side of the boundary a non-MCV bucket endpoint's rows land on.
 *
 * Fixture: t_eq has 12,000 rows, c = 7 and s = '1' on EVERY row, indexes ix_eq_c
 * and ix_eq_s. The statistics are collected WITH 1 BUCKETS: the row reservoir
 * is then 10,000 rows (< 12,000), so the MCV criterion runs (a column that was
 * sampled completely keeps every value as an MCV, which would hide the bucket
 * path) and the lone value fails it (its share is not above the 1/NDV = 1.0 it
 * would get as a non-MCV value) -> no MCV, one bucket with endpoint 7 (resp.
 * '1'), distinct count 1. Since CBRD-27192 a measured index selectivity is
 * floored at one row, not 1/pkeys, so the misestimate is visible as a plan:
 * a ~0 estimate picks the index scan, a ~1.0 estimate the sequential scan.
 * count(pad) (pad not indexed) keeps the index from covering the query.
 *   Case 1: "c >= 7" matches all 12,000 rows -> sscan (bug: estimated ~0, iscan)
 *   Case 2: "c < 7" matches 0 rows -> iscan ix_eq_c (bug: estimated 1.0, sscan)
 *   Case 3: "c between 7 and 7" matches all rows -> sscan (bug: ~0, iscan)
 *   Case 4: controls that did not change: "c > 7" (0 rows) -> iscan,
 *           "c <= 7" (all) -> sscan, "c = 7" (all) -> sscan
 *   Case 5: the same on the string column: "s >= '1'" -> sscan, "s < '1'" ->
 *           iscan ix_eq_s (the original report and the cbrd_24044/cbrd_24874
 *           plan flips were string columns)
 *   Case 6: a table that has sampled completely keeps the value as an MCV and
 *           prices the boundary through the MCV path: t_eq_small (5,000 rows,
 *           c = 7) -> "c >= 7" sscan and "c < 7" iscan both before and after
 *           the fix. Guards the fixture assumption of cases 1-5.
 */
drop table if exists t_eq, t_eq_small;

create table t_eq (c int, s varchar(10), pad varchar(100));
insert into t_eq select 7, '1', lpad ('x', 100, 'x') from db_root connect by level <= 12000;
create index ix_eq_c on t_eq (c);
create index ix_eq_s on t_eq (s);

create table t_eq_small (c int, pad varchar(100));
insert into t_eq_small select 7, lpad ('x', 100, 'x') from db_root connect by level <= 5000;
create index ix_eq_small_c on t_eq_small (c);

-- 1 bucket: 10,000-row reservoir < 12,000 rows, so the MCV criterion runs and
-- rejects the single value, it becomes the single bucket's endpoint.
update statistics on t_eq with fullscan, 1 buckets;
update statistics on t_eq_small with fullscan, 1 buckets;

select count(*), count(distinct c), count(distinct s) from t_eq;
select count(*), count(distinct c) from t_eq_small;

evaluate '[1] c >= 7 matches every row -> sscan';
--@queryplan
select /*+ recompile */ count(pad) from t_eq where c >= 7;

evaluate '[2] c < 7 matches no row -> iscan ix_eq_c';
--@queryplan
select /*+ recompile */ count(pad) from t_eq where c < 7;

evaluate '[3] c between 7 and 7 matches every row -> sscan';
--@queryplan
select /*+ recompile */ count(pad) from t_eq where c between 7 and 7;

evaluate '[4] controls: c > 7 -> iscan, c <= 7 -> sscan, c = 7 -> sscan';
--@queryplan
select /*+ recompile */ count(pad) from t_eq where c > 7;
--@queryplan
select /*+ recompile */ count(pad) from t_eq where c <= 7;
--@queryplan
select /*+ recompile */ count(pad) from t_eq where c = 7;

evaluate '[5] string column: s >= ''1'' -> sscan, s < ''1'' -> iscan ix_eq_s';
--@queryplan
select /*+ recompile */ count(pad) from t_eq where s >= '1';
--@queryplan
select /*+ recompile */ count(pad) from t_eq where s < '1';

evaluate '[6] fully sampled table keeps the value as an MCV: c >= 7 -> sscan, c < 7 -> iscan (unchanged by the fix)';
--@queryplan
select /*+ recompile */ count(pad) from t_eq_small where c >= 7;
--@queryplan
select /*+ recompile */ count(pad) from t_eq_small where c < 7;

drop table t_eq, t_eq_small;
