/**
 *  CBRD-26711: parallel heap scan now supports MIN, MAX, SUM, AVG, the STDDEV
 *  family and the VARIANCE family in aggregate queries that have no GROUP BY.
 *  Engine PR #7049, sub-task of CBRD-25447.
 *
 *  Before the fix only the COUNT family could use this optimization and the
 *  other aggregates fell back to a slower path. With the fix each worker
 *  aggregates its own share of the rows and the partial results are combined at
 *  the end, which "show trace" reports as "gather: buildvalue".
 *
 *  Because the partial results are combined after the scan, what can go wrong
 *  here is a WRONG VALUE rather than a missing plan. So every parallel query is
 *  followed by the same query with NO_PARALLEL_SCAN and the two results must
 *  match; that comparison, not the trace line by itself, is what proves the
 *  aggregate is correct.
 *
 *  On sizing and naming: CTP runs SQL tests with test_mode=yes, which lowers the
 *  page threshold that switches parallel scan on, and masks volatile values
 *  (times, page and worker counts) and digits inside identifiers to '?'. The
 *  10000-row table clears the threshold, and the letter-only table and column
 *  names stay readable after masking.
 *
 *  Two notes on the issue's acceptance criteria. It names NO_PARALLEL_HEAP_SCAN
 *  as the hint that forces serial execution, but that spelling is ignored on
 *  current builds (CBRD-26722 renamed it), so the serial queries here use
 *  NO_PARALLEL_SCAN. There is no case dedicated to that hint: every serial
 *  reference below is one, and each of their traces shows the scan running
 *  without workers. And the criterion about a ~10x speedup is a timing
 *  measurement, which is covered by the separate performance test at
 *  cubrid-testcases-private-ex/shell_perf/_40_guava/cbrd_26711.
 *
 *  Coverage:
 *    Case 1:     COUNT(*) / COUNT(col) -- worked before the fix too
 *    Case 2-5:   MIN/MAX, SUM/AVG, STDDEV family, VARIANCE family -- the fix
 *    Case 6:     all 12 supported aggregates in one query
 *    Case 7-8:   VARCHAR MIN/MAX, NUMERIC SUM/AVG/STDDEV/VARIANCE
 *    Case 9:     DISTINCT variants
 *    Case 10:    column that is entirely NULL
 *    Case 11:    predicate matching no row at all
 *    Case 12:    predicate matching exactly one row
 *    Case 13:    mixed-sign values, so a lost or double-counted share shows up
 *    Case 14:    expression operands, e.g. MIN(cola + 1)
 *    Case 15:    aggregates combined with a WHERE predicate
 *    Case 16:    aggregate plus a non-aggregate select-list item
 *    Case 17:    explicit PARALLEL(2) hint
 *    Case 18:    DISTINCT and non-DISTINCT aggregates in the same query
 *    Case 19:    SUM that overflows only after the per-worker parts are added
 *                together -- parallel must raise the same error as serial
 */

drop table if exists bv;

create table bv (id int, cola int, colb varchar(20), colc numeric(15,5),
                 cold varchar(20), cole varchar(20), colf varchar(20),
                 coln int, colneg int);
insert into bv
select rownum, rownum % 100, lpad(to_char(rownum % 50), 20, '0'), (rownum % 200) * 1.5,
       lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 20, '0'),
       null,
       case when rownum % 2 = 0 then -(rownum % 97) else (rownum % 97) end
from db_class a, db_class b, db_class c, db_class d, db_class e limit 10000;

/* Each row holds a value large enough that the 10000-row total exceeds the
 * BIGINT range, while any one worker's share stays inside it: with the total at
 * about 1.1e19 and BIGINT capped near 9.2e18, even a single worker taking half
 * the rows stays under the limit. The overflow therefore happens when the
 * per-worker sums are added together, not while a worker is accumulating. */
