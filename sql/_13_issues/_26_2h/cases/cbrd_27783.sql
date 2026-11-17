/**
 *  CBRD-27783: a RIGHT OUTER JOIN behind an explicit SEMI JOIN keeps the rows it preserves
 *
 *  The outer join rewrite turns an outer join into an inner join when a NULL-rejecting
 *  condition drops the rows that join fills with NULL. CBRD-27397 let the ON of a SEMI JOIN
 *  behind the outer joined table count as such a condition, also when a RIGHT OUTER JOIN came
 *  behind that SEMI JOIN. The joins run in FROM order, so that RIGHT OUTER JOIN fills the table
 *  with NULL after the ON of the SEMI JOIN ran, and the rewrite dropped the rows it preserves
 *  without an error. Now the ON of a SEMI JOIN counts only when no RIGHT OUTER JOIN is
 *  connected behind that SEMI JOIN. The rewrite that must still happen when none is, is
 *  checked by the plans of _36_guava/cbrd_27397 (Cases 7 and 9).
 *
 *  t1 (c1) = (1), t2 (c1) = (1), t3 (c1) = (1), (2), t4 (c1) = (1)
 *
 *  Coverage:
 *  1    the RIGHT OUTER JOIN right behind the SEMI JOIN
 *  2    an INNER JOIN between the SEMI JOIN and the RIGHT OUTER JOIN, so the RIGHT OUTER
 *       JOIN is not the join right behind the SEMI JOIN
 *  3    the SEMI JOIN reads the inner side t4 of a LEFT OUTER JOIN, so the rewrite would
 *       also turn that LEFT OUTER JOIN into an inner join and move its ON into WHERE
 */

drop table if exists t1, t2, t3, t4;
create table t1 (c1 int);
create table t2 (c1 int);
create table t3 (c1 int);
create table t4 (c1 int);
insert into t1 values (1);
insert into t2 values (1);
insert into t3 values (1), (2);
insert into t4 values (1);


evaluate 'Case 1: the RIGHT OUTER JOIN right behind the SEMI JOIN keeps the t3 row that matches no t1 row';
select /*+ recompile */ t3.c1 as t3_c1, t1.c1 as t1_c1 from t1 semi join t2 on t2.c1 = t1.c1 right outer join t3 on t3.c1 = t1.c1 order by 1;


evaluate 'Case 2: an INNER JOIN between the SEMI JOIN and the RIGHT OUTER JOIN; the t3 row that matches no t1 row stays';
select /*+ recompile */ t3.c1 as t3_c1, t1.c1 as t1_c1 from t1 semi join t2 on t2.c1 = t1.c1 inner join t4 on t4.c1 = t1.c1 right outer join t3 on t3.c1 = t1.c1 order by 1;


evaluate 'Case 3: the SEMI JOIN reads the inner side t4 of a LEFT OUTER JOIN, then a RIGHT OUTER JOIN on t4; the t3 row that matches no t4 row stays';
select /*+ recompile */ t3.c1 as t3_c1, t4.c1 as t4_c1 from t1 left outer join t4 on t4.c1 = t1.c1 semi join t2 on t2.c1 = t4.c1 right outer join t3 on t3.c1 = t4.c1 order by 1;

drop table t1, t2, t3, t4;
