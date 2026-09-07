
DROP TABLE IF EXISTS t27215_r;
CREATE TABLE t27215_r (k INT PRIMARY KEY, s VARCHAR(20000));
INSERT INTO t27215_r VALUES (1, 'a'), (2, REPEAT('x', 17000)), (3, 'c'), (4, REPEAT('y', 17000)), (5, 'e');

-- 1. SET column: every row leaves the descriptor path with RETRY_SET_TYPE (query_executor.c:1201 -> :1285)
SELECT k * 2 + 1 AS a, {k, k + 1} AS st FROM t27215_r ORDER BY k;

-- 2. oversized rows 2 and 4 take RETRY_BIG_REC through the sorted GROUP BY output list
--    (qexec_gby_finalize_group, query_executor.c:20300 -> :20333) while rows 1, 3, 5 stay on the descriptor path
SELECT a, len FROM (SELECT k * 2 + 1 AS a, LENGTH(s) AS len, s FROM t27215_r GROUP BY k, s) v ORDER BY a;

-- 3. CONNECT BY interleaves a direct copy of xasl->outptr_list (query_executor.c:19748) with the
--    descriptor+copy pair (:19769 -> qexec_insert_tuple_into_list) on the same list, row after row
SELECT k * 2 + 1 AS a, {k, LEVEL} AS st FROM t27215_r START WITH k = 1 CONNECT BY PRIOR k + 1 = k ORDER BY k;

-- 4. the same statement twice: the mark must not survive into a later execution of the cached clone
SELECT k * 2 + 1 AS a, {k, k + 1} AS st FROM t27215_r WHERE k >= 4 ORDER BY k;
SELECT k * 2 + 1 AS a, {k, k + 1} AS st FROM t27215_r WHERE k >= 4 ORDER BY k;

DROP TABLE t27215_r;
