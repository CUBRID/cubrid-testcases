/**
 * This test case verifies CBRD-25913: EXECUTE ... USING must reject a
 * parenthesized subquery inside a collection argument.
 *
 * Coverage:
 * 1-3. collection arguments (including a parenthesized non-query element), a
 *      subquery inside the prepared statement's own text, and a session
 *      variable argument all still work; the new check must not over-block.
 * 4-6. parenthesized, SET and table subqueries inside a collection are
 *      rejected; the table form used to crash the server.
 * 7-8. the rejection applies to the first and to a later USING argument.
 * 9. a subquery nested inside an expression or a function argument is rejected.
 * 10. a subquery passed directly, outside a collection, is rejected by the base
 *     USING grammar (pre-existing; documents the complement of the new check).
 * 11. the session survives the rejections that used to crash the server.
 */

DROP TABLE IF EXISTS t1;
CREATE TABLE t1(c1 int);
INSERT INTO t1 VALUES(1);

-- p and p2 reduce the bound collection to a scalar; echoing a collection back
-- would render as a per-run Java object id in the answer.
PREPARE p FROM 'select 1 in ?';
PREPARE p2 FROM 'select 1 in ?, 2 in ?';
PREPARE q FROM 'select (select max(c1) from t1) + ?';
PREPARE ps FROM 'select ?';

evaluate 'Case 1: collection arguments still bind, and their contents drive the result';
EXECUTE p USING {1};
EXECUTE p USING {2};
EXECUTE p USING {1, 2};
EXECUTE p USING set{1, 2};
EXECUTE p USING {(1)};
EXECUTE p2 USING {1}, {2};

evaluate 'Case 2: a subquery inside the prepared statement text still works';
EXECUTE q USING 1;

evaluate 'Case 3: a session variable argument is still accepted';
SET @v = 5;
EXECUTE ps USING @v;

evaluate 'Case 4: parenthesized subquery in a collection is rejected';
EXECUTE p USING {(select 1)};

evaluate 'Case 5: SET collection subquery in a collection is rejected';
EXECUTE p USING {set (select 1)};

evaluate 'Case 6: table subquery in a collection is rejected';
EXECUTE p USING {(select 1 from t1)};

evaluate 'Case 7: subquery in the first USING argument is rejected';
EXECUTE p2 USING {(select 1)}, {2};

evaluate 'Case 8: subquery in a later USING argument is rejected';
EXECUTE p2 USING {1}, {(select 2)};
EXECUTE p2 USING {1}, {set (select 2)};
EXECUTE p2 USING {1}, {(select 1 from t1)};

evaluate 'Case 9: subquery nested in an expression or a function argument is rejected';
EXECUTE p USING {1 + (select 1)};
EXECUTE p USING {abs((select 1))};

evaluate 'Case 10: subquery outside a collection is rejected by the base USING grammar, not by the new check';
EXECUTE p USING (select 1);

evaluate 'Case 11: the session and the prepared statements survive every rejection';
EXECUTE p USING {1};

DEALLOCATE PREPARE p;
DEALLOCATE PREPARE p2;
DEALLOCATE PREPARE q;
DEALLOCATE PREPARE ps;
DROP VARIABLE @v;
DROP TABLE IF EXISTS t1;
