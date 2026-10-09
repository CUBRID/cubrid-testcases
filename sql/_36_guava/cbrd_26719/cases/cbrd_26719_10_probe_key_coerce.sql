/*
 * CBRD-26719 - single-context parallel probe with mismatched join key types (string coercion)
 *   whether the value-conversion buffer built during probing is released inside the worker scope
 *
 * Key points:
 *   - the build key is varchar and the probe key is char, so every probe runs tp_value_coerce and
 *     then qstr_coerce. With matching key types there is no conversion at all
 *   - rpad is applied to the build values because a char (30) column is padded to 30 characters
 *     and trailing blanks are not ignored when char is compared with varchar. Without matching
 *     the lengths nothing would match and the case would lose its value
 *   - the conversion buffer is tracked in the per-task resource_tracker scope. Releasing it
 *     outside the task raises a restrack assert on a debug build and can corrupt the heap in
 *     production
 *   - a different path from 14_key_type_and_composite, whose Cases 7 and 8 use BIGINT against
 *     INT. That is a numeric coercion and allocates no buffer
 *
 * Judged by the answer file:
 *   - matched 80000, both EXCEPT directions 0. A matched of 0 would still exercise the conversion
 *     but would make the result comparison meaningless
 *   - a worker sub-line on the line directly below PROBE, and no SPLIT
 *
 * Not recorded in the answer file:
 *   - the conversion itself never appears in the trace
 *
 * Prerequisite: CTP runs SQL tests with test_mode=yes, so prm_tune_parameters() lowers
 *   parallel_hash_join_page_threshold from its default 256 pages to 0 (floored to 2 by
 *   compute_parallel_degree). Without it the probe lists here stay under 256 pages and the
 *   parallel-probe cases fall back to a serial probe.
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_b_str, t_p_str;

create table t_b_str (kstr varchar (50), val int);
create table t_p_str (kstr char (30), val int);

insert into t_b_str
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 100)
  select rpad ('key' || n, 30), n from cte;

insert into t_p_str
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select 'key' || (mod (rownum, 100) + 1), rownum
  from cte a, cte b limit 80000;

update statistics on t_b_str, t_p_str with fullscan;

-- default value, so no partitioning
set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: varchar build key vs char probe key - value coercion on every probe';

select /*+ recompile use_hash ordered parallel(4)
           no_parallel_scan no_parallel_subquery */
  count (*) as matched
from t_p_str a, t_b_str b where a.kstr = b.kstr;
show trace;

set trace off;

evaluate 'Case 2: trace is off from here - row set equality both ways, each result must be 0';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.val as aval, b.val as bval
    from t_p_str a, t_b_str b where a.kstr = b.kstr
    except
    select /*+ use_hash ordered parallel(0) */ a.val as aval, b.val as bval
    from t_p_str a, t_b_str b where a.kstr = b.kstr
  );

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.val as aval, b.val as bval
    from t_p_str a, t_b_str b where a.kstr = b.kstr
    except
    select /*+ use_hash ordered parallel(4) */ a.val as aval, b.val as bval
    from t_p_str a, t_b_str b where a.kstr = b.kstr
  );

set system parameters 'max_hash_list_scan_size=default';

drop table t_b_str, t_p_str;
