/**
 *  This test case verifies CBRD-27379: SEMI JOIN and ANTI JOIN run as a hash join.
 *  Part 4 of 5 -- result size estimation (TC-3-01 to TC-3-06).
 *
 *  The fix estimates the rows of a SEMI / ANTI JOIN from the probability that an outer row finds a matching inner row,
 *  instead of the inner join estimate.
 *
 *  Coverage:
 *    TC-3-01: the estimate does not exceed the rows of the outer input
 *    TC-3-02: a WHERE term filters the result and does not take part in matching
 *    TC-3-03: duplicate inner keys (the number of distinct keys is used)
 *    TC-3-04: an ON term that does not read the inner input
 *    TC-3-05: composite PK-FK, NOT NULL or nullable FK, with or without an inner filter
 *    TC-3-06: equi-join and non-equi terms together
 *
 *  CTP runs with test_mode=yes, so the estimated rows (card) in a --@queryplan output are masked.
 *  This file asserts the result rows and the plan shape. The estimate itself is not asserted here.
 */

-- =====================================================================================================================
-- TC-3-01: estimated rows of SEMI JOIN / ANTI JOIN do not exceed those of the outer input
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-01-01: SEMI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-01-01: SEMI JOIN';

DROP TABLE IF EXISTS tb, ta;

-- ta: 1000 rows of n, n = 1 .. 1000
--   n 1     -> 1
--   n 2     -> 2
--   ...
--   n 1000  -> 1000
--   Stored: 1000 rows, keys 1 .. 1000 with 1 row per key
CREATE TABLE ta (ca INT);
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000
)
SELECT n
FROM cte;

-- tb: 1500 rows of MOD (n - 1, 250) * 4 + 4, n = 1 .. 1500
--   n 1     -> 4
--   n 2     -> 8
--   ...
--   n 250   -> 1000
--   n 251   -> 4       the same keys repeat, 6 rows per key
--   ...
--   n 1500  -> 1000
--   Stored: 1500 rows, 250 keys 4 .. 1000 (multiples of 4) with 6 rows per key
CREATE TABLE tb (ca INT);
INSERT INTO tb
WITH RECURSIVE cte (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1500
)
SELECT MOD (n - 1, 250) * 4 + 4
FROM cte;

UPDATE STATISTICS ON ta, tb;

-- hash join, result and plan
evaluate 'hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  SEMI JOIN tb ON tb.ca = ta.ca;

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- =====================================================================================================================
-- TC-3-02: WHERE terms filter SEMI JOIN / ANTI JOIN rows and do not take part in matching
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-01: ANTI JOIN, with and without a WHERE term
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-01: ANTI JOIN, with and without a WHERE term';

DROP TABLE IF EXISTS tc, tb, ta;

-- ta: 10000 rows of (x.n * 100 + y.n + 1, x.n * 100 + y.n + 1), x.n and y.n = 0 .. 99
--   x.n 0,  y.n 0   -> (1, 1)
--   x.n 0,  y.n 1   -> (2, 2)
--   ...
--   x.n 99, y.n 99  -> (10000, 10000)
--   Stored: 10000 rows, ca = cb, keys 1 .. 10000 with 1 row per key
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n + 1, x.n * 100 + y.n + 1
FROM cte x, cte y;

-- tb: 100 rows of ta where ca <= 100
--   (1, 1), (2, 2), ..., (100, 100)
--   Stored: 100 rows, ca = cb, keys 1 .. 100
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb SELECT ca, ca FROM ta WHERE ca <= 100;

-- tc: 10000 rows of ta, cb is NULL where ca > 5000
--   (1, 1), (2, 2), ..., (5000, 5000), (5001, NULL), ..., (10000, NULL)
--   Stored: 10000 rows, cb = ca for ca 1 .. 5000, cb NULL for ca 5001 .. 10000
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc SELECT ca, CASE WHEN ca <= 5000 THEN ca END FROM ta;

