/**
 *  This test case verifies CBRD-28224: a subquery folded by constant folding is stored in a view definition
 *  so that it cannot be parsed again or reads back wrong
 *
 *  CREATE VIEW stores the query printed after its type checking, which folds constants. A set operation
 *  with a constant-false operand is folded to its remaining operand, which kept the mark of a set operation
 *  operand and was printed without the parentheses of its subquery. A subquery that returns no row is
 *  folded to a NULL value, and an IN, NOT IN, EXISTS, ALL or SOME over it, folded to a constant, was
 *  printed as the expression it came from, with the subquery printed as null. A scalar subquery folded so
 *  printed as an empty string in the select list of a view. The cases check the stored definition of each
 *  view and that the view returns the rows of the same query run without it.
 *
 *  Coverage:
 *    Case 1:  a scalar subquery whose set operation folds to one operand keeps its parentheses
 *    Case 2:  an IN, EXISTS or ANY subquery whose set operation folds to one operand keeps its parentheses
 *    Case 3:  a UNION or EXCEPT without ALL folded to one operand keeps its parentheses and DISTINCT
 *    Case 4:  a folded set operation in a derived table, a CTE or the view query itself is stored as before
 *    Case 5:  the queries of Case 1 and Case 2 return the same rows without a view
 *    Case 6:  a WHERE or ON folded to NULL is stored as null and parsed again (fixed by CBRD-28029)
 *    Case 7:  IN, NOT IN, ALL and SOME over a subquery that returns no row are stored as constants
 *    Case 8:  NOT EXISTS and NOT IN over a subquery that returns no row keep every row
 *    Case 9:  a scalar subquery that returns no row is stored as null, not as an empty string
 *    Case 10: a value of another type folded from an expression over an empty subquery reads back the same
 *    Case 11: the queries of Case 7 to Case 10 return the same rows without a view
 */

drop view if exists v28224_01, v28224_02, v28224_03, v28224_04, v28224_05, v28224_06, v28224_07, v28224_08;
drop view if exists v28224_09, v28224_10, v28224_11, v28224_12, v28224_13, v28224_14, v28224_15;
drop view if exists v28224_n1, v28224_n2, v28224_n3;
drop view if exists v28224_f01, v28224_f02, v28224_f03, v28224_f04, v28224_f05, v28224_f06, v28224_f07;
drop view if exists v28224_f08, v28224_f09, v28224_f10, v28224_f11, v28224_f12, v28224_f13, v28224_f14;
drop view if exists v28224_d1, v28224_d2, v28224_d3, v28224_d4, v28224_d5, v28224_d6;
drop table if exists t28224, t28224_b, t28224_c;

create table t28224 (a int);
insert into t28224 values (1), (1), (2);
create table t28224_b (a int, b int);
insert into t28224_b values (1, 1), (2, null);
create table t28224_c (a int, b int);
insert into t28224_c values (1, 1), (2, null), (null, 3);

evaluate 'Case 1: a scalar subquery whose set operation folds to one operand keeps its parentheses';
create view v28224_01 as select (select max(a) from t28224 union all select 1 from db_root where 1=0) m from db_root;
create view v28224_02 as select (select 1 from db_root where 1=0 union all select max(a) from t28224) m from db_root;
create view v28224_09 as select (select a from t28224 union all select 9 from db_root where 1=0 order by 1 desc limit 1) m from db_root;
create view v28224_10 as select u1.a, (select max(u2.a) from t28224 u2 where u2.a = u1.a union all select 9 from db_root where 1=0) m from t28224 u1;
create view v28224_11 as select (select a from t28224 where a = 2 union all select 9 from db_root where 1=0 union all select 8 from db_root where 1=0) m from db_root;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_01', 'v28224_02', 'v28224_09', 'v28224_10', 'v28224_11') order by 1;
select m from v28224_01;
select m from v28224_02;
select m from v28224_09;
select a, m from v28224_10 order by 1;
select m from v28224_11;

