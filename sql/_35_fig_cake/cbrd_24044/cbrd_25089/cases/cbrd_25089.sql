-- This scenario varifies CBRD-25089 issue.
-- Add LEADING sql hint
-- This hint determines the order of tables. It's necessary to check whether the execution plan has been created according to the order specified by the leading hint

drop table if exists tbl;
create table tbl(cola int, colb int);
update statistics on tbl;
set optimization level 513;

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
select /*+ recompile leading(a) */ *
from tbl a, tbl b, tbl c
where a.cola = b.cola
   and b.cola = c.cola;

--13. Adding an index, using an index with the lowest selectivity with USING INDEX, and setting LEADING opposite to index
select ('test13-without_hint');
create index tbl_idx on tbl(cola, colb);
update statistics on tbl;

select /*+ recompile using index tbl_idx(+) */ *
from tbl a, tbl b
where a.colb = b.colb
   and a.cola = b.cola;

select ('test13-with_leading_hint');
select /*+ recompile leading(b,a) using index tbl_idx(+) */ *
from tbl a, tbl b
where a.colb = b.colb
   and a.cola = b.cola;

--14. Multiple Join Conditions with Subqueries
select ('test14');
SELECT /*+ recompile leading(c, b, a) */ a.*, c.*, b.*
FROM tbl a, tbl b, (SELECT * FROM tbl WHERE colb > 100) c
WHERE a.cola = c.cola
AND c.cola = b.cola
AND b.colb = (SELECT MAX(colb) FROM tbl WHERE cola = a.cola);

--15. Complex Joins with Aggregate Functions
select ('test15');
SELECT /*+ recompile leading(b,a,c) */ a.cola, b.colb, SUM(c.colb)
FROM tbl a
JOIN tbl b ON a.cola = b.cola
JOIN tbl c ON a.cola = c.cola
GROUP BY a.cola, b.colb
ORDER BY a.cola;

--16. Combined Hints Usage
select ('test16');
SELECT /*+ recompile leading(a,b) index(a idx_a_cola) */ *
FROM tbl a, tbl b
WHERE a.cola = b.cola
AND a.colb = b.colb
ORDER BY a.cola DESC;

--17. Cross Join with Filtering
SELECT /*+ recompile leading(a,c) */ a.cola, c.colb
FROM tbl a, tbl c
CROSS JOIN tbl b
WHERE a.cola = b.cola
AND b.colb > 50
ORDER BY c.colb;

--18. Combining Various Join Types
select ('test18');
SELECT /*+ recompile leading(b,a,c) */ a.*, b.*, c.*
FROM tbl a
INNER JOIN tbl b ON a.cola = b.cola
LEFT JOIN tbl c ON b.cola = c.cola
WHERE a.colb > 10 AND b.colb < 20 AND c.colb IS NOT NULL;

--19. Complex Join with Subqueries
select ('test19');
SELECT /*+ recompile leading(s,b) */ b.*
FROM (SELECT cola FROM tbl WHERE colb < 100) s, tbl b
WHERE s.cola = b.cola
AND EXISTS (SELECT 1 FROM tbl c WHERE c.cola = b.cola);

--20. Multi-Level Subqueries
select ('test20');
SELECT /*+ recompile leading(a,b,c) */ a.cola, b.colb, c.colb
FROM tbl a
JOIN (SELECT cola, colb FROM tbl WHERE colb IN (SELECT colb FROM tbl WHERE colb > 200)) b ON a.cola = b.cola
JOIN tbl c ON b.colb = c.colb
WHERE a.cola IN (SELECT cola FROM tbl WHERE colb < 50);

--21. Complex Conditions and Grouping
select ('test21');
SELECT /*+ recompile leading(a,b) */ a.cola, COUNT(b.colb)
FROM tbl a
JOIN tbl b ON a.cola = b.cola AND a.colb = b.colb
WHERE a.colb > 100
GROUP BY a.cola
HAVING COUNT(b.colb) > 5;

drop table if exists tbl;
