DROP TABLE IF EXISTS test_tbl;

CREATE TABLE test_tbl(x INT PRIMARY KEY);

DELETE FROM test_tbl WHERE x IN (SELECT 1);
DELETE FROM test_tbl WHERE x IN (SELECT 1);
UPDATE test_tbl set x = 1 WHERE x IN (SELECT 1);
UPDATE test_tbl set x = 1 WHERE x IN (SELECT 1);

DROP TABLE test_tbl;
