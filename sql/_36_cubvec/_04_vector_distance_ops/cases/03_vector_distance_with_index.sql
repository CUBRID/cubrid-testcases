-------------------------------------------------------------------------------
-- Setup
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl (
    id INT,
    name VECTOR(3)
);

-- Insert test vectors
INSERT INTO tbl VALUES (1, '[1, 0, 0]');
INSERT INTO tbl VALUES (2, '[0, 1, 0]');
INSERT INTO tbl VALUES (3, '[0, 0, 1]');
INSERT INTO tbl VALUES (4, '[1, 1, 1]');
INSERT INTO tbl VALUES (5, '[0.9, 0, 0]');
INSERT INTO tbl VALUES (6, '[0, 0.9, 0]');
INSERT INTO tbl VALUES (7, '[0, 0, 0.9]');
INSERT INTO tbl VALUES (8, '[0.5, 0.5, 0]');

-- Use a query vector designed to be closest to a few of them
SET @q = '[1, 0, 0]';

-------------------------------------------------------------------------------
-- Execution/ COSINE <c> on non-indexed column
-------------------------------------------------------------------------------
-- Should perform full scan (sequential)
SELECT id, @q <c> name AS sim FROM tbl ORDER BY sim DESC;
SELECT id AS sim FROM tbl ORDER BY @q <c> name DESC;

-------------------------------------------------------------------------------
-- Execution/ COSINE <c> on indexed column (HNSW)
-------------------------------------------------------------------------------
-- Create an index using HNSW with COSINE metric
-- CREATE VECTOR INDEX idx ON tbl(name COSINE);

-- Query should now use ANN search with HNSW
-- SELECT id, @q <c> name AS sim FROM tbl ORDER BY sim DESC LIMIT 3;
-- SELECT id, @q <c> name FROM tbl ORDER BY @q <c> name DESC LIMIT 3;


