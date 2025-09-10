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

evaluate '17 - Empty parentheses: [SELECT /*+ recompile use_hash() */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash() */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b; FROM t1 JOIN t2 ON t1.col_d=t2.col_d; 

evaluate '17-1 - Spaces only: [SELECT /*+ recompile use_hash(   ) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(   ) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '17-2 - Leading/trailing commas: [SELECT /*+ recompile use_hash(, ) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(, ) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '17-3 - Trailing comma after table: [SELECT /*+ recompile use_hash(tbl_b,) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(tbl_b,) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '17-4 - Leading comma before table: [SELECT /*+ recompile use_hash(,tbl_b) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(,tbl_b) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '18 - Missing closing parenthesis: [SELECT /*+ recompile use_hash( */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash( */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '18-1 - Missing closing parenthesis with arg: [SELECT /*+ recompile use_hash(tbl_b */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(tbl_b */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '18-2 - Too many parentheses: [SELECT /*+ recompile use_hash(tbl_b)) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(tbl_b)) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '18-3 - Wrong closing bracket: [SELECT /*+ recompile use_hash(tbl_b, tbl_b] */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(tbl_b, tbl_b] */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '19 - Single quote: [SELECT /*+ recompile use_hash(') */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(') */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '19-1 - Escaped double quote: [SELECT /*+ recompile use_hash(\") */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(\") */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '19-2 - Comment terminator inside: [SELECT /*+ recompile use_hash(*/) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(*/) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '20 - Nonexistent identifier: [SELECT /*+ recompile use_hash(x) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(x) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '20-1 - Schema-qualified: [SELECT /*+ recompile use_hash(dba.tbl_b) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Syntax error or ignored
SELECT /*+ recompile use_hash(dba.tbl_b) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '20-2 - Alias handling: [SELECT /*+ recompile use_hash(b) */ * FROM tbl_b b JOIN tbl_c c ON b.col_b=c.col_b;]';
-- Expected: Query runs with alias resolved or ignored
SELECT /*+ recompile use_hash(b) */ * FROM tbl_b b JOIN tbl_c c ON b.col_b=c.col_b;

evaluate '21 - Multiple hints without args: [SELECT /*+ recompile use_hash use_nl */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Both parsed/ignored safely
SELECT /*+ recompile use_hash use_nl */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '21-1 - Conflicting hints: [SELECT /*+ recompile use_hash(tbl_b) no_use_hash(tbl_b) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Conflict resolution or ignored
SELECT /*+ recompile use_hash(tbl_b) no_use_hash(tbl_b) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '22-2 - Duplicate identical hints: [SELECT /*+ recompile use_hash(tbl_b) use_hash(tbl_b) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Deduped or ignored
SELECT /*+ recompile use_hash(tbl_b) use_hash(tbl_b) */ * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '23 - Oracle-style hint: [SELECT --+ recompile use_hash(tbl_b) * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Parser may ignore if not supported
SELECT --+ recompile use_hash(tbl_b) * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;

evaluate '23-1 - C++ style hint: [SELECT //+ recompile use_hash(tbl_b) * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;]';
-- Expected: Parser may ignore if not supported
SELECT //+ recompile use_hash(tbl_b) * FROM tbl_b JOIN tbl_c ON tbl_b.col_b=tbl_c.col_b;


DROP TABLE IF EXISTS "테이블";
DROP TABLE IF EXISTS "조인";
CREATE TABLE "테이블" (col_d INT);
CREATE TABLE "조인" (col_d INT);
INSERT INTO "테이블" VALUES (1);
INSERT INTO "조인" VALUES (1);

evaluate '24 - Korean identifiers: [SELECT /*+ recompile use_hash("테이블","조인") */ * FROM "테이블" JOIN "조인" USING (col_d);]';
-- Expected: Runs if Unicode identifiers supported
SELECT /*+ recompile use_hash("테이블","조인") */ * FROM "테이블" JOIN "조인" USING (col_d);


DROP TABLE IF EXISTS "t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
CREATE TABLE "t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" (col_d INT);
INSERT INTO "t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" VALUES (1);

evaluate '25 - Long table name ~64: [SELECT /*+ recompile use_hash("t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") */ * FROM "t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";]';
-- Expected: Works if within identifier limits
SELECT /*+ recompile use_hash("t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") */ * FROM "t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

DROP TABLE IF EXISTS "t_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
CREATE TABLE "t_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" (col_d INT);
INSERT INTO "t_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" VALUES (1);

evaluate '25-1 - Long table name ~120: [SELECT /*+ recompile use_hash("t_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb") */ * FROM "t_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";]';
-- Expected: Works if within identifier limits
SELECT /*+ recompile use_hash("t_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb") */ * FROM "t_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";

evaluate '25-2 - Long alias name: [SELECT /*+ recompile use_hash("t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") */ a.col_d FROM "t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" AS "alias_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" a;]';
-- Expected: Works if alias length supported
SELECT /*+ recompile use_hash("t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") */ a.col_d FROM "t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" AS "alias_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" a;


DROP TABLE tbl_b;
DROP TABLE tbl_c;
DROP TABLE  tbl_a;
DROP TABLE IF EXISTS "테이블";
DROP TABLE IF EXISTS "조인";
DROP TABLE IF EXISTS "t_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
DROP TABLE IF EXISTS "t_bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";

