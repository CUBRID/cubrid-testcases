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

-- lower the threshold so a partition hash join is triggered.
--
-- 32k, not the 256k this case used to carry. The BUILD method is chosen per partition:
--   in_mem_size = slot_array + entries + page_cnt * DB_PAGESIZE   -> memory when <= this limit
--   hybrid_size = slot_array + entries + tuple_cnt * sizeof (QFILE_TUPLE_SIMPLE_POS)
--                                                                -> hybrid when <= this limit
-- Under a parallel split each worker flushes a partial page into the partition through
-- qfile_append_list, which copies whole pages, so page_cnt per partition depends on how many
-- workers happened to touch it. Any limit that leaves page_cnt able to decide the method makes
-- the trace non-deterministic - at 256k the partitions straddled it and "memory+hybrid" flipped
-- to "memory" on roughly one CTP run in ten.
--
-- 32k removes page_cnt from the decision instead of moving away from the boundary. The partition
-- count is ceil (52 * rows / (limit * 0.8)) (hjoin_check_partition), so a smaller limit means more
-- and smaller partitions:
--   limit  partitions  rows/part  slot+entry  in_mem @1 page  hybrid_size
--   256k      25          4000      159.2K       175.2K         206.1K     <- both fit, memory
--    64k     100          1000       39.8K        55.8K          51.5K     <- 1 page fits (memory),
--                                                                            2 pages do not
--    32k     199           503       19.9K        35.9K          25.8K     <- even 1 page is over
-- At 32k the smallest possible in_mem_size already exceeds the limit while hybrid_size stays under
-- it, so every partition is hybrid no matter how the workers divided the input. Both cases below
-- print "hybrid"; the serial one does too, which is the point - at 64k it printed "memory" because
-- a single writer leaves one page per partition.
set system parameters 'max_hash_list_scan_size=32k';

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
