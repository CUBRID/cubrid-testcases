/**
 *  This test case verifies CBRD-25708 : Enable partition pruning when the partition key is a function expression and the WHERE clause uses the original column
 *  This test includes additional scenarios not covered in basic comparison cases.
 */

DROP TABLE IF EXISTS year_tbl;
DROP TABLE IF EXISTS chain_tbl;

set trace on;

CREATE TABLE year_tbl(col DATETIME)
  PARTITION BY RANGE (YEAR(col)) (
    PARTITION pa   VALUES LESS THAN (2022),
    PARTITION pb   VALUES LESS THAN (2023),
    PARTITION pc   VALUES LESS THAN (2024),
    PARTITION p_max VALUES LESS THAN MAXVALUE
  );

INSERT INTO year_tbl VALUES
  ('2021-05-01 10:00:00'),
  ('2022-07-15 12:00:00'), 
  ('2023-11-30 23:59:59'),
  ('2024-01-01 00:00:00'),
  (NULL);

EVALUATE '1. NULL compare col IS NULL (only the first partition is pruned)';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE col IS NULL;
show trace;

EVALUATE '2. NULL compare YEAR(col) IS NULL (only the first partition is pruned)';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE YEAR(col) IS NULL;
show trace;

EVALUATE '3. Mixed AND A: col = 2023-11-30 AND YEAR(col) > 2022';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE col = '2023-11-30 23:59:59' AND YEAR(col) > 2022;
show trace;

EVALUATE '4. Mixed AND B: YEAR(col) > 2022 AND col = 2023-11-30';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE YEAR(col) > 2022 AND col = '2023-11-30 23:59:59';
show trace;

EVALUATE '5. IN list multiple col IN (...)';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl
 WHERE col IN (
   '2021-05-01 10:00:00',
   '2024-01-01 00:00:00'
 );
show trace;

EVALUATE '6. NOT IN: col NOT IN (2023,2024 dates) (no pruning)';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl
 WHERE col NOT IN (
   '2023-11-30 23:59:59',
   '2024-01-01 00:00:00'
 );
show trace;

EVALUATE '7. <> and NOT YEAR(col)=2022 (no pruning)';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE col <> '2022-07-15 12:00:00' AND NOT YEAR(col) = 2022;
show trace;

EVALUATE '8. MAXVALUE only col >= 2024-...';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE col >= '2024-01-01';
show trace;

EVALUATE '9. ALL quantifier YEAR(col) >= ALL{2022,2023}';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE YEAR(col) >= ALL{2022,2023};
show trace;

EVALUATE '10. Using nested function as partition key (expected error)';
CREATE TABLE chain_tbl(col1 INT)
  PARTITION BY RANGE (ABS(FLOOR(col / 2))) (
    PARTITION pa VALUES LESS THAN (1),
    PARTITION p_max VALUES LESS THAN MAXVALUE
  );

EVALUATE '11. OR A: col = 2021-05-01 OR col = 2023-11-30 ';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl
WHERE col = '2021-05-01 10:00:00' OR col = '2023-11-30 23:59:59';
show trace;

EVALUATE '12. OR B: col < 2022-01-01 OR YEAR(col) > 2023 ';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl
WHERE col < '2022-01-01 00:00:00' OR YEAR(col) > 2023;
show trace;

EVALUATE '13. NULL compare with = : col = NULL (no pruning)';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE col = NULL;
show trace;

EVALUATE '14. Pruning to MAXVALUE partition only: col > 2025-01-01 ';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE col > '2025-01-01 00:00:00';
show trace;

EVALUATE '15. IS NOT NULL: col IS NOT NULL (no pruning)';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE col IS NOT NULL;
show trace;

EVALUATE '16. IS NOT NULL on function: YEAR(col) IS NOT NULL (no pruning)';
SELECT /*+ recompile */ COUNT(*) FROM year_tbl WHERE YEAR(col) IS NOT NULL;
show trace;

set trace off;

DROP TABLE IF EXISTS year_tbl;
DROP TABLE IF EXISTS chain_tbl;
