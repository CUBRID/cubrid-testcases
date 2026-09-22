/* 1. CREATE Fixed NUMERIC */

-- ===========================================================================
-- Section 1: valid CREATE
-- ===========================================================================
evaluate '1. CREATE Fixed NUMERIC: valid range boundary values';
DROP TABLE IF EXISTS t1;
evaluate '1-1. CREATE NUMERIC(38,0)';
CREATE TABLE t1 (col1 NUMERIC(38,0));
SHOW CREATE TABLE t1;
DROP TABLE IF EXISTS t1;

evaluate '1-2. CREATE NUMERIC(38,127)';
CREATE TABLE t1 (col1 NUMERIC(38,127));
SHOW CREATE TABLE t1;
DROP TABLE IF EXISTS t1;

evaluate '1-3. CREATE NUMERIC(38,-84)';
CREATE TABLE t1 (col1 NUMERIC(38,-84));
SHOW CREATE TABLE t1;
DROP TABLE IF EXISTS t1;

evaluate '1-4. CREATE NUMERIC(1,127)';
CREATE TABLE t1 (col1 NUMERIC(1,127));
SHOW CREATE TABLE t1;
DROP TABLE IF EXISTS t1;

evaluate '1-5. CREATE NUMERIC(1,-84)';
CREATE TABLE t1 (col1 NUMERIC(1,-84));
SHOW CREATE TABLE t1;
DROP TABLE IF EXISTS t1;

evaluate '1-6. CREATE NUMERIC(38) defaults scale to 0';
CREATE TABLE t1 (col1 NUMERIC(38));
SHOW CREATE TABLE t1;
DROP TABLE IF EXISTS t1;

evaluate '1-7. CREATE NUMERIC(1) defaults scale to 0';
CREATE TABLE t1 (col1 NUMERIC(1));
SHOW CREATE TABLE t1;
DROP TABLE IF EXISTS t1;

-- ===========================================================================
-- Section 2: CREATE out of Fixed NUMERIC range
-- ===========================================================================
evaluate '2. CREATE out of Fixed NUMERIC range (error)';
--ERROR: Precision (39) too large. Maximum precision is 38.
CREATE TABLE t1 (col1 NUMERIC(39));
--ERROR: Numeric scale specifier is out of range -84 to 127
CREATE TABLE t1 (col1 NUMERIC(38,-85));
--ERROR: Numeric scale specifier is out of range -84 to 127
CREATE TABLE t1 (col1 NUMERIC(38,128));
-- precision 0 is below the minimum of 1 (error)
CREATE TABLE t1 (col1 NUMERIC(0));
-- precision above 38 with an explicit scale (error)
CREATE TABLE t1 (col1 NUMERIC(40,5));
-- scale beyond 127 even at precision 1 (error)
CREATE TABLE t1 (col1 NUMERIC(1,128));
-- scale below -84 even at precision 1 (error)
CREATE TABLE t1 (col1 NUMERIC(1,-85));
DROP TABLE IF EXISTS t1;

-- ===========================================================================
-- Section 3: Fixed NUMERIC column with DEFAULT and constraints
-- ===========================================================================
evaluate '3. CREATE Fixed NUMERIC with DEFAULT and NOT NULL';
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (col1 NUMERIC(10,2) DEFAULT 1.5, col2 NUMERIC(5) NOT NULL);
SHOW CREATE TABLE t1;
-- omit col1 so its DEFAULT applies, col2 is provided
INSERT INTO t1 (col2) VALUES (10);
SELECT * FROM t1;
DROP TABLE IF EXISTS t1;
