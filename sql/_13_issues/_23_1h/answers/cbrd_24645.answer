-- This test case verifies CBRD-24645 issue.
-- Rownum of main query is displayed incorrectly.
-- Caused by order-by of subquery is copied to main query during view merging.
-- 'orderby_num()+1' is not supported yet, 
-- expression having rownum such as 'rownum+1' is restricted from view merging.

drop table if exists tbl;
create table tbl (x int, y int);
insert into tbl values(3, 10);
insert into tbl values(2, 20);
insert into tbl values(1, 30);


select /*+ recompile */ rownum, x from (select x, y from tbl where x > 0 order by x) a;
select /*+ recompile */ rownum, x from (select x, y from tbl where x > 0 order by y) a;
select /*+ recompile */ rownum, x from (select x, y from tbl where x > 0 order by 2) a;

--order by skip
create index idx on tbl(x);
select /*+ recompile */ rownum, x, y from tbl where x > 0 order by x;
select /*+ recompile */ rownum, x from (select x, y from tbl where x > 0 order by x) a;
-- order by not skiped
select /*+ recompile */ rownum, x, y from tbl where x > 0 order by 3;
select /*+ recompile */ rownum, x, y from tbl where x > 0 order by y;
select /*+ recompile */ rownum, x from (select x, y from tbl where x > 0 order by y) a;
select /*+ recompile */ rownum, x from (select x, y from tbl where x > 0 order by 2) a;

--not supported yet in view merging.
drop index idx on tbl;
select /*+ recompile */ rownum + 1, x from (select x, y from tbl where x > 0 order by x) a;
select /*+ recompile */ rownum + 1, x from (select x, y from tbl where x > 0 order by y) a;
select /*+ recompile */ rownum + 1, x from (select x, y from tbl where x > 0 order by 2) a;

drop table tbl; 