CREATE INDEX i_ta_ca ON ta (ca);
CREATE INDEX i_tb_ca ON tb (ca);
CREATE INDEX i_tc_ca ON tc (ca);
UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- no WHERE term, result and plan
evaluate 'no WHERE term, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- with WHERE term, result and plan
evaluate 'with WHERE term, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE (SELECT MAX (ca) FROM tc) = 5;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-02-02: LEFT OUTER JOIN + ANTI JOIN, with and without a WHERE term
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-02-02: LEFT OUTER JOIN + ANTI JOIN, with and without a WHERE term';

DROP TABLE IF EXISTS tc, tb, ta;

-- ta: 10000 rows of (x.n * 100 + y.n + 1, x.n * 100 + y.n + 1), x.n and y.n = 0 .. 99
--   x.n 0,  y.n 0   -> (1, 1)
--   x.n 0,  y.n 1   -> (2, 2)
--   ...
--   x.n 99, y.n 99  -> (10000, 10000)
--   Stored: 10000 rows, ca = cb, keys 1 .. 10000 with 1 row per key
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n + 1, x.n * 100 + y.n + 1
FROM cte x, cte y;

-- tb: 100 rows of ta where ca <= 100
--   (1, 1), (2, 2), ..., (100, 100)
--   Stored: 100 rows, ca = cb, keys 1 .. 100
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb SELECT ca, ca FROM ta WHERE ca <= 100;

-- tc: 10000 rows of ta, cb is NULL where ca > 5000
--   (1, 1), (2, 2), ..., (5000, 5000), (5001, NULL), ..., (10000, NULL)
--   Stored: 10000 rows, cb = ca for ca 1 .. 5000, cb NULL for ca 5001 .. 10000
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc SELECT ca, CASE WHEN ca <= 5000 THEN ca END FROM ta;

CREATE INDEX i_ta_ca ON ta (ca);
CREATE INDEX i_tb_ca ON tb (ca);
CREATE INDEX i_tc_ca ON tc (ca);
UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

-- no WHERE term, result and plan
evaluate 'no WHERE term, result and plan';
--@queryplan
SELECT /*+ RECOMPILE ORDERED USE_HASH */ COUNT (*)
FROM ta
  LEFT JOIN tc ON tc.ca = ta.ca
  ANTI JOIN tb ON tb.ca = ta.ca;

-- with WHERE term, result and plan
evaluate 'with WHERE term, result and plan';
--@queryplan
SELECT /*+ RECOMPILE ORDERED USE_HASH */ COUNT (*)
FROM ta
  LEFT JOIN tc ON tc.ca = ta.ca
  ANTI JOIN tb ON tb.ca = ta.ca
WHERE tc.cb IS NULL;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta;

-- =====================================================================================================================
-- TC-3-03: duplicate inner keys: match probability uses the number of distinct keys
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-01: ANTI JOIN, inner input tb
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-03-01: ANTI JOIN, inner input tb';

DROP TABLE IF EXISTS tb, ta, td;

-- td: 10000 rows of (x.n * 100 + y.n + 1, x.n * 100 + y.n + 1), x.n and y.n = 0 .. 99
--   x.n 0,  y.n 0   -> (1, 1)
--   x.n 0,  y.n 1   -> (2, 2)
--   ...
--   x.n 99, y.n 99  -> (10000, 10000)
--   Stored: 10000 rows, ca = cb, keys 1 .. 10000 with 1 row per key
CREATE TABLE td (ca INT, cb INT);
INSERT INTO td
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n + 1, x.n * 100 + y.n + 1
FROM cte x, cte y;

-- ta: 1000 rows of (MOD (ca, 100), ca) of td where ca <= 1000, 10 rows per key 0 .. 99
--   (1, 1), (2, 2), ..., (99, 99), (0, 100), (1, 101), ..., (0, 1000)
--   Stored: 1000 rows, 100 keys 0 .. 99 with 10 rows per key, cb 1 .. 1000
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta SELECT MOD (ca, 100), ca FROM td WHERE ca <= 1000;

