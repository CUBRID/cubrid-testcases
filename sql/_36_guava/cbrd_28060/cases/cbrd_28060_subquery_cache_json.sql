/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A correlated subquery keeps its results in the subquery cache, keyed by the values it reads from the outer row. A
 *  cached result keyed by a JSON value must not answer for another value that the comparison finds equal: 1 and 1.0,
 *  true and "true", 1 and "1" compare equal and hash alike, but JSON_TYPE tells them apart. The query is followed by
 *  the same values read without a subquery.
 *
 *  Coverage:
 *    Case 1:  JSON - a correlated subquery keyed by a JSON value returns the uncached results
 */

evaluate 'Case 1: JSON - a correlated subquery keyed by a JSON value returns the uncached results';
-- 1 and 1.0, true and "true", 1 and "1" compare equal and hash alike, but JSON_TYPE tells them apart
-- ca | cb
-- ---+-----------
--  1 | 1
--  2 | 1.0
--  3 | true
--  4 | "true"
--  5 | "1"
--  6 | {"a": 1}
--  7 | {"a":1.0}
--  8 | 1
--  9 | 1.0
DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, cb JSON);
INSERT INTO ta VALUES
  (1, '1'),
  (2, '1.0'),
  (3, 'true'),
  (4, '"true"'),
  (5, '"1"'),
  (6, '{"a": 1}'),
  (7, '{"a":1.0}'),
  (8, '1'),
  (9, '1.0');
SELECT ta.ca, (SELECT JSON_TYPE (ta.cb) FROM db_root) FROM ta ORDER BY 1;
SELECT ta.ca, JSON_TYPE (ta.cb) FROM ta ORDER BY 1;

-- cleanup

DROP TABLE IF EXISTS ta;
