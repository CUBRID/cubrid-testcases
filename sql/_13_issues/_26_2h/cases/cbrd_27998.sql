/**
 *  CBRD-27998: an uncorrelated IN or > SOME subquery whose column type differs from the outer
 *  column is rewritten into a join with a derived table
 *
 *  The type check puts a CAST to the comparison type on the select list of such a subquery,
 *  while the subquery itself keeps the type of its column. CBRD-27397 rewrote the subquery
 *  only when the comparison type was the type of the subquery, so a VARCHAR column compared
 *  with a CHAR subquery stayed a filter that reads the subquery result for every outer row.
 *  A subquery over a UNION ALL view is not unnested into a SEMI JOIN either, so no rewrite
 *  turned that IN into a join.
 *
 *  t1 (c1 varchar) = ('a'), ('b'), t2 (c1 char) = ('a'), t3 (c1 char) = ('a'),
 *  v1 = t2 union all t3
 *
 *  Coverage:
 *  1    IN over the UNION ALL view: a join with a DISTINCT derived table, and the t1 row
 *       that matches the value of both t2 and t3 comes once
 *  2    > SOME over t2: a join with a derived table that holds the MIN
 */

drop view if exists v1;
drop table if exists t1, t2, t3;
create table t1 (c1 varchar(10));
create table t2 (c1 char(1));
create table t3 (c1 char(1));
insert into t1 values ('a'), ('b');
insert into t2 values ('a');
insert into t3 values ('a');
create view v1 (c1) as select c1 from t2 union all select c1 from t3;


evaluate 'Case 1: VARCHAR IN a CHAR column of a UNION ALL view becomes a join with a DISTINCT derived table';
--@queryplan
select /*+ recompile */ c1 from t1 where c1 in (select c1 from v1) order by 1;


evaluate 'Case 2: VARCHAR > SOME a CHAR column becomes a join with a derived table of the MIN';
--@queryplan
select /*+ recompile */ c1 from t1 where c1 > some (select c1 from t2) order by 1;

drop view v1;
drop table t1, t2, t3;
