DROP IF EXISTS tbl;
CREATE TABLE tbl (
    id INT,
    name VECTOR
);
INSERT INTO tbl VALUES (1, '[7,8,9]');
INSERT INTO tbl VALUES (2, '[9,8,7]');

-------------------------------------------------------------------------------
-- Execution
-------------------------------------------------------------------------------
-- Execution/ vector_distance on non-indexed column/ should use COSINE
SELECT '[0,0,0]' <c> name FROM tbl;

-- Execution/ vector_distance on indexed column/ should use EUCLIDEAN
-- TODO: xhnsw_delete_index assertion
-- CREATE VECTOR INDEX idx ON tbl(vector_data EUCLIDEAN);
-- SELECT '[0,0,0]' <-> name FROM tbl;

-- Execution/ vector_distance on indexed column with metric/ should use DOT
SELECT name <#> name FROM tbl;
