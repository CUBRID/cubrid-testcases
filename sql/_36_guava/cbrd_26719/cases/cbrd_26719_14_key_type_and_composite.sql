/*
 * CBRD-26719 - join key handling: VARCHAR (collation), variable length, composite keys and a
 *   type mismatch
 *   covers: A/C (1) for key handling that is not a single int column
 *
 * Key points:
 *   - every other case joins on a single int key. Each probe worker allocates its own hash_scan
 *     (the temp_key and temp_new_key DB_VALUE arrays) through hjoin_scan_init(..., key_cnt, ...)
 *     and shares only the hash table pointer. Inside hjoin_fetch_key(), which fills that buffer,
 *     three branches a single int key never reaches:
 *       1. the for (key_index < key->val_count) loop with the value_indexes[] mapping, which
 *          runs once when key_cnt is 1. The case the source comment itself cites, one tuple
 *          value referenced by several keys, only arises with a composite key
 *       2. the coercion branch, entered only when the key types or their precision and scale
 *          differ between build and probe
 *       3. pr_clear_value() followed by a refill, a no-op for int, so the allocate and release
 *          lifecycle of the per-worker key buffer is never exercised
 *   - a string key also hashes and compares through the collation, and being variable-length it
 *     makes page occupancy uneven, which changes the probe sector split itself
 *   - Cases 9 and 10 leave 20 percent of the probe keys without a partner so the NULL-fill path
 *     really runs
 *
 * Judged by the answer file:
 *   - Cases 1 to 8, four pairs, all give cnt 48000 / sval 4824000
 *   - Cases 9 and 10: total_rows 60000 / matched 48000 / null_filled 12000
 *   - Cases 11 and 12: both EXCEPT directions 0
 *   - a worker sub-line below PROBE in Cases 1, 3, 5, 7 and 9 but not in the even ones
 *   - the rewritten query for Cases 5 and 6 still shows both join keys
 *   - no SPLIT
 *
 * Not judgeable from the answer file:
 *   - whether the coercion actually happened. need_coerce_domains never appears in the trace, so
 *     Cases 7 and 8 judge it indirectly through matching results. The string coercion that
 *     allocates a tracked buffer is covered by 10_probe_key_coerce
 *
 * Source: own addition (not in the JIRA attachment)
 */

drop table if exists t_kt_fbuild, t_kt_fprobe, t_kt_vbuild, t_kt_vprobe,
                     t_kt_cbuild, t_kt_cprobe, t_kt_mbuild, t_kt_mprobe;

-- fixed-width VARCHAR key (md5 always yields 32 characters)
create table t_kt_fbuild (ckey varchar (64), cval int);
create table t_kt_fprobe (ckey varchar (64), cval int);

insert into t_kt_fbuild
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select md5 (n), n from cte;

-- probe keys are 1..250, so 201..250 are absent from build (NULL-fill for Case 9/10)
insert into t_kt_fprobe
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select md5 (mod (rownum, 250) + 1), mod (rownum, 7) from cte a, cte b limit 60000;

-- variable-length VARCHAR key (md5 repeated 1 to 3 times: 32 / 64 / 96 characters)
create table t_kt_vbuild (ckey varchar (200), cval int);
create table t_kt_vprobe (ckey varchar (200), cval int);

insert into t_kt_vbuild
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select repeat (md5 (n), mod (n, 3) + 1), n from cte;

insert into t_kt_vprobe
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select repeat (md5 (mod (rownum, 250) + 1), mod (mod (rownum, 250) + 1, 3) + 1),
         mod (rownum, 7)
  from cte a, cte b limit 60000;

-- composite key (int + VARCHAR), so key_cnt is 2
create table t_kt_cbuild (kint int, kstr varchar (64), cval int);
create table t_kt_cprobe (kint int, kstr varchar (64), cval int);

insert into t_kt_cbuild
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, md5 (n), n from cte;

insert into t_kt_cprobe
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select mod (rownum, 250) + 1, md5 (mod (rownum, 250) + 1), mod (rownum, 7)
  from cte a, cte b limit 60000;

-- type mismatch (build BIGINT vs probe INT), which sets need_coerce_domains
create table t_kt_mbuild (ckey bigint, cval int);
create table t_kt_mprobe (ckey int, cval int);

insert into t_kt_mbuild
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select cast (n as bigint), n from cte;

