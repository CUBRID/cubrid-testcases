--------------------------------------------------------------------------------
-- Spec
--------------------------------------------------------------------------------
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR
);
INSERT INTO test_vector_table VALUES (1, '[1,2]');
INSERT INTO test_vector_table VALUES (2, '[1,2,3]');

-- Spec/ Cannot create vector index on various dimension column/ Error
SELECT VECTOR_DISTANCE(t1.vector_col, t2.vector_col, COSINE) AS cosine_distance
FROM test_vector_table t1, test_vector_table t2;

