/**
 *  This test case verifies CBRD-27583: in the recursive part of a recursive CTE, an expression
 *  over a self-referenced column takes its type from the column the part really reads.
 *
 *  When the two parts of the CTE type a column differently, as CHAR(1) for 'q' and VARCHAR for
 *  t || n, the column unifies to VARCHAR and the self-reference reads it through a cast.
 *  Before the change semantic checking had typed the expression over it from the type before
 *  the cast, the CHAR(1), so typeof (s) answered character (-1) for a value read as VARCHAR.
 *  Now the expression is typed from the column read, VARCHAR (specification change 26), and
 *  its values do not change.
 *
 *  Judged by the literal results: the TYPEOF of s in the first statement of Case 1 and the
 *  TYPEOF of MAX (s) in Case 2 answer character varying (1073741823), where the pre-change
 *  build answered character (-1), with the same values.  The other statements answer as
 *  before.
 *
 *  Coverage:
 *    Case 1:  COALESCE over the cast self-reference and over a NULL column
 *    Case 2:  the cast self-reference in a concatenation, an aggregate and an analytic function
 *    Case 3:  a self-reference without a cast, as before
 */


evaluate 'Case 1: COALESCE over the cast self-reference and over a NULL column';
with recursive c (n, s, v, t) as (select 1, null, null, 'q' from db_root union all select n + 1, coalesce (s, t), coalesce (v, n) * 10, t || n from c where n < 3) select n, s, typeof (s), v, typeof (v), t, typeof (t) from c order by 1;
with recursive c (n, s, t) as (select 1, null, 'q' from db_root union all select n + 1, coalesce (t, s), t || 'r' from c where n < 3) select n, s, typeof (s), t from c order by 1;


evaluate 'Case 2: the cast self-reference in a concatenation, an aggregate and an analytic function';
with recursive c (n, s, t) as (select 1, null, 'q' from db_root union all select n + 1, t || '|', t || n from c where n < 3) select n, s, typeof (s), t from c order by 1;
with recursive c (n, s, t) as (select 1, null, 'q' from db_root union all select n + 1, coalesce (s, t), t || n from c where n < 3) select count (*), max (s), group_concat (s order by s), typeof (max (s)) from c;
with recursive c (n, s, t) as (select 1, null, 'q' from db_root union all select n + 1, coalesce (s, t), t || n from c where n < 3) select n, s, max (s) over (), min (s) over () from c order by 1;


evaluate 'Case 3: a self-reference without a cast, as before';
with recursive c (n, s, t) as (select 1, null, cast ('q' as varchar) from db_root union all select n + 1, coalesce (s, t), t || n from c where n < 3) select n, s, typeof (s), t from c order by 1;
with recursive c (n, s) as (select 1, null from db_root union all select n + 1, coalesce (s, 'q') from c where n < 3) select n, s, typeof (s) from c order by 1;
