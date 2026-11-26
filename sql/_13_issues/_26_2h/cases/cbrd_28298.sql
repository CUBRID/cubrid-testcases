/**
 *  This test case verifies CBRD-28298: TO_NUMBER whose format value is NULL crashed the server (SIGSEGV)
 *
 *  A NULL format value from a column or a host variable passed the string type check in db_to_number () and
 *  strlen was then taken of no string. The fix makes the result NULL, as for a NULL source, and a NULL literal
 *  format, which failed with an invalid data type error, gives NULL too, as in TO_CHAR and TO_DATE.
 *
 *  Coverage:
 *    Case 1: a NULL format column gives NULL
 *    Case 2: a NULL format host variable gives NULL
 *    Case 3: a table mixing NULL and non-NULL format values gives NULL and the value row by row
 *    Case 4: TO_NUMBER without a format and with a non-NULL format host variable return the value
 *    Case 5: a NULL source with a non-NULL format gives NULL
 *    Case 6: an empty source and an empty format still fail with an error
 *    Case 7: a NULL literal format and a NULL cast to VARCHAR give NULL
 */
DROP TABLE IF EXISTS t28298;
CREATE TABLE t28298 (id INT, s VARCHAR(10), f VARCHAR(10));
INSERT INTO t28298 VALUES (1, '12.5', NULL), (2, '12.5', '99.9'), (3, NULL, '99.9'), (4, '7', NULL);

evaluate 'Case 1: a NULL format column gives NULL';
SELECT id, TO_NUMBER ('12', f) FROM t28298 WHERE id = 1;

evaluate 'Case 2: a NULL format host variable gives NULL';
PREPARE s FROM 'SELECT TO_NUMBER (''12'', ?) FROM t28298 WHERE id = 1';
EXECUTE s USING NULL;
DEALLOCATE PREPARE s;

evaluate 'Case 3: a table mixing NULL and non-NULL format values gives NULL and the value row by row';
SELECT id, TO_NUMBER (s, f) FROM t28298 ORDER BY id;

evaluate 'Case 4: TO_NUMBER without a format and with a non-NULL format host variable return the value';
SELECT TO_NUMBER ('12') FROM t28298 WHERE id = 1;
PREPARE s FROM 'SELECT TO_NUMBER (''12.5'', ?) FROM t28298 WHERE id = 1';
EXECUTE s USING '99.9';
DEALLOCATE PREPARE s;

evaluate 'Case 5: a NULL source with a non-NULL format gives NULL';
SELECT TO_NUMBER (s, f) FROM t28298 WHERE id = 3;

evaluate 'Case 6: an empty source and an empty format still fail with an error';
SELECT TO_NUMBER ('', f) FROM t28298 WHERE id = 2;
SELECT TO_NUMBER ('12', '') FROM t28298 WHERE id = 2;

evaluate 'Case 7: a NULL literal format and a NULL cast to VARCHAR give NULL';
SELECT TO_NUMBER ('12', NULL) FROM t28298 WHERE id = 2;
SELECT TO_NUMBER ('12', CAST (NULL AS VARCHAR)) FROM t28298 WHERE id = 2;

DROP TABLE t28298;
