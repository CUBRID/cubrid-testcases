/**
 *  This test case verifies CBRD-28413: a prepared IN subquery that becomes a semi join reads its host variable
 *  in the type its value is bound in, with no debug assertion in expr_k_hostvar ()
 *
 *  The statement is prepared before its values are bound. The equality substitution of the semi join puts the
 *  host variable into the CASE of the subquery condition, where it reads the value as a string.
 *
 *  Coverage:
 *  Case 1:  the literal form of the query returns the row of t_outer
 *  Case 2:  the prepared form with an INTEGER and a DOUBLE value returns the same row
 *  Case 3:  the prepared form with a DOUBLE and an INTEGER value returns the same row
 *  Case 4:  the prepared form with a VARCHAR first value that converts to a number returns the same row
 */
drop table if exists t_outer, t_inner;
create table t_outer (c0 double);
create table t_inner (c0 double, c1 double);
insert into t_outer values (1);
insert into t_inner values (0.5, NULL);

evaluate 'Case 1: the literal form returns the row of t_outer; result = 1 row';
select * from t_outer where (1 in (select t_inner.c1 from t_inner where (case when t_inner.c1 = t_outer.c0 then t_inner.c1 else 0.31 end) <> t_inner.c0)) union all select * from t_outer;

evaluate 'Case 2: the prepared form with an INTEGER and a DOUBLE value returns the same row; result = 1 row';
$int, $1, $double, $0.31
select * from t_outer where (? in (select t_inner.c1 from t_inner where (case when t_inner.c1 = t_outer.c0 then t_inner.c1 else ? end) <> t_inner.c0)) union all select * from t_outer;

evaluate 'Case 3: the prepared form with a DOUBLE and an INTEGER value returns the same row; result = 1 row';
$double, $1.0, $int, $2
select * from t_outer where (? in (select t_inner.c1 from t_inner where (case when t_inner.c1 = t_outer.c0 then t_inner.c1 else ? end) <> t_inner.c0)) union all select * from t_outer;

evaluate 'Case 4: the prepared form with a VARCHAR first value that converts to a number returns the same row; result = 1 row';
$varchar, $1, $double, $0.31
select * from t_outer where (? in (select t_inner.c1 from t_inner where (case when t_inner.c1 = t_outer.c0 then t_inner.c1 else ? end) <> t_inner.c0)) union all select * from t_outer;

drop table t_outer, t_inner;
