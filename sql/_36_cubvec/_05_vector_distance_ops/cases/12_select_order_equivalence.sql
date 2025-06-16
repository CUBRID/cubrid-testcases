-------------------------------------------------------------------------------
-- Test: Vector Distance Order Equivalence
-- Purpose: Test equivalence between:
--   1. SELECT id, vec1 <=> vec2 as dist FROM tbl ORDER BY dist
--   2. SELECT id FROM tbl ORDER BY vec1 <=> vec2
-- Expected: Both queries should return identical ordering of id values
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Setup
-------------------------------------------------------------------------------
-- Drop existing table if any
DROP TABLE IF EXISTS tbl;

-- Create test table with vector columns
CREATE TABLE tbl (
    id INT,
    label VARCHAR(30),
    vec1 VECTOR(3),
    vec2 VECTOR(3)
);

-- Insert test data with various vector combinations
-- These cover different distance scenarios: identical, similar, orthogonal, opposite
INSERT INTO tbl VALUES (1, 'identical_vectors',     '[1, 2, 3]',      '[1, 2, 3]');
INSERT INTO tbl VALUES (2, 'very_close',           '[1, 2, 3]',      '[1.1, 2.1, 3.1]');
INSERT INTO tbl VALUES (3, 'moderate_distance',    '[1, 2, 3]',      '[2, 3, 4]');
INSERT INTO tbl VALUES (4, 'large_distance',       '[1, 2, 3]',      '[10, 20, 30]');
INSERT INTO tbl VALUES (5, 'orthogonal_vectors',   '[1, 0, 0]',      '[0, 1, 0]');
INSERT INTO tbl VALUES (6, 'opposite_direction',   '[1, 2, 3]',      '[-1, -2, -3]');
INSERT INTO tbl VALUES (7, 'zero_to_nonzero',     '[0, 0, 0]',      '[1, 1, 1]');
INSERT INTO tbl VALUES (8, 'both_zero',           '[0, 0, 0]',      '[0, 0, 0]');
INSERT INTO tbl VALUES (9, 'random_pair_1',       '[4, -2, 7]',     '[1, 5, -3]');
INSERT INTO tbl VALUES (10, 'random_pair_2',      '[-1, 3, 2]',     '[6, -4, 1]');

-------------------------------------------------------------------------------
-- Test Case 1: Cosine Similarity (<c>) Equivalence Test
-------------------------------------------------------------------------------
-- Query 1: SELECT with distance column
SELECT 'Cosine Similarity - Query 1 (with distance column):' AS test_info;
SELECT id, label, vec1 <c> vec2 AS cosine_dist
FROM tbl 
ORDER BY cosine_dist DESC;

-- Query 2: ORDER BY only
SELECT 'Cosine Similarity - Query 2 (order by only):' AS test_info;
SELECT id, label
FROM tbl 
ORDER BY vec1 <c> vec2 DESC;

-------------------------------------------------------------------------------
-- Test Case 2: Euclidean Distance (<->) Equivalence Test  
-------------------------------------------------------------------------------
-- Query 1: SELECT with distance column
SELECT 'Euclidean Distance - Query 1 (with distance column):' AS test_info;
SELECT id, label, vec1 <-> vec2 AS euclidean_dist
FROM tbl 
ORDER BY euclidean_dist ASC;

-- Query 2: ORDER BY only
SELECT 'Euclidean Distance - Query 2 (order by only):' AS test_info;
SELECT id, label
FROM tbl 
ORDER BY vec1 <-> vec2 ASC;

-------------------------------------------------------------------------------
-- Test Case 3: Inner Product (<#>) Equivalence Test
-------------------------------------------------------------------------------
-- Query 1: SELECT with distance column
SELECT 'Inner Product - Query 1 (with distance column):' AS test_info;
SELECT id, label, vec1 <#> vec2 AS inner_prod
FROM tbl 
ORDER BY inner_prod DESC;

-- Query 2: ORDER BY only
SELECT 'Inner Product - Query 2 (order by only):' AS test_info;
SELECT id, label
FROM tbl 
ORDER BY vec1 <#> vec2 DESC;

-------------------------------------------------------------------------------
-- Test Case 4: Manhattan Distance (<+>) Equivalence Test
-------------------------------------------------------------------------------
-- Query 1: SELECT with distance column
SELECT 'Manhattan Distance - Query 1 (with distance column):' AS test_info;
SELECT id, label, vec1 <+> vec2 AS manhattan_dist
FROM tbl 
ORDER BY manhattan_dist ASC;

-- Query 2: ORDER BY only
SELECT 'Manhattan Distance - Query 2 (order by only):' AS test_info;
SELECT id, label
FROM tbl 
ORDER BY vec1 <+> vec2 ASC;

-------------------------------------------------------------------------------
-- Cleanup
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS tbl;
