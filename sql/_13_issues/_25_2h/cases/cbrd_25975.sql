-- Table Setup
DROP TABLE IF EXISTS tbl_a;
CREATE TABLE tbl_a (col_a INT);
INSERT INTO tbl_a VALUES (1);


evaluate '1 - Nested hint: [SELECT /*+ recompile use_hash(tbl_a, tbl_a) */ * FROM tbl_a;]';
-- Expected: Parsed correctly if supported; else ignored
SELECT /*+ recompile use_hash(tbl_a, tbl_a) */ * FROM tbl_a;

evaluate '2 - Invalid but safe hint: [SELECT /*+ recompile unknown_hint */ * FROM tbl_a;]';
-- Expected: Query runs; hint ignored;
SELECT /*+ recompile unknown_hint */ * FROM tbl_a; 

evaluate '3 - Malformed hint: [SELECT /*+ recompile use_hash( ) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_hash( ) */ * FROM tbl_a;

evaluate '3-1 - Malformed hint: [SELECT /*+ recompile use_hash( ` ) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_hash( ` ) */ * FROM tbl_a;

evaluate '3-2 - Malformed hint: [SELECT /*+ recompile use_hash( [ ) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_hash( [ ) */ * FROM tbl_a;

evaluate '3-4 - Malformed hint: [SELECT /*+ recompile use_hash( " ) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_hash( " ) */ * FROM tbl_a;

evaluate '4 - Escaped backtick: [SELECT /*+ recompile use_hash(\`) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_hash(\`) */ * FROM tbl_a;

evaluate '5 - Empty hint: [SELECT /*+ recompile */ * FROM tbl_a;]';
-- Expected: Query runs normally; no effect
SELECT /*+ recompile */ * FROM tbl_a;

evaluate '6 - Random content: [SELECT /*+ recompile 123abc */ * FROM tbl_a;]';
-- Expected: Query runs; hint ignored;
SELECT /*+ recompile 123abc */ * FROM tbl_a; 

evaluate '7 - Special characters: [SELECT /*+ recompile use_hash(@!$%) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_hash(@!$%) */ * FROM tbl_a;

evaluate '8 - Foreign language: [SELECT /*+ recompile use_hash (កខគឃង) */ * FROM tbl_a;]';
-- Expected : Query runs normally; no effect
SELECT /*+ recompile use_hash (កខគឃង) */ * FROM tbl_a;

evaluate '9 - Using other hints rather than use_hash: [SELECT /*+ recompile use_nl( ` ) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_nl( ` ) */ * FROM tbl_a;

evaluate '9-1 - Using other hints rather than use_hash: [SELECT /*+ recompile use_merge( ` ) */ * FROM tbl_a;';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_merge( ` ) */ * FROM tbl_a;

evaluate '9-2 - Using other hints rather than use_hash: [SELECT /*+ recompile no_use_hash( ` ) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile no_use_hash( ` ) */ * FROM tbl_a;

evaluate '9-3 - Using other hints rather than use_hash: [SELECT /*+ recompile no_merge( ` ) */ * FROM tbl_a;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile no_merge( ` ) */ * FROM tbl_a;

evaluate '10 - two same hints with one backtick: [SELECT /*+ recompile use_hash( ` ) use_hash(tbl_a) */ * FROM tbl_a;]';
-- Expected : Query runs normally; no effect
SELECT /*+ recompile use_hash( ` ) use_hash(tbl_a) */ * FROM tbl_a;

evaluate '11 - two same hints with two backtick: [SELECT /*+ recompile use_hash( ` ) use_hash( ` ) */ * FROM tbl_a;]';
-- Expected : Query runs normally; no effect
SELECT /*+ recompile use_hash( ` ) use_hash( ` ) */ * FROM tbl_a;

evaluate '12 - different hints with backtick: [SELECT /*+ recompile use_hash( ` ) no_merge( ` ) */ * FROM tbl_a;]';
-- Expected : Query runs normally; no effect
SELECT /*+ recompile use_hash( ` ) no_merge( ` ) */ * FROM tbl_a;

evaluate '13 - three same hints with a backtick: [SELECT /*+ recompile use_hash( ` ) use_nl(tbl_a) no_merge(tbl_a) */ * FROM tbl_a;]';
-- Expected : Query runs normally; no effect
SELECT /*+ recompile use_hash( ` ) use_nl(tbl_a) no_merge(tbl_a) */ * FROM tbl_a;

DROP TABLE IF EXISTS tbl_b;
DROP TABLE IF EXISTS tbl_c;
CREATE TABLE tbl_b (col_b INT, col_c INT);
CREATE TABLE tbl_c (col_b INT, col_c INT);
INSERT INTO tbl_b VALUES (1, 1);
INSERT INTO tbl_c VALUES (1, 1);

evaluate '14 - Malformed hint in join: [SELECT /*+ recompile use_hash(`) */ * FROM tbl_b, tbl_c WHERE tbl_b.col_b = tbl_c.col_b;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_hash(`) */ * FROM tbl_b, tbl_c WHERE tbl_b.col_b = tbl_c.col_b;

evaluate '15 - Unclosed hint: [SELECT /*+ recompile use_hash(tbl_b, tbl_c */ * FROM tbl_b, tbl_c WHERE tbl_b.col_b = tbl_c.col_b;]';
-- Expected: Syntax error or ignored; no crash
SELECT /*+ recompile use_hash(tbl_b, tbl_c */ * FROM tbl_b, tbl_c WHERE tbl_b.col_b = tbl_c.col_b;

evaluate '16 - Valid hint: SELECT /*+ recompile use_hash(tbl_a) */ * FROM tbl_a;';
-- Expected: Executes successfully, hint applied
SELECT /*+ recompile use_hash(tbl_a) */ * FROM tbl_a;

DROP TABLE tbl_b;
DROP TABLE tbl_c;
DROP TABLE  tbl_a;
