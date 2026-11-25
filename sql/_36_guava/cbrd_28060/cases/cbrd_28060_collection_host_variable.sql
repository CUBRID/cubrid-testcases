/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A join key that holds an expression of a host variable (cb - a bound collection) is typed only when the XASL is
 *  made, which fixes a scalar type but not the element domain of a collection. The planner leaves the join of such a
 *  key to the nested loop for every bound value, and the join returns the pairs of its nested loop join twin. Before
 *  the change, the hash join of t_multiset_varchar.cb - {x} missed those pairs. A key of a scalar expression of a host
 *  variable (ca + a bound integer) still joins by hash. SHOW TRACE shows which join runs. The verification statement
 *  after each join prints PASS when the join and its twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  INT - hash join of a key of a scalar host variable expression returns the pairs of the nested loop join
 *    Case 2:  MULTISET - a key of a host variable expression joins by nested loop under a hash join hint, with the
 *             pairs of the nested loop join, for each of two bound values
 *    Case 3:  MULTISET - a key of a host variable expression beside a scalar key joins by nested loop under a hash join
 *             hint, with the pairs of the nested loop join
 *    Case 4:  MULTISET - a join on a derived table by a host variable expression bound to NULL returns no row
 *    Case 5:  MULTISET - CONNECT BY a host variable expression bound to NULL returns the START WITH row only
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- {'1'} = {1}: the comparison coerces the elements, the element hash tells them apart
DROP TABLE IF EXISTS t_multiset_varchar, t_multiset_int;

CREATE TABLE t_multiset_varchar (ca INT, cb MULTISET (VARCHAR (10)));

-- ca | cb
-- ---+-----------
-- 61 | {'1'}
-- 62 | {'2'}
-- 63 | {'1', '2'}
INSERT INTO t_multiset_varchar VALUES (61, {'1'}), (62, {'2'}), (63, {'1', '2'});

CREATE TABLE t_multiset_int (ca INT, cb MULTISET (INT));

-- ca | cb
-- ---+-------
-- 71 | {1}
-- 72 | {3}
-- 73 | {2, 1}
INSERT INTO t_multiset_int VALUES (71, {1}), (72, {3}), (73, {2, 1});

UPDATE STATISTICS ON t_multiset_varchar, t_multiset_int WITH FULLSCAN;

evaluate 'Case 1: INT - hash join of a key of a scalar host variable expression returns the pairs of the nested loop join';
prepare st_hash from 'SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_varchar.ca, t_multiset_int.ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.ca + ? = t_multiset_int.ca ORDER BY 1, 2';
execute st_hash using 10;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
prepare st_cmp from 'with hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_varchar.ca as t_multiset_varchar_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.ca + ? = t_multiset_int.ca), nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_multiset_varchar.ca as t_multiset_varchar_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.ca + ? = t_multiset_int.ca) select (case when count (*) = 0 then ''PASS'' else ''FAIL'' end) as result from ((select * from hj_rows difference all select * from nl_rows) union all (select * from nl_rows difference all select * from hj_rows)) diff_result';
execute st_cmp using 10, 10;
deallocate prepare st_hash;
deallocate prepare st_cmp;

evaluate 'Case 2: MULTISET - a key of a host variable expression joins by nested loop under a hash join hint, with the pairs of the nested loop join, for each of two bound values';
-- One prepared statement runs with two bound multisets: t_multiset_varchar.cb - {x} keeps each t_multiset_varchar.cb,
-- and t_multiset_varchar.cb - {2} takes the element 2 out of each
prepare st_hash from 'SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_varchar.ca, t_multiset_int.ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb - ? = t_multiset_int.cb ORDER BY 1, 2';
execute st_hash using {'x'};
show trace;
execute st_hash using {'2'};
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
prepare st_cmp from 'with hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_varchar.ca as t_multiset_varchar_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb - ? = t_multiset_int.cb), nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_multiset_varchar.ca as t_multiset_varchar_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb - ? = t_multiset_int.cb) select (case when count (*) = 0 then ''PASS'' else ''FAIL'' end) as result from ((select * from hj_rows difference all select * from nl_rows) union all (select * from nl_rows difference all select * from hj_rows)) diff_result';
execute st_cmp using {'x'}, {'x'};
execute st_cmp using {'2'}, {'2'};
deallocate prepare st_hash;
deallocate prepare st_cmp;

evaluate 'Case 3: MULTISET - a key of a host variable expression beside a scalar key joins by nested loop under a hash join hint, with the pairs of the nested loop join';
prepare st_hash from 'SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_varchar.ca, t_multiset_int.ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb - ? = t_multiset_int.cb AND t_multiset_varchar.ca + 10 = t_multiset_int.ca ORDER BY 1, 2';
execute st_hash using {'x'};
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
prepare st_cmp from 'with hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_varchar.ca as t_multiset_varchar_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb - ? = t_multiset_int.cb AND t_multiset_varchar.ca + 10 = t_multiset_int.ca), nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_multiset_varchar.ca as t_multiset_varchar_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb - ? = t_multiset_int.cb AND t_multiset_varchar.ca + 10 = t_multiset_int.ca) select (case when count (*) = 0 then ''PASS'' else ''FAIL'' end) as result from ((select * from hj_rows difference all select * from nl_rows) union all (select * from nl_rows difference all select * from hj_rows)) diff_result';
execute st_cmp using {'x'}, {'x'};
deallocate prepare st_hash;
deallocate prepare st_cmp;

evaluate 'Case 4: MULTISET - a join on a derived table by a host variable expression bound to NULL returns no row';
-- t_multiset_int.cb against the NULL of cb - ?: the planner checks whether the two can be hashed alike
prepare st_nl from 'SELECT /*+ ORDERED USE_NL NO_PARALLEL_SUBQUERY */ a.ca FROM t_multiset_int a JOIN (SELECT cb FROM t_multiset_int LIMIT 3) b ON a.cb = b.cb - ? ORDER BY 1';
execute st_nl using NULL;
deallocate prepare st_nl;

evaluate 'Case 5: MULTISET - CONNECT BY a host variable expression bound to NULL returns the START WITH row only';
prepare st_connect_by from 'SELECT ca FROM t_multiset_int START WITH ca = 71 CONNECT BY PRIOR cb = cb + ? ORDER BY 1';
execute st_connect_by using NULL;
deallocate prepare st_connect_by;

-- cleanup
DROP TABLE IF EXISTS t_multiset_varchar, t_multiset_int;

set trace off;
