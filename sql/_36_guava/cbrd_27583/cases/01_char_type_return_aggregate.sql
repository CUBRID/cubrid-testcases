/**
 *  This test case verifies CBRD-27583: a stored function that returns a CHAR column's
 *  type gives MIN, MAX and COUNT DISTINCT a CHAR value in every query shape.
 *
 *  Before the change the value of such a function was compared as VARCHAR when MIN or MAX
 *  had no GROUP BY, so of two values that differ only in trailing spaces the longer one
 *  won, while GROUP BY and the analytic form compared them as CHAR.
 *  Now the value converts into the declared return type wherever it is read, so every
 *  shape compares as CHAR (specification change 22).
 *
 *  Judged by the literal results, the trailing spaces shown by the appended bar: every
 *  MAX is the two letter value and COUNT DISTINCT counts two values.
 *  Before the change the MAX of Case 1 answered the value that has the trailing space.
 *
 *  Coverage:
 *    Case 1:  MAX, MIN, COUNT DISTINCT and TYPEOF without GROUP BY
 *    Case 2:  the same with GROUP BY and HAVING
 *    Case 3:  the analytic MAX and MAX over a derived table
 *    Case 4:  GROUP BY on the function value and GROUP_CONCAT DISTINCT
 */

drop table if exists t_char;

-- three values, two of them equal as CHAR (trailing space only), so a VARCHAR comparison changes every answer
create table t_char (c char(5), v varchar(5), d double);
insert into t_char values ('ab', 'ab', 1), ('ab ', 'ab ', 2), ('aa', 'aa', 3);
create or replace function f_char_type (p varchar) return t_char.c%TYPE as begin return p; end;


evaluate 'Case 1: MAX, MIN, COUNT DISTINCT and TYPEOF without GROUP BY compare as CHAR';
select max (f_char_type (v)) || '|', min (f_char_type (v)) || '|', count (distinct f_char_type (v)), typeof (max (f_char_type (v))) from t_char;


evaluate 'Case 2: the same with GROUP BY and HAVING';
select max (f_char_type (v)) || '|', min (f_char_type (v)) || '|', count (distinct f_char_type (v)) from t_char group by c is null having count (*) > 0;


evaluate 'Case 3: the analytic MAX and MAX over a derived table';
select m || '|' from (select d, max (f_char_type (v)) over () m from t_char) dt where d = 1;
select max (x) || '|', count (distinct x) from (select f_char_type (v) x from t_char) dt;


evaluate 'Case 4: GROUP BY on the function value and GROUP_CONCAT DISTINCT';
select count (*) from (select f_char_type (v) x from t_char group by f_char_type (v)) dt;
select group_concat (distinct f_char_type (v) order by 1) from t_char;

drop function f_char_type;
drop table t_char;
