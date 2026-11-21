/**
 *  This test case verifies CBRD-28135: DELETE with a parenthesized list of two or more tables in a table spec is
 *  rejected instead of crashing the client
 *
 *  Bug: DELETE FROM (ta, tb) ... or DELETE ta FROM (ta, tb) ... crashed the client (csql or CAS) while the statement
 *  was compiled. Fix: the parser raises 'Parenthesized table list' is not allowed here. One table in parentheses,
 *  plain and multi-table DELETE, and SELECT and UPDATE over a parenthesized list keep working.
 *
 *  Coverage:
 *    Case 1:  single-table DELETE FROM (ta, tb) fails with the error and the session keeps working
 *    Case 2:  multi-table DELETE ta FROM (ta, tb) fails with the error
 *    Case 3:  a list of three tables fails with the error
 *    Case 4:  DELETE FROM (ta, tb) ... LIMIT 1 fails with the error
 *    Case 5:  no row was deleted by the rejected statements
 *    Case 6:  SELECT and UPDATE over (ta, tb) keep working
 *    Case 7:  DELETE FROM (ta) and plain DELETE keep working
 *    Case 8:  multi-table DELETE ta, tb FROM ta, tb keeps working
 */

drop table if exists ta, tb, tc;
create table ta (a int, b int);
create table tb (a int, b int);
create table tc (a int, b int);
insert into ta values (1, 99), (2, 99), (3, 1);
insert into tb values (1, 99), (2, 1);
insert into tc values (1, 99);

select 'Case 1: single-table DELETE FROM (ta, tb) fails with the error and the session keeps working' from db_root;
delete from (ta, tb) where b = 99;
select count(*) from ta;

select 'Case 2: multi-table DELETE ta FROM (ta, tb) fails with the error' from db_root;
delete ta from (ta, tb) where b = 99;
select count(*) from ta;

select 'Case 3: a list of three tables fails with the error' from db_root;
delete from (ta, tb, tc) where b = 99;
select count(*) from tc;

select 'Case 4: DELETE FROM (ta, tb) ... LIMIT 1 fails with the error' from db_root;
delete from (ta, tb) where b = 99 limit 1;
select count(*) from tb;

select 'Case 5: no row was deleted by the rejected statements' from db_root;
select (select count(*) from ta), (select count(*) from tb), (select count(*) from tc) from db_root;

select 'Case 6: SELECT and UPDATE over (ta, tb) keep working' from db_root;
select a, b from (ta, tb) where b = 99 order by a, b;
update (ta, tb) set b = b + 1 where b = 99;
select a, b from (ta, tb) where b = 100 order by a, b;
update (ta, tb) set b = b - 1 where b = 100;

select 'Case 7: DELETE FROM (ta) and plain DELETE keep working' from db_root;
delete from (ta) where b = 99;
select a, b from ta order by a;
insert into ta values (1, 99), (2, 99);
delete from ta where a = 2;
select a, b from ta order by a;

select 'Case 8: multi-table DELETE ta, tb FROM ta, tb keeps working' from db_root;
delete ta, tb from ta, tb where ta.b = tb.b and ta.b = 99;
select a, b from ta order by a;
select a, b from tb order by a;

drop table ta, tb, tc;
