-- This test case verifies the following issue: CBRD-25318
-- Verifies that subqueries containing orderby_num() are no longer view-merged.
-- Tests primarily consist of scenarios in which orderby_num() is often used. 

drop table if exists tbl;
create table tbl(col1 int, col2 int);
insert into tbl values(1,1),(2,2),(3,3),(4,4);

update statistics on tbl with fullscan;

--select '1. Single Subquery';
select orderby_num() rrnum,rnum,col1,col2 
from (select orderby_num() rnum,col1,col2 from tbl order by col1) 
where 1=1 order by rnum desc;

--select '2. Subqueries';
select /*+ recompile */ rrnum,rnum,col1,col2 
from (select orderby_num() rrnum,rnum,col1,col2 
from (select orderby_num() rnum,col1,col2 from tbl order by col1) 
where 1=1 order by col2 desc)
where 1=1 order by rrnum;

--select '3. Subqueries - for orderby_num() between';
select /*+ recompile */ rrnum,rnum,col1,col2 
from (select orderby_num() rrnum,rnum,col1,col2 
from (select orderby_num() rnum,col1,col2 from tbl order by col1) 
where 1=1 order by col2 desc for orderby_num() between 1 and 3)
where 1=1 order by rrnum;

--select '4. Subqueries - order by limit (limit 3)';
select /*+ recompile */ rrnum,rnum,col1,col2 
from (select orderby_num() rrnum,rnum,col1,col2 
from (select orderby_num() rnum,col1,col2 from tbl order by col1) 
where 1=1 order by col2 desc limit 3)
where 1=1 order by rrnum;

--select '5. Subqueries - order by limit & offset (offset 1, limit 3)';
select /*+ recompile */ rrnum,rnum,col1,col2 
from (select orderby_num() rrnum,rnum,col1,col2 
from (select orderby_num() rnum,col1,col2 from tbl order by col1) 
where 1=1 order by col2 desc limit 1, 3)
where 1=1 order by rrnum;

--select '6. 3 Subqueries';
select /*+ recompile */ rrrnum,rrnum,rnum,col1,col2 
from (select orderby_num() rrrnum,rrnum,rnum,col1,col2 
from (select orderby_num() rrnum,rnum,col1,col2 
from (select orderby_num() rnum,col1,col2 from tbl order by col1)
where 1=1 order by col1)
where 1=1 order by col2 desc)  
where 1=1 order by rrrnum;

drop table tbl;
