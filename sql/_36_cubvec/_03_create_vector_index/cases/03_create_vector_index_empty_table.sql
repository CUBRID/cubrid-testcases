-------------------------------------------------------------------------------
-- Execution
-------------------------------------------------------------------------------

-- Execution/ Create vector index on empty column/ Valid
DROP IF EXISTS test_empty_table;
CREATE TABLE test_empty_table (
    id INT,
    vector_data VECTOR(3)
);
CREATE VECTOR INDEX idx_empty ON test_empty_table(vector_data COSINE);
DROP INDEX idx_empty ON test_empty_table(vector_data);

