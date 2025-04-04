--------------------------------------------------------------------------------
-- Execution
--------------------------------------------------------------------------------

DROP IF EXISTS test_empty_table;
CREATE TABLE test_empty_table (
    id INT,
    vector_data VECTOR
);

-- Execution/ Create vector index on empty column/ Valid
CREATE VECTOR INDEX idx_empty ON test_empty_table(vector_data);

