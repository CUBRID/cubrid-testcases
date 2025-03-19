--------------------------------------------------------------------------------
-- Spec
--------------------------------------------------------------------------------

DROP IF EXISTS test_empty_table;
CREATE TABLE test_empty_table (
    id INT,
    vector_data VECTOR
);

-- Spec: Cannot create a vector index on an empty table
CREATE VECTOR INDEX idx_empty ON test_empty_table(vector_data);