-- tb: 1000 rows of (MOD (ca, 10), ca) of td where ca <= 1000, 100 rows per key 0 .. 9
--   (1, 1), (2, 2), ..., (9, 9), (0, 10), (1, 11), ..., (0, 1000)
--   Stored: 1000 rows, 10 keys 0 .. 9 with 100 rows per key, cb 1 .. 1000
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb SELECT MOD (ca, 10), ca FROM td WHERE ca <= 1000;

CREATE INDEX i_td_ca ON td (ca);
CREATE INDEX i_ta_ca ON ta (ca);
CREATE INDEX i_tb_ca ON tb (ca);
UPDATE STATISTICS ON td, ta, tb WITH FULLSCAN;

-- hash join, result and plan
evaluate 'hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca;

-- cleanup
DROP TABLE IF EXISTS tb, ta, td;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-03-02: ANTI JOIN, inner input tc
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-03-02: ANTI JOIN, inner input tc';

DROP TABLE IF EXISTS tc, tb, ta, td;

-- td: 10000 rows of (x.n * 100 + y.n + 1, x.n * 100 + y.n + 1), x.n and y.n = 0 .. 99
--   x.n 0,  y.n 0   -> (1, 1)
--   x.n 0,  y.n 1   -> (2, 2)
--   ...
--   x.n 99, y.n 99  -> (10000, 10000)
--   Stored: 10000 rows, ca = cb, keys 1 .. 10000 with 1 row per key
CREATE TABLE td (ca INT, cb INT);
INSERT INTO td
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n + 1, x.n * 100 + y.n + 1
FROM cte x, cte y;

-- ta: 1000 rows of (MOD (ca, 100), ca) of td where ca <= 1000, 10 rows per key 0 .. 99
--   (1, 1), (2, 2), ..., (99, 99), (0, 100), (1, 101), ..., (0, 1000)
--   Stored: 1000 rows, 100 keys 0 .. 99 with 10 rows per key, cb 1 .. 1000
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta SELECT MOD (ca, 100), ca FROM td WHERE ca <= 1000;

-- tb: 1000 rows of (MOD (ca, 10), ca) of td where ca <= 1000, 100 rows per key 0 .. 9
--   (1, 1), (2, 2), ..., (9, 9), (0, 10), (1, 11), ..., (0, 1000)
--   Stored: 1000 rows, 10 keys 0 .. 9 with 100 rows per key, cb 1 .. 1000
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb SELECT MOD (ca, 10), ca FROM td WHERE ca <= 1000;

-- tc: 10 rows, one per distinct key of tb
--   (0, 0), (1, 1), ..., (9, 9)
--   Stored: 10 rows, (0, 0) .. (9, 9)
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc SELECT DISTINCT ca, ca FROM tb;

CREATE INDEX i_td_ca ON td (ca);
CREATE INDEX i_ta_ca ON ta (ca);
CREATE INDEX i_tb_ca ON tb (ca);
CREATE INDEX i_tc_ca ON tc (ca);
UPDATE STATISTICS ON td, ta, tb, tc WITH FULLSCAN;

-- hash join, result and plan
evaluate 'hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  ANTI JOIN tc ON tc.ca = ta.ca;

-- cleanup
DROP TABLE IF EXISTS tc, tb, ta, td;

-- =====================================================================================================================
-- TC-3-04: an ON term that does not read the inner input is decided once per outer row
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-04-01: ANTI JOIN
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-04-01: ANTI JOIN';

DROP TABLE IF EXISTS tb, ta, tc;

