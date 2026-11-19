/**
 *  This test case verifies CBRD-27616: a WHERE condition that combines a path
 *  expression with the inner table of a LEFT JOIN returns only the rows where
 *  it is true
 *
 *  An OR of a path condition and an inner-table condition is evaluated after
 *  the join. Before the fix, the fetch of the path value dropped such a
 *  condition, so every row came out. An IS NULL on an inner-table path becomes
 *  the same kind of OR and did the same. When another inner-table condition was
 *  ANDed to the OR, the OR was evaluated at the join before the path value was
 *  fetched, with the value of the previous fetch. Now the OR is evaluated after
 *  the fetch in all three forms. Cases 6 and 7 check the third form on a row
 *  that the join pads with NULL, and Case 7 on a path of two steps.
 *
 *  Coverage:
 *    Case 1:  x.r.a = 3 alone returns 2, y.a = 99 alone returns nothing, and
 *             their OR returns 2
 *    Case 2:  y.r.a IS NULL returns 1 and 3, the rows whose path value is NULL
 *    Case 3:  (x.r.a = 3 OR y.a = 99) AND COALESCE (y.a, 0) >= 0 returns 2
 *    Case 4:  an UPDATE with x.r.a = 3 OR y.a = 99 changes only row 2
 *    Case 5:  a DELETE with x.r.a = 3 OR y.a = 99 deletes only row 12
 *    Case 6:  (x.r.a = 3 OR y.a IS NULL) AND COALESCE (y.a, 0) >= 0 returns 1
 *             and 2, with the padded row 1
 *    Case 7:  (y.r.r.a = 6 OR y.a IS NULL) AND COALESCE (y.a, 0) >= 0 returns 1
 *             and 5, after both fetches of the path
 */

drop table if exists t_ref;
create table t_ref (a int, r t_ref) dont_reuse_oid;
insert into t_ref values (1, null);
insert into t_ref (a, r) values (2, insert into t_ref (a) values (3));

evaluate 'Case 1: a path condition OR an inner-table condition returns the union of the two; result = 2, none, 2';
select x.a from t_ref x left join t_ref y on x.a = y.a where x.r.a = 3 order by 1;
select x.a from t_ref x left join t_ref y on x.a = y.a where y.a = 99 order by 1;
--@queryplan
select x.a from t_ref x left join t_ref y on x.a = y.a where x.r.a = 3 or y.a = 99 order by 1;

evaluate 'Case 2: an IS NULL on an inner-table path returns the rows whose path value is NULL; result = 1, 3';
--@queryplan
select x.a from t_ref x left join t_ref y on x.a = y.a where y.r.a is null order by 1;

evaluate 'Case 3: (x.r.a = 3 OR y.a = 99) ANDed with an inner-table condition returns the row whose path value is 3; result = 2';
--@queryplan
select x.a from t_ref x left join t_ref y on x.a = y.a where (x.r.a = 3 or y.a = 99) and coalesce (y.a, 0) >= 0 order by 1;

evaluate 'Case 4: an UPDATE with x.r.a = 3 OR y.a = 99 changes only row 2; result = 1, 3, 12';
update t_ref x left join t_ref y on x.a = y.a set x.a = x.a + 10 where x.r.a = 3 or y.a = 99;
select a from t_ref order by 1;

-- Case 5 deletes the row that Case 4 changed to 12
evaluate 'Case 5: a DELETE with x.r.a = 3 OR y.a = 99 deletes only row 12; result = 1, 3';
delete x from t_ref x left join t_ref y on x.a = y.a where x.r.a = 3 or y.a = 99;
select a from t_ref order by 1;

-- Cases 6 and 7 join on y.a = x.a - 1, so row 1 has no match and the LEFT JOIN pads it with NULL
drop table if exists t_chain;
create table t_chain (a int, r t_chain) dont_reuse_oid;
insert into t_chain values (1, null);
insert into t_chain (a, r) values (2, insert into t_chain (a) values (3));
insert into t_chain (a, r) values (4, insert into t_chain (a, r) values (5, insert into t_chain (a) values (6)));

evaluate 'Case 6: (x.r.a = 3 OR y.a IS NULL) ANDed with an inner-table condition keeps the row that the join pads with NULL and the row whose path value is 3; result = 1, 2';
select x.a from t_chain x left join t_chain y on y.a = x.a - 1 where (x.r.a = 3 or y.a is null) and coalesce (y.a, 0) >= 0 order by 1;

evaluate 'Case 7: (y.r.r.a = 6 OR y.a IS NULL) ANDed with an inner-table condition is evaluated after both fetches of the path; result = 1, 5';
--@queryplan
select x.a from t_chain x left join t_chain y on y.a = x.a - 1 where (y.r.r.a = 6 or y.a is null) and coalesce (y.a, 0) >= 0 order by 1;

drop table t_ref, t_chain;
