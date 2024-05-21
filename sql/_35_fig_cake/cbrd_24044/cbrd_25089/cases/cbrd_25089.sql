-- This scenario varifies CBRD-25089 issue.
-- Add LEADING sql hint
-- This hint determines the order of tables. It's necessary to check whether the execution plan has been created according to the order specified by the leading hint

drop table if exists tbl;
create table tbl(cola int, colb int);
create view test_v as select cola, colb from tbl;
update statistics on tbl;

--1. without leading option
select ('test1');
select *
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--2. Verify that query plans are created in the order of tables in leading
select ('test2');
select /*+ recompile leading(b,a) */ * 
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--3. Verify that query plans are created in the order of tables in leading
select ('test3');
select /*+ recompile leading(b,c,a) */ * 
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--4. ignore case : don't have edge
select ('test4');
select /*+ recompile leading(a,c) */ * 
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--5. ignore case : multiple leading hint. only first is used
select ('test5');
select /*+ recompile leading(b,c) leading(c,b) */ * 
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--6. ignore case : with ordered hint. ignore leading hint
select ('test6');
select /*+ recompile leading(b,c) ordered */ * 
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--7. ignore case : with outer join. can not be joined first. ignore leading hint.
select ('test7');
select /*+ recompile leading(b,a) */ * 
from tbl a, tbl b, tbl c
where a.cola = b.cola(+)
   and a.cola = c.cola;

--8. Include a table in leading hint that is not in the FROM clause
select ('test8');
select /*+ recompile leading(a, d, c) */ *
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--9. Include a table in leading hint that is not in the FROM clause-2
select ('test9');
select /*+ recompile leading(c, d, a) */ *
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--10. Using leading hint with a HAVING clause
select ('test10');
select /*+ recompile leading(b,a) */ a.cola, count(*)
from tbl a, tbl b
where a.cola = b.cola
group by a.cola
having count(*) > 1;

--11. Using leading hint with a GROUP BY clause
select ('test11');
select /*+ recompile leading(b,a) */ a.cola, count(b.colb)
from tbl a, tbl b
where a.cola = b.cola
group by a.cola;

--12. Select only one table from the FROM clause in leading hint
select ('test12');
select /*+ recompile leading(b) */ *
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--13. Adding an index, using an index with the lowest selectivity with USING INDEX, and setting LEADING opposite to index
select ('test13');
create index tbl_idx on tbl(cola, colb);
update statistics on tbl;
select /*+ recompile using index tbl_idx(+) */ *
from tbl a, tbl b
where a.colb = b.colb
   and a.cola = b.cola;

select /*+ recompile leading(b,a) using index tbl_idx(+) */ *
from tbl a, tbl b
where a.colb = b.colb
   and a.cola = b.cola;
drop index tbl_idx on tbl;

--14. Multiple Join Conditions with Subqueries
select ('test14');
select /*+ recompile leading(b,c,a) */ *
from tbl a, tbl b, (select * from tbl where cola > 100) c
where a.cola = b.cola
AND b.cola = c.cola
AND b.colb = (select MAX(colb) from tbl where cola = a.cola);

--15. Complex Joins with Aggregate Functions
select ('test15');
select /*+ recompile leading(c,a,b) */ a.cola, b.colb, SUM(c.colb)
from tbl a
join tbl b on a.cola = b.cola
join tbl c on a.cola = c.cola
GROUP BY a.cola, b.colb
ORDER BY a.cola;

--16. Cross Join with Filtering
select ('test16');
select /*+ recompile leading(b,a) */ *
from tbl a, tbl c
CROSS join tbl b
where a.cola = b.cola
AND b.colb > 50;

--17. Combining Various Join Types
select ('test17');
select /*+ recompile leading(b,a,c) */ a.*, b.*, c.*
from tbl a
INNER join tbl b on a.cola = b.cola
LEFT join tbl c on b.cola = c.cola
where a.colb > 10 AND b.colb < 20 AND c.colb IS NOT NULL;

--18. Complex Join with Subqueries
select ('test18');
select /*+ recompile leading(b,s) */ b.*
from (select cola from tbl where colb < 100) s, tbl b
where s.cola = b.cola
AND EXISTS (select 1 from tbl c where c.cola = b.cola);

--19. Multi-Level Subqueries
select ('test19');
select /*+ recompile leading(c,b,a) */ a.cola, b.colb, c.colb
from tbl a
join (select cola, colb from tbl where colb IN (select colb from tbl where colb > 200)) b on a.cola = b.cola
join tbl c on b.colb = c.colb
where a.cola IN (select cola from tbl where colb < 50);

--20. Complex Conditions and Grouping
select ('test20');
select /*+ recompile leading(b,a) */ a.cola, COUNT(b.colb)
from tbl a
join tbl b on a.cola = b.cola AND a.colb = b.colb
where a.colb > 100
GROUP BY a.cola
HAVING COUNT(b.colb) > 5;

--21. Partition table
select ('test21');
CREATE TABLE tbl_partition (
    cola INT,
    colb INT,
    colc VARCHAR(100)
)
PARTITION BY RANGE (cola) (
    PARTITION p0 VALUES LESS THAN (50),
    PARTITION p1 VALUES LESS THAN (100),
    PARTITION p2 VALUES LESS THAN (150)
);
select /*+ recompile leading(c_partition, b_partition) */ *
from tbl_partition a_partition, tbl_partition b_partition, tbl_partition c_partition
where a_partition.cola = b_partition.cola
AND b_partition.cola = c_partition.cola;

--22. With USE_MERGE hint
select ('test22');
select /*+ recompile leading(b,c) use_merge */ *
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--23. Leading Hint with View
select ('test23');
select /*+ recompile leading(v,a,b) */ v.cola, a.colb
from test_v v, tbl a, tbl b
where v.cola = a.cola
AND a.cola = b.cola;

drop view if exists test_v;
drop table if exists tbl_partition;
drop table if exists tbl;
