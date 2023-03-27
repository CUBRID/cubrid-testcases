-- This test case verifies CBRD-24645 issue.
-- Rownum of main query is displayed incorrectly.
-- Caused by order-by of subquery is copied to main query during view merging.
-- 'orderby_num()+1' is not supported yet, 
-- expression having rownum such as 'rownum+1' is restricted from view merging.

drop table if exists t1;
create table t1 (col1 int);
insert into t1 values(3);
insert into t1 values(2);
insert into t1 values(1);

select /*+ recompile */ rownum,col1 from (select col1 from t1 where col1 > 0 order by col1) a;

--order by skip
create index idx on t1(col1);
select /*+ recompile */ rownum,col1 from (select col1 from t1 where col1 > 0 order by col1) a;

--not supported yet in view merging.
drop index idx on t1;
select /*+ recompile */ rownum + 1,col1 from (select col1 from t1 where col1 > 0 order by col1) a;


drop table t1; 
