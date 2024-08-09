-- This test case verifies the following issue: CBRD-25318
-- Verifies that subqueries containing orderby_num() are no longer view-merged.
-- Tests primarily consist of scenarios in which orderby_num() is often used. 

drop table if exists tbl;
create table tbl(col_a int, col_b int);
insert into tbl values(1,1),(2,2),(3,3),(4,4);

update statistics on tbl with fullscan;

--select '1. Single Subquery';
select orderby_num() rrnum,rnum,col_a,col_b 
from (select orderby_num() rnum,col_a,col_b from tbl order by col_a) 
where 1=1 order by rnum desc;

--select '2. Subqueries';
select /*+ recompile */ rrnum,rnum,col_a,col_b 
from (select orderby_num() rrnum,rnum,col_a,col_b 
from (select orderby_num() rnum,col_a,col_b from tbl order by col_a) 
where 1=1 order by col_b desc)
where 1=1 order by rrnum;

--select '3. Subqueries - for orderby_num() between';
select /*+ recompile */ rrnum,rnum,col_a,col_b 
from (select orderby_num() rrnum,rnum,col_a,col_b 
from (select orderby_num() rnum,col_a,col_b from tbl order by col_a) 
where 1=1 order by col_b desc for orderby_num() between 1 and 3)
where 1=1 order by rrnum;

--select '4. Subqueries - order by limit (limit 3)';
select /*+ recompile */ rrnum,rnum,col_a,col_b 
from (select orderby_num() rrnum,rnum,col_a,col_b 
from (select orderby_num() rnum,col_a,col_b from tbl order by col_a) 
where 1=1 order by col_b desc limit 3)
where 1=1 order by rrnum;

--select '5. Subqueries - order by limit & offset (offset 1, limit 3)';
select /*+ recompile */ rrnum,rnum,col_a,col_b 
from (select orderby_num() rrnum,rnum,col_a,col_b 
from (select orderby_num() rnum,col_a,col_b from tbl order by col_a) 
where 1=1 order by col_b desc limit 1, 3)
where 1=1 order by rrnum;

--select '6. Subqueries - ROWNUM';
-- Verifies handling of ROWNUM in simple nested subqueries.
select /*+ recompile */ rrnum,rnum,col_a,col_b 
from (select orderby_num() rrnum,rnum,col_a,col_b 
from (select ROWNUM rnum,col_a,col_b from tbl order by col_a)
where ROWNUM < 5 order by rnum desc)
where 1=1 order by rrnum;

--select '7. Subqueries - INST_NUM';
-- Verifies handling of INST_NUM() in simple nested subqueries.
select /*+ recompile */ rrnum,rnum,col_a,col_b 
from (select orderby_num() rrnum,rnum,col_a,col_b 
from (select INST_NUM() rnum,col_a,col_b from tbl order by col_a)
where 1=1 order by rnum desc)
where 1=1 order by rrnum;

--select '8. Subqueries - GROUPBY_NUM()';
-- Verifies handling of GROUPBY_NUM() in simple nested subqueries.
select /*+ recompile */ rrnum,rnum,col_a,col_b 
from (select orderby_num() rrnum,rnum,col_a,col_b 
from (select GROUPBY_NUM() rnum,col_a,col_b from tbl group by col_a)
where 1=1 order by rnum desc)
where 1=1 order by rrnum;

--select '9. 3 Subqueries';
select /*+ recompile */ rrrnum,rrnum,rnum,col_a,col_b 
from (select orderby_num() rrrnum,rrnum,rnum,col_a,col_b 
from (select orderby_num() rrnum,rnum,col_a,col_b 
from (select orderby_num() rnum,col_a,col_b from tbl order by col_a)
where 1=1 order by col_a)
where 1=1 order by col_b desc)  
where 1=1 order by rrrnum;

drop table tbl;