insert into t_kt_mprobe
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select mod (rownum, 250) + 1, mod (rownum, 7) from cte a, cte b limit 60000;

update statistics on t_kt_fbuild, t_kt_fprobe, t_kt_vbuild, t_kt_vprobe,
                     t_kt_cbuild, t_kt_cprobe, t_kt_mbuild, t_kt_mprobe with fullscan;

set system parameters 'max_hash_list_scan_size=8M'; -- default value, so no partitioning

set trace on;

evaluate 'Case 1: fixed-width VARCHAR join key - parallel probe active';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_kt_fprobe a, t_kt_fbuild b where a.ckey = b.ckey;

show trace;

evaluate 'Case 2: same fixed-width VARCHAR join single-threaded - must match Case 1';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_kt_fprobe a, t_kt_fbuild b where a.ckey = b.ckey;

show trace;

evaluate 'Case 3: variable-length VARCHAR join key - uneven page occupancy across sectors';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_kt_vprobe a, t_kt_vbuild b where a.ckey = b.ckey;

show trace;

evaluate 'Case 4: same variable-length VARCHAR join single-threaded - must match Case 3';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_kt_vprobe a, t_kt_vbuild b where a.ckey = b.ckey;

show trace;

evaluate 'Case 5: composite join key (int + VARCHAR) - key_cnt is 2, not 1';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_kt_cprobe a, t_kt_cbuild b
where a.kint = b.kint and a.kstr = b.kstr;

show trace;

evaluate 'Case 6: same composite-key join single-threaded - must match Case 5';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_kt_cprobe a, t_kt_cbuild b
where a.kint = b.kint and a.kstr = b.kstr;

show trace;

evaluate 'Case 7: BIGINT build key vs INT probe key - need_coerce_domains path';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_kt_mprobe a, t_kt_mbuild b where a.ckey = b.ckey;

show trace;

evaluate 'Case 8: same coerced-key join single-threaded - must match Case 7';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_kt_mprobe a, t_kt_mbuild b where a.ckey = b.ckey;

show trace;

evaluate 'Case 9: LEFT OUTER on a VARCHAR key - 20 percent of probe rows must be NULL-filled';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.ckey) as matched,
  count (case when b.ckey is null then 1 end) as null_filled
from t_kt_fprobe a left outer join t_kt_fbuild b on a.ckey = b.ckey;

show trace;

evaluate 'Case 10: same VARCHAR LEFT OUTER single-threaded - must match Case 9';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.ckey) as matched,
  count (case when b.ckey is null then 1 end) as null_filled
from t_kt_fprobe a left outer join t_kt_fbuild b on a.ckey = b.ckey;

show trace;

set trace off;

evaluate 'Case 11: row set equality both ways - VARCHAR key';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.cval as bcval
    from t_kt_fprobe a, t_kt_fbuild b where a.ckey = b.ckey
    except
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.cval as bcval
    from t_kt_fprobe a, t_kt_fbuild b where a.ckey = b.ckey
  );

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.cval as bcval
    from t_kt_fprobe a, t_kt_fbuild b where a.ckey = b.ckey
    except
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.cval as bcval
    from t_kt_fprobe a, t_kt_fbuild b where a.ckey = b.ckey
  );

evaluate 'Case 12: row set equality both ways - composite key';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.kint, a.kstr, b.cval as bcval
    from t_kt_cprobe a, t_kt_cbuild b where a.kint = b.kint and a.kstr = b.kstr
    except
    select /*+ use_hash ordered parallel(0) */ a.kint, a.kstr, b.cval as bcval
    from t_kt_cprobe a, t_kt_cbuild b where a.kint = b.kint and a.kstr = b.kstr
  );

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.kint, a.kstr, b.cval as bcval
    from t_kt_cprobe a, t_kt_cbuild b where a.kint = b.kint and a.kstr = b.kstr
    except
    select /*+ use_hash ordered parallel(4) */ a.kint, a.kstr, b.cval as bcval
    from t_kt_cprobe a, t_kt_cbuild b where a.kint = b.kint and a.kstr = b.kstr
  );

drop table t_kt_fbuild, t_kt_fprobe, t_kt_vbuild, t_kt_vprobe,
           t_kt_cbuild, t_kt_cprobe, t_kt_mbuild, t_kt_mprobe;
