-------------------------------------------------------------------------------
-- CUBRID Vector Distance Operations Test: With/Without Index and Limit
-- Tests 4 scenarios for each distance operator:
-- 1. Without index, without limit
-- 2. With index, without limit  
-- 3. Without index, with limit
-- 4. With index, with limit
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Setup
-------------------------------------------------------------------------------
-- Drop existing table if any
DROP IF EXISTS tbl;

-- Create test table with 3D vectors
CREATE TABLE tbl (
    id INT,
    label VARCHAR(20),
    vec VECTOR(3)
);

-- Insert various test vectors for comprehensive testing
INSERT INTO tbl VALUES (1, 'same_as_input', '[1, 2, 3]');
INSERT INTO tbl VALUES (2, 'reverse',        '[3, 2, 1]');
INSERT INTO tbl VALUES (3, 'orthogonal',     '[3, -6, 3]');
INSERT INTO tbl VALUES (4, 'unit',           '[0.2673, 0.5345, 0.8018]'); -- normalized version of [1,2,3]
INSERT INTO tbl VALUES (5, 'zero',           '[0, 0, 0]');
INSERT INTO tbl VALUES (6, 'ones',           '[1, 1, 1]');
INSERT INTO tbl VALUES (7, 'negated_input',  '[-1, -2, -3]');
INSERT INTO tbl VALUES (8, 'random',         '[4, 5, 6]');
INSERT INTO tbl VALUES (9, 'large_pos',      '[10, 20, 30]');
INSERT INTO tbl VALUES (10, 'large_neg',     '[-10, -20, -30]');

-- Reference vector for all tests
SET @query_vector = '[1, 2, 3]';

-------------------------------------------------------------------------------
-- TEST 1: COSINE SIMILARITY (<c>) - All 4 Scenarios
-------------------------------------------------------------------------------
SELECT '=== COSINE SIMILARITY TESTS ===';

-- Scenario 1: Without index, without limit
SELECT 'Scenario 1: Cosine similarity WITHOUT index, WITHOUT limit';
SELECT id, label, @query_vector <c> vec AS similarity
FROM tbl
ORDER BY similarity DESC;

-- Create vector index for cosine similarity
-- TODO(CUBVEC): CREATE VECTOR INDEX idx_vec_cosine ON tbl (vec COSINE);

-- Scenario 2: With index, without limit
SELECT 'Scenario 2: Cosine similarity WITH index, WITHOUT limit';
SELECT id, label, @query_vector <c> vec AS similarity
FROM tbl
ORDER BY similarity DESC;

-- Drop index to test scenario 3
DROP VECTOR INDEX idx_vec_cosine ON tbl;

-- Scenario 3: Without index, with limit
SELECT 'Scenario 3: Cosine similarity WITHOUT index, WITH limit (TOP 3)';
SELECT id, label, @query_vector <c> vec AS similarity
FROM tbl
ORDER BY similarity DESC
LIMIT 3;

-- Recreate index for scenario 4
-- TODO(CUBVEC): CREATE VECTOR INDEX idx_vec_cosine ON tbl (vec COSINE);

-- Scenario 4: With index, with limit
SELECT 'Scenario 4: Cosine similarity WITH index, WITH limit (TOP 3)';
SELECT id, label, @query_vector <c> vec AS similarity
FROM tbl
ORDER BY similarity DESC
LIMIT 3;

-- Clean up cosine index
-- DROP VECTOR INDEX idx_vec_cosine ON tbl;

-------------------------------------------------------------------------------
-- TEST 2: EUCLIDEAN DISTANCE (<->) - All 4 Scenarios
-------------------------------------------------------------------------------
SELECT '=== EUCLIDEAN DISTANCE TESTS ===';

-- Scenario 1: Without index, without limit
SELECT 'Scenario 1: Euclidean distance WITHOUT index, WITHOUT limit';
SELECT id, label, @query_vector <-> vec AS distance
FROM tbl
ORDER BY distance ASC;

-- Create vector index for euclidean distance
-- TODO(CUBVEC): CREATE VECTOR INDEX idx_vec_euclidean ON tbl (vec EUCLIDEAN);

-- Scenario 2: With index, without limit
SELECT 'Scenario 2: Euclidean distance WITH index, WITHOUT limit';
SELECT id, label, @query_vector <-> vec AS distance
FROM tbl
ORDER BY distance ASC;

-- Drop index to test scenario 3
-- DROP VECTOR INDEX idx_vec_euclidean ON tbl;

