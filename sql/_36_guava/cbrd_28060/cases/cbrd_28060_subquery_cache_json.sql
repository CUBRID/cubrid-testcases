/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A correlated subquery keeps its results in the subquery cache, keyed by the values it reads from the outer row. A
 *  cached result keyed by a JSON value must not answer for another value that the comparison finds equal: 1 and 1.0,
 *  true and "true", 1 and "1" compare equal and hash alike, but JSON_TYPE tells them apart. The verification block
 *  after the query prints PASS when the query and the same values read without a subquery return the same rows as a
 *  multiset.
 *
 *  Coverage:
 *    Case 1:  JSON - a correlated subquery keyed by a JSON value returns the uncached results
 */

DROP TABLE IF EXISTS t_json;
CREATE TABLE t_json (id INT, body JSON);

-- 1 and 1.0, true and "true", 1 and "1" compare equal and hash alike, but JSON_TYPE tells them apart
-- id | body
-- ---+----------
-- 1  | 1
-- 2  | 1.0
-- 3  | true
-- 4  | "true"
-- 5  | "1"
-- 6  | {"a": 1}
-- 7  | {"a":1.0}
-- 8  | 1
-- 9  | 1.0
INSERT INTO t_json VALUES
  (1, '1'),
  (2, '1.0'),
  (3, 'true'),
  (4, '"true"'),
  (5, '"1"'),
  (6, '{"a": 1}'),
  (7, '{"a":1.0}'),
  (8, '1'),
  (9, '1.0');

evaluate 'Case 1: JSON - a correlated subquery keyed by a JSON value returns the uncached results';
SELECT t_json.id, (SELECT JSON_TYPE (t_json.body) FROM db_root)
FROM t_json ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT t_json.id AS t_json_id, (SELECT JSON_TYPE (t_json.body) FROM db_root) AS jtype FROM t_json),
  nocache_rows as (SELECT t_json.id AS t_json_id, JSON_TYPE (t_json.body) AS jtype FROM t_json)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_json;
