/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A cached result of a correlated subquery keyed by a bit string must not answer for one of another bit length:
 *  B'1' and B'10' are one byte (X'8'), compare equal and hash alike, but BIT_LENGTH gives them apart. The query is
 *  followed by its NO_SUBQUERY_CACHE twin.
 *
 *  Coverage:
 *    Case 1:  BIT VARYING - a correlated subquery keyed by one byte of two bit lengths returns the uncached results
 */

-- ca | cb
-- ---+-------
--  1 | B'1'
--  2 | B'10'
--  3 | B'1'
--  4 | B'10'
DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, cb BIT VARYING (8));
INSERT INTO ta VALUES (1, B'1'), (2, B'10'), (3, B'1'), (4, B'10');

evaluate 'Case 1: BIT VARYING - a correlated subquery keyed by one byte of two bit lengths returns the uncached results';
SELECT ca, (SELECT BIT_LENGTH (ta.cb) || '' FROM db_root) FROM ta ORDER BY 1;
SELECT ca, (SELECT /*+ NO_SUBQUERY_CACHE */ BIT_LENGTH (ta.cb) || '' FROM db_root) FROM ta ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS ta;
