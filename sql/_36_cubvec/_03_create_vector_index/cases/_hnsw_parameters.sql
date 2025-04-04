-- Prepare
DROP IF EXISTS test_vector_index_hnsw;
CREATE TABLE test_vector_index_hnsw (
    id INT,
    vec1 VECTOR
    vec2 VECTOR
);
INSERT INTO test_vector_index_hnsw VALUES (1, '[0.1,0.2,0.3]', '[0.1,0.2,0.3]');
INSERT INTO test_vector_index_hnsw VALUES (2, '[0.3,0.2,0.1]');
INSERT INTO test_vector_index_hnsw VALUES (3, '[0.3,0.2,0.1]');
INSERT INTO test_vector_index_hnsw VALUES (4, '[0.3,0.2,0.1]');

--------------------------------------------------------------------------------
-- Syntax
--------------------------------------------------------------------------------
-- Syntax/ creation with parameters/ Valid
drop vector index idx_hnsw;
CREATE VECTOR INDEX idx_hnsw ON test_vector_index_hnsw(embedding COSINE)
  WITH (m = 40, ef_construction = 500);

-- Syntax/ creation with parameters in reverse order/ Valid
drop vector index idx_hnsw;
CREATE VECTOR INDEX idx_hnsw ON test_vector_index_hnsw(embedding COSINE)
  WITH (ef_construction = 500, m = 40);

-- Syntax/ m and ef_construction must be integer/ Error
drop vector index idx_hnsw;
CREATE VECTOR INDEX idx_hnsw ON test_vector_index_hnsw(embedding COSINE)
  WITH (ef_construction = 'hello', m = 'world');

-- Syntax/ creation with wrong parameters/ Error
drop vector index idx_hnsw;
CREATE VECTOR INDEX idx_hnsw ON test_vector_index_hnsw(embedding COSINE)
  WITH (a = 5, b = 6);

-- Syntax/ additional parameters/ Error
drop vector index idx_hnsw;
CREATE VECTOR INDEX idx_hnsw ON test_vector_index_hnsw(embedding COSINE)
  WITH (m = 40, ef_construction = 500, a = 5, b = 6);

-- Syntax/ duplicate parameters/ Error
drop vector index idx_hnsw;
CREATE VECTOR INDEX idx_hnsw ON test_vector_index_hnsw(embedding COSINE)
  WITH (m = 40, ef_construction = 500, m = 40);

--------------------------------------------------------------------------------
-- Execution
--------------------------------------------------------------------------------
-- Prepare
CREATE TABLE test_invalid_params (
    id INT,
    embedding VECTOR
);
INSERT INTO test_invalid_params VALUES (1, '[1,2,3]');

-- Execution/ ef_construction is zero/ Error
CREATE VECTOR INDEX idx_invalid_params2 ON test_invalid_params(embedding COSINE)
  WITH (m = 40, ef_construction = 0);

-- Execution/ m is zero/ Error
CREATE VECTOR INDEX idx_valid_boundary ON test_invalid_params(embedding COSINE)
  WITH (m = 0, ef_construction = 1);
