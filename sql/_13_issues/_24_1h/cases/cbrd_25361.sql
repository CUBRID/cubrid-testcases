-- Test Cases for CBRD-25361: Fixed the issue where trace information for CTEs and subqueries are not provided.

--------------------------------------------------------------------------------
-- These test cases verify the fix for CBRD-25361, ensuring that trace information
-- is correctly outputted for various scenarios involving CTEs and subqueries,
-- including UNION, UNION ALL, DIFFERENCE, DIFFERENCE ALL, INTERSECTION, 
-- INTERSECTION ALL, and combinations of correlated and uncorrelated subqueries.
--------------------------------------------------------------------------------

-- 1. Uncorrelated Subqueries

drop table if exists tbl_a;

create table tbl_a ( i int, j varchar, k varchar);

insert into tbl_a select rownum, rownum, rownum 
from db_class a, db_class c, db_class d limit 100000;

set trace on;

-- 1.1 Single CTE: UNION
EVALUATE '1.1 Single CTE: UNION';
WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a ORDER BY i)
UNION
(SELECT * FROM cte_a ORDER BY i);

show trace;

-- 1.2 Single CTE: UNION ALL
EVALUATE '1.2 Single CTE: UNION ALL';
WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a ORDER BY i)
UNION ALL
(SELECT * FROM cte_a ORDER BY i);

show trace;

-- 1.3 Single CTE: DIFFERENCE
EVALUATE '1.3 Single CTE: DIFFERENCE';
WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a ORDER BY i)
DIFFERENCE
(SELECT * FROM cte_a ORDER BY i);

show trace;

-- 1.4 Single CTE: DIFFERENCE ALL
EVALUATE '1.4 Single CTE: DIFFERENCE ALL';
WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a ORDER BY i)
DIFFERENCE ALL
(SELECT * FROM cte_a ORDER BY i);

show trace;

-- 1.5 Single CTE: INTERSECTION
EVALUATE '1.5 Single CTE: INTERSECTION';
WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a ORDER BY i)
INTERSECTION
(SELECT * FROM cte_a ORDER BY i);

show trace;

-- 1.6 Single CTE: INTERSECTION ALL
EVALUATE '1.6 Single CTE: INTERSECTION ALL';
WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a ORDER BY i)
INTERSECTION ALL
(SELECT * FROM cte_a ORDER BY i);

show trace;

-- 1.7 Multiple CTEs: UNION ALL with Uncorrelated Subqueries
EVALUATE '1.7 Multiple CTEs: UNION ALL with Uncorrelated Subqueries';
drop table if exists tbl_b;

create table tbl_b ( a int, b varchar, c varchar);

insert into tbl_b select rownum, rownum, rownum 
from db_class a, db_class c, db_class d limit 100000;

set trace on;

WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_b ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE i < 50 ORDER BY i)
UNION ALL
(SELECT * FROM cte_b WHERE a > 50 ORDER BY a);

show trace;
drop table tbl_b;

-- 1.8 Multiple CTEs: UNION with Uncorrelated Subqueries
EVALUATE '1.8 Multiple CTEs: UNION with Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 30 ORDER BY i)
UNION
(SELECT * FROM cte_b WHERE k > 50 ORDER BY i);

show trace;

-- 1.9 Multiple CTEs: DIFFERENCE with Uncorrelated Subqueries
EVALUATE '1.9 Multiple CTEs: DIFFERENCE with Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE i < 20 ORDER BY i)
DIFFERENCE
(SELECT * FROM cte_b WHERE k > 30 ORDER BY i);

show trace;

-- 1.10 Multiple CTEs: DIFFERENCE ALL with Uncorrelated Subqueries
EVALUATE '1.10 Multiple CTEs: DIFFERENCE ALL with Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE i < 20 ORDER BY i)
DIFFERENCE ALL
(SELECT * FROM cte_b WHERE k > 30 ORDER BY i);

show trace;

-- 1.11 Multiple CTEs: INTERSECTION with Uncorrelated Subqueries
EVALUATE '1.11 Multiple CTEs: INTERSECTION with Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 30 ORDER BY i)
INTERSECTION
(SELECT * FROM cte_b WHERE k > 50 ORDER BY i);

show trace;

-- 1.12 Multiple CTEs: INTERSECTION ALL with Uncorrelated Subqueries
EVALUATE '1.12 Multiple CTEs: INTERSECTION ALL with Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 30 ORDER BY i)
INTERSECTION ALL
(SELECT * FROM cte_b WHERE k > 50 ORDER BY i);

show trace;

-- 1.13 Use limit
EVALUATE '1.13 Use limit';
WITH cte1 AS (SELECT i FROM tbl_a limit 1, 10)
(SELECT * FROM cte1)
UNION ALL
(SELECT * FROM cte1)
UNION
(SELECT * FROM cte1)
DIFFERENCE
(SELECT * FROM cte1)
INTERSECTION
(SELECT * FROM cte1);

