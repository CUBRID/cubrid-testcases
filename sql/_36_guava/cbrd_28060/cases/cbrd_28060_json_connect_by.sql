/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A JSON key of CONNECT BY takes the hash list scan, which hashes the key as it compares, so it must find the children
 *  that the comparison finds: the pid values 1.0, "1" and 1 equal the id 1. The CONNECT BY with NO_HASH_LIST_SCAN is
 *  its twin.
 *
 *  Coverage:
 *    Case 1:  JSON - CONNECT BY by a hash list scan returns the rows of the single-table plan
 */

-- a JSON key of CONNECT BY takes the hash list scan; the pid values that compare equal to the id 1 are 1.0, "1"
-- and 1, and to the id 2 are 2 and "2.0"
-- ca | id  | pid
-- ---+-----+-------
--  1 | 1   | NULL
--  2 | 2   | 1.0
--  3 | 3   | "1"
--  4 | 4   | 1
--  5 | 5   | 2
--  6 | 6   | "2.0"
--  7 | 7   | [1]
--  8 | [1] | 1
--  9 | 9   | [1]
DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, id JSON, pid JSON);
INSERT INTO ta VALUES
  (1, '1', NULL),
  (2, '2', '1.0'),
  (3, '3', '"1"'),
  (4, '4', '1'),
  (5, '5', '2'),
  (6, '6', '"2.0"'),
  (7, '7', '[1]'),
  (8, '[1]', '1'),
  (9, '9', '[1]');

evaluate 'Case 1: JSON - CONNECT BY by a hash list scan returns the rows of the single-table plan';
set trace on;
SELECT ca, LEVEL FROM ta START WITH ca = 1 CONNECT BY PRIOR id = pid ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_HASH_LIST_SCAN */ ca, LEVEL FROM ta START WITH ca = 1 CONNECT BY PRIOR id = pid ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta;
