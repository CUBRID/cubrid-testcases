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
DROP TABLE IF EXISTS t1;