-- tc: 10000 rows of (x.n * 100 + y.n + 1, x.n * 100 + y.n + 1), x.n and y.n = 0 .. 99
--   x.n 0,  y.n 0   -> (1, 1)
--   x.n 0,  y.n 1   -> (2, 2)
--   ...
--   x.n 99, y.n 99  -> (10000, 10000)
--   Stored: 10000 rows, ca = cb, keys 1 .. 10000 with 1 row per key
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n + 1, x.n * 100 + y.n + 1
FROM cte x, cte y;

-- ta: 1000 rows of (MOD (ca, 100), ca) of tc where ca <= 1000, 10 rows per key 0 .. 99
--   (1, 1), (2, 2), ..., (99, 99), (0, 100), (1, 101), ..., (0, 1000)
--   Stored: 1000 rows, 100 keys 0 .. 99 with 10 rows per key, cb 1 .. 1000
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta SELECT MOD (ca, 100), ca FROM tc WHERE ca <= 1000;

-- tb: 1000 rows, a copy of ta
--   (1, 1), (2, 2), ..., (99, 99), (0, 100), (1, 101), ..., (0, 1000)
--   Stored: 1000 rows, the same rows as ta
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb SELECT ca, cb FROM ta;

CREATE INDEX i_tc_ca ON tc (ca);
CREATE INDEX i_ta_ca ON ta (ca);
CREATE INDEX i_tb_ca ON tb (ca);
UPDATE STATISTICS ON tc, ta, tb WITH FULLSCAN;

-- hash join, result and plan
evaluate 'hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
  ANTI JOIN tb ON tb.ca = ta.ca AND ta.cb > 500;

-- cleanup
DROP TABLE IF EXISTS tb, ta, tc;

-- =====================================================================================================================
-- TC-3-05: composite PK-FK SEMI JOIN / ANTI JOIN (NOT NULL or nullable FK, with or without inner filter)
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-05-01: NOT NULL FK, FK table outer, EXISTS
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-05-01: NOT NULL FK, FK table outer, EXISTS';

DROP TABLE IF EXISTS tb, ta;

-- ta: 1000 rows of (n / 10, MOD (n, 10), n), n = 0 .. 999. The PK (a, b) covers a = 0 .. 99 and b = 0 .. 9
--   n 0    -> (0, 0, 0)
--   n 1    -> (0, 1, 1)
--   ...
--   n 10   -> (1, 0, 10)
--   ...
--   n 999  -> (99, 9, 999)
--   Stored: 1000 rows, a 0 .. 99 and b 0 .. 9, x = a * 10 + b
CREATE TABLE ta (a INT, b INT, x INT, PRIMARY KEY (a, b));
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 999
)
SELECT n / 10, MOD (n, 10), n
FROM cte;

-- tb: 10000 rows of (m, MOD (m, 1000) / 10, MOD (m, 10)), m = x.n * 100 + y.n = 0 .. 9999.
--     Each ta key (a, b) is referenced by 10 rows
--   m 0     -> (0, 0, 0)
--   m 1     -> (1, 0, 1)
--   ...
--   m 10    -> (10, 1, 0)
--   ...
--   m 999   -> (999, 99, 9)
--   m 1000  -> (1000, 0, 0)    the same keys repeat
--   ...
--   m 9999  -> (9999, 99, 9)
--   Stored: 10000 rows, id 0 .. 9999, 1000 keys (a, b) with 10 rows per key
CREATE TABLE tb (id INT, a INT NOT NULL, b INT NOT NULL, FOREIGN KEY (a, b) REFERENCES ta (a, b));
INSERT INTO tb
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n, MOD (x.n * 100 + y.n, 1000) / 10, MOD (x.n * 100 + y.n, 10)
FROM cte x, cte y;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- unnested, hash join, result and plan
evaluate 'unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM tb
WHERE EXISTS (SELECT 1 FROM ta WHERE ta.a = tb.a AND ta.b = tb.b AND ta.x < 100);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-05-02: NOT NULL FK, PK table outer, EXISTS
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-05-02: NOT NULL FK, PK table outer, EXISTS';

