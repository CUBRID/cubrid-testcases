-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

DROP IF EXISTS test_non_vector;
CREATE TABLE test_non_vector (
    id INT,
    name VARCHAR(50)
);
INSERT INTO test_non_vector VALUES (1, 'Alice');
SELECT VECTOR_DISTANCE(name, name, COSINE) FROM test_non_vector;
SELECT COSINE_DISTANCE(name name) FROM test_non_vector;
SELECT COSINE_DISTANCE(name,, name) FROM test_non_vector;
SELECT COSINE_DISTANCE(name name) FROM test_non_vector;

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- Semantics/ Argument type/ Error
DROP IF EXISTS test_non_vector;
CREATE TABLE test_non_vector (
    id INT,
    name VARCHAR(50)
);
INSERT INTO test_non_vector VALUES (1, 'Alice');
SELECT COSINE_DISTANCE(name, name) FROM test_non_vector;

-- Error for other metrics too
SELECT VECTOR_DISTANCE(name, name, COSINE) FROM test_non_vector;
SELECT INNER_PRODUCT(name, name) FROM test_non_vector;
SELECT L1_DISTANCE(name, name) FROM test_non_vector;
SELECT L2_DISTANCE(name, name) FROM test_non_vector;

-- Semantics/ Argument looks like vector but not vector type/ Error
DROP IF EXISTS test_non_vector;
CREATE TABLE test_non_vector (
    id INT,
    name VARCHAR(50)
);
INSERT INTO test_non_vector VALUES (1, '[1,2,3]');
SELECT VECTOR_DISTANCE(name, name, COSINE) FROM test_non_vector;
SELECT COSINE_DISTANCE(name, name) FROM test_non_vector;
SELECT INNER_PRODUCT(name, name) FROM test_non_vector;
SELECT L1_DISTANCE(name, name) FROM test_non_vector;
SELECT L2_DISTANCE(name, name) FROM test_non_vector;

-- Semantics/ Vector and non-vector/ Error
DROP IF EXISTS test_non_vector;
CREATE TABLE test_non_vector (
    id INT,
    name VARCHAR(50)
    vec VECTOR(3)
);
-- Semantics/ Vector and non-vector/ Vector and Varchar/ Error
INSERT INTO test_non_vector VALUES (1, '[3,2,1]', '[1,2,3]');
INSERT INTO test_non_vector VALUES (2, '[2,3,4]', '[4,5,6]');
SELECT VECTOR_DISTANCE(name, vec, COSINE) FROM test_non_vector;
SELECT VECTOR_DISTANCE(vec, name, EUCLIDEAN) FROM test_non_vector;
SELECT COSINE_DISTANCE(name, vec) FROM test_non_vector;
SELECT COSINE_DISTANCE(vec, name) FROM test_non_vector;
SELECT INNER_PRODUCT(name, vec) FROM test_non_vector;
SELECT L1_DISTANCE(name, vec) FROM test_non_vector;
SELECT L2_DISTANCE(name, vec) FROM test_non_vector;

-- Semantics/ Vector and non-vector/ Vector and Int/ Error
SELECT VECTOR_DISTANCE(id, vec, COSINE) FROM test_non_vector;
SELECT VECTOR_DISTANCE(vec, id, EUCLIDEAN) FROM test_non_vector;
SELECT COSINE_DISTANCE(id, vec) FROM test_non_vector;
SELECT COSINE_DISTANCE(vec, id) FROM test_non_vector;
SELECT INNER_PRODUCT(id, vec) FROM test_non_vector;
SELECT L1_DISTANCE(id, vec) FROM test_non_vector;
SELECT L2_DISTANCE(id, vec) FROM test_non_vector;

-- Semantics/ Vector Element Type Not Binary/ Valid
SELECT VECTOR_DISTANCE(vec, vec) FROM test_non_vector;
SELECT COSINE_DISTANCE(vec, vec) FROM test_non_vector;
-- Semantics/ Vector Element Type Not Binary/ Error
SELECT HAMMING_DISTANCE(vec, vec) FROM test_non_vector;
SELECT JACCARD_DISTANCE(vec, vec) FROM test_non_vector;

-------------------------------------------------------------------------------
-- Spec
-------------------------------------------------------------------------------

-- Spec/ Two Column Arguments/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[1,2,3]');
INSERT INTO test_vector_table VALUES (2, '[3,2,1]');
SELECT 
    VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance,
    COSINE_DISTANCE(t1.vector_col, t2.vector_col) AS cosine_distance,
    INNER_PRODUCT(t1.vector_col, t2.vector_col) AS inner_product,
    L1_DISTANCE(t1.vector_col, t2.vector_col) AS l1_distance,
    L2_DISTANCE(t1.vector_col, t2.vector_col) AS l2_distance,
FROM test_vector_table t1, test_vector_table t2;

-- Spec/ Column and a literal/ Valid
SELECT 
    VECTOR_DISTANCE(vector_col, '[2, 3, 4]', COSINE) AS cosine_distance,
    COSINE_DISTANCE(vector_col, '[2, 3, 4]') AS cosine_distance,
    INNER_PRODUCT(vector_col, '[2, 3, 4]') AS inner_product,
    L1_DISTANCE(vector_col, '[2, 3, 4]') AS l1_distance,
    L2_DISTANCE(vector_col, '[2, 3, 4]') AS l2_distance,
FROM test_vector_table;

