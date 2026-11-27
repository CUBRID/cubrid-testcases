/**
 *  This test case verifies CBRD-28222: a view over a constant-false CTE or derived table stores it as (null),
 *  so every query of the view fails with a syntax error
 *
 *  CREATE VIEW stores the query printed after its type checking, which folds constants. A CTE definition or
 *  a derived table that returns no row is folded to a NULL value, and it was printed as (null), which the
 *  grammar does not take in place of a query. It is now printed as an empty query of as many columns. The
 *  cases check the stored definition of each view and that the view returns the rows of the same query
 *  run without it.
 *
 *  Coverage:
 *    Case 1: a CTE folded by a false WHERE, read by the view query or by one operand of a UNION ALL
 *    Case 2: a CTE of several columns folded by a false WHERE or HAVING, and a recursive CTE whose
 *            non-recursive part is folded
 *    Case 3: a folded CTE inside a scalar subquery and a folded CTE read by a scalar subquery
 *    Case 4: a derived table folded alone, with several columns and ORDER BY, and joined with a table
 *    Case 5: CREATE OR REPLACE VIEW and ALTER VIEW with a folded CTE
 *    Case 6: a user other than the owner reads the views
 *    Case 7: the queries of Case 1 to Case 4 return the same rows without a view
 */

drop view if exists v28222_01, v28222_02, v28222_03, v28222_04, v28222_05, v28222_06, v28222_07;
drop view if exists v28222_08, v28222_09, v28222_10, v28222_11;
drop table if exists t28222_a, t28222_b;
drop user u28222;

create table t28222_a (s varchar(10), n int);
insert into t28222_a values ('a', 1);
create table t28222_b (s varchar(10));
insert into t28222_b values ('b'), ('b'), ('c');

evaluate 'Case 1: a CTE folded by a false WHERE, read by the view query or by one operand of a UNION ALL';
create view v28222_01 as with c as (select s from t28222_a where 1 = 0) select s from c;
create view v28222_02 as with c as (select s from t28222_a where 1 = 0) (select s x from c) union all (select s from t28222_b);
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28222_01', 'v28222_02') order by 1;
select count(*) from v28222_01;
select s from v28222_01;
select * from v28222_02 order by 1;

evaluate 'Case 2: a CTE of several columns folded by a false WHERE or HAVING, and a folded recursive CTE';
create view v28222_03 as with c as (select s, n, n + 1 m from t28222_a where 1 = 0) select s, n, m from c;
create view v28222_04 as with c as (select n, count(*) k from t28222_a group by n having 1 = 0) select n, k from c;
create view v28222_05 as with recursive c (k) as (select n from t28222_a where 1 = 0 union all select k + 1 from c where k < 3) select k from c;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28222_03', 'v28222_04', 'v28222_05') order by 1;
select s, n, m from v28222_03;
select n, k from v28222_04;
select k from v28222_05;

evaluate 'Case 3: a folded CTE inside a scalar subquery and a folded CTE read by a scalar subquery';
create view v28222_06 as select (with c as (select s from t28222_a where 1 = 0) select max(s) from c) m from db_root;
create view v28222_07 as with c as (select s from t28222_a where 1 = 0) select coalesce ((select s from c), 'k') k from db_root;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28222_06', 'v28222_07') order by 1;
select m from v28222_06;
select k from v28222_07;

evaluate 'Case 4: a derived table folded alone, with several columns and ORDER BY, and joined with a table';
create view v28222_08 as select s from (select s from t28222_a where 1 = 0) x;
create view v28222_09 as select x.a, x.b from (select s a, n b from t28222_a where 1 = 0 order by 1) x;
create view v28222_10 as select t28222_b.s, x.s xs from (select s from t28222_a where 1 = 0) x, t28222_b;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28222_08', 'v28222_09', 'v28222_10') order by 1;
select count(*) from v28222_08;
select a, b from v28222_09;
select s, xs from v28222_10;

evaluate 'Case 5: CREATE OR REPLACE VIEW and ALTER VIEW with a folded CTE';
create view v28222_11 as select s from t28222_b;
create or replace view v28222_11 as with c as (select s from t28222_a where 1 = 0) select s from c union all select s from t28222_b;
select s from v28222_11 order by 1;
alter view v28222_11 as with c as (select s from t28222_a where 0 <> 0) select s from c;
select vclass_name, vclass_def from db_vclass where vclass_name = 'v28222_11';
select count(*) from v28222_11;

evaluate 'Case 6: a user other than the owner reads the views';
create user u28222;
grant select on v28222_01 to u28222;
grant select on v28222_08 to u28222;
call login ('u28222', '') on class db_user;
select count(*) from dba.v28222_01;
select count(*) from dba.v28222_08;
call login ('dba', '') on class db_user;

evaluate 'Case 7: the queries of Case 1 to Case 4 return the same rows without a view';
with c as (select s from t28222_a where 1 = 0) select s from c;
with c as (select s from t28222_a where 1 = 0) (select s x from c) union all (select s from t28222_b) order by 1;
with recursive c (k) as (select n from t28222_a where 1 = 0 union all select k + 1 from c where k < 3) select k from c;
select (with c as (select s from t28222_a where 1 = 0) select max(s) from c) m from db_root;
with c as (select s from t28222_a where 1 = 0) select coalesce ((select s from c), 'k') k from db_root;
select t28222_b.s, x.s xs from (select s from t28222_a where 1 = 0) x, t28222_b;

drop user u28222;
drop view v28222_01, v28222_02, v28222_03, v28222_04, v28222_05, v28222_06, v28222_07;
drop view v28222_08, v28222_09, v28222_10, v28222_11;
drop table t28222_a, t28222_b;
