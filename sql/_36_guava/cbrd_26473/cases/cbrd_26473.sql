/**
 *  This test case verifies CBRD-26473 : Skip sorting for analytic functions when index order matches.
 *
 *  An analytic function sorts its input by OVER (PARTITION BY ..., ORDER BY ...)
 *  before it is evaluated. When an index scan already delivers rows in a
 *  compatible order, the engine reorders the index-compatible analytic functions
 *  to run first and skips (or reduces) their sort. Each analytic sort group is
 *  reported in the query trace as "sort: skip" (order provided by the index) or
 *  "sort: true" (a sort was still required); the ANALYTIC #N lines were also
 *  newly added to the trace output by this change, and are emitted once per
 *  distinct sort group (analytics that share a sort key are merged into one #N).
 *
 *  These are trace cases: the feature is asserted from the "show trace" output,
 *  so the scans are pinned with USING INDEX (+) / hints. No outer ORDER BY is
 *  used - an outer sort becomes the top plan node and suppresses the analytic
 *  sort-skip being tested (verified: adding one flips every "sort: skip" to
 *  "sort: true"). Determinism instead comes from the forced index scan order and
 *  the deterministic fresh CTP load: single-analytic results follow the index
 *  stream; multi-analytic results follow the engine's final sort order, whose
 *  trailing column is unique (id in sections 1-4, c4 in section 5). Section 6's
 *  row_number ties within a partition (all rows
 *  share the full index key) are broken by the deterministic load. Volatile
 *  trace counters (time, page, ioread, fetch) are masked to '?' by the CTP
 *  trace normalizer.
 *
 *  Coverage (each analytic in sections 1-4 is checked in four scenarios:
 *  single-analytic skip, two analytics with the index-compatible one written
 *  first, the same two written in reverse to prove execution-order is swapped,
 *  and a DESC/incompatible order that still requires a sort):
 *    1. NTILE
 *    2. Interpolation functions - MEDIAN, PERCENTILE_CONT, PERCENTILE_DISC
 *    3. Ranking family - ROW_NUMBER, RANK, DENSE_RANK
 *    4. Aggregate / navigation / distribution - AVG, COUNT, CUME_DIST,
 *       FIRST_VALUE, LAG, LAST_VALUE, LEAD, MAX, MIN, NTH_VALUE, PERCENT_RANK,
 *       STDDEV_POP, STDDEV_SAMP, SUM, VAR_POP, VAR_SAMP
 *       plus one case where the index-compatible-but-unskippable (DESC) analytic
 *       is written SECOND, so the execution-order promotion is observable in the
 *       final row order rather than being a no-op
 *    5. Sort-group merging - analytics sharing a sort key collapse into a single
 *       ANALYTIC #N group (trace prints per sort group, not per function)
 *    6. Index edge cases - partition on leading index columns, ORDER BY on a
 *       non-index column, ORDER BY on a function-based index column, and
 *       descending index scan (use_desc_idx)
 */

drop table if exists test_table;
create table test_table (id int auto_increment, name varchar, val int, primary key (id));
create index midx_01 on test_table (val, id);

-- 1000 deterministic, environment-independent rows: id = 1..1000, val = id % 10.
insert into test_table (name, val)
with recursive cte (n) as (
  select 1
  union all
  select n + 1 from cte where n < 1000
)
select 'name_' || n, n % 10 from cte;

set trace on;

--
-- 1. NTILE
--
evaluate '001. NTILE single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ ntile(5) over (partition by val order by id) as ntile_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '002. NTILE two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  ntile(5) over (partition by val order by id) as ntile_1,
  ntile(5) over (partition by id order by val) as ntile_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '003. NTILE two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  ntile(5) over (partition by id order by val) as ntile_2,
  ntile(5) over (partition by val order by id) as ntile_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '004. NTILE conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  ntile(5) over (partition by val order by id desc) as ntile_1,
  ntile(5) over (partition by id order by val) as ntile_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

