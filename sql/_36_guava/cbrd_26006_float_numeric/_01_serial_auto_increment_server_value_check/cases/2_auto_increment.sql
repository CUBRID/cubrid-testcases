/* 2. Verify AUTO_INCREMENT behavior */

DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t4;


-- ===========================================================================
-- Section 1: Seed and increment range check
-- ===========================================================================
evaluate '1. Verify seed and increment values (error)';
-- Expect error when values are out of the supported range (±10^38)
CREATE TABLE t1 (col1 INT AUTO_INCREMENT) AUTO_INCREMENT = 100000000000000000000000000000000000000;
-- Syntax error: unexpected '-', expecting UNSIGNED_INTEGER
CREATE TABLE t1 (col1 INT AUTO_INCREMENT) AUTO_INCREMENT = -100000000000000000000000000000000000000;
CREATE TABLE t1 (col1 INT AUTO_INCREMENT(100000000000000000000000000000000000000, 1));
CREATE TABLE t1 (col1 INT AUTO_INCREMENT(-100000000000000000000000000000000000000, 1));
CREATE TABLE t1 (col1 INT AUTO_INCREMENT(1, 100000000000000000000000000000000000000));
CREATE TABLE t1 (col1 INT AUTO_INCREMENT(1, -100000000000000000000000000000000000000));

CREATE TABLE t1 (col1 INT AUTO_INCREMENT);
ALTER TABLE t1 AUTO_INCREMENT = 100000000000000000000000000000000000000;
-- Syntax error: unexpected '-', expecting UNSIGNED_INTEGER
ALTER TABLE t1 AUTO_INCREMENT = -100000000000000000000000000000000000000;

DROP TABLE IF EXISTS t1;


-- ===========================================================================
-- Section 2: AUTO_INCREMENT on NUMERIC columns
-- ===========================================================================
evaluate '2. Verify AUTO_INCREMENT behavior on NUMERIC columns';
CREATE TABLE t1 (col1 NUMERIC AUTO_INCREMENT);
CREATE TABLE t2 (col1 NUMERIC(15) AUTO_INCREMENT);
CREATE TABLE t3 (col1 INT, col2 NUMERIC AUTO_INCREMENT);
CREATE TABLE t4 (col1 INT, col2 NUMERIC(20) AUTO_INCREMENT);

SHOW CREATE TABLE t1;
SHOW CREATE TABLE t2;
SHOW CREATE TABLE t3;
SHOW CREATE TABLE t4;

INSERT INTO t1 VALUES (NULL);
INSERT INTO t2 VALUES (NULL);
INSERT INTO t3(col1) VALUES (123);
INSERT INTO t4(col1) VALUES (123);

SELECT * FROM t1;
SELECT * FROM t2;
SELECT * FROM t3;
SELECT * FROM t4;

DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t4;


-- ===========================================================================
-- Section 3: Modify column type and AUTO_INCREMENT column type
-- ===========================================================================
evaluate '3. Modify column type and AUTO_INCREMENT column type';

evaluate '3-1. CREATE: NUMERIC AUTO_INCREMENT -> NUMERIC(38,0), serial starts at 1';
-- NUMERIC AUTO_INCREMENT is converted to NUMERIC(38,0), serial starts at 1
CREATE TABLE t1 (id NUMERIC AUTO_INCREMENT, name VARCHAR(50));
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '3-2. MODIFY NUMERIC(10) AUTO_INCREMENT(1,1): serial reset -> new id=1 (duplicate)';
-- Explicit AUTO_INCREMENT(1,1) resets serial to 1; existing row keeps id=1 (no UNIQUE)
ALTER TABLE t1 MODIFY COLUMN id NUMERIC(10) AUTO_INCREMENT(1, 1);
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '3-3. MODIFY NUMERIC AUTO_INCREMENT(1,1): serial reset again -> new id=1';
-- MODIFY back to NUMERIC with explicit (1,1) resets serial to 1 again
ALTER TABLE t1 MODIFY COLUMN id NUMERIC AUTO_INCREMENT(1, 1);
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '3-4. DROP + ADD COLUMN: existing rows -> NULL, new INSERT gets id=1';
-- DROP + ADD COLUMN: existing rows become NULL (no backfill), serial restarts at 1
ALTER TABLE t1 DROP COLUMN id;
ALTER TABLE t1 ADD COLUMN id NUMERIC(20) AUTO_INCREMENT(1, 1) FIRST;
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '3-5. MODIFY BIGINT (no seed): serial preserved -> new id=2';
-- MODIFY type only (no AUTO_INCREMENT params): serial state preserved, continues from 2
ALTER TABLE t1 MODIFY id BIGINT;
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '3-6. MODIFY NUMERIC (no seed): serial preserved -> new id=3';
-- MODIFY type only again: serial preserved, continues from 3
ALTER TABLE t1 MODIFY id NUMERIC;
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

