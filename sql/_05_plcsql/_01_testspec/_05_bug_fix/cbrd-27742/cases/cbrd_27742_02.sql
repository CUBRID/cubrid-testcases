-- verified the CBRD-27742
evaluate 'static SQL with a non-mergeable derived table or view none of whose columns the outer query references.';
evaluate 'the results must be the same as those of the same queries run as normal SQL (marked plain).';

--+ server-message on


DROP VIEW IF EXISTS v12;
DROP VIEW IF EXISTS v5;
DROP VIEW IF EXISTS v4;
DROP VIEW IF EXISTS v2;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t2;
CREATE TABLE t (c INT);
CREATE INDEX idx ON t (c);
INSERT INTO t SELECT ROWNUM FROM db_class LIMIT 10;
CREATE TABLE t2 (c INT);
INSERT INTO t2 SELECT ROWNUM FROM db_class LIMIT 10;

CREATE VIEW v2 AS SELECT c FROM t2 GROUP BY c;
CREATE VIEW v4 AS SELECT * FROM v2;
CREATE VIEW v5 AS SELECT COUNT(*) cnt FROM v4;

-- case 1: procedure, inline view with GROUP BY (WHERE + index)
CREATE OR REPLACE PROCEDURE p1 AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT c AS x FROM t WHERE c > 0 GROUP BY c) z;
 DBMS_OUTPUT.PUT_LINE('p1: ' || n);
END;
CALL p1();

-- case 2: procedure, inline view with GROUP BY (no index, no WHERE)
CREATE OR REPLACE PROCEDURE p2 AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT c AS x FROM t2 GROUP BY c) z;
 DBMS_OUTPUT.PUT_LINE('p2: ' || n);
END;
CALL p2();

-- case 3: procedure, view with GROUP BY
CREATE OR REPLACE PROCEDURE p3 AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM v2;
 DBMS_OUTPUT.PUT_LINE('p3: ' || n);
END;
CALL p3();

-- case 4: function called from select list, view with GROUP BY
CREATE OR REPLACE FUNCTION f4 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM v2;
 RETURN n;
END;
SELECT f4() FROM db_root;

-- case 5: function called from select list, inline view with GROUP BY
CREATE OR REPLACE FUNCTION f5 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT c AS x FROM t2 GROUP BY c) z;
 RETURN n;
END;
SELECT f5() FROM db_root;

-- case 6: function called per row of a table
SELECT c, f5() FROM t2 WHERE c < 3 ORDER BY c;

-- case 7: cursor FOR loop, select list references no view column
CREATE OR REPLACE FUNCTION f7 RETURN INT AS n INT := 0;
BEGIN
 FOR r IN (SELECT 1 AS k FROM v2) LOOP
 n := n + 1;
 END LOOP;
 RETURN n;
END;
SELECT f7() FROM db_root;

-- case 8: nested view (v5 -> v4 -> v2), outer aggregate view is non-mergeable
CREATE OR REPLACE FUNCTION f8 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM v5;
 RETURN n;
END;
SELECT f8() FROM db_root;

-- case 9: PL variable only in a derived column the outer query never references
-- (removed with the select list; CBRD-27584 falls back to printing the tree here)
CREATE OR REPLACE FUNCTION f9 (v INT) RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT c, MAX(c) + v AS y FROM t2 GROUP BY c) z;
 RETURN n;
END;
SELECT f9(1) FROM db_root;

-- case 10: PL variable in ORDER BY of the derived table, outer references no column
-- (ORDER BY is kept as a hidden column: printed as "z (1, ha_2)")
CREATE OR REPLACE FUNCTION f10 (v INT) RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT c FROM t2 GROUP BY c ORDER BY c + v) z;
 RETURN n;
END;
SELECT f10(1) FROM db_root;

-- case 11: inline view of an aggregate query without GROUP BY (one row)
-- (must not be printed as "select 1 from t2", which returns 10 rows)
CREATE OR REPLACE FUNCTION f11 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT COUNT(*) cnt FROM t2) z;
 RETURN n;
END;
SELECT f11() FROM db_root;

-- case 12: view of an aggregate query without GROUP BY, HAVING only
CREATE VIEW v12 AS SELECT MAX(c) mx FROM t2 HAVING MAX(c) > 0;
CREATE OR REPLACE FUNCTION f12 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM v12;
 RETURN n;
END;
SELECT f12() FROM db_root;

-- the same queries as normal SQL
SELECT 'plain1', COUNT(*) FROM (SELECT c AS x FROM t WHERE c > 0 GROUP BY c) z;
SELECT 'plain3', COUNT(*) FROM v2;
SELECT 'plain7', COUNT(*) FROM (SELECT 1 AS k FROM v2) q;
SELECT 'plain8', COUNT(*) FROM v5;
SELECT 'plain10', COUNT(*) FROM (SELECT c FROM t2 GROUP BY c ORDER BY c + 1) z;
SELECT 'plain11', COUNT(*) FROM (SELECT COUNT(*) cnt FROM t2) z;
SELECT 'plain12', COUNT(*) FROM v12;

DROP PROCEDURE p1;
DROP PROCEDURE p2;
DROP PROCEDURE p3;
DROP FUNCTION f4;
DROP FUNCTION f5;
DROP FUNCTION f7;
DROP FUNCTION f8;
DROP FUNCTION f9;
DROP FUNCTION f10;
DROP FUNCTION f11;
DROP FUNCTION f12;
DROP VIEW v12;
DROP VIEW v5;
DROP VIEW v4;
DROP VIEW v2;
DROP TABLE t;
DROP TABLE t2;

--+ server-message off