--
-- 2. Interpolation functions (MEDIAN, PERCENTILE_CONT, PERCENTILE_DISC)
--
evaluate '005. MEDIAN single analytic - OVER(partition by val) covered by midx_01 leading column, sort skipped';
select /*+ recompile */ median(id) over (partition by val) as md_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '006. MEDIAN two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  median(id) over (partition by val) as md_1,
  median(val) over (partition by id) as md_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '007. MEDIAN two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  median(val) over (partition by id) as md_2,
  median(id) over (partition by val) as md_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '008. MEDIAN partition column not in the index (val, name) - sort required';
select /*+ recompile */ id, val,
  median(id) over (partition by val, name) as md_1,
  median(val) over (partition by id) as md_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '009. PERCENTILE_CONT single analytic - within group(order by id) over(partition by val) covered by midx_01, sort skipped';
select /*+ recompile */ percentile_cont(0.5) within group (order by id) over (partition by val) as pc_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '010. PERCENTILE_CONT two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  percentile_cont(0.5) within group (order by id) over (partition by val) as pc_1,
  percentile_cont(0.5) within group (order by val) over (partition by id) as pc_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '011. PERCENTILE_CONT two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  percentile_cont(0.5) within group (order by val) over (partition by id) as pc_2,
  percentile_cont(0.5) within group (order by id) over (partition by val) as pc_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '012. PERCENTILE_CONT conflicting DESC order (order by id desc) - sort required';
select /*+ recompile */ id, val,
  percentile_cont(0.5) within group (order by id desc) over (partition by val) as pc_1,
  percentile_cont(0.5) within group (order by val) over (partition by id) as pc_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '013. PERCENTILE_DISC single analytic - within group(order by id) over(partition by val) covered by midx_01, sort skipped';
select /*+ recompile */ percentile_disc(0.5) within group (order by id) over (partition by val) as pd_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '014. PERCENTILE_DISC two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  percentile_disc(0.5) within group (order by id) over (partition by val) as pd_1,
  percentile_disc(0.5) within group (order by val) over (partition by id) as pd_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '015. PERCENTILE_DISC two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  percentile_disc(0.5) within group (order by val) over (partition by id) as pd_2,
  percentile_disc(0.5) within group (order by id) over (partition by val) as pd_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '016. PERCENTILE_DISC conflicting DESC order (order by id desc) - sort required';
select /*+ recompile */ id, val,
  percentile_disc(0.5) within group (order by id desc) over (partition by val) as pd_1,
  percentile_disc(0.5) within group (order by val) over (partition by id) as pd_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

--
-- 3. Ranking family (ROW_NUMBER, RANK, DENSE_RANK)
--
evaluate '017. ROW_NUMBER single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ row_number() over (partition by val order by id) as rn_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '018. ROW_NUMBER two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  row_number() over (partition by val order by id) as rn_1,
  row_number() over (partition by id order by val) as rn_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '019. ROW_NUMBER two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  row_number() over (partition by id order by val) as rn_2,
  row_number() over (partition by val order by id) as rn_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '020. ROW_NUMBER conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  row_number() over (partition by val order by id desc) as rn_1,
  row_number() over (partition by id order by val) as rn_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '021. RANK single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ rank() over (partition by val order by id) as rk_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '022. RANK two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  rank() over (partition by val order by id) as rk_1,
  rank() over (partition by id order by val) as rk_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '023. RANK two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  rank() over (partition by id order by val) as rk_2,
  rank() over (partition by val order by id) as rk_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '024. RANK conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  rank() over (partition by val order by id desc) as rk_1,
  rank() over (partition by id order by val) as rk_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '025. DENSE_RANK single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ dense_rank() over (partition by val order by id) as dr_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '026. DENSE_RANK two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  dense_rank() over (partition by val order by id) as dr_1,
  dense_rank() over (partition by id order by val) as dr_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '027. DENSE_RANK two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  dense_rank() over (partition by id order by val) as dr_2,
  dense_rank() over (partition by val order by id) as dr_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '028. DENSE_RANK conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  dense_rank() over (partition by val order by id desc) as dr_1,
  dense_rank() over (partition by id order by val) as dr_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

