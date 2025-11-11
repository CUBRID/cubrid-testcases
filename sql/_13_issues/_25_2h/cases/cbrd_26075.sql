-- Verification for CBRD-26075
-- Issue: Problem with incorrect results being retrieved when comparing columns
--        in the main query within the HAVING clause.

DROP TABLE IF EXISTS tbl_a;
DROP TABLE IF EXISTS tbl_b;

CREATE TABLE tbl_a (id INT, col VARCHAR(10));
INSERT INTO tbl_a VALUES (1, '10'), (1, '20'), (1, '30'), (1, '15');

CREATE TABLE tbl_b (id INT, col VARCHAR(10));
INSERT INTO tbl_b VALUES (1, '20'), (1, '30'), (1, '15');

EVALUATE 'case 1. HAVING compares a.col';
SELECT a.col
FROM tbl_a a
WHERE EXISTS (
  SELECT 1
  FROM tbl_b b
  GROUP BY b.id
  HAVING MAX(b.col) = a.col
);

EVALUATE 'case 2. HAVING + UNION ALL comparing a.col';
SELECT /*+ recompile */ a.col
FROM tbl_a a
WHERE EXISTS (
  SELECT 1
  FROM tbl_b b
  WHERE id = 2
  UNION ALL
  SELECT 1
  FROM tbl_b b
  GROUP BY b.id
  HAVING MAX(b.col) = a.col
);

EVALUATE 'case 3. HAVING uses expression with outer column';
SELECT a.col
FROM tbl_a a
WHERE EXISTS (
  SELECT 1
  FROM tbl_b b
  GROUP BY b.id
  HAVING MAX(b.col) = SUBSTRING(a.col, 1, 2)
);

EVALUATE 'case 4. Nested subquery HAVING references outer column';
SELECT a.col
FROM tbl_a a
WHERE EXISTS (
  SELECT 1
  FROM (
    SELECT id, MAX(col) AS mcol
    FROM tbl_b
    GROUP BY id
    HAVING MAX(col) = a.col
  ) x
);

EVALUATE 'case 5. Inner subquery inside HAVING references outer column';
SELECT a.col
FROM tbl_a a
WHERE EXISTS (
  SELECT 1
  FROM tbl_b b
  GROUP BY b.id
  HAVING (SELECT MAX(col) FROM tbl_b WHERE id = b.id) = a.col
);

DROP TABLE IF EXISTS tbl_c;
DROP TABLE IF EXISTS tbl_d;

CREATE TABLE tbl_c (id INT, num INT);
INSERT INTO tbl_c VALUES (1, 11), (2, 11);

CREATE TABLE tbl_d (id INT, num INT);
INSERT INTO tbl_d VALUES (1, 1), (1, 10), (1, 5), (2, 1), (2, 100), (2, 5);

EVALUATE 'case 6. HAVING compares c.num';
SELECT /*+ recompile */ *
FROM tbl_c c
WHERE EXISTS (
  SELECT 1
  FROM tbl_d d
  WHERE d.id = c.id
  GROUP BY d.id
  HAVING MAX(d.num) < c.num
);

EVALUATE 'case 7. HAVING compares with numeric expression';
SELECT /*+ recompile */ *
FROM tbl_c c
WHERE EXISTS (
  SELECT 1
  FROM tbl_d d
  WHERE d.id = c.id
  GROUP BY d.id
  HAVING MAX(d.num) + 1 > c.num
);

EVALUATE 'case 8. Control query for validation (no main column in HAVING)';
SELECT (
  SELECT 1
  FROM tbl_d d
  WHERE d.id = c.id
  GROUP BY d.id
  HAVING MAX(d.num) < c.num
)
FROM tbl_c c;

DROP TABLE IF EXISTS tbl_a;
DROP TABLE IF EXISTS tbl_b;
DROP TABLE IF EXISTS tbl_c;
DROP TABLE IF EXISTS tbl_d;

