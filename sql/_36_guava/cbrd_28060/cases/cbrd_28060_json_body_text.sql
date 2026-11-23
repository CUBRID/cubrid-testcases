/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A JSON object or array hashes as its body text, so keys of one body written with other spaces ({"a": 1} and {"a":1})
 *  get one hash, and a key of another body ({"a":1.0}) another. The hash join and the hash GROUP BY are followed by
 *  their nested loop join and sort GROUP BY twins, and the two results must match row by row.
 *
 *  Coverage:
 *    Case 1:  JSON - hash join returns the pairs of the nested loop join
 *    Case 2:  JSON - hash GROUP BY on ta returns the groups of the sort GROUP BY
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- JSON keys of one table: equal texts, {"a": 1} and {"a":1} of one body, {"a":1.0} of another
-- ca | cb
-- ---+-----------
--  1 | {"a":1}
--  2 | {"a":1}
--  3 | [1,2]
--  4 | "x"
--  5 | "x"
--  6 | true
--  7 | NULL
--  8 | {"a": 1}
--  9 | {"a":1.0}
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb JSON);
INSERT INTO ta VALUES
  (1, '{"a":1}'),
  (2, '{"a":1}'),
  (3, '[1,2]'),
  (4, '"x"'),
  (5, '"x"'),
  (6, 'true'),
  (7, NULL),
  (8, '{"a": 1}'),
  (9, '{"a":1.0}');
CREATE TABLE tb AS SELECT * FROM ta;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: JSON - hash join returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb AND ta.ca < tb.ca ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb AND ta.ca < tb.ca ORDER BY 1, 2;

evaluate 'Case 2: JSON - hash GROUP BY on ta returns the groups of the sort GROUP BY';
set trace on;
select min(ca), count(*) from ta group by cb order by 1, 2;
show trace;
set trace off;
select /*+ no_hash_aggregate */ min(ca), count(*) from ta group by cb order by 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb;
