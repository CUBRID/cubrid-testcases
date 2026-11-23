/*
 * This test case verifies CBRD-27192 : the index scan cost floored a MEASURED
 * key range selectivity at the index's average key share (1/pkeys).
 *
 * Bug: qo_iscan_cost () raises the key range selectivity to
 * sel = MAX (sel, 1/pkeys[n]) before pricing the scan. That floor is the
 * average share of one key, taken from the index NDV, it predates the column
 * histograms and stood in for selectivities the optimizer could not measure.
 * Once a term's selectivity IS measured from the histogram (CBRD-26936 /
 * CBRD-26746), the floor overwrote the measurement with the average: an
 * equality on a rare value of a skewed low-NDV column (a = 7, 10 of 10,000 rows,
 * NDV 3) was priced as 1/3 of the table while its cardinality kept the measured
 * 10 rows. The optimal index therefore lost to a competing index, or to the
 * sequential scan, that reads orders of magnitude more rows.
 * Fix: when every key range term of the scan is a search condition whose
 * selectivity came from the histogram with no fallback
 * (QO_TERM_SEL_FROM_HISTOGRAM, qo_iscan_terms_all_measured ()), the floor is
 * one row (1/NCARD) instead of 1/pkeys. Join terms, default guesses, fallback
 * selectivities and histogram-less tables keep the 1/pkeys floor.
 *
 * Fixture (the JIRA reproduction scaled from 100k to 10k rows): t_floor has
 * 10,000 rows, a = 7 on 10 rows, a = 5 on 1,000 rows, a = 1 on 8,990 rows,
 * b = 0..9999 (unique), pad not indexed. Single-column indexes ix_floor_a and
 * ix_floor_b ONLY -- a composite (a,b) index would make pkeys large and hide the
 * effect. With 10,000 rows the reservoir keeps every row, so a's three values
 * are exact MCVs (a = 7 -> 0.001) and "b < 500" is ~5%. t_floor_nh holds the
 * same data and indexes but its statistics are collected WITH NO HISTOGRAM.
 *   Case 1: "a = 7 and b < 500" -> iscan ix_floor_a (10 rows). Under the bug
 *           ix_floor_a was priced at 1/3 of the table and ix_floor_b (5%) won.
 *   Case 2: "a = 7" alone -> iscan ix_floor_a. Under the bug 1/3 of the table
 *           through the index lost to the sequential scan.
 *   Case 3: "a = 9 and b < 500" (value absent from the histogram, measured 0)
 *           -> iscan ix_floor_a: the one-row floor still prices it as a probe.
 *   Case 4: controls that keep their plan: "a = 1 and b < 500" (a = 1 is 90%)
 *           and "a = 5 and b < 500" (10% vs 5%) must NOT use ix_floor_a.
 *   Case 5: histogram-less twin t_floor_nh, "a = 7 and b < 500": no measured
 *           term, the 1/pkeys floor stays, and the plan must NOT use
 *           ix_floor_nh_a (the JIRA shows ix_b).
 * Every query returns its count so the answer is self-checking.
 */
drop table if exists t_floor, t_floor_nh;

create table t_floor (a int, b int, pad varchar(100));
insert into t_floor
select case when level <= 10 then 7 when level <= 1010 then 5 else 1 end, level - 1, lpad ('x', 100, 'x')
from db_root connect by level <= 10000;
create index ix_floor_a on t_floor (a);
create index ix_floor_b on t_floor (b);

create table t_floor_nh (a int, b int, pad varchar(100));
insert into t_floor_nh select a, b, pad from t_floor;
create index ix_floor_nh_a on t_floor_nh (a);
create index ix_floor_nh_b on t_floor_nh (b);

update statistics on t_floor with fullscan;
update statistics on t_floor_nh with fullscan, no histogram;

select a, count(*) from t_floor group by a order by a;
select count(*) from t_floor where b < 500;

evaluate '[1] a = 7 and b < 500 -> iscan ix_floor_a (10 rows), not ix_floor_b';
--@queryplan
select /*+ recompile */ count(pad) from t_floor where a = 7 and b < 500;

evaluate '[2] a = 7 alone -> iscan ix_floor_a, not sscan';
--@queryplan
select /*+ recompile */ count(pad) from t_floor where a = 7;

evaluate '[3] a = 9 (not in the histogram) and b < 500 -> iscan ix_floor_a (one-row floor)';
--@queryplan
select /*+ recompile */ count(pad) from t_floor where a = 9 and b < 500;

evaluate '[4] controls: a = 1 (90%) and a = 5 (10%) with b < 500 must not use ix_floor_a';
--@queryplan
select /*+ recompile */ count(pad) from t_floor where a = 1 and b < 500;
--@queryplan
select /*+ recompile */ count(pad) from t_floor where a = 5 and b < 500;

evaluate '[5] histogram-less twin keeps the 1/pkeys floor: a = 7 and b < 500 must not use ix_floor_nh_a';
--@queryplan
select /*+ recompile */ count(pad) from t_floor_nh where a = 7 and b < 500;

drop table t_floor, t_floor_nh;
