/*
 * This test case verifies CBRD-27425 : the per-row std::vector<DB_VALUE>
 * heap allocation was removed from the aggregate evaluation loop.
 *
 * qdata_evaluate_aggregate_list() (query_aggregate.cpp) is called for every
 * input tuple and used to build a local std::vector<DB_VALUE> per aggregate
 * function to hold the operand values, i.e. one operator new / delete per row
 * and per aggregate. The change replaces the vector by a fixed two-slot
 * DB_VALUE array (AGG_MAX_OPERANDS = 2: every aggregate has one operand,
 * JSON_OBJECTAGG two, GROUP_CONCAT's separator lives in accumulator.value2)
 * and a cleanup helper, and changes the signature of
 * qdata_aggregate_multiple_values_to_accumulator(). No branch or eligibility
 * gate was added: every aggregate still runs through the same code with a
 * different operand container, so the only possible regression is a wrong,
 * leaked or double-cleared operand value in some aggregate kind. This case
 * therefore evaluates many aggregate kinds in one SELECT - counting, sum /
 * average, min / max, the six STDDEV / VARIANCE variants, BIT_AND / OR / XOR,
 * DISTINCT variants, GROUP_CONCAT with ORDER BY and SEPARATOR, MEDIAN,
 * PERCENTILE_CONT / DISC, JSON_ARRAYAGG - over integer, numeric, bigint and
 * string operands with NULL-heavy and all-NULL columns, with GROUP BY, as a
 * single ungrouped row (buildvalue), and over an empty input.
 *
 * Each grouped query runs twice: with the PARALLEL(1) hint (serial, one
 * accumulator per aggregate) and with the automatic degree (the table has
 * about 160 heap pages, above the 32-page test_mode scan threshold, so the
 * heap is scanned by workers whose per-worker accumulators are merged). The
 * two outputs must be identical and equal the values derived from the data
 * definition. Doubles are rounded to 4 decimals, the sums behind STDDEV /
 * VARIANCE are exact integers below 2^53, so the merge order cannot change
 * the rounded result.
 *
 * Data: 20,000 rows, id = 1..20000, grp = id mod 20 (20 groups x 1,000),
 *       i = NULL when id mod 7 = 0, else id mod 101,
 *       n = id / 100 as numeric(12,2),
 *       s = NULL when id mod 5 = 0, else 's' || two-digit (id mod 37),
 *       b = id * 1000003 (bigint), nul = always NULL. Group 0 holds the ids
 *       divisible by 20, so every s of that group is NULL and MIN / MAX /
 *       GROUP_CONCAT of s are NULL there (an all-NULL string group).
 *
 *   Case 1: counting, SUM, AVG, MIN, MAX and their DISTINCT variants on i
 *   Case 2: STDDEV / VARIANCE (default, _POP, _SAMP) and BIT_AND / OR / XOR on i
 *   Case 3: string, numeric and bigint operands incl. GROUP_CONCAT DISTINCT
 *   Case 4: all-NULL column, MEDIAN, PERCENTILE_CONT / DISC, JSON_ARRAYAGG
 *   Case 5: ungrouped single row (buildvalue path) with CASE operands
 *   Case 6: empty input
 */

drop table if exists agg_t;

create table agg_t (id int, grp int, i int, n numeric(12,2), s varchar(20), b bigint, nul int, pad char(100));

insert into agg_t
  select rownum, mod(rownum, 20),
         case when mod(rownum, 7) = 0 then null else mod(rownum, 101) end,
         rownum / 100.0,
         case when mod(rownum, 5) = 0 then null else concat('s', lpad(mod(rownum, 37), 2, '0')) end,
         cast(rownum as bigint) * 1000003,
         null,
         lpad('x', 100, 'x')
  from db_class a, db_class b, db_class c, db_class d limit 20000;

select count(*), count(i), count(s), count(nul), count(distinct grp) from agg_t;

-- Case 1: counting, SUM, AVG, MIN, MAX and DISTINCT variants on the NULL-heavy int column
evaluate '[1] COUNT / SUM / AVG / MIN / MAX and DISTINCT variants per group: serial reference';
select /*+ PARALLEL(1) */ grp, count(*) cnt, count(i) cnt_i, count(distinct i) cntd_i, sum(i) sum_i, sum(distinct i) sumd_i,
       round(avg(i), 4) avg_i, round(avg(distinct i), 4) avgd_i, min(i) min_i, max(i) max_i
  from agg_t group by grp order by grp;

evaluate '[1] COUNT / SUM / AVG / MIN / MAX and DISTINCT variants per group: parallel';
select grp, count(*) cnt, count(i) cnt_i, count(distinct i) cntd_i, sum(i) sum_i, sum(distinct i) sumd_i,
       round(avg(i), 4) avg_i, round(avg(distinct i), 4) avgd_i, min(i) min_i, max(i) max_i
  from agg_t group by grp order by grp;

