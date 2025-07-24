/**
 *  This test case verifies CBRD-25611 : CUBRID GROUP BY with ROLLUP Bug Test Cases
 *  
 *  Coverage:
 *  Different Built-in Functions
 *  1. Ceil
 *  2. Floor
 *  3. Round
 *  4. ABS
 *  Case with Built-in Function (Ceil)
 *  5. original column referenced by the expression exists in both select-list and group by clause
 *  6. original column referenced by the expression is not specified in group by clause
 *  7. original column referenced by the expression is not specified in select-list and group by clause
 *  8. dimension level of the original column referenced by the expression is less than that of the expression
 *  Case with User-Defined Function
 *  9. original column referenced by the function exists in both select-list and group by clause
 *  10. original column referenced by the function is not specified in group by clause
 *  11. original column referenced by the function is not specified in select-list and group by clause
 *  12. dimension level of the original column referenced by the function is less than that of the expression
 *  Nested Function
 *  13. Built-in inside Built-in
 *  14. Built-in inside User-Defined Function
 *  Multiple Expressions and Functions
 *  15. Two Built-in functions as the expression
 *  16. Built-in and User-Defined function as the expression
 *  Other Cases
 *  17. 3-Level ROLLUP
 *  18. GROUPING BY with HAVING
 *  19. Inline Function
 */

-- Test Setup
CREATE TABLE t1 (
    c1 int,
    c2 float,
    c3 double
);

INSERT INTO t1 VALUES
(1, 1.1, 1.11),
(2, 2.2, 2.22), (2, 2.2, 2.22),
(3, 3.3, 3.33), (3, 3.3, 3.33), (3, 3.3, 3.33),
(-1, -1.1, -1.11), (-2, -2.2, -2.22),
(NULL, NULL, NULL), (NULL, 4.4, 4.44);

-- Create test function
CREATE OR REPLACE FUNCTION test_func(a int) RETURN int AS
BEGIN
    RETURN CEIL(a);
END;

-- =====================================================
-- Different Built-in Functions
-- =====================================================
evaluate('1. Ceil');
select /*+ recompile */ ceil(c1) as c0, c1, count(*) as cnt
from t1 
group by c0, c1 with rollup;

evaluate('2. Floor');
select /*+ recompile */ floor(c2) as c0, c1, count(*) as cnt
from t1 
group by c0, c1 with rollup;

evaluate('3. Round');
select /*+ recompile */ round(c2) as c0, c1, count(*) as cnt
from t1 
group by c0, c1 with rollup;

evaluate('4. ABS');
select /*+ recompile */ abs(c1) as c0, c1, count(*) as cnt
from t1 
group by c0, c1 with rollup;

-- =====================================================
-- Cases with Built-in Functions
-- =====================================================
evaluate('5. original column referenced by the expression exists in both select-list and group by clause (CEIL)');
select /*+ recompile */ ceil(c1) as c0, c1, count(*) as cnt
from t1 
group by c0, c1 with rollup
order by c0, c1;

evaluate('6. original column referenced by the expression is not specified in group by clause');
select /*+ recompile */ ceil(c1) as c0, c1, count(*) as cnt
from t1 
group by c0, c2 with rollup
order by c0, c2;

evaluate('7. original column referenced by the expression is not specified in select-list and group by clause');
select /*+ recompile */ ceil(c1) as c0, c2, count(*) as cnt
from t1 
group by c0, c2 with rollup
order by c0, c2;

evaluate('8. dimension level of the original column referenced by the expression is less than that of the expression');
select /*+ recompile */ c1, ceil(c1) as c0, count(*) as cnt
from t1 
group by c1, c0 with rollup
order by c1, c0;

-- =====================================================
-- Cases with User-Defined Function
-- =====================================================
evaluate('9. original column referenced by the function exists in both select-list and group by clause');
select /*+ recompile */ test_func(c1) as c0, c1, count(*) as cnt
from t1 
group by c0, c1 with rollup
order by c0, c1;

evaluate('10. original column referenced by the function is not specified in group by clause');
select /*+ recompile */ test_func(c1) as c0, c1, count(*) as cnt
from t1 
group by c0, c2 with rollup
order by c0, c1;

evaluate('11. original column referenced by the function is not specified in select-list and group by clause');
select /*+ recompile */ test_func(c1) as c0, c2, count(*) as cnt
from t1 
group by c0, c2 with rollup
order by c0, c2;

evaluate('12. dimension level of the original column referenced by the function is less than that of the expression');
select /*+ recompile */ c1, test_func(c1) as c0, count(*) as cnt
from t1 
group by c1, c0 with rollup
order by c1, c0;

-- =====================================================
-- Nested Function
-- =====================================================
evaluate('13. Built-in inside Built-in');
select /*+ recompile */ ceil(abs(c1)) as c0, c1, count(*) as cnt
from t1 
group by c0, c1 with rollup
order by c0, c1;

evaluate('14. Built-in inside User-Defined Function');
select /*+ recompile */ test_func(abs(c1)) as c0, c1, count(*) as cnt
from t1 
group by c0, c1 with rollup
order by c0, c1;

-- =====================================================
-- Multiple Expressions
-- =====================================================
evaluate('15. Two Built-in functions as the expression');
select /*+ recompile */ ceil(c1) as c1_cell, floor(c2) as c2_floor, count(*) as cnt
from t1 
group by c1_cell, c2_floor with rollup
order by c1_cell, c2_floor;

evaluate('16. Built-in and User-Defined function as the expression');
select /*+ recompile */ ceil(c1) as c1_ceil, test_func(c1) as c1_tf, count(*) as cnt
from t1 
group by c1_ceil, c1_tf with rollup
order by c1_ceil, c1_tf;

-- =====================================================
-- Other Cases
-- =====================================================

evaluate('17. 3-Level ROLLUP');
SELECT /*+ recompile */ ceil(c1) as c1_ceil, floor(c2) as c2_floor, c1, count(*) as cnt
FROM t1 
GROUP BY c1_ceil, c2_floor, c1 WITH ROLLUP
ORDER BY c1_ceil, c2_floor, c1;

evaluate('18. GROUPING BY with HAVING');
SELECT /*+ recompile */ ceil(c1) as c0, c1, count(*) as cnt
FROM t1 
GROUP BY c0, c1 WITH ROLLUP
HAVING cnt > 0
ORDER BY c0, c1;

evaluate('19. Inline Function');
SELECT /*+ recompile */ (c1 * 2) as c1_mult, ceil(c1 + 1) as c1_expr, count(*) as cnt
FROM t1 
GROUP BY c1_mult, c1_expr WITH ROLLUP
ORDER BY c1_mult, c1_expr;

-- =====================================================
-- Cleanup
-- =====================================================
DROP FUNCTION test_func;
DROP TABLE t1;