evaluate 'Case 2: an IN, EXISTS or ANY subquery whose set operation folds to one operand keeps its parentheses';
create view v28224_03 as select a from t28224 where a in (select a from t28224 union all select 1 from db_root where 1=0);
create view v28224_04 as select a from t28224 u where exists (select 1 from t28224 v where v.a = u.a + 1 union all select 1 from db_root where 1=0);
create view v28224_05 as select a from t28224 where a = any (select a from t28224 union all select 9 from db_root where 1=0);
-- the inner set operation folds to its second operand inside the outer one
create view v28224_12 as select a from t28224 where a in (select a from t28224 union all (select 9 from db_root where 1=0 union all select 2 from db_root));
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_03', 'v28224_04', 'v28224_05', 'v28224_12') order by 1;
select a from v28224_03 order by 1;
select a from v28224_04 order by 1;
select a from v28224_05 order by 1;
select a from v28224_12 order by 1;

evaluate 'Case 3: a UNION or EXCEPT without ALL folded to one operand keeps its parentheses and DISTINCT';
create view v28224_06 as select a from t28224 where a in (select a from t28224 union select 9 from db_root where 1=0);
create view v28224_07 as select a from t28224 where a in (select a from t28224 except select 9 from db_root where 1=0);
create view v28224_08 as select (select count(*) from (select a from t28224 union select 9 from db_root where 1=0) d) c from db_root;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_06', 'v28224_07', 'v28224_08') order by 1;
select a from v28224_06 order by 1;
select a from v28224_07 order by 1;
select c from v28224_08;

evaluate 'Case 4: a folded set operation in a derived table, a CTE or the view query itself is stored as before';
create view v28224_13 as select * from (select a from t28224 union all select 9 from db_root where 1=0) t;
create view v28224_14 as with c as (select a from t28224 union all select 9 from db_root where 1=0) select * from c;
create view v28224_15 as select a from t28224 union all select 9 from db_root where 1=0;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_13', 'v28224_14', 'v28224_15') order by 1;
select a from v28224_13 order by 1;
select a from v28224_14 order by 1;
select a from v28224_15 order by 1;

evaluate 'Case 5: the queries of Case 1 and Case 2 return the same rows without a view';
select (select max(a) from t28224 union all select 1 from db_root where 1=0) m from db_root;
select a from t28224 where a in (select a from t28224 union all select 1 from db_root where 1=0) order by 1;
select u1.a, (select max(u2.a) from t28224 u2 where u2.a = u1.a union all select 9 from db_root where 1=0) m from t28224 u1 order by 1;

evaluate 'Case 6: a WHERE or ON folded to NULL is stored as null and parsed again; result = no row, no row, two NULL-padded rows';
create view v28224_n1 as select a from t28224_b where b = null;
create view v28224_n2 as select a from t28224_b where a = 1 and 1 = null;
create view v28224_n3 as select x.a, y.a b from t28224_b x left join t28224 y on x.a = y.a and 1 = null;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_n1', 'v28224_n2', 'v28224_n3') order by 1;
select a from v28224_n1;
select a from v28224_n2;
select a, b from v28224_n3 order by 1;

evaluate 'Case 7: IN, NOT IN, ALL and SOME over a subquery that returns no row are stored as constants';
create view v28224_f01 as select a from t28224_c where a in (select a from t28224_c where 1=0);
create view v28224_f02 as select a from t28224_c where a not in (select a from t28224_c where 1=0);
-- an INTERSECT with an empty operand folds to a NULL value as a subquery with a false WHERE does
create view v28224_f05 as select a from t28224_c where a in (select a from t28224_c intersect select 9 from db_root where 1=0);
create view v28224_f06 as select a from t28224_c where (a, b) in (select a, b from t28224_c where 1=0);
create view v28224_f07 as select a from t28224_c where (a, b) not in (select a, b from t28224_c where 1=0);
create view v28224_f08 as select a from t28224_c where a > all (select a from t28224_c where 1=0);
create view v28224_f09 as select a from t28224_c where a = some (select a from t28224_c where 1=0);
create view v28224_f13 as select a from t28224_c where a not in (select a from t28224_c where 1=0) or b = 1;
create view v28224_f14 as select a from t28224_c where a in (select a from t28224_c where 1=0) or b = 1;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_f01', 'v28224_f02', 'v28224_f05', 'v28224_f06', 'v28224_f07', 'v28224_f08', 'v28224_f09', 'v28224_f13', 'v28224_f14') order by 1;
select a from v28224_f01 order by 1;
select a from v28224_f02 order by 1;
select a from v28224_f05 order by 1;
select a from v28224_f06 order by 1;
select a from v28224_f07 order by 1;
select a from v28224_f08 order by 1;
select a from v28224_f09 order by 1;
select a from v28224_f13 order by 1;
select a from v28224_f14 order by 1;

