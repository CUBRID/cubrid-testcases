/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A join key that holds an expression of a host variable (cb - a bound collection) is typed only when the XASL is
 *  made, which fixes a scalar type but not the element domain of a collection. The planner leaves the join of such a
 *  key to the nested loop for every bound value, and the join returns the pairs of its nested loop join twin. Before
 *  the change, the hash join of ta.cb - {x} missed those pairs. A key of a scalar expression of a host variable (ca + a
 *  bound integer) still joins by hash. SHOW TRACE shows which join runs.
 *
 *  Coverage:
 *    Case 1:  MULTISET - a key of a host variable expression joins by nested loop under a hash join hint, for each of
 *             two bound values
 *    Case 2:  MULTISET - a key of a host variable expression beside a scalar key joins by nested loop, with the pairs
 *             of the nested loop join
 *    Case 3:  a key of a scalar host variable expression still joins by hash, with the pairs of the nested loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- {'1'} = {1}: the comparison coerces the elements, the element hash tells them apart.
DROP TABLE IF EXISTS ta, tb;

-- ta: VARCHAR elements
-- ca | cb
-- ---+-----------
-- 61 | {'1'}
-- 62 | {'2'}
-- 63 | {'1', '2'}
CREATE TABLE ta (ca INT, cb MULTISET (VARCHAR (10)));
INSERT INTO ta VALUES (61, {'1'}), (62, {'2'}), (63, {'1', '2'});

-- tb: INT elements
-- ca | cb
-- ---+-------
-- 71 | {1}
-- 72 | {3}
-- 73 | {2, 1}
CREATE TABLE tb (ca INT, cb MULTISET (INT));
INSERT INTO tb VALUES (71, {1}), (72, {3}), (73, {2, 1});

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: MULTISET - a key of a host variable expression joins by nested loop under a hash join hint, for each of two bound values';
-- One prepared statement runs with two bound multisets: ta.cb - {x} keeps each ta.cb,
-- and ta.cb - {2} takes the element 2 out of each. Before the change, the hash join of ta.cb - {x} missed the pairs
-- of its nested loop join twin
set trace on;
prepare st_hash from 'SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb - ? = tb.cb ORDER BY 1, 2';
execute st_hash using {'x'};
show trace;
execute st_hash using {'2'};
show trace;
set trace off;
prepare st_nl from 'SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb - ? = tb.cb ORDER BY 1, 2';
execute st_nl using {'x'};
execute st_nl using {'2'};
deallocate prepare st_hash;
deallocate prepare st_nl;

evaluate 'Case 2: MULTISET - a key of a host variable expression beside a scalar key joins by nested loop, with the pairs of the nested loop join';
set trace on;
prepare st_hash from 'SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb - ? = tb.cb AND ta.ca + 10 = tb.ca ORDER BY 1, 2';
execute st_hash using {'x'};
show trace;
set trace off;
prepare st_nl from 'SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb - ? = tb.cb AND ta.ca + 10 = tb.ca ORDER BY 1, 2';
execute st_nl using {'x'};
deallocate prepare st_hash;
deallocate prepare st_nl;

evaluate 'Case 3: a key of a scalar host variable expression still joins by hash, with the pairs of the nested loop join';
set trace on;
prepare st_hash from 'SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.ca + ? = tb.ca ORDER BY 1, 2';
execute st_hash using 10;
show trace;
set trace off;
prepare st_nl from 'SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.ca + ? = tb.ca ORDER BY 1, 2';
execute st_nl using 10;
deallocate prepare st_hash;
deallocate prepare st_nl;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb;