show trace;

-- 1.14 Use limit offset
EVALUATE '1.14 Use limit offset';
WITH cte1 AS (SELECT i FROM tbl_a limit 3 offset 7)
(SELECT * FROM cte1)
UNION ALL
(SELECT * FROM cte1)
UNION
(SELECT * FROM cte1)
DIFFERENCE
(SELECT * FROM cte1)
INTERSECTION
(SELECT * FROM cte1);

show trace;

-- 1.15 Use rownum
EVALUATE '1.15 Use rownum';
WITH cte1 AS (SELECT i FROM tbl_a where rownum < 5 )
(SELECT * FROM cte1)
UNION ALL
(SELECT * FROM cte1)
UNION
(SELECT * FROM cte1)
DIFFERENCE
(SELECT * FROM cte1)
INTERSECTION
(SELECT * FROM cte1);

show trace;

-- 1.16 Use orderby_num()
EVALUATE '1.16 Use orderby_num()';
WITH cte1 AS (SELECT i FROM tbl_a order by 1 for orderby_num() between 3 and 5)
(SELECT * FROM cte1)
UNION ALL
(SELECT * FROM cte1)
UNION
(SELECT * FROM cte1)
DIFFERENCE
(SELECT * FROM cte1)
INTERSECTION
(SELECT * FROM cte1);

show trace;

-- 2. Correlated Subqueries

-- 2.1 Single CTE: UNION with Correlated Subqueries
EVALUATE '2.1 Single CTE: UNION with Correlated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.i = cte_a.i) ORDER BY i)
UNION
(SELECT * FROM cte_a WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.j = cte_a.j) ORDER BY i);

show trace;

-- 2.2 Single CTE: INTERSECTION with Correlated Subqueries
EVALUATE '2.2 Single CTE: INTERSECTION with Correlated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.j = cte_a.j) ORDER BY i)
INTERSECTION
(SELECT * FROM cte_a WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_a.k) ORDER BY i);

show trace;

-- 2.3 Multiple CTEs: UNION ALL with Mixed Correlated and Uncorrelated Subqueries
EVALUATE '2.3 Multiple CTEs: UNION ALL with Mixed Correlated and Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 20 ORDER BY i)
UNION ALL
(SELECT * FROM cte_b WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_b.k) ORDER BY i);

show trace;

-- 2.4 Multiple CTEs: UNION with Mixed Correlated and Uncorrelated Subqueries
EVALUATE '2.4 Multiple CTEs: UNION with Mixed Correlated and Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 20 ORDER BY i)
UNION
(SELECT * FROM cte_b WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_b.k) ORDER BY i);

show trace;

-- 2.5 Multiple CTEs: DIFFERENCE with Mixed Correlated and Uncorrelated Subqueries
EVALUATE '2.5 Multiple CTEs: DIFFERENCE with Mixed Correlated and Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 20 ORDER BY i)
DIFFERENCE
(SELECT * FROM cte_b WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_b.k) ORDER BY i);

show trace;

-- 2.6 Multiple CTEs: DIFFERENCE ALL with Mixed Correlated and Uncorrelated Subqueries
EVALUATE '2.6 Multiple CTEs: DIFFERENCE ALL with Mixed Correlated and Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 20 ORDER BY i)
DIFFERENCE ALL
(SELECT * FROM cte_b WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_b.k) ORDER BY i);

show trace;

-- 2.7 Multiple CTEs: INTERSECTION with Mixed Correlated and Uncorrelated Subqueries
EVALUATE '2.7 Multiple CTEs: INTERSECTION with Mixed Correlated and Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 20 ORDER BY i)
INTERSECTION
(SELECT * FROM cte_b WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_b.k) ORDER BY i);

show trace;

-- 2.8 Multiple CTEs: INTERSECTION ALL with Mixed Correlated and Uncorrelated Subqueries
EVALUATE '2.8 Multiple CTEs: INTERSECTION ALL with Mixed Correlated and Uncorrelated Subqueries';
set trace on;

WITH cte_a AS (SELECT * FROM tbl_a WHERE i < 50 ORDER BY 1 LIMIT 20),
     cte_b AS (SELECT * FROM tbl_a WHERE i >= 50 ORDER BY 1 LIMIT 20)
(SELECT * FROM cte_a WHERE j < 20 ORDER BY i)
INTERSECTION ALL
(SELECT * FROM cte_b WHERE EXISTS (SELECT 1 FROM tbl_a WHERE tbl_a.k = cte_b.k) ORDER BY i);

show trace;

set trace off;
drop table tbl_a;


