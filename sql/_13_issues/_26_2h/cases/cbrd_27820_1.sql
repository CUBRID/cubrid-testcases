/**
 *  CBRD-27820: the GROUP BY of a join and the ORDER BY of an anti join are not skipped when an index column
 *  is compared to a constant only in a join condition that does not filter the scanned table
 *
 *  The same check as in cbrd_27820.sql decides whether the scan order of a join gives the GROUP BY order
 *  (CBRD-27685, a nested-loop join with GROUP BY ... LIMIT), and whether an anti join keeps the ORDER BY
 *  order. A constant in the ON condition of a LEFT OUTER JOIN on the preserved table, or in the ON condition
 *  of an ANTI JOIN, let an index column be left out although it still had several values. The GROUP BY then
 *  split one group into several, and the ORDER BY came back in index order.
 *
 *  q1 (b, c, v) = (1, 1, 10), (1, 2, 20), (2, 1, 30), (2, 2, 40), (3, 1, 50), (3, 2, 60), index (b, c):
 *  GROUP BY c gives (1, 3, 90), (2, 3, 120); the index order gives c = 1, 2, 1, 2, 1, 2.
 *  n1 (a, b, c) = (1, 1, 2), (1, 2, 1), index (a, b, c): ORDER BY a, c needs (1, 2, 1) before (1, 1, 2).
 *
 *  Coverage:
 *  1    LEFT OUTER JOIN ON q1.b = 2, GROUP BY q1.c with LIMIT, with and without WHERE on q1.b
 *  2    ANTI JOIN ON n1.b = 2, ORDER BY n1.a, n1.c
 *  3    the GROUP BY is still skipped when no constant is in the ON condition on q1, or when the constant
 *       filters q1: WHERE, INNER JOIN ON
 *  4    RIGHT OUTER JOIN with q1 on the preserved side, GROUP BY q1.c with LIMIT
 *  5    ANTI JOIN ON n1.b = 2, GROUP BY n1.a, n1.c with LIMIT 1
 */

drop table if exists q1, q2, n1, m2;
create table q1 (b int not null, c int not null, v int);
create index i_q1 on q1 (b, c);
insert into q1 values (1, 1, 10), (1, 2, 20), (2, 1, 30), (2, 2, 40), (3, 1, 50), (3, 2, 60);
create table q2 (x int);
insert into q2 values (1);
create table n1 (a int not null, b int, c int);
create index i_n1 on n1 (a, b, c);
insert into n1 values (1, 1, 2), (1, 2, 1);
create table m2 (x int);
insert into m2 values (1);


evaluate 'Case 1-1: LEFT OUTER JOIN ON q1.b = 2, GROUP BY q1.c ORDER BY q1.c LIMIT 1; expect (1, 3, 90)';
--@queryplan
select /*+ recompile */ q1.c, count(*), sum(q1.v) from q1 left join q2 on q1.b = 2 group by q1.c order by q1.c limit 1;

evaluate 'Case 1-2: case 1-1 with WHERE q1.b > 0 and LIMIT 2; expect (1, 3, 90), (2, 3, 120)';
--@queryplan
select /*+ recompile */ q1.c, count(*), sum(q1.v) from q1 left join q2 on q1.b = 2 where q1.b > 0 group by q1.c order by q1.c limit 2;


evaluate 'Case 2: ANTI JOIN ON n1.b = 2; expect c = 1, 2';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 anti join m2 on n1.b = 2 and m2.x = n1.c + 5 where n1.a > 0 order by n1.a, n1.c;


evaluate 'Case 3-1: no constant on q1 in the ON condition; the GROUP BY may be skipped; expect (1, 1, 1, 10), (1, 2, 1, 20)';
--@queryplan
select /*+ recompile */ q1.b, q1.c, count(*), sum(q1.v) from q1 left join q2 on q2.x = q1.c where q1.b > 0 group by q1.b, q1.c order by q1.b, q1.c limit 2;

evaluate 'Case 3-2: WHERE q1.b = 2 filters q1; expect (1, 1, 30), (2, 1, 40)';
--@queryplan
select /*+ recompile */ q1.c, count(*), sum(q1.v) from q1 left join q2 on q2.x = 1 where q1.b = 2 group by q1.c order by q1.c limit 2;

evaluate 'Case 3-3: INNER JOIN ON q1.b = 2 filters q1; expect (1, 1, 30), (2, 1, 40)';
--@queryplan
select /*+ recompile */ q1.c, count(*), sum(q1.v) from q1 inner join q2 on q1.b = 2 group by q1.c order by q1.c limit 2;


evaluate 'Case 4: RIGHT OUTER JOIN ON q1.b = 2 with q1 preserved, GROUP BY q1.c LIMIT 1; expect (1, 3, 90)';
--@queryplan
select /*+ recompile */ q1.c, count(*), sum(q1.v) from q2 right join q1 on q1.b = 2 group by q1.c order by q1.c limit 1;


evaluate 'Case 5: ANTI JOIN ON n1.b = 2, GROUP BY n1.a, n1.c LIMIT 1; expect (1, 1, 1)';
--@queryplan
select /*+ recompile */ n1.a, n1.c, count(*) from n1 anti join m2 on n1.b = 2 and m2.x = n1.c + 5 where n1.a > 0 group by n1.a, n1.c order by n1.a, n1.c limit 1;

drop table q1, q2, n1, m2;
