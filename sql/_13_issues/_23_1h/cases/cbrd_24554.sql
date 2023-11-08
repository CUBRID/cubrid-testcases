-- This test case verifies CBRD-24554 issue.
-- incorrect result of "NOT EXISTS" and "NOT IN" with sub-query returning null

DROP TABLE IF EXISTS t1;

CREATE TABLE t1 (a INT);
INSERT INTO t1 VALUES (1);
SELECT * FROM t1 WHERE NOT EXISTS (SELECT 1 FROM dual WHERE 'a' = 'b');
SELECT * FROM t1 WHERE 1 NOT IN (SELECT 1 FROM dual WHERE 'a' = 'b');

DROP TABLE IF EXISTS t1;