DROP TABLE IF EXISTS tb, ta;

-- ta: 1000 rows of (n / 10, MOD (n, 10), n), n = 0 .. 999. The PK (a, b) covers a = 0 .. 99 and b = 0 .. 9
--   n 0    -> (0, 0, 0)
--   n 1    -> (0, 1, 1)
--   ...
--   n 10   -> (1, 0, 10)
--   ...
--   n 999  -> (99, 9, 999)
--   Stored: 1000 rows, a 0 .. 99 and b 0 .. 9, x = a * 10 + b
CREATE TABLE ta (a INT, b INT, x INT, PRIMARY KEY (a, b));
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 999
)
SELECT n / 10, MOD (n, 10), n
FROM cte;

-- tb: 10000 rows of (m, MOD (m, 1000) / 10, MOD (m, 10)), m = x.n * 100 + y.n = 0 .. 9999.
--     Each ta key (a, b) is referenced by 10 rows
--   m 0     -> (0, 0, 0)
--   m 1     -> (1, 0, 1)
--   ...
--   m 10    -> (10, 1, 0)
--   ...
--   m 999   -> (999, 99, 9)
--   m 1000  -> (1000, 0, 0)    the same keys repeat
--   ...
--   m 9999  -> (9999, 99, 9)
--   Stored: 10000 rows, id 0 .. 9999, 1000 keys (a, b) with 10 rows per key
CREATE TABLE tb (id INT, a INT NOT NULL, b INT NOT NULL, FOREIGN KEY (a, b) REFERENCES ta (a, b));
INSERT INTO tb
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n, MOD (x.n * 100 + y.n, 1000) / 10, MOD (x.n * 100 + y.n, 10)
FROM cte x, cte y;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- unnested, hash join, result and plan
evaluate 'unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.a = ta.a AND tb.b = ta.b AND tb.id < 100);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-05-03: nullable FK, FK table outer, EXISTS
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-05-03: nullable FK, FK table outer, EXISTS';

DROP TABLE IF EXISTS tb, ta;

-- ta: 1000 rows of (n / 10, MOD (n, 10), n), n = 0 .. 999. The PK (a, b) covers a = 0 .. 99 and b = 0 .. 9
--   n 0    -> (0, 0, 0)
--   n 1    -> (0, 1, 1)
--   ...
--   n 10   -> (1, 0, 10)
--   ...
--   n 999  -> (99, 9, 999)
--   Stored: 1000 rows, a 0 .. 99 and b 0 .. 9, x = a * 10 + b
CREATE TABLE ta (a INT, b INT, x INT, PRIMARY KEY (a, b));
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 999
)
SELECT n / 10, MOD (n, 10), n
FROM cte;

-- tb: 10000 rows of (m, MOD (m, 1000) / 10, MOD (m, 10)), m = x.n * 100 + y.n = 0 .. 9999.
--     a is NULL where MOD (m, 4) = 0 (2500 rows)
--   m 0     -> (0, NULL, 0)
--   m 1     -> (1, 0, 1)
--   m 2     -> (2, 0, 2)
--   m 3     -> (3, 0, 3)
--   m 4     -> (4, NULL, 4)
--   ...
--   m 9999  -> (9999, 99, 9)
--   Stored: 10000 rows, a is NULL in the 2500 rows where MOD (id, 4) = 0
CREATE TABLE tb (id INT, a INT, b INT, FOREIGN KEY (a, b) REFERENCES ta (a, b));
INSERT INTO tb
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n,
       CASE WHEN MOD (x.n * 100 + y.n, 4) = 0 THEN NULL ELSE MOD (x.n * 100 + y.n, 1000) / 10 END,
       MOD (x.n * 100 + y.n, 10)
