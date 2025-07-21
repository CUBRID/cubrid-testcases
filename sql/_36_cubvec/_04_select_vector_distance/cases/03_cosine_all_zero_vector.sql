-- When an all-zero vector is involved in cosine distance computation, it leads to a mathematically undefined issue.
-- The formula for cosine distance is:
--   cosine_distance(A, B) = 1 - (A · B) / (||A|| ||B||)
-- If either A or B is an all-zero vector (e.g., [0, 0, 0, ..., 0]), a division-by-zero occurs due to the zero magnitude.
-- Test the cases where such vectors are allowed as index inputs or used in search queries.

-- Test 1: all zero vector is not allowed as index input.
-- Therefore, even if the data is inserted into the table, it does not appear in the index result.
DROP TABLE vtbl;
CREATE TABLE vtbl (id int, vec vector(3));
CREATE VECTOR INDEX vidx ON vtbl(vec COSINE); -- default m, ef_construction

INSERT INTO vtbl VALUES (1, '[1, 1, 1]');
INSERT INTO vtbl VALUES (2, '[1, 2, 3]');
INSERT INTO vtbl VALUES (3, '[0, 0, 0]');        -- all zeros
INSERT INTO vtbl VALUES (4, '[2, 2, 2]');
INSERT INTO vtbl VALUES (5, '[-1, -1, -1]');
INSERT INTO vtbl VALUES (6, '[100, 100, 100]');
INSERT INTO vtbl VALUES (7, '[0.1, 0.1, 0.1]');

SELECT COUNT(*) FROM (SELECT vec from vtbl where vec = '[0, 0, 0]');

SELECT id, CAST (vec AS VARCHAR) FROM vtbl ORDER BY vec <c> '[-1, -1, -1]' LIMIT 3;

-- Test 2: When using an all-zero vector as a condition in the vector index, it does not return any results.
SELECT id, CAST (vec AS VARCHAR) FROM vtbl ORDER BY vec <c> '[0, 0, 0]' LIMIT 3;

DROP TABLE vtbl;

-- Test 3: It does not affect metrics other than the cosine metric.
CREATE TABLE vtbl (id int, vec vector(3));
CREATE VECTOR INDEX vidx ON vtbl(vec EUCLIDEAN); -- default m, ef_construction

INSERT INTO vtbl VALUES (1, '[1, 1, 1]');
INSERT INTO vtbl VALUES (2, '[1, 2, 3]');
INSERT INTO vtbl VALUES (3, '[0, 0, 0]');        -- all zeros
INSERT INTO vtbl VALUES (4, '[2, 2, 2]');
INSERT INTO vtbl VALUES (5, '[-1, -1, -1]');
INSERT INTO vtbl VALUES (6, '[100, 100, 100]');
INSERT INTO vtbl VALUES (7, '[0.1, 0.1, 0.1]');

SELECT id, CAST (vec AS VARCHAR) FROM vtbl ORDER BY vec <c> '[-1, -1, -1]' LIMIT 3;
SELECT id, CAST (vec AS VARCHAR) FROM vtbl ORDER BY vec <c> '[0, 0, 0]' LIMIT 3;

DROP TABLE vtbl;
