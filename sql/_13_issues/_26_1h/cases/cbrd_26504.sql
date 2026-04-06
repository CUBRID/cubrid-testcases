/**
 * This test case verifies CBRD-26504: Verify START WITH conditions are NOT propagated like WHERE conditions
 * during reduce_equality_terms optimization.
 */

-- SETUP: Create Test Table
DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (
    c1 VARCHAR(10) PRIMARY KEY,
    c2 VARCHAR(10)
);
 
-- Tree structure:
--   A (root)
--   ├── B
--   │   └── D
--   └── C
INSERT INTO tbl VALUES ('A', NULL);
INSERT INTO tbl VALUES ('B', 'A');
INSERT INTO tbl VALUES ('C', 'A');
INSERT INTO tbl VALUES ('D', 'B');

evaluate 'Case 1. Full hierarchy traversal from root';
SELECT c1 FROM tbl
START WITH c1 = 'A'
CONNECT BY PRIOR c1 = c2
ORDER BY c1;
-- Expected: A, B, C, D (4 rows)

evaluate 'Case 2. Subtree traversal';
SELECT c1 FROM tbl
START WITH c1 = 'B'
CONNECT BY PRIOR c1 = c2
ORDER BY c1;
-- Expected: B, D

evaluate 'Case 3. Multiple Roots in START WITH';
SELECT c1 FROM tbl
START WITH c1 IN ('B', 'C')
CONNECT BY PRIOR c1 = c2
ORDER BY c1;
-- Expected: B, C, D (3 rows)

evaluate 'Case 4. START WITH using root detection (IS NULL)';
SELECT c1 FROM tbl
START WITH c2 IS NULL
CONNECT BY PRIOR c1 = c2
ORDER BY c1;
-- Expected: A, B, C, D

evaluate 'Case 5. START WITH matches No Rows';
SELECT c1 FROM tbl
START WITH c1 = 'Z'
CONNECT BY PRIOR c1 = c2
ORDER BY c1;
-- Expected: (empty — 0 rows)

evaluate 'Case 6. CONNECT BY with WHERE Clause — WHERE Must Not Affect START WITH';
SELECT c1 FROM tbl
WHERE c1 <> 'C'
START WITH c1 = 'A'
CONNECT BY PRIOR c1 = c2
ORDER BY c1;
-- Expected: A, B, D  (C excluded by WHERE)

evaluate 'Case 7. START WITH and WHERE equality terms on same query';
SELECT c1 FROM tbl
WHERE c1 = c1
START WITH c1 = 'A'
CONNECT BY PRIOR c1 = c2
ORDER BY c1;
-- Expected: A, B, C, D

evaluate 'Case 8. START WITH on parent column';
SELECT c1 FROM tbl
START WITH c2 = 'A'
CONNECT BY PRIOR c1 = c2
ORDER BY c1;
-- Expected: B, C, D
-- START WITH on c2 must not be treated or propagated like a WHERE conditions.

evaluate 'Case 9. START WITH Using a Subquery';
SELECT c1 FROM tbl
START WITH c1 = (
    SELECT MIN(c1) FROM tbl
    WHERE c2 IS NULL
)
CONNECT BY PRIOR c1=c2
ORDER BY c1;
-- Expected: A, B, C, D

evaluate 'Case 10. CONNECT BY with JOIN (single_table_opt disabled)';
DROP TABLE IF EXISTS tbl2;
CREATE TABLE tbl2 (c1 VARCHAR(10) PRIMARY KEY);
INSERT INTO tbl2 VALUES ('A'), ('B'), ('C'), ('D');

SELECT tbl.c1 FROM tbl
JOIN tbl2 ON tbl.c1 = tbl2.c1
START WITH tbl.c1 = 'A'
CONNECT BY PRIOR tbl.c1 = tbl.c2
ORDER BY tbl.c1;
-- Expected: A, B, C, D 

evaluate 'Case 11. DELETE Full Tree from Root';
DELETE FROM tbl WHERE c1 IN (
    SELECT c1 FROM tbl
    START WITH c1 = 'A'
    CONNECT BY PRIOR c1 = c2
);

SELECT COUNT(*) FROM tbl;
-- Expected: 0  (all 4 rows deleted)

evaluate 'Case 12. DELETE Subtree Only (Non-Root Start)';
TRUNCATE tbl;
INSERT INTO tbl VALUES ('A', NULL), ('B', 'A'), ('C', 'A'), ('D', 'B');

DELETE FROM tbl WHERE c1 IN (
    SELECT c1 FROM tbl
    START WITH c1 = 'B'
    CONNECT BY PRIOR c1 = c2
);

SELECT c1 FROM tbl ORDER BY c1;
-- Expected: A, C (B and D deleted, A and C untouched)

DROP TABLE tbl;
DROP TABLE tbl2;