drop table if exists ovf;
create table ovf (id int, b bigint, colb varchar(20), colc varchar(20), cold varchar(20), cole varchar(20));
insert into ovf
select rownum, 1106804644422573, lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 20, '0'),
       lpad(to_char(rownum), 20, '0'), lpad(to_char(rownum), 20, '0')
from db_class a, db_class b, db_class c, db_class d, db_class e limit 10000;

set trace on;


evaluate 'Case 1: COUNT(*) and COUNT(col) -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*), count(cola) from bv;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile no_parallel_scan */ count(*), count(cola) from bv;
show trace;


evaluate 'Case 2: MIN / MAX -> parallel heap scan (buildvalue)';
select /*+ recompile */ min(cola), max(cola) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ min(cola), max(cola) from bv;
show trace;


evaluate 'Case 3: SUM / AVG -> parallel heap scan (buildvalue)';
select /*+ recompile */ sum(cola), avg(cola) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ sum(cola), avg(cola) from bv;
show trace;


evaluate 'Case 4: STDDEV / STDDEV_POP / STDDEV_SAMP -> parallel heap scan (buildvalue)';
-- each worker accumulates X and X^2 separately; the merged result must equal the
-- serial one exactly, so a different summation order would be visible here.
select /*+ recompile */ stddev(cola), stddev_pop(cola), stddev_samp(cola) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ stddev(cola), stddev_pop(cola), stddev_samp(cola) from bv;
show trace;


evaluate 'Case 5: VARIANCE / VAR_POP / VAR_SAMP -> parallel heap scan (buildvalue)';
select /*+ recompile */ variance(cola), var_pop(cola), var_samp(cola) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ variance(cola), var_pop(cola), var_samp(cola) from bv;
show trace;


evaluate 'Case 6: all 12 supported aggregates in one query -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*), count(cola), min(cola), max(cola), sum(cola), avg(cola),
       stddev(cola), stddev_pop(cola), stddev_samp(cola), variance(cola), var_pop(cola), var_samp(cola)
from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*), count(cola), min(cola), max(cola), sum(cola), avg(cola),
       stddev(cola), stddev_pop(cola), stddev_samp(cola), variance(cola), var_pop(cola), var_samp(cola)
from bv;
show trace;


evaluate 'Case 7: VARCHAR column MIN / MAX -> parallel heap scan (buildvalue)';
-- string accumulators are copied across worker heaps, so a domain or allocator
-- mistake would surface as a wrong or truncated string rather than a wrong count.
select /*+ recompile */ min(colb), max(colb), min(cold), max(cold) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ min(colb), max(colb), min(cold), max(cold) from bv;
show trace;


evaluate 'Case 8: NUMERIC column SUM / AVG / STDDEV / VARIANCE -> parallel heap scan (buildvalue)';
select /*+ recompile */ sum(colc), avg(colc), stddev(colc), variance(colc) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ sum(colc), avg(colc), stddev(colc), variance(colc) from bv;
show trace;


evaluate 'Case 9: DISTINCT variants -> parallel heap scan (buildvalue)';
-- DISTINCT keeps a per-thread list that is connected at the end instead of being
-- accumulated in place; the gather mode stays buildvalue.
select /*+ recompile */ count(distinct cola), sum(distinct cola), avg(distinct cola),
       min(distinct colb), max(distinct colb) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(distinct cola), sum(distinct cola), avg(distinct cola),
       min(distinct colb), max(distinct colb) from bv;
show trace;


evaluate 'Case 10: column containing only NULL -> parallel heap scan (buildvalue)';
-- count(*) counts the rows, count(coln) is 0 and every value aggregate is NULL:
-- a worker that merged an untouched accumulator as 0 instead of NULL fails here.
select /*+ recompile */ count(*), count(coln), min(coln), max(coln), sum(coln), avg(coln), stddev(coln) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*), count(coln), min(coln), max(coln), sum(coln), avg(coln), stddev(coln) from bv;
show trace;


