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

-- ===========================================================================
-- Section 3: Bucket assignment at the boundaries
-- ===========================================================================
evaluate '3. Bucket assignment at the boundaries';
SELECT WIDTH_BUCKET(40, 50, 80, 3);   -- 0 (below min)
SELECT WIDTH_BUCKET(50, 50, 80, 3);   -- 1 (min is inclusive)
SELECT WIDTH_BUCKET(65, 50, 80, 3);   -- 2
SELECT WIDTH_BUCKET(79, 50, 80, 3);   -- 3
SELECT WIDTH_BUCKET(80, 50, 80, 3);   -- 4 (max is exclusive, overflow bucket)
SELECT WIDTH_BUCKET(90, 50, 80, 3);   -- 4 (above max)

-- ===========================================================================
-- Section 4: Fractional and high-precision bounds
-- ===========================================================================
evaluate '4. Fractional and high-precision bounds';
SELECT WIDTH_BUCKET(0.5, 0, 1, 4);
SELECT WIDTH_BUCKET(0.123456789012345678901234567890, 0, 1, 10);