--
-- 4. Aggregate / navigation / distribution window functions
--
evaluate '029. AVG single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ avg(id) over (partition by val order by id) as av_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '030. AVG two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  avg(id) over (partition by val order by id) as av_1,
  avg(val) over (partition by id order by val) as av_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '031. AVG two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  avg(val) over (partition by id order by val) as av_2,
  avg(id) over (partition by val order by id) as av_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '032. AVG conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  avg(id) over (partition by val order by id desc) as av_1,
  avg(val) over (partition by id order by val) as av_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '033. COUNT single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ count(id) over (partition by val order by id) as cnt_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '034. COUNT two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  count(id) over (partition by val order by id) as cnt_1,
  count(val) over (partition by id order by val) as cnt_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '035. COUNT two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  count(val) over (partition by id order by val) as cnt_2,
  count(id) over (partition by val order by id) as cnt_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '036. COUNT conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  count(id) over (partition by val order by id desc) as cnt_1,
  count(val) over (partition by id order by val) as cnt_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '037. CUME_DIST single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ cume_dist() over (partition by val order by id) as cd_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '038. CUME_DIST two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  cume_dist() over (partition by val order by id) as cd_1,
  cume_dist() over (partition by id order by val) as cd_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '039. CUME_DIST two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  cume_dist() over (partition by id order by val) as cd_2,
  cume_dist() over (partition by val order by id) as cd_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '040. CUME_DIST conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  cume_dist() over (partition by val order by id desc) as cd_1,
  cume_dist() over (partition by id order by val) as cd_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '041. FIRST_VALUE single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ first_value(name) over (partition by val order by id) as fv_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '042. FIRST_VALUE two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  first_value(name) over (partition by val order by id) as fv_1,
  first_value(name) over (partition by id order by val) as fv_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '043. FIRST_VALUE two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  first_value(name) over (partition by id order by val) as fv_2,
  first_value(name) over (partition by val order by id) as fv_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '044. FIRST_VALUE conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  first_value(name) over (partition by val order by id desc) as fv_1,
  first_value(name) over (partition by id order by val) as fv_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '045. LAG single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ lag(name, 1) over (partition by val order by id) as lg_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '046. LAG two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  lag(name, 1) over (partition by val order by id) as lg_1,
  lag(name, 1) over (partition by id order by val) as lg_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '047. LAG two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  lag(name, 1) over (partition by id order by val) as lg_2,
  lag(name, 1) over (partition by val order by id) as lg_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '048. LAG conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  lag(name, 1) over (partition by val order by id desc) as lg_1,
  lag(name, 1) over (partition by id order by val) as lg_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '049. LAST_VALUE single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ last_value(name) over (partition by val order by id) as lv_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '050. LAST_VALUE two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  last_value(name) over (partition by val order by id) as lv_1,
  last_value(name) over (partition by id order by val) as lv_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '051. LAST_VALUE two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  last_value(name) over (partition by id order by val) as lv_2,
  last_value(name) over (partition by val order by id) as lv_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '052. LAST_VALUE conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  last_value(name) over (partition by val order by id desc) as lv_1,
  last_value(name) over (partition by id order by val) as lv_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '053. LEAD single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ lead(name, 1) over (partition by val order by id) as ld_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '054. LEAD two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  lead(name, 1) over (partition by val order by id) as ld_1,
  lead(name, 1) over (partition by id order by val) as ld_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '055. LEAD two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  lead(name, 1) over (partition by id order by val) as ld_2,
  lead(name, 1) over (partition by val order by id) as ld_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '056. LEAD conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  lead(name, 1) over (partition by val order by id desc) as ld_1,
  lead(name, 1) over (partition by id order by val) as ld_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '057. MAX single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ max(id) over (partition by val order by id) as mx_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '058. MAX two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  max(id) over (partition by val order by id) as mx_1,
  max(val) over (partition by id order by val) as mx_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '059. MAX two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  max(val) over (partition by id order by val) as mx_2,
  max(id) over (partition by val order by id) as mx_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '060. MAX conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  max(id) over (partition by val order by id desc) as mx_1,
  max(val) over (partition by id order by val) as mx_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '061. MIN single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ min(id) over (partition by val order by id) as mn_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '062. MIN two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  min(id) over (partition by val order by id) as mn_1,
  min(val) over (partition by id order by val) as mn_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '063. MIN two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  min(val) over (partition by id order by val) as mn_2,
  min(id) over (partition by val order by id) as mn_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '064. MIN conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  min(id) over (partition by val order by id desc) as mn_1,
  min(val) over (partition by id order by val) as mn_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '065. NTH_VALUE single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ nth_value(name, 10) over (partition by val order by id) as nv_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '066. NTH_VALUE two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  nth_value(name, 10) over (partition by val order by id) as nv_1,
  nth_value(name, 10) over (partition by id order by val) as nv_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '067. NTH_VALUE two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  nth_value(name, 10) over (partition by id order by val) as nv_2,
  nth_value(name, 10) over (partition by val order by id) as nv_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '068. NTH_VALUE conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  nth_value(name, 10) over (partition by val order by id desc) as nv_1,
  nth_value(name, 10) over (partition by id order by val) as nv_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '069. PERCENT_RANK single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ percent_rank() over (partition by val order by id) as pr_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '070. PERCENT_RANK two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  percent_rank() over (partition by val order by id) as pr_1,
  percent_rank() over (partition by id order by val) as pr_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '071. PERCENT_RANK two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  percent_rank() over (partition by id order by val) as pr_2,
  percent_rank() over (partition by val order by id) as pr_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '072. PERCENT_RANK conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  percent_rank() over (partition by val order by id desc) as pr_1,
  percent_rank() over (partition by id order by val) as pr_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '073. STDDEV_POP single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ stddev_pop(id) over (partition by val order by id) as sp_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '074. STDDEV_POP two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  stddev_pop(id) over (partition by val order by id) as sp_1,
  stddev_pop(val) over (partition by id order by val) as sp_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '075. STDDEV_POP two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  stddev_pop(val) over (partition by id order by val) as sp_2,
  stddev_pop(id) over (partition by val order by id) as sp_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '076. STDDEV_POP conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  stddev_pop(id) over (partition by val order by id desc) as sp_1,
  stddev_pop(val) over (partition by id order by val) as sp_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '077. STDDEV_SAMP single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ stddev_samp(id) over (partition by val order by id) as ss_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '078. STDDEV_SAMP two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  stddev_samp(id) over (partition by val order by id) as ss_1,
  stddev_samp(val) over (partition by id order by val) as ss_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '079. STDDEV_SAMP two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  stddev_samp(val) over (partition by id order by val) as ss_2,
  stddev_samp(id) over (partition by val order by id) as ss_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '080. STDDEV_SAMP conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  stddev_samp(id) over (partition by val order by id desc) as ss_1,
  stddev_samp(val) over (partition by id order by val) as ss_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '081. SUM single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ sum(id) over (partition by val order by id) as sm_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '082. SUM two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  sum(id) over (partition by val order by id) as sm_1,
  sum(val) over (partition by id order by val) as sm_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '083. SUM two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  sum(val) over (partition by id order by val) as sm_2,
  sum(id) over (partition by val order by id) as sm_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '084. SUM conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  sum(id) over (partition by val order by id desc) as sm_1,
  sum(val) over (partition by id order by val) as sm_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '085. VAR_POP single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ var_pop(id) over (partition by val order by id) as vp_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '086. VAR_POP two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  var_pop(id) over (partition by val order by id) as vp_1,
  var_pop(val) over (partition by id order by val) as vp_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '087. VAR_POP two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  var_pop(val) over (partition by id order by val) as vp_2,
  var_pop(id) over (partition by val order by id) as vp_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '088. VAR_POP conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  var_pop(id) over (partition by val order by id desc) as vp_1,
  var_pop(val) over (partition by id order by val) as vp_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '089. VAR_SAMP single analytic - OVER matches midx_01(val,id), sort skipped';
