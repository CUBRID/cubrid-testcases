/* 8. INSERT-SELECT Float↔Fixed */

-- ===========================================================================
-- Section 1: INSERT-SELECT Float to Fixed and back
-- ===========================================================================
evaluate '1. INSERT-SELECT from Float to Fixed and back: overflow check';
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE TABLE t1 (col1 NUMERIC(38));
SHOW CREATE TABLE t1;

-- (38)
INSERT INTO t1 VALUES (12345678901234567890123456789012345678);
SELECT * FROM t1;

CREATE TABLE t2 (col2 NUMERIC);
INSERT INTO t2 SELECT * FROM t1;
SELECT * FROM t2;

-- (76,38)
INSERT INTO t2 VALUES (12345678901234567890123456789012345678.12345678901234567890123456789012345678);
SELECT * FROM t2 ORDER BY 1;

evaluate '1-1. INSERT INTO t1 FROM t2';
INSERT INTO t1 SELECT * FROM t2;
SELECT * FROM t1 ORDER BY 1;

-- (76)
INSERT INTO t2 VALUES (1234567890123456789012345678901234567812345678901234567890123456789012345678);
SELECT * FROM t2 ORDER BY 1;

evaluate '1-2. INSERT INTO t1 FROM t2 overflow (error)';
INSERT INTO t1 SELECT * FROM t2;

DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;


-- ===========================================================================
-- Section 2: INSERT-SELECT with an arithmetic expression coerced into Fixed
-- ===========================================================================
evaluate '2. INSERT-SELECT with an arithmetic expression coerced into Fixed';
DROP TABLE IF EXISTS tf;
DROP TABLE IF EXISTS tx;
CREATE TABLE tf (col1 NUMERIC);
INSERT INTO tf VALUES (100);
CREATE TABLE tx (col1 NUMERIC(10,4));
INSERT INTO tx SELECT col1 / 3 FROM tf;
SELECT * FROM tx;
DROP TABLE IF EXISTS tf;
DROP TABLE IF EXISTS tx;


-- ===========================================================================
-- Section 3: INSERT-SELECT Float to Fixed overflow by rounding carry
-- ===========================================================================
evaluate '3. INSERT-SELECT Float to Fixed overflow by rounding carry (error)';
DROP TABLE IF EXISTS tf;
DROP TABLE IF EXISTS tx;
CREATE TABLE tf (col1 NUMERIC);
INSERT INTO tf VALUES (99999999999999999999999999999999999999.7);
CREATE TABLE tx (col1 NUMERIC(38,0));
-- fractional part rounds up and carries to 10^38 which exceeds precision 38 (error)
INSERT INTO tx SELECT * FROM tf;
SELECT * FROM tx;
DROP TABLE IF EXISTS tf;
DROP TABLE IF EXISTS tx;