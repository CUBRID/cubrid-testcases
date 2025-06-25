-- Prepare
DROP IF EXISTS test_vector_index_hnsw;
CREATE TABLE test_vector_index_hnsw (
    id INT,
    embedding VECTOR(3)
);
-- TODO: Creating vector index on non-empty table is not yet implemented.
-- INSERT INTO test_vector_index_hnsw VALUES (2, '[0.3,0.2,0.1]');
-- INSERT INTO test_vector_index_hnsw VALUES (3, '[0.3,0.2,0.1]');
-- INSERT INTO test_vector_index_hnsw VALUES (4, '[0.3,0.2,0.1]');

--------------------------------------------------------------------------------
-- Syntax
--------------------------------------------------------------------------------
-- Syntax/ creation with parameters/ Valid
-- TODO : min, max, range out value of m and ef_construction should be tested.
-- TODO : Also, when m and ef_construction is changed, recall will be changed, which should be tested by shell test.
CREATE VECTOR INDEX idx_hnsw1 ON test_vector_index_hnsw(embedding COSINE)
  WITH (m = 40, ef_construction = 500);
DROP VECTOR INDEX idx_hnsw1 ON test_vector_index_hnsw(embedding);

-- Syntax/ creation with parameters in reverse order/ Valid
CREATE VECTOR INDEX idx_hnsw2 ON test_vector_index_hnsw(embedding COSINE)
  WITH (ef_construction = 500, m = 40);
DROP VECTOR INDEX idx_hnsw2 ON test_vector_index_hnsw(embedding);

-- Syntax/ m and ef_construction must be integer/ Error
CREATE VECTOR INDEX idx_hnsw3 ON test_vector_index_hnsw(embedding COSINE)
  WITH (ef_construction = 'hello', m = 'world');

-- Syntax/ creation with wrong parameters/ Error
-- TODO: passes
CREATE VECTOR INDEX idx_hnsw4 ON test_vector_index_hnsw(embedding COSINE)
  WITH (a = 5, b = 6);
DROP VECTOR INDEX idx_hnsw4 ON test_vector_index_hnsw(embedding);

-- Syntax/ additional parameters/ Error
-- TODO: passes
CREATE VECTOR INDEX idx_hnsw5 ON test_vector_index_hnsw(embedding COSINE)
  WITH (m = 40, ef_construction = 500, a = 5, b = 6);
DROP VECTOR INDEX idx_hnsw5 ON test_vector_index_hnsw(embedding);

-- Syntax/ duplicate parameters/ Error
-- TODO: passes
CREATE VECTOR INDEX idx_hnsw6 ON test_vector_index_hnsw(embedding COSINE)
  WITH (m = 40, ef_construction = 500, m = 40);
DROP VECTOR INDEX idx_hnsw6 ON test_vector_index_hnsw(embedding);

--------------------------------------------------------------------------------
-- Execution
--------------------------------------------------------------------------------
-- Prepare
DROP IF EXISTS test_invalid_params;
CREATE TABLE test_invalid_params (
    id INT,
    embedding VECTOR(3)
);
-- TODO: Not yet implemented.
-- INSERT INTO test_invalid_params VALUES (1, '[1,2,3]');

-- Execution/ m is zero/ Error
-- TODO: Must be error but currently passes.
CREATE VECTOR INDEX idx_invalid_params ON test_invalid_params(embedding COSINE)
  WITH (m = 0, ef_construction = 1);
DROP VECTOR INDEX idx_invalid_params ON test_invalid_params(embedding);

-- Execution/ ef_construction is zero/ Error
-- TODO: Must be error but currently passes.
CREATE VECTOR INDEX idx_invalid_params2 ON test_invalid_params(embedding COSINE)
  WITH (m = 40, ef_construction = 0);
DROP VECTOR INDEX idx_invalid_params2 ON test_invalid_params(embedding);

