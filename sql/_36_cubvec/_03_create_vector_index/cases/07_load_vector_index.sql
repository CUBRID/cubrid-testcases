-------------------------------------------------------------------------------
-- Execution
-------------------------------------------------------------------------------

-- Execution/ Create vector index on table with data
DROP IF EXISTS test_empty_table;
CREATE TABLE test_empty_table (
    id INT,
    vector_data VECTOR(3)
);

INSERT INTO test_empty_table VALUES (1, '[1,2,3]');
INSERT INTO test_empty_table VALUES (2, '[1,0,2]');
INSERT INTO test_empty_table VALUES (3, '[3,4,5]');
INSERT INTO test_empty_table VALUES (4, '[0,0,1]');
INSERT INTO test_empty_table VALUES (5, '[5,6,7]');
INSERT INTO test_empty_table VALUES (6, '[9,8,7]');
INSERT INTO test_empty_table VALUES (7, '[1,1,0]');
INSERT INTO test_empty_table VALUES (8, '[0,1,0]');
INSERT INTO test_empty_table VALUES (9, '[1,1,1]');
INSERT INTO test_empty_table VALUES (10, '[1,0,1]');
INSERT INTO test_empty_table VALUES (11, '[2,3,4]');
INSERT INTO test_empty_table VALUES (12, '[1,1,1]');

CREATE VECTOR INDEX idx_vector_index ON test_empty_table(vector_data EUCLIDEAN);

set trace on;

SELECT id FROM test_empty_table ORDER by l2_distance(vector_data, '[0,0,0]') LIMIT 3;

show trace;

DROP INDEX idx_vector_index ON test_empty_table(vector_data);

