-------------------------------------------------------------------------------
-- Execution
-------------------------------------------------------------------------------

-- Execution/ Create vector index on table with data
DROP IF EXISTS test_empty_table;
CREATE TABLE test_empty_table (
    id INT,
    vector_data VECTOR(3)
);

INSERT INTO test_empty_table VALUES (1, '[1,2,3]');
INSERT INTO test_empty_table VALUES (2, '[4,5,6]');
INSERT INTO test_empty_table VALUES (3, '[7,8,9]');

CREATE VECTOR INDEX idx_vector_index ON test_empty_table(vector_data COSINE);
DROP INDEX idx_vector_index ON test_empty_table(vector_data);

