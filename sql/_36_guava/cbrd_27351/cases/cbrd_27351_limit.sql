/**
 * This test case verifies CBRD-27351: a view referenced more than once in a query is executed once
 * Scenario file: many references of a view
 * Description: At most 64 references of views are considered in a statement; the others execute the view as
 *              before. The result is unchanged.
 * Coverage: 65 references of a view (one UNION operand each)
 */

--
-- test data
--

drop view if exists v_27351_one;
drop table if exists t_27351_li;

create table t_27351_li (l_suppkey int, l_price int);
insert into t_27351_li select mod(level, 20) + 1, level from db_root connect by level <= 200;

create view v_27351_one (k) as select max(l_suppkey) from t_27351_li;

evaluate 'L1: 65 references of one view, the first 64 share one result';
set trace on;
select /*+ recompile parallel(0) */ k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one
union
select k from v_27351_one;
show trace;
set trace off;

--
-- clean up test data
--

drop view v_27351_one;
drop table t_27351_li;