evaluate 'Case 11: predicate matching no row -> parallel heap scan (buildvalue)';
-- every worker finishes with an empty accumulator; the merge must still yield
-- count 0 and NULL for the value aggregates.
select /*+ recompile */ count(*), count(cola), min(cola), max(cola), sum(cola), avg(cola), stddev(cola)
from bv where cola < 0;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*), count(cola), min(cola), max(cola), sum(cola), avg(cola), stddev(cola)
from bv where cola < 0;
show trace;


evaluate 'Case 12: predicate matching exactly one row -> parallel heap scan (buildvalue)';
-- only one worker sees a row, the others merge empty accumulators.
select /*+ recompile */ count(*), min(cola), max(cola), sum(cola), avg(cola), stddev(cola)
from bv where id = 1;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*), min(cola), max(cola), sum(cola), avg(cola), stddev(cola)
from bv where id = 1;
show trace;


evaluate 'Case 13: mixed-sign values -> parallel heap scan (buildvalue)';
-- colneg alternates sign, so a dropped or double-counted partial changes the sum.
select /*+ recompile */ sum(colneg), avg(colneg), min(colneg), max(colneg), stddev(colneg) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ sum(colneg), avg(colneg), min(colneg), max(colneg), stddev(colneg) from bv;
show trace;


evaluate 'Case 14: expression operands -> parallel heap scan (buildvalue)';
select /*+ recompile */ min(cola + 1), max(cola * 2), sum(cola - 10), avg(cola * 1.5) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ min(cola + 1), max(cola * 2), sum(cola - 10), avg(cola * 1.5) from bv;
show trace;


evaluate 'Case 15: aggregates with a WHERE predicate -> parallel heap scan (buildvalue)';
select /*+ recompile */ count(*), min(cola), max(cola), sum(cola), avg(cola), stddev(cola)
from bv where cola > 50;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*), min(cola), max(cola), sum(cola), avg(cola), stddev(cola)
from bv where cola > 50;
show trace;


evaluate 'Case 16: aggregate plus a non-aggregate select-list item -> parallel heap scan (buildvalue)';
-- CBRD-26982 removed the constraint that every select-list item be an aggregate,
-- so a trailing constant no longer disables the optimization.
select /*+ recompile */ count(*), sum(cola), 'x' from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ count(*), sum(cola), 'x' from bv;
show trace;


evaluate 'Case 17: explicit PARALLEL(2) hint -> parallel heap scan (buildvalue)';
select /*+ recompile PARALLEL(2) */ sum(cola), avg(cola), stddev(cola) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ sum(cola), avg(cola), stddev(cola) from bv;
show trace;


evaluate 'Case 18: non-DISTINCT and DISTINCT aggregates in one query -> parallel heap scan (buildvalue)';
-- attachment scenario 15. Within a single query the non-DISTINCT aggregates are
-- accumulated in place while the DISTINCT ones build a per-thread list, so both
-- merge paths run side by side over the same scan.
select /*+ recompile */ min(cola), max(cola), sum(cola), count(distinct cola), sum(distinct cola) from bv;
show trace;
-- serial reference
select /*+ recompile no_parallel_scan */ min(cola), max(cola), sum(cola), count(distinct cola), sum(distinct cola) from bv;
show trace;


evaluate 'Case 19: SUM overflowing only when the per-worker parts are combined -> same error as serial';
-- the sum of any one worker's rows fits in BIGINT, so the overflow can only be
-- raised where the parts are added together. Parallel must fail exactly as
-- serial does rather than returning a wrapped or partial value.
--+ server-message on
select /*+ recompile */ sum(b) from ovf;
--+ server-message off
-- the trace proves the failing query really ran in parallel: without it a run
-- that quietly fell back to a serial scan would raise the same error and pass
-- while testing nothing about the combine step.
show trace;
--+ server-message on
-- serial reference: must report the identical error
select /*+ recompile no_parallel_scan */ sum(b) from ovf;
--+ server-message off


set trace off;

drop table if exists bv;
drop table if exists ovf;