select /*+ recompile */ var_samp(id) over (partition by val order by id) as vs_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '090. VAR_SAMP two analytics, index-compatible one listed first - #1 sort skipped, #2 sort required';
select /*+ recompile */ id, val,
  var_samp(id) over (partition by val order by id) as vs_1,
  var_samp(val) over (partition by id order by val) as vs_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '091. VAR_SAMP two analytics, index-compatible one listed second - reordered to run first, #1 sort skipped';
select /*+ recompile */ id, val,
  var_samp(val) over (partition by id order by val) as vs_2,
  var_samp(id) over (partition by val order by id) as vs_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

evaluate '092. VAR_SAMP conflicting DESC order on the ASC index - sort required';
select /*+ recompile */ id, val,
  var_samp(id) over (partition by val order by id desc) as vs_1,
  var_samp(val) over (partition by id order by val) as vs_2
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;
evaluate '093. NTILE index-compatible DESC analytic written second - promoted ahead of the incompatible one (final row order reveals the execution order)';
select /*+ recompile */ id, val,
  ntile(5) over (partition by id order by val) as n_2,
  ntile(5) over (partition by val order by id desc) as n_1
from test_table where val >= 0 using index midx_01(+) limit 10;
show trace;

set trace off;
drop table test_table;

--
-- 5. Sort-group merging: two analytics that share a sort key are
--    reported as a single ANALYTIC #N group (JIRA comment 2026-03-19).
--
drop table if exists t_group;
create table t_group (c1 int, c2 int, c3 int, c4 int);
create index gidx on t_group (c1, c2, c3, c4);

