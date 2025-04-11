--------------------------------------------------------------------------------
-- Execution
--------------------------------------------------------------------------------

-- Execution/ Multiple Vector Indexes on the Same Vector Column (Invalid)
DROP IF EXISTS test_vector_index;
CREATE TABLE test_vector_index (
    id INT,
    vector_data VECTOR
);
-- TODO: creating vector index on non-empty table not yet implemented.
-- INSERT INTO test_vector_index VALUES (1, '[1,2,3]');
-- INSERT INTO test_vector_index VALUES (2, '[3,2,1]');

CREATE VECTOR INDEX idx_vector1 ON test_vector_index(vector_data COSINE);
-- Execution/ Cannot create index with the same name/ Error
CREATE VECTOR INDEX idx_vector1 ON test_vector_index(vector_data COSINE);

-- Execution/ Cannot create index with the same metric/ Error
-- TODO: Currently a vector index with the same metric is being created.
-- TODO: This also breaks CTP.
-- CREATE VECTOR INDEX idx_vector2 ON test_vector_index(vector_data COSINE);

-- Execution/ Cannot create index with different metric/ Error
-- TODO:  This breaks CTP.
-- If call drop statements below (which are commented out), the CTP breaks.
-- CREATE VECTOR INDEX idx_vector3 ON test_vector_index(vector_data EUCLIDEAN);
-- CREATE VECTOR INDEX idx_vector4 ON test_vector_index(vector_data DOT);
-- CREATE VECTOR INDEX idx_vector5 ON test_vector_index(vector_data MANHATTAN);
-- TODO! Only for Binary vectors
-- CREATE VECTOR INDEX idx_vector6 ON test_vector_index(vector_data HAMMING);
-- CREATE VECTOR INDEX idx_vector7 ON test_vector_index(vector_data JACCARD);

-- Clean up.
-- TODO: drop statement on idx_vector{2-5} must be deleted later.
DROP VECTOR INDEX idx_vector1 ON test_vector_index(vector_data);
