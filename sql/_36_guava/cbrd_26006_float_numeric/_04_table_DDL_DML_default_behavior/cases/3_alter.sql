/* 3. ALTER tests */

-- ===========================================================================
-- Section 1: sequential ALTER flow
-- ===========================================================================
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (col1 NUMERIC(5));
CREATE INDEX idx_01 ON t1 (col1);

SHOW CREATE TABLE t1;
INSERT INTO t1 VALUES (1.1);
SELECT * FROM t1;

evaluate '1-1. ALTER MODIFY: NUMERIC precision';
ALTER TABLE t1 MODIFY col1 NUMERIC(20);
SHOW CREATE TABLE t1;
INSERT INTO t1 VALUES (1.1);
SELECT * FROM t1;

evaluate '1-2. ALTER MODIFY: Fixed NUMERIC -> Float NUMERIC (no explicit p/s)';
ALTER TABLE t1 MODIFY col1 NUMERIC;
SHOW CREATE TABLE t1;
INSERT INTO t1 VALUES (1.1);
SELECT * FROM t1;

evaluate '1-3. ALTER ADD: Adding a new column FIRST inserts NULLs for existing rows.';
ALTER TABLE t1 ADD COLUMN name VARCHAR FIRST;
SHOW CREATE TABLE t1;
INSERT INTO t1 VALUES ('1', 1.1);
SELECT * FROM t1;

evaluate '1-4. ALTER CHANGE: VARCHAR -> NUMERIC';
ALTER TABLE t1 CHANGE name col2 NUMERIC(20);
SHOW CREATE TABLE t1;
INSERT INTO t1 VALUES (1.1, 2.2);
SELECT * FROM t1;

evaluate '1-5. ALTER CHANGE: Float NUMERIC -> Fixed NUMERIC(p,s)';
ALTER TABLE t1 CHANGE col1 col3 NUMERIC(10,5);
SHOW CREATE TABLE t1;
INSERT INTO t1 VALUES (1.1, 2.2);
SELECT * FROM t1;

evaluate '1-6. ALTER CHANGE: NUMERIC PRIMARY KEY - fails with NULLs, succeeds after DELETE';
-- Expect error due to existing NULLs
ALTER TABLE t1 CHANGE col2 col1 NUMERIC PRIMARY KEY; 
DELETE FROM t1 WHERE col2 IS NULL OR col2 = 1;
ALTER TABLE t1 CHANGE col2 col1 NUMERIC PRIMARY KEY;

evaluate '1-7. ALTER DROP: DROP NUMERIC COLUMN';
ALTER TABLE t1 DROP COLUMN col3;
SHOW CREATE TABLE t1;
INSERT INTO t1 VALUES (0.00000000001);
SELECT * FROM t1;

DROP TABLE IF EXISTS t1;

-- ===========================================================================
-- Section 2: MODIFY narrowing validates existing data
-- ===========================================================================
evaluate '2-1. MODIFY narrowing precision overflows existing data (error)';
DROP TABLE IF EXISTS t2;
CREATE TABLE t2 (col1 NUMERIC(20));
INSERT INTO t2 VALUES (123456);
-- 6-digit value does not fit NUMERIC(5,0) (error)
ALTER TABLE t2 MODIFY col1 NUMERIC(5);
-- table stays unchanged after the failed ALTER
SHOW CREATE TABLE t2;
SELECT * FROM t2;
DROP TABLE IF EXISTS t2;

evaluate '2-2. MODIFY Float -> Fixed rejects out-of-range existing data (error)';
DROP TABLE IF EXISTS t2;
CREATE TABLE t2 (col1 NUMERIC);
INSERT INTO t2 VALUES (1234567890123456789012345678901234567890);
-- 40-digit value is beyond Fixed NUMERIC(38) range (error)
ALTER TABLE t2 MODIFY col1 NUMERIC(38);
-- table stays unchanged after the failed ALTER
SHOW CREATE TABLE t2;
SELECT * FROM t2;
DROP TABLE IF EXISTS t2;
