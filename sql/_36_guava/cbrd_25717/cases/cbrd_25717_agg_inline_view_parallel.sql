/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: PARALLEL hint preservation across aggregate-as-derived rewrite
 * Coverage: PR#6628(2). When an aggregate query is rewritten into an inline (derived)
 *           view - e.g. an aggregate with a LIMIT clause, handled by
 *           mq_rewrite_aggregate_as_derived() - the PARALLEL hint (num_parallel_threads)
 *           must be copied to the derived select so the inner hash join still runs in
 *           parallel. Before the fix the hint was lost and the hash join ran single-threaded.
 * How verified: the rewritten derived SELECT in SQL Trace must show the PARALLEL node /
 *           "parallel workers", and the count must match the parallel(0) result.
 * Source: own addition (not in the JIRA attachment, which does not cover PR#6628(2)).
 */

-- test data
drop table if exists t_agg;

create table t_agg (ckey int);

insert into t_agg
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum from cte a, cte b limit 100000;

-- lower the threshold so a partition hash join is triggered
set system parameters 'max_hash_list_scan_size=256k';

set trace on;

evaluate 'Case 1: aggregate + LIMIT -> derived rewrite, PARALLEL(8) hint preserved in derived hash join';

/*
 * count(*) + limit 1 triggers mq_rewrite_aggregate_as_derived (semantic_check.c).
 * The hash join moves into the derived SELECT; the PARALLEL(8) hint must move with it.
 * Trace: the derived SELECT's HASHJOIN must contain a PARALLEL node (parallel workers).
 */
select /*+ recompile
           use_hash
           parallel(8) */
  count (*)
from t_agg a, t_agg b
where a.ckey = b.ckey
limit 1;

show trace;

evaluate 'Case 2: same query with NO_PARALLEL_HASH_JOIN - serial baseline, identical count';

select /*+ recompile
           use_hash
           parallel(8)
           no_parallel_hash_join */
  count (*)
from t_agg a, t_agg b
where a.ckey = b.ckey
limit 1;

show trace;

set trace off;

-- clean up test data
set system parameters 'max_hash_list_scan_size=default';

drop table t_agg;
