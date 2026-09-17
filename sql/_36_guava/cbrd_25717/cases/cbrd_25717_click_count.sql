/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: click counter restriction
 * Description: When a click counter function (INCR/DECR, WITH INCREMENT/DECREMENT) is used, hash join cannot be used.
 * Coverage: PR#6247 INCR/DECR/WITH INCREMENT/WITH DECREMENT -> hash join not used (HINT ignored), falls back to NL; A/C: click counter restriction
 * Source: JIRA attachment cbrd-25717_test-case_20260811.zip (adapted)
 */

-- 
-- test data
-- 

drop table if exists t_click_counter, t_filter;

create table t_click_counter (ckey int, cval int);
create index t_click_counter_c1 on t_click_counter (ckey);

create table t_filter (ckey int);

insert into t_click_counter
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum, 0 from cte a, cte b limit 10000;

insert into t_filter values (10000);

/*
 * Cases 1-4 all touch the SAME row (ckey = 10000) and are therefore order-dependent.
 * INCR / DECR return the value BEFORE the change, so cval walks 0 -> 1 -> 2 -> 1 -> 0 and the
 * expected output is 0, 1, 2, 1 - each case reads what the previous one left behind:
 *     Case 1  INCR            reads 0, leaves 1
 *     Case 2  WITH INCREMENT  reads 1, leaves 2
 *     Case 3  DECR            reads 2, leaves 1
 *     Case 4  WITH DECREMENT  reads 1, leaves 0
 * Reordering the cases, or dropping one, shifts every later expected value. Keep them together
 * and in this order.
 */


evaluate 'Case 1: INCR function used -> hash join must not be performed (HINT ignored)';

--@queryplan
select /*+ recompile ordered use_hash */
  incr (a.cval)
from t_click_counter a, t_click_counter b, t_filter c
where a.ckey = b.ckey and a.ckey = c.ckey;


evaluate 'Case 2: WITH INCREMENT FOR used -> hash join must not be performed (HINT ignored)';

--@queryplan
select /*+ recompile ordered use_hash */
  a.cval
from t_click_counter a, t_click_counter b, t_filter c
where a.ckey = b.ckey and a.ckey = c.ckey
with increment for a.cval;


evaluate 'Case 3: DECR function used -> hash join must not be performed (HINT ignored)';

--@queryplan
select /*+ recompile ordered use_hash */
  decr (a.cval)
from t_click_counter a, t_click_counter b, t_filter c
where a.ckey = b.ckey and a.ckey = c.ckey;


evaluate 'Case 4: WITH DECREMENT FOR used -> hash join must not be performed (HINT ignored)';

--@queryplan
select /*+ recompile ordered use_hash */
  a.cval
from t_click_counter a, t_click_counter b, t_filter c
where a.ckey = b.ckey and a.ckey = c.ckey
with decrement for a.cval;


--
-- clean up test data
--

drop table t_click_counter, t_filter;
