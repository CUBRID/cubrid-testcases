/**
 *  This test case verifies CBRD-28029 #2: with no ESCAPE clause and no_backslash_escapes=yes (default), a backslash in a LIKE pattern is an
 *  ordinary character. NOT LIKE between two literals (folded at compile time) must not read it as an escape.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t02;
CREATE TABLE t02 (s VARCHAR(10));
INSERT INTO t02 VALUES ('abc6'), ('ab\6'), ('abc'), ('a\bc'), ('a_c'), ('a\_c');
-- expected: rows: 1 | 0
evaluate 'Case 2-1';
SELECT ('abc6' NOT LIKE '%\6') AS nl, ('abc6' LIKE '%\6') AS l FROM db_root;
-- expected: rows: 1 | 0
evaluate 'Case 2-2';
SELECT ('abc' NOT LIKE 'a\bc') AS nl, ('abc' LIKE 'a\bc') AS l FROM db_root;
-- expected: rows: 1
evaluate 'Case 2-3';
SELECT COUNT(*) AS cnt FROM db_root WHERE 'abc6' NOT LIKE '%\6';
-- the backslash on both sides: LIKE matches, NOT LIKE does not
-- expected: rows: 0 | 1
evaluate 'Case 2-4';
SELECT ('a\bc' NOT LIKE 'a\bc') AS nl, ('a\bc' LIKE 'a\bc') AS l FROM db_root;
-- expected: rows: 0 | 1
evaluate 'Case 2-5';
SELECT ('ab\6' NOT LIKE '%\6') AS nl, ('ab\6' LIKE '%\6') AS l FROM db_root;
-- a backslash before a wildcard: the wildcard stays a wildcard
-- expected: rows: 1 | 0
evaluate 'Case 2-6';
SELECT ('a_c' NOT LIKE 'a\_c') AS nl, ('a_c' LIKE 'a\_c') AS l FROM db_root;
-- expected: rows: 0 | 1
evaluate 'Case 2-7';
SELECT ('a\_c' NOT LIKE 'a\_c') AS nl, ('a\_c' LIKE 'a\_c') AS l FROM db_root;
-- expected: rows: 0
evaluate 'Case 2-8';
SELECT COUNT(*) AS cnt FROM db_root WHERE 'a\bc' NOT LIKE 'a\bc';
-- national character literals
-- expected: rows: 1 | 0
evaluate 'Case 2-9';
SELECT (N'abc6' NOT LIKE N'%\6') AS nl, (N'abc6' LIKE N'%\6') AS l FROM db_root;
-- controls: not folded, explicit ESCAPE, NOT (... LIKE ...)
-- expected: rows: 1
evaluate 'Case 2-c1';
SELECT (CAST('abc6' AS VARCHAR) NOT LIKE '%\6') AS nl FROM db_root;
-- expected: rows: 1
evaluate 'Case 2-c2';
SELECT ('abc6' NOT LIKE '%\6' ESCAPE '!') AS nl FROM db_root;
-- expected: rows: 1
evaluate 'Case 2-c3';
SELECT (NOT ('abc6' LIKE '%\6')) AS nl FROM db_root;
-- an explicit backslash escape: '%\6' means '%6'
-- expected: rows: 0 | 1
evaluate 'Case 2-c4';
SELECT ('abc6' NOT LIKE '%\6' ESCAPE '\') AS nl, ('abc6' LIKE '%\6' ESCAPE '\') AS l FROM db_root;
-- ESCAPE NULL keeps its current meaning (backslash escape)
-- expected: rows: 0 | 1
evaluate 'Case 2-c5';
SELECT ('abc6' NOT LIKE '%\6' ESCAPE NULL) AS nl, ('abc6' LIKE '%\6' ESCAPE NULL) AS l FROM db_root;
-- a column operand (no folding)
-- expected: rows: 'a\_c' | 1 | 0 / 'a\bc' | 1 | 0 / 'a_c' | 1 | 0 / 'ab\6' | 0 | 1 / 'abc' | 1 | 0 / 'abc6' | 1 | 0
evaluate 'Case 2-c6';
SELECT s, (s NOT LIKE '%\6') AS nl, (s LIKE '%\6') AS l FROM t02 ORDER BY s;
-- expected: rows: 'a\_c' / 'a\bc' / 'a_c' / 'abc' / 'abc6'
evaluate 'Case 2-c7';
SELECT s FROM t02 WHERE s NOT LIKE '%\6' ORDER BY s;
-- the literal pattern against the column must give the same answer as the folded literal pair
-- expected: rows: 'a\_c' | 0 | 1 / 'a_c' | 1 | 0
evaluate 'Case 2-c8';
SELECT s, (s NOT LIKE 'a\_c') AS nl, (s LIKE 'a\_c') AS l FROM t02 WHERE s IN ('a_c', 'a\_c') ORDER BY s;
-- host variables
PREPARE p02 FROM 'SELECT (? NOT LIKE ''%\6'') AS nl, (? LIKE ''%\6'') AS l FROM db_root';
-- expected: rows: 1 | 0
evaluate 'Case 2-c9';
EXECUTE p02 USING 'abc6', 'abc6';
DEALLOCATE PREPARE p02;
DROP TABLE t02;
-- no_backslash_escapes=no: with no ESCAPE clause the backslash escapes only under require_like_escape_character=yes,
-- folded or not, as on a column (decided 11-18: the constant fold read no_backslash_escapes, the evaluation does not).
-- '\6' and '\b' lose the backslash in the lexer already, '\_' keeps it
CREATE TABLE t02c (s VARCHAR(10));
INSERT INTO t02c VALUES ('a_c'), ('a\_c');
SET SYSTEM PARAMETERS 'no_backslash_escapes=no';
-- expected: keep
evaluate 'Case 2-20';
SELECT /*+ RECOMPILE */ ('abc6' NOT LIKE '%\6') AS nl_nbe, ('abc6' LIKE '%\6') AS l_nbe FROM db_root;
-- expected: keep
evaluate 'Case 2-21';
SELECT /*+ RECOMPILE */ ('abc' NOT LIKE 'a\bc') AS nl_nbe, ('abc' LIKE 'a\bc') AS l_nbe FROM db_root;
-- expected: rows: 1 | 0
evaluate 'Case 2-22';
SELECT /*+ RECOMPILE */ ('a_c' NOT LIKE 'a\_c') AS nl_nbe, ('a_c' LIKE 'a\_c') AS l_nbe FROM db_root;
-- expected: keep
evaluate 'Case 2-23';
SELECT /*+ RECOMPILE */ COUNT(*) AS cnt_nbe FROM db_root WHERE 'abc6' NOT LIKE '%\6';
-- expected: rows: 1 | 0
evaluate 'Case 2-24';
SELECT /*+ RECOMPILE */ (CAST('a_c' AS VARCHAR) NOT LIKE 'a\_c') AS nl_nbe, (CAST('a_c' AS VARCHAR) LIKE 'a\_c') AS l_nbe FROM db_root;
-- the constant gives what the column gives
-- expected: rows: 0 | 0
evaluate 'Case 2-25';
SELECT /*+ RECOMPILE */ (SELECT s LIKE 'a\_c' FROM t02c WHERE s = 'a_c') AS l_col, ('a_c' LIKE 'a\_c') AS l_const FROM db_root;
-- expected: rows: 1 | 1
evaluate 'Case 2-26';
SELECT /*+ RECOMPILE */ (SELECT s LIKE 'a\_c' FROM t02c WHERE s = 'a\_c') AS l_col, ('a\_c' LIKE 'a\_c') AS l_const FROM db_root;
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
DROP TABLE t02c;
-- the XASL cache key holds no_backslash_escapes; with no ESCAPE clause the constant fold of LIKE reads
-- require_like_escape_character, so the same text gives the same value under either value (develop reused the DML
-- compiled under the other value)
-- expected: rows: 1 | 0
evaluate 'Case 2-30';
SELECT ('a_c' NOT LIKE 'a\_c') AS nl, ('a_c' LIKE 'a\_c') AS l FROM db_root;
SET SYSTEM PARAMETERS 'no_backslash_escapes=no';
-- expected: any
evaluate 'Case 2-31r';
SELECT /*+ RECOMPILE */ ('a_c' NOT LIKE 'a\_c') AS nl, ('a_c' LIKE 'a\_c') AS l FROM db_root;
-- expected: same: 2-31r
evaluate 'Case 2-31';
SELECT ('a_c' NOT LIKE 'a\_c') AS nl, ('a_c' LIKE 'a\_c') AS l FROM db_root;
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
-- expected: same: 2-30
evaluate 'Case 2-32';
SELECT ('a_c' NOT LIKE 'a\_c') AS nl, ('a_c' LIKE 'a\_c') AS l FROM db_root;
DROP TABLE IF EXISTS t02n, t02u;
CREATE TABLE t02n (k INT AUTO_INCREMENT PRIMARY KEY, r INT);
INSERT INTO t02n (r) SELECT ('a_c' LIKE 'a\_c') FROM db_root;
SET SYSTEM PARAMETERS 'no_backslash_escapes=no';
INSERT INTO t02n (r) SELECT ('a_c' LIKE 'a\_c') FROM db_root;
INSERT /*+ RECOMPILE */ INTO t02n (r) SELECT ('a_c' LIKE 'a\_c') FROM db_root;
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
-- k = 2 equals k = 3 (both under no_backslash_escapes=no)
-- expected: rows: 1
evaluate 'Case 2-33';
SELECT COUNT(*) AS cnt FROM t02n a, t02n b WHERE a.k = 2 AND b.k = 3 AND a.r = b.r;
CREATE TABLE t02u (k INT, r INT);
INSERT INTO t02u VALUES (1, -1), (2, -1), (3, -1);
UPDATE t02u SET r = (SELECT ('a_c' LIKE 'a\_c') FROM db_root) WHERE k = 1;
SET SYSTEM PARAMETERS 'no_backslash_escapes=no';
UPDATE t02u SET r = (SELECT ('a_c' LIKE 'a\_c') FROM db_root) WHERE k = 2;
UPDATE /*+ RECOMPILE */ t02u SET r = (SELECT ('a_c' LIKE 'a\_c') FROM db_root) WHERE k = 3;
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
-- expected: rows: 1
evaluate 'Case 2-34';
SELECT COUNT(*) AS cnt FROM t02u a, t02u b WHERE a.k = 2 AND b.k = 3 AND a.r = b.r;
-- expected: rows: 0
evaluate 'Case 2-35';
SELECT r FROM t02u WHERE k = 1;
DROP TABLE t02n, t02u;
