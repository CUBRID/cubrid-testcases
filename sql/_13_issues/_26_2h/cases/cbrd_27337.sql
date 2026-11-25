/*
 *  This test case pins the INSERT behaviour that CBRD-27337 (engine PR #7902) makes
 *  loaddb match.
 *
 *  loaddb used to carry two copies of the code that turns a token into a value, one
 *  for CS mode and one for SA mode, and they had drifted apart from each other and
 *  from INSERT. The PR replaced both with a single table whose rule is: whatever
 *  INSERT accepts, loaddb accepts, and it stores the same value.
 *
 *  That rule is only worth anything while INSERT itself keeps behaving this way, so
 *  these are the reference answers. The loaddb side is covered by the shell cases
 *  cbrd_27337_loaddb_conversion and cbrd_27337_loaddb_error_paths, which compare
 *  what loaddb stores against what INSERT stores in the same column.
 *
 *  Coverage:
 *    case 01 : a 19-digit BIGINT literal behind a '+' keeps its value
 *    case 02 : a NUMERIC literal one decimal place past the 252 limit is rounded
 *    case 03 : a 41-digit integer literal is kept whole in a NUMERIC column
 *    case 04 : the same literal in a character column
 *    case 05 : a string with a NUL in it is refused by a numeric column
 *    case 06 : the sign of zero in a MONETARY column, per literal form
 *    case 07 : bit string literals as elements of a character collection
 */

DROP TABLE IF EXISTS t_big;
DROP TABLE IF EXISTS t_sc;
DROP TABLE IF EXISTS t_num;
DROP TABLE IF EXISTS t_chr;
DROP TABLE IF EXISTS t_mon;
DROP TABLE IF EXISTS t_set;

evaluate 'case 01 : a 19-digit BIGINT literal behind a +';
CREATE TABLE t_big (id INT, b BIGINT);
INSERT INTO t_big VALUES (1, +1234567890123456789);
INSERT INTO t_big VALUES (2, -1234567890123456789);
SELECT id, b FROM t_big ORDER BY 1;

evaluate 'case 02 : a NUMERIC literal past the 252 scale limit is rounded, not refused';
CREATE TABLE t_sc (id INT, c NUMERIC);
INSERT INTO t_sc VALUES (1, 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009);
INSERT INTO t_sc VALUES (2, 0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009);
SELECT id, c FROM t_sc ORDER BY 1;

evaluate 'case 03 : a 41-digit integer literal in a NUMERIC column';
CREATE TABLE t_num (id INT, c NUMERIC);
INSERT INTO t_num VALUES (1, 87112285931760246646623899502532662132740);
SELECT id, c FROM t_num ORDER BY 1;

evaluate 'case 04 : the same literal in a character column';
CREATE TABLE t_chr (id INT, c VARCHAR(60));
INSERT INTO t_chr VALUES (1, 87112285931760246646623899502532662132741);
SELECT id, c FROM t_chr ORDER BY 1;

evaluate 'case 05 : a string with a NUL in it is refused by a numeric column';
CREATE TABLE t_nul (id INT, c NUMERIC(10,2));
INSERT INTO t_nul VALUES (1, '2.25' || CHR(0) || 'junk');
SELECT COUNT(*) FROM t_nul;

evaluate 'case 06 : the sign of zero in a MONETARY column, per literal form';
CREATE TABLE t_mon (id INT, m MONETARY);
INSERT INTO t_mon VALUES (1, -0);
INSERT INTO t_mon VALUES (2, -0.0);
INSERT INTO t_mon VALUES (3, -0e0);
INSERT INTO t_mon VALUES (4, 0);
SELECT id, m FROM t_mon ORDER BY 1;

evaluate 'case 07 : bit string literals as elements of a character collection';
CREATE TABLE t_set (id INT, s SET(VARCHAR(10)));
INSERT INTO t_set VALUES (1, {B'1010', X'AF'});
SELECT id, s FROM t_set ORDER BY 1;

DROP TABLE IF EXISTS t_big;
DROP TABLE IF EXISTS t_sc;
DROP TABLE IF EXISTS t_num;
DROP TABLE IF EXISTS t_chr;
DROP TABLE IF EXISTS t_nul;
DROP TABLE IF EXISTS t_mon;
DROP TABLE IF EXISTS t_set;
