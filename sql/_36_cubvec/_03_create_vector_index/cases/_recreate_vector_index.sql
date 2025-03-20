--------------------------------------------------------------------------------
-- Spec
--------------------------------------------------------------------------------
DROP IF EXISTS test_index_lifecycle;
CREATE TABLE test_index_lifecycle (
    id INT,
    vector_data VECTOR
);
INSERT INTO test_index_lifecycle VALUES (1, '[7,8,9]');
INSERT INTO test_index_lifecycle VALUES (2, '[9,8,7]');
CREATE VECTOR INDEX idx_lifecycle ON test_index_lifecycle(vector_data);
DROP INDEX idx_lifecycle ON test_index_lifecycle; -- Drop index.

-- Spec/ Re-create index after DROP/ Valid
CREATE VECTOR INDEX idx_lifecycle ON test_index_lifecycle(vector_data);

