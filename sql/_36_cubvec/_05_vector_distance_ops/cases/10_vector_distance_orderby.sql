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

-- Insert various test vectors
INSERT INTO tbl VALUES (1, 'same_as_input', '[1, 2, 3]');
INSERT INTO tbl VALUES (2, 'reverse',        '[3, 2, 1]');
INSERT INTO tbl VALUES (3, 'orthogonal',     '[3, -6, 3]');
INSERT INTO tbl VALUES (4, 'unit',           '[0.2673, 0.5345, 0.8018]'); -- normalized version of [1,2,3]
INSERT INTO tbl VALUES (5, 'zero',           '[0, 0, 0]');
INSERT INTO tbl VALUES (6, 'ones',           '[1, 1, 1]');
INSERT INTO tbl VALUES (7, 'negated_input',  '[-1, -2, -3]');
INSERT INTO tbl VALUES (8, 'random',         '[4, 5, 6]');

-------------------------------------------------------------------------------
-- Execution Tests: Cosine Similarity Operator (<c>)
-------------------------------------------------------------------------------

-- Test cosine similarity from input vector [1,2,3]
-- Expect:
--   Highest similarity (lowest rank) with itself or unit version
--   Lowest (negative) similarity with negated vector
--   Zero similarity with orthogonal vector
SELECT id, label, '[1, 2, 3]' <c> vec AS similarity
FROM tbl
ORDER BY similarity DESC;

-------------------------------------------------------------------------------
-- Execution Tests: Euclidean Distance Operator (<->)
-------------------------------------------------------------------------------

-- Test euclidean distance from input vector [1,2,3]
-- Expect:
--   Zero for exact match
--   Larger distances for more different vectors
SELECT id, label, '[1, 2, 3]' <-> vec AS distance
FROM tbl
ORDER BY distance ASC;

-------------------------------------------------------------------------------
-- Execution Tests: Inner Product Operator (<#>)
-------------------------------------------------------------------------------

-- Test dot product with input vector [1,2,3]
-- Expect:
--   Highest value for similar direction
--   Negative for opposite vectors
--   Zero for orthogonal
SELECT id, label, '[1, 2, 3]' <#> vec AS dot_product
FROM tbl
ORDER BY dot_product DESC;

-------------------------------------------------------------------------------
-- Execution Tests: Manhattan Distance Operator (<+>)
-------------------------------------------------------------------------------

-- Test L1 distance from input vector [1,2,3]
-- Expect:
--   Sum of absolute coordinate differences
SELECT id, label, '[1, 2, 3]' <+> vec AS l1_distance
FROM tbl
ORDER BY l1_distance ASC;