evaluate 'Case 8: NOT EXISTS and NOT IN over a subquery that returns no row keep every row; result = 3 rows each';
create view v28224_f03 as select a from t28224_c where not exists (select a from t28224_c where 1=0);
create view v28224_f10 as select a from t28224_c where not (a in (select a from t28224_c where 1=0));
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_f03', 'v28224_f10') order by 1;
select a from v28224_f03 order by 1;
select a from v28224_f10 order by 1;

evaluate 'Case 9: a scalar subquery that returns no row is stored as null, not as an empty string';
create view v28224_f04 as select (select a from t28224_c where 1=0) m from db_root;
create view v28224_f11 as select a, case when a in (select a from t28224_c where 1=0) then 'y' else 'n' end c from t28224_c;
create view v28224_f12 as select a, (select a from t28224_c where 1=0) + 1 m from t28224_c;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_f04', 'v28224_f11', 'v28224_f12') order by 1;
select m, m is null from v28224_f04;
select a, c from v28224_f11 order by 1;
select a, m from v28224_f12 order by 1;

evaluate 'Case 10: a value of another type folded from an expression over an empty subquery reads back the same';
create view v28224_d1 as select coalesce((select 1e0 from db_root where 1=0), 1e0/3e0) x from db_root;
create view v28224_d2 as select nvl2((select 1 from db_root where 1=0), 1e0, 2e0/3e0) x from db_root;
create view v28224_d3 as select coalesce((select cast(1 as bigint) from db_root where 1=0), cast(9007199254740993 as bigint)) x from db_root;
create view v28224_d4 as select coalesce((select 1.0 from db_root where 1=0), 1.0/3) x from db_root;
create view v28224_d5 as select coalesce((select sysdatetime from db_root where 1=0), datetime'2026-01-02 03:04:05.678') x from db_root;
create view v28224_d6 as select coalesce((select 'a' from db_root where 1=0), 'b') x from db_root;
select vclass_name, vclass_def from db_vclass where vclass_name in ('v28224_d1', 'v28224_d2', 'v28224_d3', 'v28224_d4', 'v28224_d5', 'v28224_d6') order by 1;
select x = 1e0/3e0 from v28224_d1;
select x = 2e0/3e0 from v28224_d2;
select x from v28224_d3;
select x from v28224_d4;
select x from v28224_d5;
select x from v28224_d6;

evaluate 'Case 11: the queries of Case 7 to Case 10 return the same rows without a view';
select a from t28224_c where a not in (select a from t28224_c where 1=0) order by 1;
select a from t28224_c where not exists (select a from t28224_c where 1=0) order by 1;
select (select a from t28224_c where 1=0) m from db_root;
select a from t28224_c where a in (select a from t28224_c where 1=0) or b = 1 order by 1;
select coalesce((select 1e0 from db_root where 1=0), 1e0/3e0) = 1e0/3e0 from db_root;
select nvl2((select 1 from db_root where 1=0), 1e0, 2e0/3e0) = 2e0/3e0 from db_root;

drop view v28224_01, v28224_02, v28224_03, v28224_04, v28224_05, v28224_06, v28224_07, v28224_08;
drop view v28224_09, v28224_10, v28224_11, v28224_12, v28224_13, v28224_14, v28224_15;
drop view v28224_n1, v28224_n2, v28224_n3;
drop view v28224_f01, v28224_f02, v28224_f03, v28224_f04, v28224_f05, v28224_f06, v28224_f07;
drop view v28224_f08, v28224_f09, v28224_f10, v28224_f11, v28224_f12, v28224_f13, v28224_f14;
drop view v28224_d1, v28224_d2, v28224_d3, v28224_d4, v28224_d5, v28224_d6;
drop table t28224, t28224_b, t28224_c;
