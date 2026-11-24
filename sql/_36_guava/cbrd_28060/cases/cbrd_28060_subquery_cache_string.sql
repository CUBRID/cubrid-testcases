/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A cached result of a correlated subquery keyed by a string must not answer for another string that its collation
 *  finds equal: a and A compare equal in utf8_en_ci and hash alike, but HEX tells them apart. The subquery returns HEX
 *  of its key, since a comparison of the two strings under utf8_en_ci would find them equal. The verification block
 *  after the query prints PASS when the query and its NO_SUBQUERY_CACHE twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  VARCHAR utf8_en_ci - a correlated subquery keyed by a and A returns the uncached results
 */

DROP TABLE IF EXISTS t_varchar;
CREATE TABLE t_varchar (ca INT, cb VARCHAR (10) COLLATE utf8_en_ci);

-- ca | cb
-- ---+-----
--  1 | 'a'
--  2 | 'A'
--  3 | 'a'
--  4 | 'A'
INSERT INTO t_varchar VALUES (1, 'a'), (2, 'A'), (3, 'a'), (4, 'A');

evaluate 'Case 1: VARCHAR utf8_en_ci - a correlated subquery keyed by a and A returns the uncached results';
SELECT ca, (SELECT HEX (t_varchar.cb) FROM db_root)
FROM t_varchar ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT ca, (SELECT HEX (t_varchar.cb) FROM db_root) AS cb_hex FROM t_varchar),
  nocache_rows as (SELECT ca, (SELECT /*+ NO_SUBQUERY_CACHE */ HEX (t_varchar.cb) FROM db_root) AS cb_hex FROM t_varchar)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_varchar;
