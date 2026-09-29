/*
 * CBRD-26719 - single-context parallel probe over overflow tuples
 *   current_tfile() consistency, and the sector iterator walking an overflow page chain
 *
 * Key points:
 *   - a tuple in the probe list file must exceed QFILE_MAX_TUPLE_SIZE_IN_PAGE (DB_PAGESIZE - 32,
 *     that is 16,352 bytes on a 16K page) before an overflow chain is built. Eight bit(32000)
 *     columns come to 32,000 bytes. bit is counted in bytes whatever the charset, unlike char
 *   - the wide columns must appear in the select list to be carried in the probe list file. With
 *     count(*) alone only the join column is carried and no overflow occurs, so the subquery is
 *     marked no_merge to keep the projection
 *   - if current_tfile returns the wrong tfile, another worker unfixes it and the server crashes
 *   - the probe is a single list file, so tfiles[] holds one entry. The multi-entry case
 *     (a dependent list chain) is covered by 15_probe_dependent_list
 *
 * Judged by the answer file:
 *   - count(*) 100, both EXCEPT directions 0
 *   - a worker sub-line on the line directly below PROBE
 *   - BUILD reports method: memory, and there is no SPLIT
 *
 * Not judgeable from the answer file:
 *   - whether all four workers report readrows > 0. With narrower tuples the list would span only
 *     a few pages, one or two workers would do the work and the rest would report 0, which would
 *     mean the overflow path was never exercised
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_b_small, t_p_overflow;

create table t_b_small (ckey int, cval int);
insert into t_b_small
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 100)
  select n, n from cte;

create table t_p_overflow (
    ckey int,
    pa bit (32000), pb bit (32000), pc bit (32000), pd bit (32000),
    pe bit (32000), pf bit (32000), pg bit (32000), ph bit (32000)
  );

insert into t_p_overflow
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, B'1', B'1', B'1', B'1', B'1', B'1', B'1', B'1'
  from cte a, cte b limit 2000;

update statistics on t_b_small, t_p_overflow with fullscan;

set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: probe tuples exceed one page - parallel probe over an overflow chain';

select /*+ recompile no_parallel_scan no_parallel_subquery */
  count (*)
from (
    select /*+ use_hash ordered parallel(4) no_merge
               no_parallel_scan no_parallel_subquery */
      a.ckey, a.pa, a.pb, a.pc, a.pd, a.pe, a.pf, a.pg, a.ph, b.ckey as bckey
    from t_p_overflow a, t_b_small b where a.ckey = b.ckey
  );
show trace;

set trace off;

evaluate 'Case 2: trace is off from here - row set equality both ways, each result must be 0';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */
      a.ckey, a.pa, a.pb, a.pc, a.pd, a.pe, a.pf, a.pg, a.ph
    from t_p_overflow a, t_b_small b where a.ckey = b.ckey
    except
    select /*+ use_hash ordered parallel(0) */
      a.ckey, a.pa, a.pb, a.pc, a.pd, a.pe, a.pf, a.pg, a.ph
    from t_p_overflow a, t_b_small b where a.ckey = b.ckey
  );

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */
      a.ckey, a.pa, a.pb, a.pc, a.pd, a.pe, a.pf, a.pg, a.ph
    from t_p_overflow a, t_b_small b where a.ckey = b.ckey
    except
    select /*+ use_hash ordered parallel(4) */
      a.ckey, a.pa, a.pb, a.pc, a.pd, a.pe, a.pf, a.pg, a.ph
    from t_p_overflow a, t_b_small b where a.ckey = b.ckey
  );

drop table t_b_small, t_p_overflow;