-- Case 2: STDDEV / VARIANCE family and BIT_AND / BIT_OR / BIT_XOR
evaluate '[2] STDDEV / VARIANCE family and BIT_AND / BIT_OR / BIT_XOR per group: serial reference';
select /*+ PARALLEL(1) */ grp, round(stddev(i), 4) sd, round(variance(i), 4) var, round(stddev_pop(i), 4) sd_pop, round(var_pop(i), 4) var_pop,
       round(stddev_samp(i), 4) sd_samp, round(var_samp(i), 4) var_samp, bit_and(i) band, bit_or(i) bor, bit_xor(i) bxor
  from agg_t group by grp order by grp;

evaluate '[2] STDDEV / VARIANCE family and BIT_AND / BIT_OR / BIT_XOR per group: parallel';
select grp, round(stddev(i), 4) sd, round(variance(i), 4) var, round(stddev_pop(i), 4) sd_pop, round(var_pop(i), 4) var_pop,
       round(stddev_samp(i), 4) sd_samp, round(var_samp(i), 4) var_samp, bit_and(i) band, bit_or(i) bor, bit_xor(i) bxor
  from agg_t group by grp order by grp;

-- Case 3: string, numeric and bigint operands, GROUP_CONCAT DISTINCT with ORDER BY and SEPARATOR
evaluate '[3] string / numeric / bigint operands and GROUP_CONCAT per group: serial reference';
select /*+ PARALLEL(1) */ grp, count(s) cnt_s, count(distinct s) cntd_s, min(s) min_s, max(s) max_s,
       group_concat(distinct s order by s separator '|') gc_s,
       sum(n) sum_n, round(avg(n), 4) avg_n, min(n) min_n, max(n) max_n, sum(b) sum_b, min(b) min_b, max(b) max_b
  from agg_t group by grp order by grp;

evaluate '[3] string / numeric / bigint operands and GROUP_CONCAT per group: parallel';
select grp, count(s) cnt_s, count(distinct s) cntd_s, min(s) min_s, max(s) max_s,
       group_concat(distinct s order by s separator '|') gc_s,
       sum(n) sum_n, round(avg(n), 4) avg_n, min(n) min_n, max(n) max_n, sum(b) sum_b, min(b) min_b, max(b) max_b
  from agg_t group by grp order by grp;

-- Case 4: all-NULL column, MEDIAN, PERCENTILE_CONT / PERCENTILE_DISC, JSON_ARRAYAGG (NULLs kept as JSON null)
evaluate '[4] all-NULL column, MEDIAN, PERCENTILE_CONT / DISC, JSON_ARRAYAGG per group: serial reference';
select /*+ PARALLEL(1) */ grp, count(nul) cnt_nul, count(distinct nul) cntd_nul, sum(nul) sum_nul, avg(nul) avg_nul, min(nul) min_nul, max(nul) max_nul,
       stddev(nul) sd_nul, median(i) med_i,
       percentile_cont(0.5) within group (order by i) pc_i, percentile_disc(0.5) within group (order by i) pd_i,
       json_length(json_arrayagg(i)) ja_len
  from agg_t group by grp order by grp;

evaluate '[4] all-NULL column, MEDIAN, PERCENTILE_CONT / DISC, JSON_ARRAYAGG per group: parallel';
select grp, count(nul) cnt_nul, count(distinct nul) cntd_nul, sum(nul) sum_nul, avg(nul) avg_nul, min(nul) min_nul, max(nul) max_nul,
       stddev(nul) sd_nul, median(i) med_i,
       percentile_cont(0.5) within group (order by i) pc_i, percentile_disc(0.5) within group (order by i) pd_i,
       json_length(json_arrayagg(i)) ja_len
  from agg_t group by grp order by grp;

-- Case 5: ungrouped single row (buildvalue path), CASE operands
evaluate '[5] ungrouped aggregates over the whole table: serial reference / parallel';
select /*+ PARALLEL(1) */ count(*) cnt, count(i) cnt_i, sum(i) sum_i, round(avg(i), 4) avg_i, min(i) min_i, max(i) max_i,
       count(distinct i) cntd_i, sum(distinct i) sumd_i, round(stddev(i), 4) sd_i, round(var_samp(i), 4) vs_i,
       count(case when i > 50 then 1 end) cnt_gt50, sum(case when i > 50 then i else 0 end) sum_gt50,
       min(s) min_s, max(s) max_s, count(distinct s) cntd_s, sum(n) sum_n, max(b) max_b
  from agg_t;
select count(*) cnt, count(i) cnt_i, sum(i) sum_i, round(avg(i), 4) avg_i, min(i) min_i, max(i) max_i,
       count(distinct i) cntd_i, sum(distinct i) sumd_i, round(stddev(i), 4) sd_i, round(var_samp(i), 4) vs_i,
       count(case when i > 50 then 1 end) cnt_gt50, sum(case when i > 50 then i else 0 end) sum_gt50,
       min(s) min_s, max(s) max_s, count(distinct s) cntd_s, sum(n) sum_n, max(b) max_b
  from agg_t;

-- Case 6: empty input
evaluate '[6] aggregates over an empty input';
select count(*) cnt, count(i) cnt_i, sum(i) sum_i, avg(i) avg_i, min(i) min_i, max(i) max_i, stddev(i) sd_i, var_samp(i) vs_i,
       count(distinct i) cntd_i, group_concat(s) gc_s, median(i) med_i, json_arrayagg(i) ja_i
  from agg_t where id < 0;

drop table agg_t;
