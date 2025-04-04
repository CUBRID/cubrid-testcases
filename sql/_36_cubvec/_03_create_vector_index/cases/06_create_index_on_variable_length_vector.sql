-------------------------------------------------------------------------------
-- Execution
-------------------------------------------------------------------------------

-- Execution/ Create vector index on variable length vector column/ Error
DROP IF EXISTS tbl;
CREATE TABLE tbl (
    id INT,
    vector_data VECTOR
);
CREATE VECTOR INDEX idx ON tbl(vector_data);

