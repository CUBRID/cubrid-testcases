-- Test Cases for CBRD-25361: Fixed the issue where trace information for CTEs and subqueries are not provided.

--------------------------------------------------------------------------------
-- These test cases verify the fix for CBRD-25361, ensuring that trace information
-- is correctly outputted for various scenarios involving CTEs and subqueries,
-- including UNION ALL, DIFFERENCE, INTERSECTION, and combinations of correlated
-- and uncorrelated subqueries.
--------------------------------------------------------------------------------

-- 1. Uncorrelated Subqueries

-- 1.1 Single CTE: UNION ALL
drop table if exists tbl_a;

create table tbl_a ( i int, j varchar, k varchar);

insert into tbl_a select rownum, rownum, rownum 
from db_class a, db_class c, db_class d limit 100000;

set trace on;

WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a)
UNION ALL
(SELECT * FROM cte_a);

show trace;

-- 1.2 Single CTE: DIFFERENCE
WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a)
DIFFERENCE
(SELECT * FROM cte_a);

show trace;

-- 1.3 Single CTE: INTERSECTION
WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a)
INTERSECTION
(SELECT * FROM cte_a);

show trace;

-- 1.4 Multiple CTEs: UNION ALL with Uncorrelated Subqueries
drop table if exists tbl_b;

create table tbl_b ( a int, b varchar, c varchar);

insert into tbl_b select rownum, rownum, rownum 
from db_class a, db_class c, db_class d limit 100000;

set trace on;

WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_b ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE i < 50)
UNION ALL
(SELECT * FROM cte_b WHERE a > 50);

show trace;
drop table tbl_b;

-- 1.5 Multiple CTEs: DIFFERENCE with Uncorrelated Subqueries
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE i < 20)
DIFFERENCE
(SELECT * FROM cte_b WHERE k > 30);

show trace;

-- 1.6 Multiple CTEs: UNION with Uncorrelated Subqueries
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 30)
UNION
(SELECT * FROM cte_b WHERE k > 50);

show trace;

-- 2. Correlated Subqueries

-- 2.1 Single CTE: UNION with Correlated Subqueries
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.i = cte_a.i))
UNION
(SELECT * FROM cte_a WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.j = cte_a.j));

show trace;

-- 2.2 CTE with Correlated Subqueries: INTERSECTION
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.j = cte_a.j))
INTERSECTION
(SELECT * FROM cte_a WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_a.k));

show trace;

-- 2.3 Multiple CTEs: UNION ALL with Mixed Correlated and Uncorrelated Subqueries
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 20)
UNION ALL
(SELECT * FROM cte_b WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_b.k));

show trace;

