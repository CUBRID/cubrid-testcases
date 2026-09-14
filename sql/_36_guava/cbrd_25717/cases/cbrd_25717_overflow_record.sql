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
    c1 int,
    dummy0 bit(32000),
    dummy1 bit(32000),
    dummy2 bit(32000),
    dummy3 bit(32000),
    dummy4 bit(32000),
    dummy5 bit(32000),
    c2 int,
    dummy6 bit(32000),
    dummy7 bit(32000),
    dummy8 bit(32000),
    dummy9 bit(32000),
    c3 int
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
      a.c1      as a_c1,
      a.dummy0  as a_dummy0,
      a.dummy1  as a_dummy1,
      a.dummy2  as a_dummy2,
      a.dummy3  as a_dummy3,
      a.dummy4  as a_dummy4,
      a.dummy5  as a_dummy5,
      a.c2      as a_c2,
      a.dummy6  as a_dummy6,
      a.dummy7  as a_dummy7,
      a.dummy8  as a_dummy8,
      a.dummy9  as a_dummy9,
      a.c3      as a_c3,
      b.c1      as b_c1,
      b.dummy0  as b_dummy0,
      b.dummy1  as b_dummy1,
      b.dummy2  as b_dummy2,
      b.dummy3  as b_dummy3,
      b.dummy4  as b_dummy4,
      b.dummy5  as b_dummy5,
      b.c2      as b_c2,
      b.dummy6  as b_dummy6,
      b.dummy7  as b_dummy7,
      b.dummy8  as b_dummy8,
      b.dummy9  as b_dummy9,
      b.c3      as b_c3
    from t_overflow a, t_overflow b
    where a.c1 = b.c1 and a.c2 = b.c2 and a.c3 = b.c3
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
      a.c1      as a_c1,
      a.dummy0  as a_dummy0,
      a.dummy1  as a_dummy1,
      a.dummy2  as a_dummy2,
      a.dummy3  as a_dummy3,
      a.dummy4  as a_dummy4,
      a.dummy5  as a_dummy5,
      a.c2      as a_c2,
      a.dummy6  as a_dummy6,
      a.dummy7  as a_dummy7,
      a.dummy8  as a_dummy8,
      a.dummy9  as a_dummy9,
      a.c3      as a_c3,
      b.c1      as b_c1,
      b.dummy0  as b_dummy0,
      b.dummy1  as b_dummy1,
      b.dummy2  as b_dummy2,
      b.dummy3  as b_dummy3,
      b.dummy4  as b_dummy4,
      b.dummy5  as b_dummy5,
      b.c2      as b_c2,
      b.dummy6  as b_dummy6,
      b.dummy7  as b_dummy7,
      b.dummy8  as b_dummy8,
      b.dummy9  as b_dummy9,
      b.c3      as b_c3
    from t_overflow a, t_overflow b
    where a.c1 = b.c1 and a.c2 = b.c2 and a.c3 = b.c3
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
      a.c1      as a_c1,
      a.dummy0  as a_dummy0,
      a.dummy1  as a_dummy1,
      a.dummy2  as a_dummy2,
      a.dummy3  as a_dummy3,
      a.dummy4  as a_dummy4,
      a.dummy5  as a_dummy5,
      a.c2      as a_c2,
      a.dummy6  as a_dummy6,
      a.dummy7  as a_dummy7,
      a.dummy8  as a_dummy8,
      a.dummy9  as a_dummy9,
      a.c3      as a_c3,
      b.c1      as b_c1,
      b.dummy0  as b_dummy0,
      b.dummy1  as b_dummy1,
      b.dummy2  as b_dummy2,
      b.dummy3  as b_dummy3,
      b.dummy4  as b_dummy4,
      b.dummy5  as b_dummy5,
      b.c2      as b_c2,
      b.dummy6  as b_dummy6,
      b.dummy7  as b_dummy7,
      b.dummy8  as b_dummy8,
      b.dummy9  as b_dummy9,
      b.c3      as b_c3
    from t_overflow a, t_overflow b
    where a.c1 = b.c1 and a.c2 = b.c2 and a.c3 = b.c3
  );

show trace;


--
-- clean up test data
--

drop table t_overflow;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