DROP TABLE IF EXISTS t1;


-- ===========================================================================
-- Section 4: Modify AUTO_INCREMENT column type with existing index
-- ===========================================================================
evaluate '4. Modify AUTO_INCREMENT column type with existing index';

evaluate '4-1. CREATE + index: NUMERIC AUTO_INCREMENT -> NUMERIC(38,0), serial starts at 1';
CREATE TABLE t1 (name VARCHAR(50), id NUMERIC AUTO_INCREMENT);
CREATE INDEX idx_t1 ON t1(id);
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '4-2. MODIFY NUMERIC(10) AUTO_INCREMENT(1,1): serial reset, index preserved -> new id=1';
-- Explicit (1,1) resets serial; index on id is preserved automatically
ALTER TABLE t1 MODIFY COLUMN id NUMERIC(10) AUTO_INCREMENT(1, 1);
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '4-3. MODIFY NUMERIC AUTO_INCREMENT(1,1): serial reset again -> new id=1';
ALTER TABLE t1 MODIFY COLUMN id NUMERIC AUTO_INCREMENT(1, 1);
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '4-4. DROP + ADD COLUMN + recreate index: existing rows -> NULL, new id=1';
-- DROP COLUMN removes index; ADD COLUMN + CREATE INDEX to restore
ALTER TABLE t1 DROP COLUMN id;
ALTER TABLE t1 ADD COLUMN id NUMERIC AUTO_INCREMENT(1, 1);
CREATE INDEX idx_t1 ON t1(id);
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '4-5. MODIFY BIGINT (no seed): serial preserved -> new id=2';
-- MODIFY type only: serial preserved, index preserved
ALTER TABLE t1 MODIFY id BIGINT;
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

evaluate '4-6. MODIFY NUMERIC (no seed): serial preserved -> new id=3';
ALTER TABLE t1 MODIFY id NUMERIC;
SHOW CREATE TABLE t1;
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

DROP TABLE IF EXISTS t1;


-- ===========================================================================
-- Section 5: LAST_INSERT_ID, CURRENT_VALUE, and NEXT_VALUE
-- ===========================================================================
evaluate '5. Verify LAST_INSERT_ID, CURRENT_VALUE, and NEXT_VALUE';

evaluate '5-1. CREATE serial';
CREATE TABLE t1 (id NUMERIC(38) AUTO_INCREMENT(1, 1), name VARCHAR(50));
INSERT INTO t1 (name) VALUES ('test');
SELECT * FROM t1;

SELECT LAST_INSERT_ID() FROM t1;

CREATE SERIAL s1;
SELECT s1.CURRENT_VALUE;
SELECT s1.NEXT_VALUE;

evaluate '5-2. INSERT serial';
CREATE TABLE t2 (col1 NUMERIC(38));
INSERT INTO t2 SELECT LAST_INSERT_ID() FROM t1;
INSERT INTO t2 SELECT s1.NEXT_VALUE;
INSERT INTO t2 SELECT s1.CURRENT_VALUE;
SELECT * FROM t2;

DROP SERIAL IF EXISTS s1;
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t3;
DROP TABLE IF EXISTS t4;
