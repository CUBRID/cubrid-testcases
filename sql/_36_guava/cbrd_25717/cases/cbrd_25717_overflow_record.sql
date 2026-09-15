/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: overflow record correctness
 * Description: Parallel hash join must work correctly even when overflow records (rows whose
 *              columns span multiple pages, here bit(32000) x 10) exist.
 * Coverage: single / partition / parallel hash join over overflow records; A/C: parallel result == single/NL
 * Source: JIRA attachment cbrd-25717_test-case_20260811.zip (adapted)
 */

--
-- test data
--

drop table if exists t_overflow;

create table t_overflow (
    ckey int,
    dummya bit(32000),
    dummyb bit(32000),
    dummyc bit(32000),
    dummyd bit(32000),
    dummye bit(32000),
    dummyf bit(32000),
    cval int,
    dummyg bit(32000),
    dummyh bit(32000),
    dummyi bit(32000),
    dummyj bit(32000),
    cext int
  );

insert into t_overflow
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum, B'1', B'1', B'1', B'1', B'1', B'1', rownum, B'1', B'1', B'1', B'1', rownum from cte a, cte b limit 10000;

set trace on;


evaluate 'Case 1: single hash join over overflow records';

set system parameters 'max_hash_list_scan_size=8M';

select /*+ recompile
           no_parallel_scan
           no_parallel_subquery */
  count(*)
from (
    select /*+ recompile
               use_hash
               no_merge
               no_parallel_scan
               no_parallel_subquery
               no_parallel_hash_join */
      a.ckey      as a_ckey,
      a.dummya  as a_dummya,
      a.dummyb  as a_dummyb,
      a.dummyc  as a_dummyc,
      a.dummyd  as a_dummyd,
      a.dummye  as a_dummye,
      a.dummyf  as a_dummyf,
      a.cval      as a_cval,
      a.dummyg  as a_dummyg,
      a.dummyh  as a_dummyh,
      a.dummyi  as a_dummyi,
      a.dummyj  as a_dummyj,
      a.cext      as a_cext,
      b.ckey      as b_ckey,
      b.dummya  as b_dummya,
      b.dummyb  as b_dummyb,
      b.dummyc  as b_dummyc,
      b.dummyd  as b_dummyd,
      b.dummye  as b_dummye,
      b.dummyf  as b_dummyf,
      b.cval      as b_cval,
      b.dummyg  as b_dummyg,
      b.dummyh  as b_dummyh,
      b.dummyi  as b_dummyi,
      b.dummyj  as b_dummyj,
      b.cext      as b_cext
    from t_overflow a, t_overflow b
    where a.ckey = b.ckey and a.cval = b.cval and a.cext = b.cext
  );

show trace;


evaluate 'Case 2: partition hash join over overflow records';

set system parameters 'max_hash_list_scan_size=256k';

select /*+ recompile
           no_parallel_scan
           no_parallel_subquery */
  count(*)
from (
    select /*+ recompile
               use_hash
               no_merge
               no_parallel_scan
               no_parallel_subquery
               no_parallel_hash_join */
      a.ckey      as a_ckey,
      a.dummya  as a_dummya,
      a.dummyb  as a_dummyb,
      a.dummyc  as a_dummyc,
      a.dummyd  as a_dummyd,
      a.dummye  as a_dummye,
      a.dummyf  as a_dummyf,
      a.cval      as a_cval,
      a.dummyg  as a_dummyg,
      a.dummyh  as a_dummyh,
      a.dummyi  as a_dummyi,
      a.dummyj  as a_dummyj,
      a.cext      as a_cext,
      b.ckey      as b_ckey,
      b.dummya  as b_dummya,
      b.dummyb  as b_dummyb,
      b.dummyc  as b_dummyc,
      b.dummyd  as b_dummyd,
      b.dummye  as b_dummye,
      b.dummyf  as b_dummyf,
      b.cval      as b_cval,
      b.dummyg  as b_dummyg,
      b.dummyh  as b_dummyh,
      b.dummyi  as b_dummyi,
      b.dummyj  as b_dummyj,
      b.cext      as b_cext
    from t_overflow a, t_overflow b
    where a.ckey = b.ckey and a.cval = b.cval and a.cext = b.cext
  );

show trace;


evaluate 'Case 3: parallel hash join over overflow records';

set system parameters 'max_hash_list_scan_size=256k';

select /*+ recompile
           no_parallel_scan
           no_parallel_subquery */
  count(*)
from (
    select /*+ recompile
               use_hash
               no_merge
               no_parallel_scan
               no_parallel_subquery */
      a.ckey      as a_ckey,
      a.dummya  as a_dummya,
      a.dummyb  as a_dummyb,
      a.dummyc  as a_dummyc,
      a.dummyd  as a_dummyd,
      a.dummye  as a_dummye,
      a.dummyf  as a_dummyf,
      a.cval      as a_cval,
      a.dummyg  as a_dummyg,
      a.dummyh  as a_dummyh,
      a.dummyi  as a_dummyi,
      a.dummyj  as a_dummyj,
      a.cext      as a_cext,
      b.ckey      as b_ckey,
      b.dummya  as b_dummya,
      b.dummyb  as b_dummyb,
      b.dummyc  as b_dummyc,
      b.dummyd  as b_dummyd,
      b.dummye  as b_dummye,
      b.dummyf  as b_dummyf,
      b.cval      as b_cval,
      b.dummyg  as b_dummyg,
      b.dummyh  as b_dummyh,
      b.dummyi  as b_dummyi,
      b.dummyj  as b_dummyj,
      b.cext      as b_cext
    from t_overflow a, t_overflow b
    where a.ckey = b.ckey and a.cval = b.cval and a.cext = b.cext
  );

show trace;


--
-- clean up test data
--

drop table t_overflow;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
