/**
 *  This test case verifies CBRD-27955: a printf conversion such as %n or %s that stays in the statement text as a
 *  literal crashed a debug server when the query went through the parallel query executor (UNION ALL and the like).
 *  The debug dump of the XASL tree there logged the statement text as the format string of the error log, so vfprintf
 *  read arguments that were not there (%s) or wrote through them (%n). Now the text is an argument of "%s".
 *  A release server never makes that dump, so on it the queries pass with or without the fix.
 *
 *  Coverage:
 *    Case 1: %n in the LIKE and NOT LIKE patterns of the arms of a UNION ALL (the issue's query)
 *    Case 2: %s and %d in a string literal of a select list of a UNION ALL arm
 *    Case 3: a query with no set operation and the same patterns (it never took the dump path)
 */

drop table if exists t_27955;

create table t_27955 (c varchar (20));
insert into t_27955 values ('a'), ('%n'), ('b%s');

evaluate 'Case 1: %n in the LIKE and NOT LIKE patterns of UNION ALL arms';
select c from t_27955 where c like '%n%n%n%n' union all select c from t_27955 where c not like '%n%n%n%n' order by 1;

evaluate 'Case 2: %s and %d in a select list literal of a UNION ALL arm';
select c, '%s%s%s%s%d' as fmt from t_27955 where c = 'a' union all select c, 'x' from t_27955 where c not like 'a%' order by 1;

evaluate 'Case 3: no set operation';
select count (*) from t_27955 where c not like '%n%n%n%n';

drop table t_27955;
