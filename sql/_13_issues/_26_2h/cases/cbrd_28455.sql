/**
 *  This test case verifies CBRD-28455: an IN or = ANY subquery whose WHERE folds to an empty range, as the first or a
 *  middle operand of an OR, folded the whole OR to false and the query returned no row
 *
 *  The fold of a predicate over a subquery that returns no row to TRUE or FALSE dropped the rest of the OR that hangs
 *  on the predicate in the normalized search condition. FALSE now drops out of the OR and the rest of it stays, and
 *  TRUE still takes the whole OR. The inverted bounds of the subquery are found only by the optimizer, after the OR
 *  is normalized - a literal false WHERE folds earlier and was right before the fix.
 *
 *  Coverage:
 *    Case 1:  IN over an empty range as the first operand of OR keeps the other operand
 *    Case 2:  = ANY over an empty range as the first operand of OR keeps the other operand
 *    Case 3:  IN over an empty AND of bounds as the first operand of OR keeps the other operand
 *    Case 4:  NOT over an AND with NOT IN over an empty range keeps the other operand
 *    Case 5:  IN over an empty range as a middle operand of OR keeps the operands after it
 *    Case 6:  IN over an empty range as the last operand of OR, and over a literal false WHERE, as before
 *    Case 7:  NOT IN and greater than ALL over an empty range take the whole OR, as before
 *    Case 8:  the same OR in HAVING keeps the other operand
 *    Case 9:  the same OR in the WHERE of UPDATE and DELETE keeps the other operand
 *    Case 10: the same OR in a prepared statement with bound bounds, as before
 */
drop table if exists t_out, t_sub, t_dml;
create table t_out (c double);
insert into t_out values (1), (2), (null);
-- t_sub is read only by the subqueries, never joined
create table t_sub (c double);
insert into t_sub values (1), (4), (7);

evaluate 'Case 1: IN over an empty range as the first operand of OR keeps the other operand; result = 2';
select count(*) from t_out o where o.c in (select c from t_sub where c between 5 and 3) or o.c > 0;

evaluate 'Case 2: = ANY over an empty range as the first operand of OR keeps the other operand; result = 2';
select count(*) from t_out o where o.c = any (select c from t_sub where c between 5 and 3) or o.c > 0;

evaluate 'Case 3: IN over an empty AND of bounds as the first operand of OR keeps the other operand; result = 2';
select count(*) from t_out o where o.c in (select c from t_sub where c > 5 and c < 3) or o.c > 0;

evaluate 'Case 4: NOT over an AND with NOT IN over an empty range keeps the other operand; result = 2';
select count(*) from t_out o where not (o.c not in (select c from t_sub where c between 5 and 3) and o.c <> o.c);

evaluate 'Case 5: IN over an empty range as a middle operand of OR keeps the operands after it; result = 2';
-- expressions over the column, so that the two other operands do not merge into one range of o.c ahead of the IN
select count(*) from t_out o where o.c + 0 > 5 or o.c in (select c from t_sub where c between 5 and 3) or o.c + 0 > 0;

evaluate 'Case 6: IN over an empty range as the last operand of OR, and over a literal false WHERE; result = 2, 2';
select count(*) from t_out o where o.c > 0 or o.c in (select c from t_sub where c between 5 and 3);
select count(*) from t_out o where o.c in (select c from t_sub where 1 = 0) or o.c > 0;

evaluate 'Case 7: NOT IN and greater than ALL over an empty range take the whole OR; result = 3, 3';
select count(*) from t_out o where o.c not in (select c from t_sub where c between 5 and 3) or o.c > 5;
select count(*) from t_out o where o.c > all (select c from t_sub where c between 5 and 3) or o.c > 5;

evaluate 'Case 8: the same OR in HAVING keeps the other operand; result = 3 groups';
select c, count(*) from t_out group by c having c in (select c from t_sub where c between 5 and 3) or count(*) > 0 order by 1;

evaluate 'Case 9: the same OR in the WHERE of UPDATE and DELETE keeps the other operand; result = 2 rows each';
create table t_dml (c double);
insert into t_dml select c from t_out;
update t_dml set c = c + 10 where c in (select c from t_sub where c between 5 and 3) or c > 0;
select c from t_dml order by 1;
delete from t_dml where c in (select c from t_sub where c between 5 and 3) or c > 10;
select c from t_dml order by 1;

evaluate 'Case 10: the same OR in a prepared statement with bound bounds, as before; result = 2';
prepare q_or from 'select count(*) from t_out o where o.c in (select c from t_sub where c between ? and ?) or o.c > ?';
execute q_or using 5, 3, 0;
deallocate prepare q_or;

drop table t_out, t_sub, t_dml;
