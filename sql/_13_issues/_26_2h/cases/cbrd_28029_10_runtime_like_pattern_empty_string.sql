/**
 *  This test case verifies CBRD-28029 #10: a LIKE pattern known only at run time (an expression or a host variable) gets an added range term
 *  [like_match_lower_bound, like_match_upper_bound), for a pattern that matches the empty string ('', '%', '%%') that
 *  range must keep the rows whose value is ''.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t10, t10x, t10s, t10b;
CREATE TABLE t10 (c0 VARCHAR(20));
INSERT INTO t10 VALUES (''), (''), ('a'), ('ab'), (NULL);
CREATE TABLE t10x (c0 VARCHAR(20));
CREATE INDEX t10x_c0 ON t10x (c0);
INSERT INTO t10x VALUES (''), (''), ('a'), ('ab'), (NULL);
-- expected: rows: 2
evaluate 'Case 10-1';
SELECT COUNT(*) AS cnt FROM t10 WHERE c0 LIKE NULLIF('', CAST(846735931 AS VARCHAR));
-- expected: rows: 4
evaluate 'Case 10-2';
SELECT COUNT(*) AS cnt FROM t10 WHERE c0 LIKE NULLIF('%', CAST(846735931 AS VARCHAR));
-- expected: rows: 2
evaluate 'Case 10-c1';
SELECT COUNT(*) AS cnt FROM t10 WHERE c0 LIKE '';
-- expected: rows: 4
evaluate 'Case 10-c2';
SELECT COUNT(*) AS cnt FROM t10 WHERE c0 LIKE '%';
-- expected: rows: '' / '' / 'a' / 'ab'
evaluate 'Case 10-3';
SELECT c0 FROM t10 WHERE c0 LIKE NULLIF('%', CAST(846735931 AS VARCHAR)) ORDER BY c0;
-- expected: rows: 4
evaluate 'Case 10-4';
SELECT COUNT(*) AS cnt FROM t10 WHERE c0 LIKE NULLIF('%%', CAST(846735931 AS VARCHAR));
-- the same over an index on c0
-- expected: rows: 2
evaluate 'Case 10-5';
SELECT COUNT(*) AS cnt FROM t10x WHERE c0 LIKE NULLIF('', CAST(846735931 AS VARCHAR));
-- expected: rows: '' / '' / 'a' / 'ab'
evaluate 'Case 10-6';
SELECT c0 FROM t10x WHERE c0 LIKE NULLIF('%', CAST(846735931 AS VARCHAR)) ORDER BY c0;
-- expected: rows: 'a' / 'ab'
evaluate 'Case 10-7';
SELECT c0 FROM t10x WHERE c0 LIKE NULLIF('a%', CAST(846735931 AS VARCHAR)) ORDER BY c0;
-- host variables
-- expected: exec
evaluate 'Case 10-8p';
PREPARE p10 FROM 'SELECT COUNT(*) AS cnt FROM t10 WHERE c0 LIKE ?';
-- expected: rows: 2
evaluate 'Case 10-8a';
EXECUTE p10 USING '';
-- expected: rows: 4
evaluate 'Case 10-8b';
EXECUTE p10 USING '%';
-- expected: rows: 4
evaluate 'Case 10-8c';
EXECUTE p10 USING '%%';
-- expected: rows: 2
evaluate 'Case 10-8d';
EXECUTE p10 USING '_%';
-- expected: rows: 2
evaluate 'Case 10-8e';
EXECUTE p10 USING 'a%';
-- expected: rows: 1
evaluate 'Case 10-8f';
EXECUTE p10 USING '%a';
-- expected: rows: 1
evaluate 'Case 10-8g';
EXECUTE p10 USING '_';
-- expected: rows: 1
evaluate 'Case 10-8h';
EXECUTE p10 USING 'a';
-- expected: rows: 0
evaluate 'Case 10-8i';
EXECUTE p10 USING 'b%';
DEALLOCATE PREPARE p10;
-- expected: exec
evaluate 'Case 10-9p';
PREPARE p10x FROM 'SELECT COUNT(*) AS cnt FROM t10x WHERE c0 LIKE ?';
-- expected: rows: 2
evaluate 'Case 10-9a';
EXECUTE p10x USING '';
-- expected: rows: 4
evaluate 'Case 10-9b';
EXECUTE p10x USING '%';
-- expected: rows: 2
evaluate 'Case 10-9c';
EXECUTE p10x USING 'a%';
-- expected: rows: 1
evaluate 'Case 10-9d';
EXECUTE p10x USING 'ab';
DEALLOCATE PREPARE p10x;
-- expected: exec
evaluate 'Case 10-10p';
PREPARE p10n FROM 'SELECT COUNT(*) AS cnt FROM t10 WHERE c0 NOT LIKE ?';
-- expected: rows: 2
evaluate 'Case 10-10a';
EXECUTE p10n USING '';
-- expected: rows: 0
evaluate 'Case 10-10b';
EXECUTE p10n USING '%';
DEALLOCATE PREPARE p10n;
-- expected: exec
evaluate 'Case 10-11p';
PREPARE p10e FROM 'SELECT COUNT(*) AS cnt FROM t10 WHERE c0 LIKE ? ESCAPE ''!''';
-- expected: rows: 4
evaluate 'Case 10-11a';
EXECUTE p10e USING '%';
-- expected: rows: 2
evaluate 'Case 10-11b';
EXECUTE p10e USING '';
DEALLOCATE PREPARE p10e;
-- values that start with a space or a control character
CREATE TABLE t10s (c0 VARCHAR(20));
INSERT INTO t10s VALUES (''), (' '), (' x'), (CHR(9) || 'a'), ('a');
-- the rows of the literal patterns are the reference for the host-variable patterns
-- expected: rows: 0 / 1 / 2 / 2 / 1
evaluate 'Case 10-c3';
SELECT LENGTH(c0) AS len FROM t10s WHERE c0 LIKE '%' ORDER BY c0;
-- expected: any
evaluate 'Case 10-c4';
SELECT LENGTH(c0) AS len FROM t10s WHERE c0 LIKE '' ORDER BY c0;
-- expected: any
evaluate 'Case 10-c5';
SELECT LENGTH(c0) AS len FROM t10s WHERE c0 LIKE ' ' ORDER BY c0;
-- expected: any
evaluate 'Case 10-c6';
SELECT LENGTH(c0) AS len FROM t10s WHERE c0 LIKE ' %' ORDER BY c0;
-- expected: exec
evaluate 'Case 10-12p';
PREPARE p10s FROM 'SELECT LENGTH(c0) AS len FROM t10s WHERE c0 LIKE ? ORDER BY c0';
-- expected: same: 10-c3
evaluate 'Case 10-12a';
EXECUTE p10s USING '%';
-- expected: same: 10-c4
evaluate 'Case 10-12b';
EXECUTE p10s USING '';
-- expected: same: 10-c5
evaluate 'Case 10-12c';
EXECUTE p10s USING ' ';
-- expected: same: 10-c6
evaluate 'Case 10-12d';
EXECUTE p10s USING ' %';
DEALLOCATE PREPARE p10s;

-- BETWEEN variant: '' compared with ' ' on two paths. Whatever the answer, p, NOT p and p IS NULL add up to the
-- 2 rows, and WHERE agrees with the select list.
CREATE TABLE t10b (c0 INT);
INSERT INTO t10b VALUES (1), (2);
-- expected: rows: 2
evaluate 'Case 10-20';
SELECT SUM(CASE WHEN ('' BETWEEN ' ' AND (CASE c0 WHEN c0 + 5 THEN 'a' ELSE ('x' || 'y') END)) THEN 1 ELSE 0 END) AS sel_p FROM t10b;
-- expected: rows: 2
evaluate 'Case 10-21';
SELECT COUNT(*) AS cnt FROM t10b WHERE ('' BETWEEN ' ' AND (CASE c0 WHEN c0 + 5 THEN 'a' ELSE ('x' || 'y') END));
-- expected: rows: 0
evaluate 'Case 10-22';
SELECT COUNT(*) AS cnt FROM t10b WHERE NOT ('' BETWEEN ' ' AND (CASE c0 WHEN c0 + 5 THEN 'a' ELSE ('x' || 'y') END));
-- expected: rows: 2
evaluate 'Case 10-23';
SELECT (SELECT COUNT(*) FROM t10b WHERE ('' BETWEEN ' ' AND (CASE c0 WHEN c0 + 5 THEN 'a' ELSE ('x' || 'y') END))) + (SELECT COUNT(*) FROM t10b WHERE NOT ('' BETWEEN ' ' AND (CASE c0 WHEN c0 + 5 THEN 'a' ELSE ('x' || 'y') END))) + (SELECT COUNT(*) FROM t10b WHERE ('' BETWEEN ' ' AND (CASE c0 WHEN c0 + 5 THEN 'a' ELSE ('x' || 'y') END)) IS NULL) AS total FROM db_root;
-- expected: same: 10-20
evaluate 'Case 10-24';
SELECT COUNT(*) AS sel_p FROM t10b WHERE ('' BETWEEN ' ' AND (CASE c0 WHEN c0 + 5 THEN 'a' ELSE ('x' || 'y') END));
-- the literal upper bound (folded) as a control
-- expected: rows: 2
evaluate 'Case 10-25';
SELECT COUNT(*) AS cnt FROM t10b WHERE ('' BETWEEN ' ' AND 'xy');
-- expected: rows: 2
evaluate 'Case 10-26';
SELECT (SELECT COUNT(*) FROM t10b WHERE ('' BETWEEN ' ' AND 'xy')) + (SELECT COUNT(*) FROM t10b WHERE NOT ('' BETWEEN ' ' AND 'xy')) AS total FROM db_root;
DROP TABLE t10, t10x, t10s, t10b;
-- a CHAR column LIKE a constant that is not CHAR: rewritten to "=", which does not ignore the trailing spaces of a CHAR
-- against a VARCHAR as LIKE does, it returned no row (found while analysing)
DROP TABLE IF EXISTS t10c, t10v;
CREATE TABLE t10c (id INT, c CHAR(5));
INSERT INTO t10c VALUES (1, 'ab'), (2, 'abc'), (3, NULL);
-- expected: rows: 1
evaluate 'Case 10-40';
SELECT id FROM t10c WHERE c LIKE 'a' || 'b' ORDER BY id;
-- expected: rows: 1
evaluate 'Case 10-41';
SELECT id FROM t10c WHERE c LIKE CONCAT('a', 'b') ORDER BY id;
-- expected: rows: 1
evaluate 'Case 10-42';
SELECT id FROM t10c WHERE c LIKE CAST('ab' AS VARCHAR(10)) ORDER BY id;
-- expected: rows: 1 | 1 / 2 | 0 / 3 | NULL
evaluate 'Case 10-43';
SELECT id, (c LIKE 'a' || 'b') AS m FROM t10c ORDER BY id;
-- expected: rows: 1 | 1 | 1
evaluate 'Case 10-44';
SELECT (SELECT COUNT(*) FROM t10c WHERE c LIKE 'a' || 'b') AS p, (SELECT COUNT(*) FROM t10c WHERE NOT (c LIKE 'a' || 'b')) AS np, (SELECT COUNT(*) FROM t10c WHERE (c LIKE 'a' || 'b') IS NULL) AS pn FROM db_root;
-- expected: rows: 1
evaluate 'Case 10-c40';
SELECT id FROM t10c WHERE c LIKE 'ab' ORDER BY id;
CREATE INDEX t10c_c ON t10c (c);
-- expected: rows: 1
evaluate 'Case 10-45';
SELECT /*+ RECOMPILE */ id FROM t10c WHERE c LIKE 'a' || 'b' ORDER BY id;
-- a pattern with no wildcard that ends in a space, with ESCAPE: the generic rewrite keeps LIKE, and the rows are those
-- LIKE gives as an expression
CREATE TABLE t10v (id INT, v VARCHAR(10));
INSERT INTO t10v VALUES (1, 'ab'), (2, 'ab '), (3, 'ab  '), (4, 'abc');
CREATE INDEX t10v_v ON t10v (v);
-- expected: any
evaluate 'Case 10-46r';
SELECT id FROM t10v WHERE (CASE WHEN v LIKE 'ab ' ESCAPE '!' THEN 1 ELSE 0 END) = 1 ORDER BY id;
-- expected: same: 10-46r
evaluate 'Case 10-46';
SELECT /*+ RECOMPILE */ id FROM t10v WHERE v LIKE 'ab ' ESCAPE '!' ORDER BY id;
DROP TABLE t10c, t10v;
-- LIKE ignores the trailing spaces of the compared value once the pattern is used up, on every path, a pattern with no
-- wildcard was rewritten to "=", which ignores them only between two CHAR, so p, NOT p and p IS NULL missed rows
-- (decided 11-18: the rewrite follows LIKE)
DROP TABLE IF EXISTS tls;
CREATE TABLE tls (id INT, v VARCHAR(10), c CHAR(5));
INSERT INTO tls VALUES (1, '', ''), (2, ' ', ' '), (3, 'ab', 'ab'), (4, 'ab ', 'ab '), (5, 'ab  ', 'ab  '), (6, ' ab', ' ab');
-- expected: rows: 6 | 6
evaluate 'Case 10-50';
SELECT (SELECT COUNT(*) FROM tls WHERE v LIKE 'ab') + (SELECT COUNT(*) FROM tls WHERE NOT (v LIKE 'ab')) + (SELECT COUNT(*) FROM tls WHERE (v LIKE 'ab') IS NULL) AS p_ab, (SELECT COUNT(*) FROM tls WHERE v LIKE '') + (SELECT COUNT(*) FROM tls WHERE NOT (v LIKE '')) + (SELECT COUNT(*) FROM tls WHERE (v LIKE '') IS NULL) AS p_e FROM db_root;
-- expected: rows: 3 / 4 / 5
evaluate 'Case 10-51r';
SELECT id FROM tls WHERE (CASE WHEN v LIKE 'ab' THEN 1 ELSE 0 END) = 1 ORDER BY id;
-- expected: same: 10-51r
evaluate 'Case 10-51';
SELECT id FROM tls WHERE v LIKE 'ab' ORDER BY id;
-- expected: rows: 1 / 2
evaluate 'Case 10-52r';
SELECT id FROM tls WHERE (CASE WHEN v LIKE '' THEN 1 ELSE 0 END) = 1 ORDER BY id;
-- expected: same: 10-52r
evaluate 'Case 10-52';
SELECT id FROM tls WHERE v LIKE '' ORDER BY id;
-- expected: rows: 1 / 2 / 3 / 4 / 5 / 6
evaluate 'Case 10-53';
SELECT id FROM tls WHERE v LIKE 'ab' OR NOT (v LIKE 'ab') ORDER BY id;
-- expected: exec
evaluate 'Case 10-54p';
PREPARE pls FROM 'SELECT id FROM tls WHERE v LIKE ? ORDER BY id';
-- expected: same: 10-51r
evaluate 'Case 10-54a';
EXECUTE pls USING 'ab';
-- expected: same: 10-52r
evaluate 'Case 10-54b';
EXECUTE pls USING '';
DEALLOCATE PREPARE pls;
-- CHAR against CHAR still becomes "=": both ignore trailing spaces
-- expected: rows: 3 / 4 / 5
evaluate 'Case 10-55';
SELECT id FROM tls WHERE c LIKE 'ab' ORDER BY id;
CREATE INDEX tls_v ON tls (v);
-- expected: same: 10-51r
evaluate 'Case 10-56';
SELECT /*+ RECOMPILE */ id FROM tls WHERE v LIKE 'ab' ORDER BY id;
-- expected: rows: 'ab' / 'ab ' / 'ab  '
evaluate 'Case 10-57';
SELECT /*+ RECOMPILE */ v FROM tls WHERE v LIKE 'ab' ORDER BY v;
DROP TABLE tls;
