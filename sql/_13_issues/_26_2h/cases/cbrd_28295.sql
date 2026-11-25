/**
 *  This test case verifies CBRD-28295: a COLLATE modifier on a non-string value inside a collection constructor,
 *  an IN list or = ANY over a collection crashed the client (SIGSEGV)
 *
 *  A COLLATE modifier becomes a CAST that gets no type when its operand is not a string, and an error is set.
 *  Outside a collection that error ends the statement, but a collection is typed during name resolution and the
 *  type walk went on to the parent expression, which read the CAST without a type: an outer CAST read its cast type,
 *  and +, ||, CONCAT and COALESCE wrote a collation into its missing data type. The fix makes both places treat that
 *  CAST as failed, so the statement fails with the same error as outside a collection.
 *  Cases 1 to 6 have an outer CAST over the COLLATE modifier, cases 7 to 10 coerce the collation of a COLLATE
 *  modifier on an expression of undetermined type (COALESCE with a bind value), cases 11 and 12 are the same
 *  expressions outside a collection, and cases 13 and 14 put a COLLATE modifier on a string inside a collection.
 *
 *  Coverage:
 *    Case 1:  CAST of an INT column with COLLATE in a collection constructor fails with an error
 *    Case 2:  the same CAST in an IN list fails with an error
 *    Case 3:  the same CAST in = ANY over a collection fails with an error
 *    Case 4:  CAST of a DATE column with COLLATE in a collection constructor fails with an error
 *    Case 5:  CAST of an arithmetic expression with COLLATE in an IN list fails with an error
 *    Case 6:  CAST of COALESCE with a bind value and COLLATE in a collection constructor fails with an error
 *    Case 7:  string plus COALESCE with COLLATE in a collection constructor fails with an error
 *    Case 8:  string concatenation with COALESCE of two bind values and COLLATE in an IN list fails with an error
 *    Case 9:  CONCAT with COALESCE and COLLATE in = ANY over a collection fails with an error
 *    Case 10: COALESCE over COALESCE with COLLATE in a collection constructor fails with an error
 *    Case 11: case 1 outside a collection fails with the same error
 *    Case 12: case 7 outside a collection fails with the same error
 *    Case 13: CAST of a VARCHAR column with COLLATE in a collection constructor returns the value
 *    Case 14: string plus COALESCE of strings with COLLATE in a collection constructor returns the value
 */
DROP TABLE IF EXISTS t28295;
CREATE TABLE t28295 (c0 VARCHAR(10), c1 INT, c2 DATE);
INSERT INTO t28295 VALUES ('a', 1, DATE '2020-01-01');

evaluate 'Case 1: CAST of an INT column with COLLATE in a collection constructor fails with an error';
SELECT {CAST ((c1 COLLATE utf8_bin) AS CHAR(3))} FROM t28295;

evaluate 'Case 2: the same CAST in an IN list fails with an error';
SELECT c0 FROM t28295 WHERE c0 IN (CAST ((c1 COLLATE utf8_bin) AS CHAR(3)), 'x');

evaluate 'Case 3: the same CAST in = ANY over a collection fails with an error';
SELECT c0 FROM t28295 WHERE c0 = ANY {CAST ((c1 COLLATE utf8_bin) AS CHAR(3))};

evaluate 'Case 4: CAST of a DATE column with COLLATE in a collection constructor fails with an error';
SELECT {CAST ((c2 COLLATE utf8_bin) AS CHAR(3))} FROM t28295;

evaluate 'Case 5: CAST of an arithmetic expression with COLLATE in an IN list fails with an error';
SELECT c0 FROM t28295 WHERE c0 IN (CAST (((c1 + 1) COLLATE utf8_bin) AS CHAR(3)), 'x');

evaluate 'Case 6: CAST of COALESCE with a bind value and COLLATE in a collection constructor fails with an error';
PREPARE s FROM 'SELECT {CAST ((COALESCE (1, ?) COLLATE utf8_bin) AS CHAR(3))} FROM t28295';

evaluate 'Case 7: string plus COALESCE with COLLATE in a collection constructor fails with an error';
PREPARE s FROM 'SELECT {''x'', ''x'' + (COALESCE (1, ?) COLLATE utf8_bin)} FROM db_root';

evaluate 'Case 8: string concatenation with COALESCE of two bind values and COLLATE in an IN list fails with an error';
PREPARE s FROM 'SELECT c0 FROM t28295 WHERE c0 IN (''x'' || (COALESCE (?, ?) COLLATE utf8_bin), ''x'')';

evaluate 'Case 9: CONCAT with COALESCE and COLLATE in = ANY over a collection fails with an error';
PREPARE s FROM 'SELECT c0 FROM t28295 WHERE c0 = ANY {CONCAT (''x'', (COALESCE (1, ?) COLLATE utf8_bin))}';

evaluate 'Case 10: COALESCE over COALESCE with COLLATE in a collection constructor fails with an error';
PREPARE s FROM 'SELECT {COALESCE ((COALESCE (1, ?) COLLATE utf8_bin), ''b'')} FROM t28295';

evaluate 'Case 11: case 1 outside a collection fails with the same error';
SELECT CAST ((c1 COLLATE utf8_bin) AS CHAR(3)) FROM t28295;

evaluate 'Case 12: case 7 outside a collection fails with the same error';
PREPARE s FROM 'SELECT 1 FROM db_root WHERE ''x'' = (''x'' + (COALESCE (1, ?) COLLATE utf8_bin))';

evaluate 'Case 13: CAST of a VARCHAR column with COLLATE in a collection constructor returns the value';
SELECT {CAST ((c0 COLLATE utf8_bin) AS CHAR(3))} FROM t28295;

evaluate 'Case 14: string plus COALESCE of strings with COLLATE in a collection constructor returns the value';
PREPARE s FROM 'SELECT {''x'' + (COALESCE (''a'', ?) COLLATE utf8_bin)} FROM db_root';
EXECUTE s USING 'b';
DEALLOCATE PREPARE s;

DROP TABLE t28295;
