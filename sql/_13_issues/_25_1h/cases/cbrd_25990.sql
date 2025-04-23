-- This test case verifies the following issue: CBRD-25990
-- The problem where for orderby_num() in inline views gets removed due to view merging

drop table if exists tbl;
create table tbl(cola int, colb int);
insert into tbl (select rownum, rownum + 1 from db_class limit 30);

-- query1: When an inline view is merged, the ORDER BY remains but the ORDERBY FOR clause is removed  
evaluate 'query1-1';
select /*+ recompile */ * from 
    (select * from (select cola from tbl order by 1 desc) where rownum < 2);
evaluate 'query1-2';
select /*+ recompile */ * from 
    (select * from (select cola from tbl order by 1 desc) limit 1);

-- query2: When using aggregate functions, ORDER BY and ORDERBY FOR clauses cannot be pushed up to the parent query.
evaluate 'query2';
select /*+ recompile */ count(*) from 
(
    select * from 
    (
        select * from tbl order by 1 desc
    ) where rownum <= 20
) where rownum >= 11;

-- query3: When the main query has DISTINCT, the ORDER BY in the inline view is removed  
evaluate 'query3';
select /*+ recompile */ distinct * from 
(
    select cola from 
    (
        select cola from tbl order by colb desc
    ) limit 3
);

drop table if exists tbl;
