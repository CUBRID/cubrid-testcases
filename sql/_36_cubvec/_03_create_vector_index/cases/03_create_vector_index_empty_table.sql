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

-- Vector index shoud not be affected by other constraints such as primary key or not null.
-- This TC is for verifying bugfix issue for dropping vector index which is occured by using BTID for vector index indication.

DROP IF EXISTS test_primary_key_table;
CREATE TABLE test_primary_key_table (
    id INT PRIMARY KEY,
    vector_data VECTOR(3)
);
CREATE VECTOR INDEX idx_v ON test_primary_key_table(vector_data COSINE);
DROP INDEX idx_v ON test_primary_key_table(vector_data);

DROP IF EXISTS test_not_null_table;
CREATE TABLE test_not_null_table (
    id INT NOT NULL,
    vector_data VECTOR(3)
);
CREATE VECTOR INDEX idx_v ON test_not_null_table(vector_data COSINE);
DROP INDEX idx_v ON test_not_null_table(vector_data);

