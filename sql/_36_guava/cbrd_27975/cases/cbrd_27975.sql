/**
 *  This test case verifies CBRD-27975: GROUP BY ... WITH ROLLUP with an ORDER BY on the group keys
 *  and a LIMIT keeps the subtotal and total rows.
 *
 *  Before the fix the rewriter moved the orderby_num() bound of the LIMIT to a groupby_num() bound in
 *  HAVING whenever the ORDER BY was covered by the GROUP BY, ROLLUP included. groupby_num() counts
 *  only the regular groups and is applied before the super-aggregate rows are made, so the LIMIT cut
 *  the regular groups first and the subtotal and total rows were dropped or shuffled. Now the ORDER BY
 *  of a ROLLUP query is not merged into the GROUP BY: the rows are sorted after the subtotals are
 *  made and the LIMIT is applied to the sorted rows.
 *
 *  Coverage:
 *    Case 1:  the ORDER BY on both keys with LIMIT, LIMIT OFFSET, and FOR ORDERBY_NUM()
 *    Case 2:  descending keys, an ORDER BY on a prefix of the keys, NULLS LAST, one key
 *    Case 3:  a constant key in WHERE, an orderby_num() column, a HAVING, and a join
 *    Case 4:  the ROLLUP query under a derived table and under a UNION branch
 *    Case 5:  a LIMIT without ORDER BY, an ORDER BY on a non-key column, and the GROUP BY without
 *             ROLLUP, which still merges its ORDER BY into the GROUP BY
 */

drop table if exists t1, t2;
create table t1 (a int, b int);
insert into t1 values (1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3);
create table t2 (a int, c int);
insert into t2 values (1, 10), (2, 20);

-- Case 1: the ORDER BY on both keys with LIMIT, LIMIT OFFSET, and FOR ORDERBY_NUM()
select a, b, count(*) from t1 group by a, b with rollup order by a, b;
select a, b, count(*) from t1 group by a, b with rollup order by a, b limit 3;
select a, b, count(*) from t1 group by a, b with rollup order by a, b limit 3 offset 1;
select a, b, count(*) from t1 group by a, b with rollup order by a, b for orderby_num() between 2 and 4;

-- Case 2: descending keys, an ORDER BY on a prefix of the keys, NULLS LAST, one key
select a, b, count(*) from t1 group by a, b with rollup order by a desc, b desc limit 4;
select a, b, count(*) from t1 group by a, b with rollup order by a limit 1;
select a, b, count(*) from t1 group by a, b with rollup order by a nulls last, b nulls last limit 3 offset 2;
select a, count(*) from t1 group by a with rollup order by a limit 2;

-- Case 3: a constant key in WHERE, an orderby_num() column, a HAVING, and a join
select a, b, count(*) from t1 where a = 1 group by a, b with rollup order by a, b limit 3;
select orderby_num(), a, b, count(*) from t1 group by a, b with rollup order by a, b limit 3;
select a, b, count(*) from t1 group by a, b with rollup having count(*) > 0 order by a, b limit 3;
select t1.a, t2.c, count(*) from t1, t2 where t1.a = t2.a group by t1.a, t2.c with rollup order by 1, 2 limit 3;

-- Case 4: the ROLLUP query under a derived table and under a UNION branch
select * from (select a, b, count(*) cnt from t1 group by a, b with rollup order by a, b limit 3) x order by 1, 2;
(select a, b, count(*) from t1 group by a, b with rollup order by a, b limit 2) union all (select a, b, count(*) from t1 group by a, b with rollup order by a desc, b desc limit 2);

-- Case 5: a LIMIT without ORDER BY, an ORDER BY on a non-key column, and the GROUP BY without ROLLUP
select a, b, count(*) from t1 group by a, b with rollup limit 3;
select a, b, count(*) from t1 group by a, b with rollup order by 3 desc, 1, 2 limit 3;
select a, b, count(*) from t1 group by a, b order by a, b limit 3;
select a, b, count(*) from t1 group by a, b order by a, b limit 3 offset 2;

drop table t1, t2;
