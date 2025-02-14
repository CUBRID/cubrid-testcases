-- Verified for CBRD-25785
-- Problem with view merging when ORDER BY clause in the subquery and the main query, and rownum is in the main query select list.

drop table if exists t1;
create table t1 (c1 int, c2 int);
insert into t1 values (9, 9);
insert into t1 values (10, 10);
insert into t1 values (7, 7);
insert into t1 values (8, 8);
insert into t1 values (5, 5);
insert into t1 values (6, 6);
insert into t1 values (3, 3);
insert into t1 values (4, 4);
insert into t1 values (1, 1);
insert into t1 values (2, 2);

--case1: Basic Combination of rownum and ORDER BY
evaluate 'case1';
select /*+ recompile */ rownum, c1, c2 from (select c1, c2 from t1 where c1 > 0 order by c1) order by c2 desc;

--case2: Example Using orderby_num()
evaluate 'case2';
select /*+ recompile */ orderby_num(), c1, c2 from (select c1, c2 from t1 where c1 > 0 order by c2) order by c1 desc;

--case3: Using rownum with Multiple ORDER BY Clauses
evaluate 'case3';
select /*+ recompile */ rownum, c1, c2 from (select c1, c2 from t1 where c2 < 10 order by c1) order by c2 desc, c1 asc;

--case4: orderby_num() with Additional Conditions
evaluate 'case4';
select /*+ recompile */ orderby_num(), c1, c2 from (select c1, c2 from t1 where c1 % 2 = 0 order by c2 desc) order by c1 asc;

--case5: Using Both rownum and orderby_num() Together
evaluate 'case5';
select /*+ recompile */ rownum, orderby_num(), c1, c2 from (select c1, c2 from t1 where c1 between 1 and 8 order by c1) order by c2 desc;

drop table if exists t1;
