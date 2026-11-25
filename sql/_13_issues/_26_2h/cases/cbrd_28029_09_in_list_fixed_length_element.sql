/**
 *  This test case verifies CBRD-28029 #9: an IN list with an element of a fixed length (a VARCHAR(2) column, a folded VARCHAR(2) value) must
 *  not coerce a longer literal element to that length.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t09;
CREATE TABLE t09 (v VARCHAR(2), ch CHAR(2), n NUMERIC(2,0), vb VARCHAR(5));
INSERT INTO t09 VALUES ('ab', 'ab', 12, 'ab');
-- expected: rows: 'r'
evaluate 'Case 9-1';
SELECT 'r' AS r FROM t09 WHERE 'xyz' IN (v, 'xyz');
-- expected: rows: 'r'
evaluate 'Case 9-2';
SELECT 'r' AS r FROM db_root WHERE 'xyz' IN (LOWER('' || 'ab'), 'xyz');
-- expected: rows: 'r'
evaluate 'Case 9-c1';
SELECT 'r' AS r FROM t09 WHERE 'xyz' = v OR 'xyz' = 'xyz';
-- expected: rows: 'r'
evaluate 'Case 9-3';
SELECT 'r' AS r FROM t09 WHERE 'xyz' IN (ch, 'xyz');
-- expected: rows: 'r'
evaluate 'Case 9-4';
SELECT 'r' AS r FROM t09 WHERE v IN ('xyz', 'ab');
-- expected: rows: 'r'
evaluate 'Case 9-5';
SELECT 'r' AS r FROM t09 WHERE 'xyz' NOT IN (v, 'abc');
-- expected: rows: 'r'
evaluate 'Case 9-6';
SELECT 'r' AS r FROM t09 WHERE 'ab' IN (v, 'xyz');
-- a longer value must not be cut down to the column length: 'abc' is not 'ab'
-- expected: empty
evaluate 'Case 9-7';
SELECT 'r' AS r FROM t09 WHERE 'abc' IN (v, 'xyz');
-- expected: rows: 1 | 0 | 1
evaluate 'Case 9-8';
SELECT ('xyz' IN (v, 'xyz')) AS a1, ('abc' IN (v, 'xyz')) AS a2, ('ab' IN (v, 'xyz')) AS a3 FROM t09;
-- expected: rows: 'r'
evaluate 'Case 9-9';
SELECT 'r' AS r FROM t09 WHERE 'xyz' IN (v, 'xyz', 'q');
-- expected: empty
evaluate 'Case 9-10';
SELECT 'r' AS r FROM t09 WHERE 'abcd' IN (v, vb);
-- expected: rows: 'r'
evaluate 'Case 9-11';
SELECT 'r' AS r FROM t09 WHERE vb IN (v, 'abcde');
-- expected: rows: 'r'
evaluate 'Case 9-12';
SELECT 'r' AS r FROM t09 WHERE 'xyz' IN (LOWER('' || 'ab'), v, 'xyz');
-- numeric precision of the element
-- expected: rows: 'r'
evaluate 'Case 9-13';
SELECT 'r' AS r FROM t09 WHERE 123 IN (n, 123);
-- expected: rows: 'r'
evaluate 'Case 9-14';
SELECT 'r' AS r FROM t09 WHERE 12.5 IN (n, 12.5);
-- expected: empty
evaluate 'Case 9-15';
SELECT 'r' AS r FROM t09 WHERE 12.5 IN (n, 13);
-- a subquery instead of a list (other path)
-- expected: rows: 'r'
evaluate 'Case 9-c2';
SELECT 'r' AS r FROM t09 WHERE 'xyz' IN (SELECT v FROM t09 UNION ALL SELECT 'xyz' FROM db_root);
-- host variables
-- expected: exec
evaluate 'Case 9-16p';
PREPARE p09 FROM 'SELECT ''r'' AS r FROM t09 WHERE ? IN (v, ?)';
-- expected: rows: 'r'
evaluate 'Case 9-16';
EXECUTE p09 USING 'xyz', 'xyz';
-- expected: empty
evaluate 'Case 9-17';
EXECUTE p09 USING 'abc', 'xyz';
DEALLOCATE PREPARE p09;
-- DML
-- expected: affected: 1
evaluate 'Case 9-18';
UPDATE t09 SET vb = 'upd' WHERE 'xyz' IN (v, 'xyz');
-- expected: rows: 'upd'
evaluate 'Case 9-19';
SELECT vb FROM t09;
-- expected: affected: 1
evaluate 'Case 9-20';
DELETE FROM t09 WHERE 'xyz' IN (v, 'xyz');
DROP TABLE t09;
