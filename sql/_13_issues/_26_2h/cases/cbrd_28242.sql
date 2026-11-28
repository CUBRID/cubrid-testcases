/**
 *  This test case verifies CBRD-28242: a UNION or DIFFERENCE folded to its remaining operand loses DISTINCT
 *  on a string column when the other operand reads a constant-false CTE, and a folded UNION ALL ignores
 *  the collation of the empty operand
 *
 *  An operand of a set operation that reads a constant-false CTE was folded into a NULL value by the type
 *  checking before the set operation was folded, so the set operation could not tell the collations of its
 *  string columns and folded without DISTINCT. A set operation that is itself an operand and returns no row
 *  was folded into a value the same way. A folded UNION ALL took the collation of the empty operand only
 *  inside its duplicate elimination decision, so a comparison on its result used the collation of the
 *  remaining operand. The operand now stays a query until the set operation folds it, and the collations
 *  are taken whether the set operation removes duplicates or not. Each case prints the result of the same
 *  query with 1 = 0 replaced by rand() < 0, which folds nothing, right after it.
 *
 *  Coverage:
 *    Case 1:  a UNION whose other operand reads a false CTE removes the duplicates of a string column
 *    Case 2:  a DIFFERENCE whose right operand reads a false CTE removes the duplicates, and an empty
 *             left operand of DIFFERENCE or INTERSECTION returns no row
 *    Case 3:  an integer column and DIFFERENCE ALL fold as before
 *    Case 4:  a UNION ALL compares its result in the collation of the empty operand, and a UNION
 *             removes duplicates in it
 *    Case 5:  the empty operand is a set operation of empty operands
 *    Case 6:  more than one column, three operands, a LIMIT on the remaining operand, the fold under IN,
 *             a correlated operand and a prepared statement run twice
 */

drop table if exists t28242_s, t28242_d, t28242_i, t28242_ci, t28242_bin, t28242_m;

create table t28242_s (s varchar(10));
insert into t28242_s values ('a');
create table t28242_d (s varchar(10));
insert into t28242_d values ('b'), ('b'), ('c');
create table t28242_i (i int);
insert into t28242_i values (5), (5), (6);
create table t28242_ci (s varchar(10) collate utf8_en_ci);
insert into t28242_ci values ('a');
create table t28242_bin (s varchar(10) collate utf8_bin);
insert into t28242_bin values ('a'), ('A');
create table t28242_m (s varchar(10), n int);
insert into t28242_m values ('b', 1), ('b', 1), ('c', 2);

evaluate 'Case 1: a UNION whose other operand reads a false CTE removes the duplicates of a string column';
select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from c) union (select s from t28242_d)) u;
select count(*) from (with c as (select s from t28242_s where rand() < 0) (select s x from c) union (select s from t28242_d)) u;
with c as (select s from t28242_s where 1 = 0) (select s x from c) union (select s from t28242_d) order by x;
with c as (select s from t28242_s where rand() < 0) (select s x from c) union (select s from t28242_d) order by x;
select count(*) from (with c as (select s from t28242_s where 1 = 0) select s x from c union select s from t28242_d) u;

evaluate 'Case 2: a DIFFERENCE whose right operand reads a false CTE removes the duplicates';
select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from t28242_d) difference (select s from c)) u;
select count(*) from (with c as (select s from t28242_s where rand() < 0) (select s x from t28242_d) difference (select s from c)) u;
select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from c) difference (select s from t28242_d)) u;
select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from c) intersection (select s from t28242_d)) u;

evaluate 'Case 3: an integer column and DIFFERENCE ALL fold as before';
select count(*) from (with c as (select i from t28242_i where 1 = 0) (select i x from c) union (select i from t28242_i)) u;
select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from t28242_d) difference all (select s from c)) u;

evaluate 'Case 4: a UNION ALL compares its result in the collation of the empty operand';
select count(*) from ((select s x from t28242_ci where 1 = 0) union all (select s from t28242_bin)) u where x = 'a';
select count(*) from ((select s x from t28242_ci where rand() < 0) union all (select s from t28242_bin)) u where x = 'a';
select count(*) from ((select s x from t28242_bin) union all (select s from t28242_ci where 1 = 0)) u where x = 'a';
select count(*) from ((select s x from t28242_bin) union all (select s from t28242_ci where rand() < 0)) u where x = 'a';
select count(*) from (with c as (select s from t28242_ci where 1 = 0) (select s x from c) union all (select s from t28242_bin) union all (select s from c)) u where x = 'a';
select count(*) from (with c as (select s from t28242_ci where 1 = 0) (select s x from c) union (select s from t28242_bin)) u;
select count(*) from (with c as (select s from t28242_ci where rand() < 0) (select s x from c) union (select s from t28242_bin)) u;

evaluate 'Case 5: the empty operand is a set operation of empty operands';
select count(*) from ((select s x from t28242_d where 1 = 0 union select s from t28242_d where 1 = 0) union (select s from t28242_d)) u;
select count(*) from (select s x from t28242_d where 1 = 0 union select s from t28242_d where 1 = 0 union select s from t28242_d) u;
select count(*) from ((select s x from t28242_ci where 1 = 0 union select s from t28242_ci where 1 = 0) union all (select s from t28242_bin)) u where x = 'a';
select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from c union all select s from t28242_d where 1 = 0) union (select s from t28242_d)) u;

evaluate 'Case 6: more than one column, three operands, a LIMIT, the fold under IN, a correlated operand, a prepared statement';
select count(*) from (with c as (select s, 1 n from t28242_s where 1 = 0) (select s x, n from c) union (select s, n from t28242_m)) u;
select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from c) union (select s from t28242_d) union (select s from c)) u;
select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from c) union (select s from t28242_d limit 2) order by 1) u;
select count(*) from (with c as (select s from t28242_s where rand() < 0) (select s x from c) union (select s from t28242_d limit 2) order by 1) u;
select count(*) from t28242_d where s in (with c as (select s from t28242_s where 1 = 0) (select s from c) union (select s from t28242_d));
select count(*) from t28242_m o where o.s in (with c as (select s from t28242_s where 1 = 0) (select s x from c) union (select s from t28242_m i where i.n <= o.n));
prepare st28242 from 'select count(*) from (with c as (select s from t28242_s where 1 = 0) (select s x from c) union (select s from t28242_d)) u';
execute st28242;
execute st28242;
deallocate prepare st28242;

drop table t28242_s, t28242_d, t28242_i, t28242_ci, t28242_bin, t28242_m;
