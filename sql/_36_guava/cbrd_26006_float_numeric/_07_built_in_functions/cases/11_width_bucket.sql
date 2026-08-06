/* 11. Verify WIDTH_BUCKET behavior */

-- ===========================================================================
-- Section 1: Fixed NUMERIC (NUMERIC(38))
-- ===========================================================================
evaluate '1. Fixed NUMERIC (NUMERIC(38))';
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (col1 VARCHAR(10), col2 NUMERIC(38));

INSERT INTO t1 VALUES
  ('Amie', 60),
  ('Jane', 80),
  ('Lora', 60),
  ('James', 75),
  ('Peter', 70),
  ('Tom', 50),
  ('Ralph', 99),
  ('David', 55);

-- Lower bound > upper bound path
SELECT col1, col2, WIDTH_BUCKET(col2, 80, 50, 3) AS grade
FROM t1
ORDER BY grade ASC, col2 DESC;

-- Normal path
SELECT col1, col2, WIDTH_BUCKET(col2, 50, 80, 3) AS grade
FROM t1
ORDER BY grade ASC, col2 DESC;

DROP TABLE IF EXISTS t1;

-- ===========================================================================
-- Section 2: Float NUMERIC (NUMERIC)
-- ===========================================================================
evaluate '2. Float NUMERIC (NUMERIC)';
CREATE TABLE t1 (col1 VARCHAR(10), col2 NUMERIC);

INSERT INTO t1 VALUES
  ('Amie', 60),
  ('Jane', 80),
  ('Lora', 60),
  ('James', 75),
  ('Peter', 70),
  ('Tom', 50),
  ('Ralph', 99),
  ('David', 55);

SELECT col1, col2, WIDTH_BUCKET(col2, 80, 50, 3.01) AS grade
FROM t1
ORDER BY grade ASC, col2 DESC;

-- Normal path
SELECT col1, col2, WIDTH_BUCKET(col2, 50, 80, 3.01) AS grade
FROM t1
ORDER BY grade ASC, col2 DESC;

DROP TABLE IF EXISTS t1;
