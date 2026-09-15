/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: during-join predicates with parallel hash join
 * Description: Parallel hash join must work correctly with various during-join predicate expressions - regexp, PL/CSQL functions (INNER JOIN parallel-capable, LEFT OUTER JOIN not), bind variables, and user-defined variables.
 * Coverage: PR#6628(1) pre-evaluation of during-join terms that are NOT a plain column reference
 *           (not a PT_NAME node): PL/CSQL functions, regexp, bind and user variables. The fix flipped
 *           the test from an enumeration (pt_is_expr_node || pt_is_function) to its complement
 *           (!pt_is_name_node), so node kinds outside those two stop being skipped.
 *           A/C: parallel result == serial
 * Note: Case 4 needs a SECOND answer file, cbrd_25717_during_join_predicates.answer_cci.
 *           Case 4 puts "--@queryplan" in front of a PREPARE statement. The CTP CCI runner
 *           (sql_by_cci/execute.c) emits a query plan only for SELECT / CALL / EVALUATE /
 *           GET_STATS and for UPDATE / DELETE - every other statement type falls through to a
 *           branch that prints just the affected-row count, so the directive is silently ignored
 *           for PREPARE. The JDBC runner (ConsoleDAO.java) calls getQueryplan() whenever the
 *           directive is set, regardless of statement type, and does print it. The _cci answer is
 *           therefore the same file minus Case 4's plan block. This is a CTP runner limitation,
 *           not a product difference - drop the extra answer file once CTP is fixed.
 * Source: JIRA attachment cbrd-25717_test-case_20260811.zip (adapted)
 */

-- test data

drop table if exists t_during;

create table t_during (id int, filter varchar);
create index t_during_id on t_during (id);

create or replace function is_factorial (n int) return int
as begin
  if n in (1, 2, 6, 24, 120, 720, 5040, 40320) then
    return n; -- true
  else
    return NULL; -- false
  end if;
end;

insert into t_during
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum, md5 (rownum) from cte a, cte b limit 100000;

update statistics on t_during;

set system parameters 'max_hash_list_scan_size=256k';

set trace on;


evaluate 'Case 1: regular expression (RLIKE) in during-join predicate';

--@queryplan
select /*+ recompile
           no_push_pred
           no_parallel_scan
           no_parallel_subquery */
  *
from (
    select /*+ recompile
               no_merge
               use_hash
               no_parallel_scan
               no_parallel_subquery */
      a.id as a_id, a.filter as a_filter,
      b.id as b_id, b.filter as b_filter
    from
      t_during a
      left outer join t_during b on a.id = b.id and a.filter rlike '^1234'
  )
where b_id is not null
order by a_id desc;


show trace;


evaluate 'Case 2: PL/CSQL function in during-join predicate (INNER JOIN)';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery */
  *
from
  t_during a,
  t_during b
where
  a.id = is_factorial (b.id)
order by a.id desc;


show trace;


evaluate 'Case 3: PL/CSQL function in during-join predicate (LEFT OUTER JOIN)';

--@queryplan
select /*+ recompile
           no_push_pred
           no_parallel_scan
           no_parallel_subquery */
  *
from (
    select /*+ recompile
               no_merge
               use_hash
               no_parallel_scan
               no_parallel_subquery */
      a.id as a_id, a.filter as a_filter,
      b.id as b_id, b.filter as b_filter
    from
      t_during a
      left outer join t_during b on a.id = b.id and is_factorial (a.id) = 1
  )
where b_id is not null
order by a_id desc;


show trace;


evaluate 'Case 4: bind (host) variables in during-join predicate';

--@queryplan
prepare q from '
select /*+ no_push_pred
           no_parallel_scan
           no_parallel_subquery */
  *
from (
    select /*+ recompile
               no_merge
               use_hash
               no_parallel_scan
               no_parallel_subquery */
      a.id as a_id, a.filter as a_filter,
      b.id as b_id, b.filter as b_filter
    from
      t_during a
      left outer join t_during b on a.id = b.id and a.id > ? and a.filter > ''ffff'' and a.id < ?
  )
where b_id is not null
order by a_id desc
';


execute q using 30000, 60000;


show trace;


evaluate 'Case 5: user-defined variables in during-join predicate';

SET @filter_id = 70000;

--@queryplan
select /*+ recompile
           no_push_pred
           no_parallel_scan
           no_parallel_subquery */
  *
from (
    select /*+ recompile
               no_merge
               use_hash
               no_parallel_scan
               no_parallel_subquery */
      a.id as a_id, a.filter as a_filter,
      b.id as b_id, b.filter as b_filter,
      @filter_id as filter_id
    from
      t_during a
      left outer join t_during b on a.id = b.id and a.id = @filter_id
  )
where b_id is not null
order by a_id desc;


show trace;


-- clean up test data

set trace off;

set system parameters 'max_hash_list_scan_size=default';

drop table t_during;
drop function is_factorial;
drop variable @filter_id;
