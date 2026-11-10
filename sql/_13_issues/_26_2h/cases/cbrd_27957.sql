/**
 *  This test case verifies CBRD-27957: EXISTS over a subquery that always returns no row was folded to a value whose
 *  type was NULL while the value itself was 0. The value printed as null, so the XASL cache key of the query was that
 *  of the same query with a real NULL in that place (c0 <= NULL), and one of the two queries ran the plan of the
 *  other. The value also looked NULL in a select list while IS NULL said it was not. Now such an EXISTS has the
 *  logical type and folds to 0, and a set operation that folds to no row (both arms always false) counts as such a
 *  subquery too, so EXISTS over it is false, and NOT EXISTS and NOT IN over it are true.
 *
 *  Coverage:
 *    Case 1: the issue's queries in the order Q1, Q2, Q3: each gives its own result
 *    Case 2: the same pair in the other order
 *    Case 3: the value of the folded EXISTS, IS NULL, IS FALSE, TYPEOF
 *    Case 4: EXISTS, NOT EXISTS and NOT IN over a UNION ALL whose arms are both always false
 *    Case 5: EXISTS that is not folded (control)
 */

drop table if exists t_27957;

create table t_27957 (c0 double);
insert into t_27957 values (1), (2), (3);

evaluate 'Case 1: EXISTS over an always false subquery, then a comparison with NULL';
select (case when ((exists (select 1 from t_27957 where ('a' <> 'a'))) is null) then 1 else 0 end) as a from t_27957;
select (case when ((t_27957.c0 <= null) is null) then 1 else 0 end) as a from t_27957;
select /*+ RECOMPILE */ (case when ((t_27957.c0 <= null) is null) then 1 else 0 end) as a from t_27957;

evaluate 'Case 2: the other order';
select (case when ((t_27957.c0 > null) is false) then 1 else 0 end) as a from t_27957;
select (case when ((exists (select 1 from t_27957 where ('b' <> 'b'))) is false) then 1 else 0 end) as a from t_27957;

evaluate 'Case 3: the value of the folded EXISTS';
select (exists (select 1 from t_27957 where ('a' <> 'a'))) as e,
       ((exists (select 1 from t_27957 where ('a' <> 'a'))) is null) as e_is_null,
       ((exists (select 1 from t_27957 where ('a' <> 'a'))) is false) as e_is_false,
       typeof ((exists (select 1 from t_27957 where ('a' <> 'a')))) as t
  from t_27957 where c0 = 1;

evaluate 'Case 4: a UNION ALL whose arms are both always false';
select (exists (select 1 from t_27957 where 'a' <> 'a' union all select 1 from t_27957 where 'b' <> 'b')) as e from t_27957 where c0 = 1;
select count (*) from t_27957 where exists (select 1 from t_27957 where 'a' <> 'a' union all select 1 from t_27957 where 'b' <> 'b');
select count (*) from t_27957 where not exists (select 1 from t_27957 where 'a' <> 'a' union all select 1 from t_27957 where 'b' <> 'b');
select count (*) from t_27957 where c0 not in (select c0 from t_27957 where 'a' <> 'a' union all select c0 from t_27957 where 'b' <> 'b');
select (c0 not in (select c0 from t_27957 where 'a' <> 'a' union all select c0 from t_27957 where 'b' <> 'b')) as ni from t_27957 where c0 = 1;

evaluate 'Case 5: EXISTS that is not folded';
select (exists (select 1 from t_27957 x where x.c0 > t_27957.c0)) as e from t_27957 order by c0;
select count (*) from t_27957 where not exists (select 1 from t_27957 where c0 > 5);

drop table t_27957;
