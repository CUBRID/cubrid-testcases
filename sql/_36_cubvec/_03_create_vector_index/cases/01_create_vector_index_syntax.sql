-- Prepare a table with a vector column.
DROP IF EXISTS test_vector_index;
CREATE TABLE test_vector_index (
    id INT,
    vector_data VECTOR,
    varchar_data VARCHAR
);
INSERT INTO test_vector_index VALUES (1, '[1,2,3]', '[1,2,3]');
INSERT INTO test_vector_index VALUES (2, '[3,2,1]', '[3,2,1]');

--------------------------------------------------------------------------------
-- Syntax
--------------------------------------------------------------------------------
-- Syntax/ Create Index (pg compat)
-- Syntax/ Create Index/ With Metric/ Valid
-- TODO: Should be able to make vector index with create index statement too.
-- CREATE INDEX idx_vector1 ON test_vector_index(vector_data COSINE);
-- drop index idx_vector1;
-- Syntax/ Create Index/ Without Metric/ Valid
-- TODO: Should be able to make vector index with create index statement too.
-- CREATE INDEX idx_vector1 ON test_vector_index(vector_data COSINE);
-- DROP VECTOR INDEX idx_vector1 on tbl(vector_data);

-- Syntax/ Create Vector Index
-- Syntax/ Create Vector Index/ With Metric/Valid
CREATE VECTOR INDEX idx_vector1 ON test_vector_index(vector_data COSINE);
-- DROP VECTOR INDEX idx_vector1 on test_vector_index(vector_data);

-- Syntax/ Create Vector Index/ Without Metric/ Valid
-- TODO: Should be able to create without metric.
-- CREATE VECTOR INDEX idx_vector2 ON test_vector_index(vector_data);
-- DROP VECTOR INDEX idx_vector2 on tbl(vector_data);

-- Syntax/ Create Vector Index/ Missing parens/ Error
CREATE VECTOR INDEX idx_vector3 ON test_vector_index;

-- Syntax/ Create Vector Index/ Missing column name/ Error
CREATE VECTOR INDEX idx_vector4 ON test_vector_index();

-- Syntax/ Create Vector Index/ Missing column name/ Error
CREATE VECTOR INDEX idx_vector5 ON test_vector_index(COSINE);

--------------------------------------------------------------------------------
-- Semantics
--------------------------------------------------------------------------------
-- Semantics/ Create Vector Index/Non-vector type/ Error
-- TODO: Currently these statements pass
-- CREATE VECTOR INDEX idx_vector6 ON test_vector_index(id COSINE);
-- DROP VECTOR INDEX idx_vector6 on test_vector_index(id);
-- CREATE VECTOR INDEX idx_vector7 ON test_vector_index(varchar_data COSINE);
-- DROP VECTOR INDEX idx_vector7 on test_vector_index(varchar_data);
