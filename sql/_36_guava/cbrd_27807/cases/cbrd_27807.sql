-- CBRD-27807 a debug client aborts when an IN list cast to NUMERIC holds an ENUM element
-- When the final comparison type of an IN list is NUMERIC, the list is cast to NUMERIC and its precision is taken
-- from the elements. The precision only handled NUMERIC and discrete number elements and asserted on an ENUM
-- element. An ENUM is coerced to NUMERIC as its index, so it is sized like a discrete number; the results are those
-- of a release build, which compares the ENUM index.

DROP TABLE IF EXISTS t;
CREATE TABLE t (i INT, e ENUM('a', 'b', '12', '2.5'));
INSERT INTO t VALUES (1, 'a'), (2, 'b'), (3, '12'), (4, '2.5');

-- 1. NUMERIC on the left: the common type of the list is an integer, NUMERIC or ENUM
SELECT i, (2.5 IN (1, e)) AS r FROM t ORDER BY i;
SELECT i, (2.5 IN (e, 1)) AS r FROM t ORDER BY i;
SELECT i, (2.5 IN (1.5, e)) AS r FROM t ORDER BY i;
SELECT i, (2.5 IN (e, e)) AS r FROM t ORDER BY i;

-- 2. an integer on the left, a NUMERIC and an ENUM in the list: the comparison type is NUMERIC
SELECT i, (2 IN (1.5, e)) AS r FROM t ORDER BY i;

-- 3. ANY over a single ENUM element is not rewritten to a comparison
SELECT i, (2.5 = ANY {e}) AS r FROM t ORDER BY i;

-- 4. references whose comparison type is not NUMERIC: an integer and a DOUBLE
SELECT i, (i IN (1, e)) AS r FROM t ORDER BY i;
SELECT i, (2.5e0 IN (1, e)) AS r FROM t ORDER BY i;

DROP TABLE t;
