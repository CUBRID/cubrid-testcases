-------------------------------------------------------------------------------
-- Execution
-------------------------------------------------------------------------------

-- Execution/ Create vector index on variable length vector column/ Error
DROP IF EXISTS tbl;
CREATE TABLE tbl (
    id INT,
    vector_data VECTOR
);
-- TODO: Must fail but passes.
CREATE VECTOR INDEX idx ON tbl(vector_data COSINE);
DROP VECTOR INDEX idx ON tbl(vector_data);

