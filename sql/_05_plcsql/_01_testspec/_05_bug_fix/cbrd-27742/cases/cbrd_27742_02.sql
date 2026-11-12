-- verified the CBRD-27742
evaluate 'static SQL with a non-mergeable derived table or view none of whose columns the outer query references.';
evaluate 'the results must be the same as those of the same queries run as normal SQL (marked plain).';

--+ server-message on


DROP VIEW IF EXISTS v15;
DROP VIEW IF EXISTS v12;
DROP VIEW IF EXISTS v5;
DROP VIEW IF EXISTS v4;
DROP VIEW IF EXISTS v2;
DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS te;
CREATE TABLE t (c INT);
CREATE INDEX idx ON t (c);
INSERT INTO t SELECT ROWNUM FROM db_class LIMIT 10;
CREATE TABLE t2 (c INT);
INSERT INTO t2 SELECT ROWNUM FROM db_class LIMIT 10;
CREATE TABLE te (c INT);

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
-- (kept in the printed tree, as its select list is not removed when compiled)
CREATE OR REPLACE FUNCTION f9 (v INT) RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT c, MAX(c) + v AS y FROM t2 GROUP BY c) z;
 RETURN n;
END;
SELECT f9(1) FROM db_root;

-- case 10: PL variable in ORDER BY of the derived table, outer references no column
-- (the select list and ORDER BY are kept in the printed tree when compiled)
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

-- case 13: inline view of an aggregate query without GROUP BY, the first column is a constant
CREATE OR REPLACE FUNCTION f13 (v INT) RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT 1 AS k, COUNT(*) + v AS cnt FROM t2) z;
 RETURN n;
END;
SELECT f13(1) FROM db_root;

-- case 14: the same inline view, only the constant column is referenced
CREATE OR REPLACE FUNCTION f14 (v INT) RETURN INT AS n INT;
BEGIN
 SELECT COUNT(k) INTO n FROM (SELECT 1 AS k, COUNT(*) + v AS cnt FROM t2) z;
 RETURN n;
END;
SELECT f14(1) FROM db_root;

-- case 15: view of an aggregate query without GROUP BY, the first attribute is a constant
CREATE VIEW v15 AS SELECT 'x' AS k, COUNT(*) AS cnt FROM t2;
CREATE OR REPLACE FUNCTION f15 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM v15;
 RETURN n;
END;
SELECT f15() FROM db_root;

-- case 16: the same view, only the constant attribute is referenced
CREATE OR REPLACE FUNCTION f16 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(k) INTO n FROM v15;
 RETURN n;
END;
SELECT f16() FROM db_root;

-- case 17: the first column is an expression of constants
CREATE OR REPLACE FUNCTION f17 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT 1 + 1 AS k, COUNT(*) AS cnt FROM t2) z;
 RETURN n;
END;
SELECT f17() FROM db_root;

-- case 18: the first column is a string constant
CREATE OR REPLACE FUNCTION f18 RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT 'x' AS k, COUNT(*) AS cnt FROM t2) z;
 RETURN n;
END;
SELECT f18() FROM db_root;

-- case 19: the first column is a PL variable
CREATE OR REPLACE FUNCTION f19 (v INT) RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT v AS k, COUNT(*) AS cnt FROM t2) z;
 RETURN n;
END;
SELECT f19(7) FROM db_root;

-- case 20: aggregate query without GROUP BY of an empty table (one row)
CREATE OR REPLACE FUNCTION f20 (v INT) RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT COUNT(*) + v AS cnt FROM te) z;
 RETURN n;
END;
SELECT f20(1) FROM db_root;

-- case 21: GROUP BY with a HAVING false for every group (no row)
CREATE OR REPLACE FUNCTION f21 (v INT) RETURN INT AS n INT;
BEGIN
 SELECT COUNT(*) INTO n FROM (SELECT c, MAX(c) + v AS y FROM t2 GROUP BY c HAVING MAX(c) > 100) z;
 RETURN n;
END;
SELECT f21(1) FROM db_root;

-- the same queries as normal SQL
SELECT 'plain1', COUNT(*) FROM (SELECT c AS x FROM t WHERE c > 0 GROUP BY c) z;
SELECT 'plain3', COUNT(*) FROM v2;
SELECT 'plain7', COUNT(*) FROM (SELECT 1 AS k FROM v2) q;
SELECT 'plain8', COUNT(*) FROM v5;
SELECT 'plain10', COUNT(*) FROM (SELECT c FROM t2 GROUP BY c ORDER BY c + 1) z;
SELECT 'plain11', COUNT(*) FROM (SELECT COUNT(*) cnt FROM t2) z;
SELECT 'plain12', COUNT(*) FROM v12;
SELECT 'plain13', COUNT(*) FROM (SELECT 1 AS k, COUNT(*) + 1 AS cnt FROM t2) z;
SELECT 'plain14', COUNT(k) FROM (SELECT 1 AS k, COUNT(*) + 1 AS cnt FROM t2) z;
SELECT 'plain15', COUNT(*) FROM v15;
SELECT 'plain16', COUNT(k) FROM v15;
SELECT 'plain17', COUNT(*) FROM (SELECT 1 + 1 AS k, COUNT(*) AS cnt FROM t2) z;
SELECT 'plain18', COUNT(*) FROM (SELECT 'x' AS k, COUNT(*) AS cnt FROM t2) z;
SELECT 'plain19', COUNT(*) FROM (SELECT 7 AS k, COUNT(*) AS cnt FROM t2) z;
SELECT 'plain20', COUNT(*) FROM (SELECT COUNT(*) + 1 AS cnt FROM te) z;
SELECT 'plain21', COUNT(*) FROM (SELECT c, MAX(c) + 1 AS y FROM t2 GROUP BY c HAVING MAX(c) > 100) z;

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
DROP FUNCTION f13;
DROP FUNCTION f14;
DROP FUNCTION f15;
DROP FUNCTION f16;
DROP FUNCTION f17;
DROP FUNCTION f18;
DROP FUNCTION f19;
DROP FUNCTION f20;
DROP FUNCTION f21;
DROP VIEW v15;
DROP VIEW v12;
DROP VIEW v5;
DROP VIEW v4;
DROP VIEW v2;
DROP TABLE t;
DROP TABLE t2;
DROP TABLE te;

--+ server-message off