SELECT 
    VECTOR_DISTANCE('[2, 3, 4]', vector_col, COSINE) AS cosine_distance,
    COSINE_DISTANCE('[2, 3, 4]', vector_col) AS cosine_distance,
    INNER_PRODUCT('[2, 3, 4]', vector_col) AS inner_product,
    L1_DISTANCE('[2, 3, 4]', vector_col) AS l1_distance,
    L2_DISTANCE('[2, 3, 4]', vector_col) AS l2_distance,
FROM test_vector_table;

-- -- Spec/ NULL and column/ Valid
-- SELECT 
--     VECTOR_DISTANCE(NULL, vector_col, COSINE) AS cosine_distance,
--     COSINE_DISTANCE(NULL, vector_col) AS cosine_distance,
--     INNER_PRODUCT(NULL, vector_col) AS inner_product,
--     L1_DISTANCE(NULL, vector_col) AS l1_distance,
--     L2_DISTANCE(NULL, vector_col) AS l2_distance,
-- FROM test_vector_table;

-- -- Spec/ column and NULL/ Valid
-- SELECT 
--     VECTOR_DISTANCE(vector_col, NULL, COSINE) AS cosine_distance,
--     INNER_PRODUCT(vector_col, NULL) AS inner_product,
--     L1_DISTANCE(vector_col, NULL) AS l1_distance,
--     L2_DISTANCE(vector_col, NULL) AS l2_distance,
-- FROM test_vector_table;

-- Spec/ Different vector dimensions/ Error
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR
);
INSERT INTO test_vector_table VALUES (1, '[1,2,3]');
INSERT INTO test_vector_table VALUES (2, '[1,2,3,4]');  -- Different dimension
INSERT INTO test_vector_table VALUES (3, '[1,2]');     -- Different dimension
SELECT 
    VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance,
    COSINE_DISTANCE(t1.vector_col, t2.vector_col) AS cosine_distance,
    INNER_PRODUCT(t1.vector_col, t2.vector_col) AS inner_product,
    L1_DISTANCE(t1.vector_col, t2.vector_col) AS l1_distance,
    L2_DISTANCE(t1.vector_col, t2.vector_col) AS l2_distance,
FROM test_vector_table t1, test_vector_table t2;

-- Spec/ Empty vectors/ Error
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR
);
INSERT INTO test_vector_table VALUES (1, '[]');
INSERT INTO test_vector_table VALUES (2, '[1,2,3]');
SELECT 
    VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance
FROM test_vector_table t1, test_vector_table t2;

-- Spec/ Zero vectors/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(4)
);
INSERT INTO test_vector_table VALUES (1, '[0,0,0,0]');
INSERT INTO test_vector_table VALUES (2, '[0,0,0,0]');
SELECT 
    VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance,
    COSINE_DISTANCE(t1.vector_col, t2.vector_col) AS cosine_distance,
    INNER_PRODUCT(t1.vector_col, t2.vector_col) AS inner_product,
    L1_DISTANCE(t1.vector_col, t2.vector_col) AS l1_distance,
    L2_DISTANCE(t1.vector_col, t2.vector_col) AS l2_distance,
FROM test_vector_table t1, test_vector_table t2;

-- Spec/ Negative values/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[-1,-2,-3]');
INSERT INTO test_vector_table VALUES (2, '[1,2,3]');
SELECT 
    VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance,
    COSINE_DISTANCE(t1.vector_col, t2.vector_col) AS cosine_distance,
    INNER_PRODUCT(t1.vector_col, t2.vector_col) AS inner_product,
    L1_DISTANCE(t1.vector_col, t2.vector_col) AS l1_distance,
    L2_DISTANCE(t1.vector_col, t2.vector_col) AS l2_distance,
FROM test_vector_table t1, test_vector_table t2;

-- Spec/ Non integer values/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[1.5,2.5,3.5]');
INSERT INTO test_vector_table VALUES (2, '[0.1,0.2,0.3]');
SELECT 
    VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance,
    COSINE_DISTANCE(t1.vector_col, t2.vector_col) AS cosine_distance,
    INNER_PRODUCT(t1.vector_col, t2.vector_col) AS inner_product,
    L1_DISTANCE(t1.vector_col, t2.vector_col) AS l1_distance,
    L2_DISTANCE(t1.vector_col, t2.vector_col) AS l2_distance,
FROM test_vector_table t1, test_vector_table t2;

-- Spec/ large numbers/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[1e10,2e10,3e10]');
INSERT INTO test_vector_tablE VALUES (2, '[1e-10,2e-10,3e-10]');
SELECT 
    VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance,
    COSINE_DISTANCE(t1.vector_col, t2.vector_col) AS cosine_distance,
    INNER_PRODUCT(t1.vector_col, t2.vector_col) AS inner_product,
    L1_DISTANCE(t1.vector_col, t2.vector_col) AS l1_distance,
    L2_DISTANCE(t1.vector_col, t2.vector_col) AS l2_distance,
FROM test_vector_table t1, test_vector_table t2;

-- Spec/ very large numbers exceeding floating points range/ Error
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[1e100,2e100,3e100]');
INSERT INTO test_vector_tablE VALUES (2, '[1e-100,2e-100,3e-100]');
SELECT 
    VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance,
    COSINE_DISTANCE(t1.vector_col, t2.vector_col) AS cosine_distance,
    INNER_PRODUCT(t1.vector_col, t2.vector_col) AS inner_product,
    L1_DISTANCE(t1.vector_col, t2.vector_col) AS l1_distance,
    L2_DISTANCE(t1.vector_col, t2.vector_col) AS l2_distance,
FROM test_vector_table t1, test_vector_table t2;
