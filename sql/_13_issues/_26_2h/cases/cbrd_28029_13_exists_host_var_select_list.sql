/**
 *  This test case verifies CBRD-28029 #13: a prepared statement whose EXISTS subquery has a host variable in its select list, with the EXISTS
 *  used as a value (IS [NOT] NULL, select list), must run.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t13, t13e;
CREATE TABLE t13 (a INT);
INSERT INTO t13 VALUES (1), (2);
CREATE TABLE t13e (a INT);
-- expected: exec
evaluate 'Case 13-1p';
PREPARE s13 FROM 'SELECT a FROM t13 WHERE (EXISTS (SELECT ? FROM t13)) IS NULL ORDER BY a';
-- expected: empty
evaluate 'Case 13-1';
EXECUTE s13 USING 1;
-- expected: empty
evaluate 'Case 13-1b';
EXECUTE s13 USING 'x';
DEALLOCATE PREPARE s13;
-- expected: exec
evaluate 'Case 13-2p';
PREPARE s13b FROM 'SELECT a FROM t13 WHERE (EXISTS (SELECT ? FROM t13)) IS NOT NULL ORDER BY a';
-- expected: rows: 1 / 2
evaluate 'Case 13-2';
EXECUTE s13b USING 1;
DEALLOCATE PREPARE s13b;
-- expected: exec
evaluate 'Case 13-3p';
PREPARE s13c FROM 'SELECT a FROM t13 WHERE (EXISTS (SELECT ? FROM t13)) IS FALSE ORDER BY a';
-- expected: empty
evaluate 'Case 13-3';
EXECUTE s13c USING 1;
DEALLOCATE PREPARE s13c;
-- expected: exec
evaluate 'Case 13-4p';
PREPARE s13d FROM 'SELECT a FROM t13 WHERE (EXISTS (SELECT ? FROM t13)) IS TRUE ORDER BY a';
-- expected: rows: 1 / 2
evaluate 'Case 13-4';
EXECUTE s13d USING 1;
DEALLOCATE PREPARE s13d;
-- expected: exec
evaluate 'Case 13-5p';
PREPARE s13e FROM 'SELECT a, (EXISTS (SELECT ? FROM t13)) AS ex FROM t13 ORDER BY a';
-- expected: rows: 1 | 1 / 2 | 1
evaluate 'Case 13-5';
EXECUTE s13e USING 1;
DEALLOCATE PREPARE s13e;
-- expected: exec
evaluate 'Case 13-6p';
PREPARE s13f FROM 'SELECT (EXISTS (SELECT ? FROM t13e)) AS ex, (NOT EXISTS (SELECT ? FROM t13e)) AS nex FROM db_root';
-- expected: rows: 0 | 1
evaluate 'Case 13-6';
EXECUTE s13f USING 1, 1;
DEALLOCATE PREPARE s13f;
-- expected: exec
evaluate 'Case 13-7p';
PREPARE s13g FROM 'SELECT a FROM t13 WHERE (NOT EXISTS (SELECT ? FROM t13)) IS NULL ORDER BY a';
-- expected: empty
evaluate 'Case 13-7';
EXECUTE s13g USING 1;
DEALLOCATE PREPARE s13g;
-- expected: exec
evaluate 'Case 13-8p';
PREPARE s13h FROM 'SELECT a FROM t13 WHERE (EXISTS (SELECT ?, a FROM t13 WHERE a > ?)) IS NOT NULL ORDER BY a';
-- expected: rows: 1 / 2
evaluate 'Case 13-8';
EXECUTE s13h USING 1, 5;
DEALLOCATE PREPARE s13h;
-- expected: exec
evaluate 'Case 13-9p';
PREPARE s13i FROM 'SELECT a FROM t13 WHERE (EXISTS (SELECT ? + 1 FROM t13 i WHERE i.a = t13.a)) IS NOT NULL ORDER BY a';
-- expected: rows: 1 / 2
evaluate 'Case 13-9';
EXECUTE s13i USING 1;
DEALLOCATE PREPARE s13i;
-- the value of the EXISTS itself (the IS [NOT] NULL cases above cannot tell 0 from 1)
-- expected: exec
evaluate 'Case 13-10p';
PREPARE s13k FROM 'SELECT (EXISTS (SELECT ?, a FROM t13 WHERE a > ?)) AS ex FROM db_root';
-- expected: rows: 0
evaluate 'Case 13-10a';
EXECUTE s13k USING 1, 5;
-- expected: rows: 1
evaluate 'Case 13-10b';
EXECUTE s13k USING 1, 1;
DEALLOCATE PREPARE s13k;
-- expected: exec
evaluate 'Case 13-11p';
PREPARE s13l FROM 'SELECT a, (EXISTS (SELECT ? + 1 FROM t13 i WHERE i.a > t13.a)) AS ex FROM t13 ORDER BY a';
-- expected: rows: 1 | 1 / 2 | 0
evaluate 'Case 13-11';
EXECUTE s13l USING 1;
DEALLOCATE PREPARE s13l;
-- expected: exec
evaluate 'Case 13-12p';
PREPARE s13m FROM 'SELECT a FROM t13 WHERE (EXISTS (SELECT ? FROM t13 i WHERE i.a > t13.a)) = 0 ORDER BY a';
-- expected: rows: 2
evaluate 'Case 13-12';
EXECUTE s13m USING 1;
DEALLOCATE PREPARE s13m;
-- the same EXISTS compiled with the value bound (RECOMPILE) and in DML
-- expected: exec
evaluate 'Case 13-13p';
PREPARE s13n FROM 'SELECT /*+ RECOMPILE */ a FROM t13 WHERE (EXISTS (SELECT ? FROM t13)) IS NOT NULL ORDER BY a';
-- expected: rows: 1 / 2
evaluate 'Case 13-13';
EXECUTE s13n USING 1;
DEALLOCATE PREPARE s13n;
-- expected: exec
evaluate 'Case 13-14p';
PREPARE s13o FROM 'DELETE FROM t13 WHERE (EXISTS (SELECT ? FROM t13)) IS NULL';
-- expected: affected: 0
evaluate 'Case 13-14';
EXECUTE s13o USING 1;
DEALLOCATE PREPARE s13o;
-- expected: rows: 1 / 2
evaluate 'Case 13-15';
SELECT a FROM t13 ORDER BY a;
-- EXISTS over a host variable that is not a query stays an error
-- expected: exec
evaluate 'Case 13-16p';
PREPARE s13p FROM 'SELECT a FROM t13 WHERE EXISTS ?';
-- expected: keep
evaluate 'Case 13-16';
EXECUTE s13p USING 1;
DEALLOCATE PREPARE s13p;
-- controls: no host variable, host variable outside the select list
-- expected: empty
evaluate 'Case 13-c1';
SELECT a FROM t13 WHERE (EXISTS (SELECT 1 FROM t13)) IS NULL ORDER BY a;
-- expected: exec
evaluate 'Case 13-c2p';
PREPARE s13j FROM 'SELECT a FROM t13 WHERE (EXISTS (SELECT 1 FROM t13 WHERE a = ?)) IS NULL ORDER BY a';
-- expected: empty
evaluate 'Case 13-c2';
EXECUTE s13j USING 1;
DEALLOCATE PREPARE s13j;
DROP TABLE t13, t13e;
-- EXISTS in arithmetic: the debug client aborted on develop 3421d763b (domain_resolve_arith), so it runs last
CREATE TABLE t13 (a INT);
INSERT INTO t13 VALUES (1), (2);
-- expected: exec
evaluate 'Case 13-17p';
PREPARE s13q FROM 'SELECT (EXISTS (SELECT ? FROM t13)) + 1 AS x FROM db_root';
-- expected: rows: 2
evaluate 'Case 13-17';
EXECUTE s13q USING 1;
DEALLOCATE PREPARE s13q;
DROP TABLE t13;
