-- Prepare a table with a vector column.
DROP IF EXISTS test_vector_index;
CREATE TABLE test_vector_index (
    id INT,
    vector_data VECTOR
    varchar_data VARCHAR
);
INSERT INTO test_vector_index VALUES (1, '[1,2,3]', '[1,2,3]');
INSERT INTO test_vector_index VALUES (2, '[3,2,1]', '[3,2,1]');

--------------------------------------------------------------------------------
-- Syntax
--------------------------------------------------------------------------------
-- Syntax: Valid
CREATE VECTOR INDEX idx_vector1 ON test_vector_index(vector_data COSINE);

-- Syntax: Missing parens: Error
CREATE VECTOR INDEX idx_vector1 ON test_vector_index;

-- Syntax: Missing column name: Error
CREATE VECTOR INDEX idx_vector1 ON test_vector_index();

-- Syntax: Missing column name: Error
CREATE VECTOR INDEX idx_vector1 ON test_vector_index(COSINE);
--
-- Syntax: Missing metric name: Error
CREATE VECTOR INDEX idx_vector1 ON test_vector_index(vector_data);

--------------------------------------------------------------------------------
-- Semantics
--------------------------------------------------------------------------------
-- Semantics: Create vector index on non-vector type: Error
CREATE VECTOR INDEX idx_vector1 ON test_vector_index(id COSINE);
CREATE VECTOR INDEX idx_vector1 ON test_vector_index(varchar_data COSINE);
