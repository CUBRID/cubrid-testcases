/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: SQL Trace JSON output for parallel hash join
 * Coverage: Acceptance Criteria - "SQL Trace TEXT/JSON support". PR#6429 - collision_rate
 *           must NOT appear; HASHJOIN/split/build/probe structure; parallel level recorded.
 * Note: numeric trace values are normalized to '?' by the CTP framework, so only the
 *       JSON structure (presence of "parallel"/"split" objects, absence of collision_rate)
 *       is asserted.
 * Source: own addition (not in the JIRA attachment, which uses TEXT trace only) - covers the JSON-trace AC.
 */

-- test data
drop table if exists t_trace_json;

create table t_trace_json (ckey int);

insert into t_trace_json
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum from cte a, cte b limit 100000;

-- lower the threshold so a partition hash join is triggered
set system parameters 'max_hash_list_scan_size=256k';

set trace on output json;

evaluate 'Case 1: parallel partition hash join - JSON trace (split + parallel, no collision_rate)';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery
           parallel(8) */
  count (*)
from t_trace_json a, t_trace_json b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 2: NO_PARALLEL_HASH_JOIN - JSON trace (split present, parallel absent)';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery
           no_parallel_hash_join */
  count (*)
from t_trace_json a, t_trace_json b
where a.ckey = b.ckey;

show trace;

set trace off;

-- clean up test data
set system parameters 'max_hash_list_scan_size=default';

drop table t_trace_json;
