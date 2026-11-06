/**
 *  CBRD-27889: a WHERE condition evaluated after an outer join filters the rows an ANTI JOIN keeps
 *
 *  When the ANTI JOIN of a NOT EXISTS is the last join, a WHERE condition that can be evaluated
 *  only after an outer join goes to that ANTI JOIN. A nested loop ANTI JOIN checked it together
 *  with its ON condition for each inner row and never on the outer row it kept, so the query
 *  returned NOT EXISTS (match AND condition) instead of NOT EXISTS (match) AND condition: an outer
 *  row whose condition is not true was kept whether it had a match or not. Now the ON condition
 *  alone decides the match, and the condition is checked on the outer row that has no match.
 *
 *  t1 (c1)     = (1), (2), (3), (4), (5)
 *  t2 (c1, c2) = (1, 1), (3, 1), (4, 5)   outer joined on t2.c1 = t1.c1, no row for 2 and 5
 *  t3 (c1, c2) = (1, 2), (2, 9)           NOT EXISTS on t3.c1 = t1.c1, a match for 1 and 2
 *
 *  Coverage:
 *  1    a WHERE condition with no subquery, rows with and without a match and with the
 *       condition true, NULL and false
 *  2    a WHERE condition true only on the rows the outer join fills with NULL
 *  3    the same with a RIGHT OUTER JOIN, the condition on the table it fills with NULL
 *  4    an explicit ANTI JOIN with the WHERE condition of case 1
 *  5    a WHERE condition with a correlated subquery
 *  6    the NOT EXISTS table is partitioned, so the outer row is kept after every partition
 *  7    the outer rows repeat, so the ANTI JOIN answers them from memoize
 *  8    an ON condition of the ANTI JOIN that reads three tables still decides the match
 */

drop table if exists t1, t2, t3, t4, t5, t6;
create table t1 (c1 int);
create table t2 (c1 int, c2 int);
create table t3 (c1 int, c2 int);
create table t4 (c1 int, c2 int);
create table t5 (c1 int, c2 int) partition by hash (c1) partitions 4;
create table t6 (c1 int);
insert into t1 values (1), (2), (3), (4), (5);
insert into t2 values (1, 1), (3, 1), (4, 5);
insert into t3 values (1, 2), (2, 9);
insert into t4 values (1, 1), (2, 2), (3, 1), (4, 4);
insert into t5 values (1, 1), (2, 2), (5, 7), (6, 8);
insert into t6 select mod (rownum - 1, 4) + 1 from db_class a, db_class b limit 200;


evaluate 'Case 1: a WHERE condition after the outer join and NOT EXISTS; only the t1 row with no t3 match and a true condition stays';
select /*+ recompile */ t1.c1 as t1_c1, t2.c2 as t2_c2 from t1 left outer join t2 on t2.c1 = t1.c1
 where not exists (select 1 from t3 where t3.c1 = t1.c1) and (t2.c2 = 1 or t1.c1 is null) order by 1;


evaluate 'Case 2: t2.c2 is null holds only on the rows with no t2 row; only the one of them with no t3 match stays';
select /*+ recompile */ t1.c1 as t1_c1, t2.c2 as t2_c2 from t1 left outer join t2 on t2.c1 = t1.c1
 where not exists (select 1 from t3 where t3.c1 = t1.c1) and t2.c2 is null order by 1;


evaluate 'Case 3: a RIGHT OUTER JOIN with t2.c1 is null; only the t1 row with no t2 row and no t3 match stays';
select /*+ recompile */ t1.c1 as t1_c1, t2.c1 as t2_c1 from t2 right outer join t1 on t2.c1 = t1.c1
 where not exists (select 1 from t3 where t3.c1 = t1.c1) and t2.c1 is null order by 1;


evaluate 'Case 4: an explicit ANTI JOIN with the WHERE condition of case 1; only the t1 row with no t3 match and a true condition stays';
select /*+ recompile */ t1.c1 as t1_c1, t2.c2 as t2_c2 from t1 left outer join t2 on t2.c1 = t1.c1
 anti join t3 on t3.c1 = t1.c1 where (t2.c2 = 1 or t1.c1 is null) order by 1;


evaluate 'Case 5: the WHERE condition holds a correlated subquery; only the t1 row with no t3 match and a true condition stays';
select /*+ recompile */ t1.c1 as t1_c1, t2.c2 as t2_c2 from t1 left outer join t2 on t2.c1 = t1.c1
 where not exists (select 1 from t3 where t3.c1 = t1.c1)
   and (t2.c2 = (select t4.c2 from t4 where t4.c1 = t1.c1) or t1.c1 is null) order by 1;


evaluate 'Case 6: the NOT EXISTS table t5 is partitioned; only the t1 row with no t5 match and a true condition stays';
select /*+ recompile */ t1.c1 as t1_c1, t2.c2 as t2_c2 from t1 left outer join t2 on t2.c1 = t1.c1
 where not exists (select 1 from t5 where t5.c2 = t1.c1) and (t2.c2 = 1 or t1.c1 is null) order by 1;


evaluate 'Case 7: 50 outer rows for each of 1 to 4, answered from memoize; only the rows of 3 stay';
select /*+ recompile */ t6.c1 as t6_c1, count (*) as cnt from t6 left outer join t2 on t2.c1 = t6.c1
 where not exists (select 1 from t3 where t3.c1 = t6.c1) and (t2.c2 = 1 or t6.c1 is null) group by t6.c1 order by 1;


evaluate 'Case 8: an ANTI JOIN whose ON condition reads t1, t2 and t3; the t1 rows with no t2 row match no t3 row and stay';
select /*+ recompile */ t1.c1 as t1_c1, t2.c2 as t2_c2 from t1 left outer join t2 on t2.c1 = t1.c1
 anti join t3 on t3.c1 = t1.c1 and t3.c2 = t1.c1 + t2.c2 order by 1;

drop table t1, t2, t3, t4, t5, t6;
