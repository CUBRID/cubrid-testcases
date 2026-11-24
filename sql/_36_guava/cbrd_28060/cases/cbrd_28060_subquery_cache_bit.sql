/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A cached result of a correlated subquery keyed by a bit string must not answer for one of another bit length: B'1'
 *  and B'10' are one byte (X'8'), compare equal and hash alike, but BIT_LENGTH gives them apart. The verification block
 *  after the query prints PASS when the query and its NO_SUBQUERY_CACHE twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  BIT VARYING - a correlated subquery keyed by one byte of two bit lengths returns the uncached results
 */

DROP TABLE IF EXISTS t_bit_varying;
CREATE TABLE t_bit_varying (ca INT, cb BIT VARYING (8));

-- ca | cb
-- ---+-------
--  1 | B'1'
--  2 | B'10'
--  3 | B'1'
--  4 | B'10'
INSERT INTO t_bit_varying VALUES (1, B'1'), (2, B'10'), (3, B'1'), (4, B'10');

evaluate 'Case 1: BIT VARYING - a correlated subquery keyed by one byte of two bit lengths returns the uncached results';

SELECT ca, (SELECT BIT_LENGTH (t_bit_varying.cb) || '' FROM db_root)
FROM t_bit_varying ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT ca, (SELECT BIT_LENGTH (t_bit_varying.cb) || '' FROM db_root) AS bit_len FROM t_bit_varying),
  nocache_rows as (SELECT ca, (SELECT /*+ NO_SUBQUERY_CACHE */ BIT_LENGTH (t_bit_varying.cb) || '' FROM db_root) AS bit_len FROM t_bit_varying)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_bit_varying;
