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

create table t_click_counter (c1 int, c2 int);
create index t_click_counter_c1 on t_click_counter (c1);

create table t_filter (c1 int);

insert into t_click_counter
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum, 0 from cte a, cte b limit 10000;

insert into t_filter values (10000);


evaluate 'Case 1: INCR function used -> hash join must not be performed (HINT ignored)';

--@queryplan
select /*+ recompile ordered use_hash */
  incr (a.c2)
from t_click_counter a, t_click_counter b, t_filter c
where a.c1 = b.c1 and a.c1 = c.c1;


evaluate 'Case 2: WITH INCREMENT FOR used -> hash join must not be performed (HINT ignored)';

--@queryplan
select /*+ recompile ordered use_hash */
  a.c2
from t_click_counter a, t_click_counter b, t_filter c
where a.c1 = b.c1 and a.c1 = c.c1
with increment for a.c2;


evaluate 'Case 3: DECR function used -> hash join must not be performed (HINT ignored)';

--@queryplan
select /*+ recompile ordered use_hash */
  decr (a.c2)
from t_click_counter a, t_click_counter b, t_filter c
where a.c1 = b.c1 and a.c1 = c.c1;


evaluate 'Case 4: WITH DECREMENT FOR used -> hash join must not be performed (HINT ignored)';

--@queryplan
select /*+ recompile ordered use_hash */
  a.c2
from t_click_counter a, t_click_counter b, t_filter c
where a.c1 = b.c1 and a.c1 = c.c1
with decrement for a.c2;


--
-- clean up test data
--

drop table t_click_counter, t_filter;
