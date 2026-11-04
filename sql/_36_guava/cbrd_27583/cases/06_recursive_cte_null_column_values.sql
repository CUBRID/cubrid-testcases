/**
 *  This test case verifies CBRD-27583: a recursive CTE column that its recursive part writes
 *  from a NULL-typed column takes the type both parts unify to and keeps its values.
 *
 *  In with recursive c (n, a, z) as (select 1, 'a', null ... union all select n + 1, z,
 *  coalesce (z, 'b') ...), the column a is 'a' in the first row and the NULL-typed z after,
 *  and the recursive part types z.  Before the change the column a was typed NULL, so every
 *  value of a was lost to NULL, the 'a' of row 1 and the 'b' of row 3 (a form of CBRD-27668,
 *  in every release).  Now the column takes the unified type of the two parts, with z counted
 *  by the type z unifies to (specification change 27): its values stay, and a predicate, an
 *  expression and an aggregate over the CTE read them.  A column the recursive part writes
 *  only NULL into takes the type of the non-recursive part, and a column that neither part
 *  types stays NULL (CBRD-27668).
 *
 *  Judged by the literal results: column a answers 'a', NULL and 'b' in Case 1 and 7, NULL
 *  and 6 in Case 2, where the pre-change build answered NULL in every row and a TYPEOF of
 *  *NULL*.  Case 3 answers rows 1 and 3, 7, NULL and 6, COUNT 2 and SUM 13, where it answered
 *  no rows, NULL, 0 and NULL.  Case 4 answers 7, COUNT 1 and SUM 7, and 'z' in rows 3 and 4
 *  of s, where it answered NULL, 0 and NULL, and NULL.
 *
 *  Coverage:
 *    Case 1:  a string value in the non-recursive part, a NULL-typed column after
 *    Case 2:  the integer form of Case 1
 *    Case 3:  the values read by a predicate, an expression and an aggregate over the CTE
 *    Case 4:  a NULL written by the recursive part, and a column a self-reference types
 */


evaluate 'Case 1: a string value in the non-recursive part, a NULL-typed column after';
with recursive c (n, a, z) as (select 1, 'a', null from db_root union all select n + 1, z, coalesce (z, 'b') from c where n < 3) select n, a, z from c order by 1;
with recursive c (n, a, z) as (select 1, 'a', null from db_root union all select n + 1, z, coalesce (z, 'b') from c where n < 3) select n, a, typeof (a), z, typeof (z) from c order by 1;


evaluate 'Case 2: the integer form of Case 1';
with recursive c (n, a, z) as (select 1, 7, null from db_root union all select n + 1, z, coalesce (z, 5) + 1 from c where n < 3) select n, a, z from c order by 1;


evaluate 'Case 3: the values read by a predicate, an expression and an aggregate over the CTE';
with recursive c (n, a, z) as (select 1, 'a', null from db_root union all select n + 1, z, coalesce (z, 'b') from c where n < 3) select n, a from c where a is not null order by 1;
with recursive c (n, a, z) as (select 1, 7, null from db_root union all select n + 1, z, coalesce (z, 5) + 1 from c where n < 3) select n, a + 0 from c order by 1;
with recursive c (n, a, z) as (select 1, 7, null from db_root union all select n + 1, z, coalesce (z, 5) + 1 from c where n < 3) select count (a), sum (a) from c;


evaluate 'Case 4: a NULL written by the recursive part, and a column a self-reference types';
with recursive c (n, a) as (select 1, 7 from db_root union all select n + 1, null from c where n < 3) select n, a from c order by 1;
with recursive c (n, a) as (select 1, 7 from db_root union all select n + 1, null from c where n < 3) select count (a), sum (a) from c;
with recursive c (n, s, t) as (select 1, null, null from db_root union all select n + 1, t, coalesce (s, 'z') from c where n < 4) select n, s, t from c order by 1;
