/**
 * This test case verifies CBRD-25913: subqueries must not be allowed in the EXECUTE ... USING clause
 *
 * Coverage:
 * 1 - USING with a plain scalar value still works (no over-blocking)
 * 2 - Parenthesized subquery inside a USING collection raises a syntax error
 * 3 - Subquery inside SET(...) in a USING collection raises a syntax error
 * 4 - Subquery over a table in a USING collection raises a syntax error (previously a segmentation fault)
 * 5 - Multiple USING arguments where a later argument holds a subquery raises a syntax error
 * 6 - Multiple USING arguments with a SET(...) subquery raises a syntax error
 * 7 - Multiple USING arguments with a table subquery raises a syntax error
 * 8 - A bare (non-collection) subquery in USING is also rejected, at parse time (complements the fix, which guards the collection form)
 */

--+ server-message on

DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (c1 INT);
INSERT INTO t1 VALUES (1);

prepare p from 'select ?';
prepare p2 from 'select ?, ?';

evaluate 'Case 1: USING plain scalar value succeeds';
execute p using 1;

evaluate 'Case 2: parenthesized subquery in USING collection is rejected';
execute p using {(select 1)};

evaluate 'Case 3: SET subquery in USING collection is rejected';
execute p using {set (select 1)};

evaluate 'Case 4: table subquery in USING collection is rejected (was segfault)';
execute p using {(select 1 from t1)};

evaluate 'Case 5: later USING argument with a subquery is rejected';
execute p2 using {(1)}, {(select 2)};

evaluate 'Case 6: later USING argument with a SET subquery is rejected';
execute p2 using {1}, {set (select 2)};

evaluate 'Case 7: later USING argument with a table subquery is rejected';
execute p2 using {1}, {(select 1 from t1)};

evaluate 'Case 8: bare subquery in USING is also rejected at parse time';
execute p using (select 1);

DROP TABLE IF EXISTS t1;

--+ server-message off
