
DROP IF EXISTS tbl;
CREATE TABLE tbl (
    id INT,
    vector_data VECTOR
);
INSERT INTO test_index_lifecycle VALUES (1, '[7,8,9]');
INSERT INTO test_index_lifecycle VALUES (2, '[9,8,7]');
SELECT VECTOR_DISTANCE('[0,0,0]', name) FROM tbl;

-------------------------------------------------------------------------------
-- spec
-------------------------------------------------------------------------------
-- spec: vector_distance on non-indexed column: should use COSINE
SELECT VECTOR_DISTANCE('[0,0,0]', name) FROM tbl;

CREATE VECTOR INDEX idx ON tbl(vector_data EUCLIDEAN);
-- spec: vector_distance on indexed column: should use EUCLIDEAN
SELECT VECTOR_DISTANCE('[0,0,0]', name) FROM tbl;

-- spec: vector_distance on indexed column with metric: should use DOT
SELECT VECTOR_DISTANCE(name, name, DOT) FROM tbl;

