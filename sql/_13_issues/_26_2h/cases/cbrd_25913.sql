/**
 * This test case verifies CBRD-25913: EXECUTE ... USING must reject a
 * parenthesized subquery inside a collection argument.
 *
 * Coverage:
 * 1-2. plain collection arguments, and a parenthesized non-query expression
 *      inside a collection, still bind normally.
 * 3-5. parenthesized, SET and table subqueries inside a collection are
 *      rejected; the table form used to crash the server.
 * 6-7. the rejection applies to the first and to a later USING argument.
 * 8. a subquery nested inside an expression or a function argument is rejected.
 * 9. a subquery passed directly, outside a collection, is rejected.
 */

DROP TABLE IF EXISTS t1;
CREATE TABLE t1(c1 int);
INSERT INTO t1 VALUES(1);

-- Both statements reduce the bound collection to a scalar; echoing the
-- collection back would render as a per-run Java object id in the answer.
PREPARE p FROM 'select 1 in ?';
PREPARE p2 FROM 'select 1 in ?, 2 in ?';

evaluate 'Case 1: collection arguments in USING still bind';
EXECUTE p USING {1};
EXECUTE p USING {1, 2};
EXECUTE p USING set{1, 2};
EXECUTE p2 USING {1}, {2};

evaluate 'Case 2: parenthesized non-query expression in a collection still binds';
EXECUTE p USING {(1)};

evaluate 'Case 3: parenthesized subquery in a collection is rejected';
EXECUTE p USING {(select 1)};

evaluate 'Case 4: SET collection subquery in a collection is rejected';
EXECUTE p USING {set (select 1)};

evaluate 'Case 5: table subquery in a collection is rejected';
EXECUTE p USING {(select 1 from t1)};

evaluate 'Case 6: subquery in the first USING argument is rejected';
EXECUTE p2 USING {(select 1)}, {2};

evaluate 'Case 7: subquery in a later USING argument is rejected';
EXECUTE p2 USING {1}, {(select 2)};
EXECUTE p2 USING {1}, {set (select 2)};
EXECUTE p2 USING {1}, {(select 1 from t1)};

evaluate 'Case 8: subquery nested in an expression or a function argument is rejected';
EXECUTE p USING {1 + (select 1)};
EXECUTE p USING {abs((select 1))};

evaluate 'Case 9: subquery outside a collection is rejected';
EXECUTE p USING (select 1);

DEALLOCATE PREPARE p;
DEALLOCATE PREPARE p2;
DROP TABLE IF EXISTS t1;
