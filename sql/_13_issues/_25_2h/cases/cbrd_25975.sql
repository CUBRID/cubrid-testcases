-- Table Setup
DROP TABLE IF EXISTS testtbl;
CREATE TABLE testtbl (c1 INT);
INSERT INTO testtbl VALUES (1);

-- Scenario 1: Valid hint
SELECT /*+ recompile use_hash(testtbl) */ * FROM testtbl;
-- Expected: Executes successfully, hint applied

-- Scenario 2: Nested hint
SELECT /*+ recompile use_hash(testtbl, testtbl) */ * FROM testtbl;
-- Expected: Parsed correctly if supported; else ignored

-- Scenario 3: Invalid but safe hint
SELECT /*+ recompile unknown_hint */ * FROM testtbl;
-- Expected: Query runs; hint ignored; 

-- Scenario 4: Malformed hint
SELECT /*+ recompile use_hash( ) */ * FROM testtbl;
SELECT /*+ recompile use_hash( ` ) */ * FROM testtbl;
SELECT /*+ recompile use_hash( [ ) */ * FROM testtbl;
SELECT /*+ recompile use_hash( " ) */ * FROM testtbl;
-- Expected: Syntax error or ignored; no crash

-- Scenario 5: Escaped backtick
SELECT /*+ recompile use_hash(\`) */ * FROM testtbl;
-- Expected: Syntax error or ignored; no crash

-- Scenario 6: Empty hint
SELECT /*+ recompile */ * FROM testtbl;
-- Expected: Query runs normally; no effect

-- Scenario 7: Random content
SELECT /*+ recompile 123abc */ * FROM testtbl;
-- Expected: Query runs; hint ignored; 

-- Scenario 8: Special characters
SELECT /*+ recompile use_hash(@!$%) */ * FROM testtbl;
-- Expected: Syntax error or ignored; no crash

-- Scenario 9 : Foreign language 
SELECT /*+ recompile use_hash (កខគឃង) */ * FROM testtbl;
-- Expected : Query runs normally; no effect

-- Using other hints rather than use_hash
SELECT /*+ recompile use_nl( ) */ * FROM testtbl;
SELECT /*+ recompile use_merge( ` ) */ * FROM testtbl;
SELECT /*+ recompile no_use_hash( [ ) */ * FROM testtbl;
SELECT /*+ recompile no_merge( " ) */ * FROM testtbl;
-- Expected: Syntax error or ignored; no crash

-- Extended Test: Join scenario with malformed hints
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE TABLE t1 (c1 INT, c2 INT);
CREATE TABLE t2 (c1 INT, c2 INT);
INSERT INTO t1 VALUES (1, 1);
INSERT INTO t2 VALUES (1, 1);

-- Malformed hint in join
SELECT /*+ recompile use_hash(`) */ * FROM t1, t2 WHERE t1.c1 = t2.c1;
-- Expected: Syntax error or ignored; no crash

-- Unclosed hint
SELECT /*+ recompile use_hash(t1, t2 */ * FROM t1, t2 WHERE t1.c1 = t2.c1;
-- Expected: Syntax error or ignored; no crash