-- Independent columns (coprime moduli) so every (c1,c2,c3) partition
-- holds several rows with distinct c4; c4 is unique overall.
insert into t_group
with recursive cte (n) as (
  select 1
  union all
  select n + 1 from cte where n < 1000
)
select n % 5, n % 7, n % 3, n from cte;

set trace on;

evaluate '094. Two analytics share the sort key (c1,c2,c3,c4) - they merge into a single ANALYTIC # group (sort skipped); the trace prints one line per sort group, not per function';
select /*+ recompile */ c1, c2, c3, c4,
  row_number() over (partition by c1, c2, c3 order by c4) as a1,
  row_number() over (partition by c1, c2 order by c3, c4) as a2
from t_group where c1 >= 0 using index gidx(+) limit 10;
show trace;

set trace off;
drop table t_group;

--
-- 6. Index edge cases found in code review
--    (function-based index column, descending index scan, non-index column)
-- note: no outer ORDER BY (it would suppress the analytic sort-skip).
--    Every (c1,c2,c3) partition shares the full index key
--    (c1,c2,c3,mod(c1,10)); the returned partition's rows and their
--    row_number values are fixed by the deterministic fresh CTP load
--    (index/insertion order), independent of the sort:skip/true signal.
--
drop table if exists test_table_2;
create table test_table_2 (c1 int, c2 varchar, c3 varchar, c4 int);
create index midx_02 on test_table_2 (c1, c2, c3, mod(c1, 10));

insert into test_table_2
with recursive cte (n) as (
  select 1
  union all
  select n + 1 from cte where n < 1000
)
select n % 100, 'c2_' || (n % 10), 'c3_' || (n % 10), n from cte;

set trace on;

evaluate '095. Partition on leading index columns (c1, c2, c3), no ORDER BY - sort skipped';
select /*+ recompile */ c1, c2, c3,
  row_number() over (partition by c1, c2, c3) as rn
from test_table_2 where c1 >= 0 using index midx_02(+) limit 10;
show trace;

evaluate '096. ORDER BY c4 (not an index column) - sort required';
select /*+ recompile */ c1, c2, c3,
  row_number() over (partition by c1, c2, c3 order by c4) as rn
from test_table_2 where c1 >= 0 using index midx_02(+) limit 10;
show trace;

evaluate '097. ORDER BY mod(c1, 10) (the function-based 4th index column) - sort skipped';
select /*+ recompile */ c1, c2, c3,
  row_number() over (partition by c1, c2, c3 order by mod(c1, 10)) as rn
from test_table_2 where c1 >= 0 using index midx_02(+) limit 10;
show trace;

evaluate '098. use_desc_idx with ascending OVER order - descending scan conflicts, sort required';
select /*+ recompile use_desc_idx */ c1, c2, c3,
  row_number() over (partition by c1, c2, c3 order by mod(c1, 10)) as rn
from test_table_2 where c1 >= 0 using index midx_02(+) limit 10;
show trace;

evaluate '099. use_desc_idx with all-descending OVER order - matches descending scan, sort skipped';
select /*+ recompile use_desc_idx */ c1, c2, c3,
  row_number() over (partition by c1 desc, c2 desc, c3 desc order by mod(c1, 10) desc) as rn
from test_table_2 where c1 >= 0 using index midx_02(+) limit 10;
show trace;

set trace off;
drop table test_table_2;
