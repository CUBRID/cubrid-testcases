-------------------------------------------------------------------------------
-- Execution
-------------------------------------------------------------------------------

-- Execution/ Create vector index on zero length vector column/ Error
DROP IF EXISTS tbl;
CREATE TABLE tbl (
    id INT,
    vector_data VECTOR
);

CREATE VECTOR INDEX idx ON tbl(vector_data COSINE);
DROP VECTOR INDEX idx ON tbl(vector_data);

-- Execution/ Create vector index on variable length vector column/ Pass
DROP IF EXISTS tbl;
CREATE TABLE tbl (
    id INT,
    vector_data VECTOR(3)
);

CREATE VECTOR INDEX idx ON tbl(vector_data COSINE);
DROP VECTOR INDEX idx ON tbl(vector_data);
