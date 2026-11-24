/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A JSON key of CONNECT BY takes the hash list scan, which hashes the key as it compares, so it must find the children
 *  that the comparison finds: the pid values 1.0, "1" and 1 equal the id 1. The CONNECT BY with NO_HASH_LIST_SCAN is
 *  its twin. The verification block prints PASS when the two queries return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  JSON - CONNECT BY by a hash list scan returns the rows of the CONNECT BY without the hash list scan
 */

set trace on;

DROP TABLE IF EXISTS t_json_tree;
CREATE TABLE t_json_tree (ca INT, id JSON, pid JSON);

-- the pid values that compare equal to the id 1 are 1.0, "1" and 1, and to the id 2 are 2 and "2.0"
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
INSERT INTO t_json_tree VALUES
  (1, '1', NULL),
  (2, '2', '1.0'),
  (3, '3', '"1"'),
  (4, '4', '1'),
  (5, '5', '2'),
  (6, '6', '"2.0"'),
  (7, '7', '[1]'),
  (8, '[1]', '1'),
  (9, '9', '[1]');

evaluate 'Case 1: JSON - CONNECT BY by a hash list scan returns the rows of the CONNECT BY without the hash list scan';

SELECT ca, LEVEL
FROM t_json_tree START WITH ca = 1 CONNECT BY PRIOR id = pid ORDER BY 1, 2;
show trace;

-- compare with the CONNECT BY without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (SELECT ca, LEVEL as lvl FROM t_json_tree START WITH ca = 1 CONNECT BY PRIOR id = pid),
  listscan_rows as (SELECT /*+ NO_HASH_LIST_SCAN */ ca, LEVEL as lvl FROM t_json_tree START WITH ca = 1 CONNECT BY PRIOR id = pid)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_json_tree;

set trace off;