-- Scenario 3: Without index, with limit
SELECT 'Scenario 3: Euclidean distance WITHOUT index, WITH limit (TOP 3)';
SELECT id, label, @query_vector <-> vec AS distance
FROM tbl
ORDER BY distance ASC
LIMIT 3;

-- Recreate index for scenario 4
-- TODO(CUBVEC): CREATE VECTOR INDEX idx_vec_euclidean ON tbl(vec EUCLIDEAN);

-- Scenario 4: With index, with limit
SELECT 'Scenario 4: Euclidean distance WITH index, WITH limit (TOP 3)';
SELECT id, label, @query_vector <-> vec AS distance
FROM tbl
ORDER BY distance ASC
LIMIT 3;

-- Clean up euclidean index
-- DROP VECTOR INDEX idx_vec_euclidean ON tbl;

-------------------------------------------------------------------------------
-- TEST 3: INNER PRODUCT (<#>) - All 4 Scenarios
-------------------------------------------------------------------------------
SELECT '=== INNER PRODUCT TESTS ===';

-- Scenario 1: Without index, without limit
SELECT 'Scenario 1: Inner product WITHOUT index, WITHOUT limit';
SELECT id, label, @query_vector <#> vec AS dot_product
FROM tbl
ORDER BY dot_product DESC;

-- Create vector index for inner product
-- TODO(CUBVEC): CREATE VECTOR INDEX idx_vec_inner ON tbl(vec DOT);

-- Scenario 2: With index, without limit
SELECT 'Scenario 2: Inner product WITH index, WITHOUT limit';
SELECT id, label, @query_vector <#> vec AS dot_product
FROM tbl
ORDER BY dot_product DESC;

-- Drop index to test scenario 3
-- DROP VECTOR INDEX idx_vec_inner ON tbl;

-- Scenario 3: Without index, with limit
SELECT 'Scenario 3: Inner product WITHOUT index, WITH limit (TOP 3)';
SELECT id, label, @query_vector <#> vec AS dot_product
FROM tbl
ORDER BY dot_product DESC
LIMIT 3;

-- Recreate index for scenario 4
-- TODO(CUBVEC): CREATE VECTOR INDEX idx_vec_inner ON tbl(vec DOT);

-- Scenario 4: With index, with limit
SELECT 'Scenario 4: Inner product WITH index, WITH limit (TOP 3)';
SELECT id, label, @query_vector <#> vec AS dot_product
FROM tbl
ORDER BY dot_product DESC
LIMIT 3;

-- Clean up inner product index
-- DROP VECTOR INDEX idx_vec_inner ON tbl;

-------------------------------------------------------------------------------
-- TEST 4: MANHATTAN DISTANCE (<+>) - All 4 Scenarios
-------------------------------------------------------------------------------
SELECT '=== MANHATTAN DISTANCE TESTS ===';

-- Scenario 1: Without index, without limit
SELECT 'Scenario 1: Manhattan distance WITHOUT index, WITHOUT limit';
SELECT id, label, @query_vector <+> vec AS l1_dist
FROM tbl
ORDER BY l1_dist ASC;

-- Create vector index for manhattan distance
-- TODO(CUBVEC): CREATE VECTOR INDEX idx_vec_manhattan ON tbl(vec MANHATTAN);

-- Scenario 2: With index, without limit
SELECT 'Scenario 2: Manhattan distance WITH index, WITHOUT limit';
SELECT id, label, @query_vector <+> vec AS l1_dist
FROM tbl
ORDER BY l1_dist ASC;

-- Drop index to test scenario 3
-- DROP VECTOR INDEX idx_vec_manhattan ON tbl;

-- Scenario 3: Without index, with limit
SELECT 'Scenario 3: Manhattan distance WITHOUT index, WITH limit (TOP 3)';
SELECT id, label, @query_vector <+> vec AS l1_dist
FROM tbl
ORDER BY l1_dist ASC
LIMIT 3;

-- Recreate index for scenario 4
-- TODO(CUBVEC): CREATE VECTOR INDEX idx_vec_manhattan ON tbl(vec MANHATTAN);

-- Scenario 4: With index, with limit
SELECT 'Scenario 4: Manhattan distance WITH index, WITH limit (TOP 3)';
SELECT id, label, @query_vector <+> vec AS l1_dist
FROM tbl
ORDER BY l1_dist ASC
LIMIT 3;

-- Clean up manhattan index
-- DROP VECTOR INDEX idx_vec_manhattan ON tbl;

-------------------------------------------------------------------------------
-- Cleanup
-------------------------------------------------------------------------------
DROP TABLE tbl;
