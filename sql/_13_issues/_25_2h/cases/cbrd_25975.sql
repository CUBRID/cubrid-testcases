-- Table Setup
DROP TABLE IF EXISTS tableA;
CREATE TABLE tableA (columnA INT);
INSERT INTO tableA VALUES (1);

evaluate '1 - Nested hint';
SELECT /*+ recompile use_hash(tableA, tableA) */ * FROM tableA;
-- Expected: Parsed correctly if supported; else ignored

evaluate '2 - Invalid but safe hint';
SELECT /*+ recompile unknown_hint */ * FROM tableA;
-- Expected: Query runs; hint ignored; 

evaluate '3 - Malformed hint';
SELECT /*+ recompile use_hash( ) */ * FROM tableA;
SELECT /*+ recompile use_hash( ` ) */ * FROM tableA;
SELECT /*+ recompile use_hash( [ ) */ * FROM tableA;
SELECT /*+ recompile use_hash( " ) */ * FROM tableA;
-- Expected: Syntax error or ignored; no crash

evaluate '4 - Escaped backtick';
SELECT /*+ recompile use_hash(\`) */ * FROM tableA;
-- Expected: Syntax error or ignored; no crash

evaluate '5 - Empty hint';
SELECT /*+ recompile */ * FROM tableA;
-- Expected: Query runs normally; no effect

evaluate '6 - Random content';
SELECT /*+ recompile 123abc */ * FROM tableA;
-- Expected: Query runs; hint ignored; 

evaluate '7 - Special characters';
SELECT /*+ recompile use_hash(@!$%) */ * FROM tableA;
-- Expected: Syntax error or ignored; no crash

evaluate '8 - Foreign language';
SELECT /*+ recompile use_hash (កខគឃង) */ * FROM tableA;
-- Expected : Query runs normally; no effect

evaluate '9 - Using other hints rather than use_hash';
SELECT /*+ recompile use_nl( ` ) */ * FROM tableA;
SELECT /*+ recompile use_merge( ` ) */ * FROM tableA;
SELECT /*+ recompile no_use_hash( ` ) */ * FROM tableA;
SELECT /*+ recompile no_merge( ` ) */ * FROM tableA;
-- Expected: Syntax error or ignored; no crash

evaluate '10 - two same hints with one backtick';
SELECT /*+ recompile use_hash( ` ) use_hash(tableA) */ * FROM tableA;
-- Expected : Query runs normally; no effect

evaluate '11 - two same hints with two backtick';
SELECT /*+ recompile use_hash( ` ) use_hash( ` ) */ * FROM tableA;
-- Expected : Query runs normally; no effect

evaluate '12 - different hints with backtick';
SELECT /*+ recompile use_hash( ` ) no_merge( ` ) */ * FROM tableA;
-- Expected : Query runs normally; no effect

evaluate '13 - three same hints with a backtick';
SELECT /*+ recompile use_hash( ` ) use_nl(tableA) no_merge(tableA) */ * FROM tableA;
-- Expected : Query runs normally; no effect

DROP TABLE IF EXISTS tableB;
DROP TABLE IF EXISTS tableC;
CREATE TABLE tableB (columnB INT, columnC INT);
CREATE TABLE tableC (columnB INT, columnC INT);
INSERT INTO tableB VALUES (1, 1);
INSERT INTO tableC VALUES (1, 1);

evaluate '14 - Malformed hint in join';
SELECT /*+ recompile use_hash(`) */ * FROM tableB, tableC WHERE tableB.columnB = tableC.columnB;
-- Expected: Syntax error or ignored; no crash

evaluate '15 - Unclosed hint';
SELECT /*+ recompile use_hash(tableB, tableC */ * FROM tableB, tableC WHERE tableB.columnB = tableC.columnB;
-- Expected: Syntax error or ignored; no crash

evaluate '16 - Valid hint';
SELECT /*+ recompile use_hash(tableA) */ * FROM tableA;
-- Expected: Executes successfully, hint applied

DROP TABLE tableA;
DROP TABLE tableB;
DROP TABLE tableC;