FROM cte x, cte y;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- unnested, hash join, result and plan
evaluate 'unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM tb
WHERE EXISTS (SELECT 1 FROM ta WHERE ta.a = tb.a AND ta.b = tb.b);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-05-04: nullable FK, PK table outer, EXISTS
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-05-04: nullable FK, PK table outer, EXISTS';

DROP TABLE IF EXISTS tb, ta;

-- ta: 1000 rows of (n / 10, MOD (n, 10), n), n = 0 .. 999. The PK (a, b) covers a = 0 .. 99 and b = 0 .. 9
--   n 0    -> (0, 0, 0)
--   n 1    -> (0, 1, 1)
--   ...
--   n 10   -> (1, 0, 10)
--   ...
--   n 999  -> (99, 9, 999)
--   Stored: 1000 rows, a 0 .. 99 and b 0 .. 9, x = a * 10 + b
CREATE TABLE ta (a INT, b INT, x INT, PRIMARY KEY (a, b));
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 999
)
SELECT n / 10, MOD (n, 10), n
FROM cte;

-- tb: 10000 rows of (m, MOD (m, 1000) / 10, MOD (m, 10)), m = x.n * 100 + y.n = 0 .. 9999.
--     a is NULL where MOD (m, 4) = 0 (2500 rows)
--   m 0     -> (0, NULL, 0)
--   m 1     -> (1, 0, 1)
--   m 2     -> (2, 0, 2)
--   m 3     -> (3, 0, 3)
--   m 4     -> (4, NULL, 4)
--   ...
--   m 9999  -> (9999, 99, 9)
--   Stored: 10000 rows, a is NULL in the 2500 rows where MOD (id, 4) = 0
CREATE TABLE tb (id INT, a INT, b INT, FOREIGN KEY (a, b) REFERENCES ta (a, b));
INSERT INTO tb
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n,
       CASE WHEN MOD (x.n * 100 + y.n, 4) = 0 THEN NULL ELSE MOD (x.n * 100 + y.n, 1000) / 10 END,
       MOD (x.n * 100 + y.n, 10)
FROM cte x, cte y;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- unnested, hash join, result and plan
evaluate 'unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.a = ta.a AND tb.b = ta.b AND tb.id < 1000);

-- cleanup
DROP TABLE IF EXISTS tb, ta;

-- =====================================================================================================================
-- TC-3-06: equi and non-equi terms together: only inner rows with the same key are candidates
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- TC-3-06-01: EXISTS
-- ---------------------------------------------------------------------------------------------------------------------
evaluate 'TC-3-06-01: EXISTS';

DROP TABLE IF EXISTS tb, ta;

-- ta: 10000 rows of (x.n * 100 + y.n + 1, x.n * 100 + y.n + 1), x.n and y.n = 0 .. 99
--   x.n 0,  y.n 0   -> (1, 1)
--   x.n 0,  y.n 1   -> (2, 2)
--   ...
--   x.n 99, y.n 99  -> (10000, 10000)
--   Stored: 10000 rows, ca = cb, keys 1 .. 10000 with 1 row per key
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta
WITH RECURSIVE cte (n) AS (
  SELECT 0
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 99
)
SELECT x.n * 100 + y.n + 1, x.n * 100 + y.n + 1
FROM cte x, cte y;

-- tb: 100 rows of ta where ca <= 100
--   (1, 1), (2, 2), ..., (100, 100)
--   Stored: 100 rows, ca = cb, keys 1 .. 100
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb SELECT ca, ca FROM ta WHERE ca <= 100;

CREATE INDEX i_ta_ca ON ta (ca);
CREATE INDEX i_tb_ca ON tb (ca);
UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

-- unnested, hash join, result and plan
evaluate 'unnested, hash join, result and plan';
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ COUNT (*)
FROM ta
WHERE EXISTS (SELECT 1 FROM tb WHERE tb.ca = ta.ca AND tb.cb > ta.cb);

-- cleanup
DROP TABLE IF EXISTS tb, ta;
