-- This test case verifies CBRD-25179 issue.
-- If the CTE query is a false query (null query), check whether a core dump occurs.

drop table if exists tbl_a, tbl_b;

create table tbl_a(col_a int, col_b varchar(10));
create table tbl_b(col_a int, col_b varchar(10));

--@queryplan
SELECT /*+ recompile */ 1 a, T.* FROM   ( WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT tbl_a.* FROM  tbl_a INNER JOIN cte ON tbl_a.col_a = cte.col_a LEFT JOIN tbl_b ON tbl_a.col_b = tbl_b.col_b ) t;

-- Query plan not created.
--@queryplan
SELECT /*+ recompile */ 1 b, T.* FROM   ( WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT tbl_a.* FROM  tbl_a, cte, tbl_b WHERE tbl_a.col_a = cte.col_a AND tbl_a.col_b = tbl_b.col_b(+) ) t;

--@queryplan
prepare q from '
SELECT /*+ recompile */ 1 c, T.* FROM   ( WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat (?,NULL,?))
SELECT tbl_a.* FROM  tbl_a INNER JOIN cte ON tbl_a.col_a = cte.col_a LEFT JOIN tbl_b ON tbl_a.col_b = tbl_b.col_b ) t
';
execute q using 'KOR-','%';
deallocate prepare q;

--@queryplan
SELECT /*+ recompile */ 1 d, T.* FROM   (WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT tbl_b.* FROM  tbl_b INNER JOIN cte ON tbl_b.col_a = cte.col_a LEFT JOIN tbl_a ON tbl_a.col_b = cte.col_b) t;

-- Query plan not created.
--@queryplan
SELECT /*+ recompile */ 1 e, T.* FROM   (WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT tbl_b.* FROM  tbl_b, cte, tbl_a WHERE tbl_b.col_a = cte.col_a AND tbl_a.col_b = cte.col_b(+) ) t;

--@queryplan
prepare q from '
SELECT /*+ recompile */ 1 f, T.* FROM   (WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat (?, NULL, ?))
SELECT tbl_b.* FROM  tbl_b INNER JOIN cte ON tbl_b.col_a = cte.col_a LEFT JOIN tbl_a ON tbl_a.col_b = cte.col_b) t
';
execute q using 'KOR-','%';
deallocate prepare q;

--@queryplan
SELECT /*+ recompile */ 1 g, T.* FROM   (WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE replace(col_b, 'abc', NULL) = 'pabc')
SELECT tbl_b.* FROM  tbl_b INNER JOIN cte ON tbl_b.col_a = cte.col_a LEFT JOIN tbl_a ON tbl_a.col_b = cte.col_b) t;

--@queryplan
SELECT /*+ recompile */ 1 h, T.* FROM   (WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE 'a'='b')
SELECT tbl_b.* FROM  tbl_b INNER JOIN cte ON tbl_b.col_a = cte.col_a LEFT JOIN tbl_a ON tbl_a.col_b = cte.col_b) t;

--@queryplan
SELECT /*+ recompile */ 1 i, T.* FROM   (WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a=null)
SELECT tbl_b.* FROM  tbl_b INNER JOIN cte ON tbl_b.col_a = cte.col_a LEFT JOIN tbl_a ON tbl_a.col_b = cte.col_b) t;

--@queryplan
WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT /*+ recompile */ 1 j, tbl_b.* FROM  tbl_b INNER JOIN cte ON tbl_b.col_a = cte.col_a LEFT JOIN tbl_a ON tbl_a.col_b = cte.col_b;

-- Query plan not created.
--@queryplan
SELECT /*+ recompile */ 1 k, a1.* FROM   ( WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT * FROM  cte) a1 INNER JOIN ( WITH cte AS (SELECT col_a, col_b FROM   tbl_b  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT * FROM  cte) a2 ON a1.col_a = a2.col_a LEFT JOIN tbl_b ON tbl_b.col_b = a2.col_b ;

--@queryplan
SELECT /*+ recompile */ 1 l, T.* FROM ( WITH cte AS (SELECT col_a, col_b FROM tbl_a WHERE 1=0)
SELECT tbl_a.* FROM tbl_a INNER JOIN cte ON tbl_a.col_a = cte.col_a LEFT JOIN tbl_b ON tbl_a.col_b = tbl_b.col_b ) t;

--@queryplan
SELECT /*+ recompile */ 1 m, T.* FROM ( WITH cte AS (SELECT col_a, col_b FROM tbl_a WHERE col_a > 10000 and col_a <100 )
SELECT tbl_a.* FROM tbl_a INNER JOIN cte ON tbl_a.col_a = cte.col_a LEFT JOIN tbl_b ON tbl_a.col_b = tbl_b.col_b ) t;

--@queryplan
SELECT /*+ recompile */ 1 n, T.* FROM ( WITH cte AS (SELECT col_a, col_b FROM tbl_a WHERE col_b = '2024-13-01' )
SELECT tbl_a.* FROM tbl_a INNER JOIN cte ON tbl_a.col_a = cte.col_a LEFT JOIN tbl_b ON tbl_a.col_b = tbl_b.col_b ) t;

--@queryplan
SELECT /*+ recompile */ 1 o, T.* FROM ( WITH cte AS (select col_a, count(*) cnt from tbl_a group by col_b )
SELECT * FROM cte ) t;

--@queryplan
SELECT /*+ recompile */ 1 p, T.* FROM ( WITH cte AS (select col_a, count(*) col_b from tbl_a group by col_b )
SELECT tbl_a.* FROM tbl_a INNER JOIN cte ON tbl_a.col_a = cte.col_a LEFT JOIN tbl_b ON tbl_a.col_b = tbl_b.col_b ) t;

-- Query plan not created.
--@queryplan
SELECT /*+ recompile */ 1 q, T.* FROM   ( WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT tbl_a.* FROM  tbl_a INNER JOIN cte ON tbl_a.col_a = cte.col_a ) t;

--@queryplan
SELECT /*+ recompile */ 1 r, T.* FROM   ( WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT tbl_a.* FROM  tbl_a LEFT JOIN cte ON tbl_a.col_a = cte.col_a ) t;

-- Query plan not created.
--@queryplan
SELECT /*+ recompile */ 1 s, T.* FROM   ( WITH cte AS (SELECT col_a, col_b FROM   tbl_a  WHERE col_a LIKE Concat ('KOR-', NULL, '%'))
SELECT tbl_a.* FROM  tbl_a CROSS JOIN cte ) t;

drop table tbl_a;
drop table tbl_b;
