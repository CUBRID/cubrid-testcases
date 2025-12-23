/**
 *  Test Case : connect_by_root_groupby_semantic_errors
 *  Issue     : CBRD-25899
 *  Purpose   : Make sure CONNECT_BY_ROOT and SYS_CONNECT_BY_PATH trigger
 *              semantic errors whenever they are mixed with GROUP BY in any
 *              form.  Also include three positive controls that must succeed.
 */

-- main table
DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (
    col1         INT,
    parnts_col1  INT,
    id           VARCHAR
);

INSERT INTO tbl VALUES
(1 ,NULL,'Kim'  ),
(2 ,NULL,'Moy'  ),
(3 ,1   ,'Jonas'),
(4 ,1   ,'Smith'),
(5 ,2   ,'Verma'),
(6 ,2   ,'Foster'),
(7 ,6   ,'Brown');

------------------------------------------------------------------------
--  1 – 17  INVALID CASES (should raise -49x semantic errors)
------------------------------------------------------------------------

evaluate('1. Invalid: CONNECT_BY_ROOT + GROUP BY positional reference');
SELECT /*+ recompile */ CONNECT_BY_ROOT id
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
GROUP  BY 1;

evaluate('2. Invalid: CONNECT_BY_ROOT + GROUP BY explicit column');
SELECT /*+ recompile */ col1, CONNECT_BY_ROOT id
FROM   tbl
START WITH parnts_col1 IS NULL
CONNECT BY PRIOR col1 = parnts_col1
GROUP  BY col1;

evaluate('3. Invalid: CONNECT_BY_ROOT alias grouped');
SELECT /*+ recompile */ CONNECT_BY_ROOT id AS root_id
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
GROUP  BY root_id;

evaluate('4. Invalid: GROUP BY parnts_col1 while selecting CONNECT_BY_ROOT');
SELECT /*+ recompile */ parnts_col1, CONNECT_BY_ROOT id
FROM   tbl
START WITH parnts_col1 IS NULL
CONNECT BY PRIOR col1 = parnts_col1
GROUP  BY parnts_col1;

evaluate('5. Invalid: CONNECT_BY_ROOT inside GROUP BY list');
SELECT /*+ recompile */ COUNT(*)
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
GROUP  BY CONNECT_BY_ROOT id;

evaluate('6. Invalid: HAVING references CONNECT_BY_ROOT');
SELECT /*+ recompile */ col1, COUNT(*)
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
GROUP  BY col1
HAVING CONNECT_BY_ROOT id <> '';

evaluate('7. Invalid: ORDER BY CONNECT_BY_ROOT with GROUP BY');
SELECT /*+ recompile */ col1, SUM(col1)
FROM   tbl
START WITH parnts_col1 IS NULL
CONNECT BY PRIOR col1 = parnts_col1
GROUP  BY col1
ORDER BY CONNECT_BY_ROOT id;

evaluate('8. Invalid: SYS_CONNECT_BY_PATH + GROUP BY explicit column');
SELECT /*+ recompile */ col1,
       SYS_CONNECT_BY_PATH(id,'/') AS path
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
GROUP  BY col1;

evaluate('9. Invalid: SYS_CONNECT_BY_PATH alias grouped');
SELECT /*+ recompile */ SYS_CONNECT_BY_PATH(id,'/') AS path_col
FROM   tbl
START WITH parnts_col1 IS NULL
CONNECT BY PRIOR col1 = parnts_col1
GROUP  BY path_col;

evaluate('10. Invalid: LENGTH(CONNECT_BY_ROOT) with GROUP BY');
SELECT /*+ recompile */ col1, LENGTH(CONNECT_BY_ROOT id)
FROM   tbl
START WITH parnts_col1 IS NULL
CONNECT BY PRIOR col1 = parnts_col1
GROUP  BY col1;

evaluate('11. Invalid: CONNECT_BY_ROOT with GROUP BY col1 WITH ROLLUP');
SELECT /*+ recompile */ col1, CONNECT_BY_ROOT id
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
GROUP  BY col1 WITH ROLLUP;

evaluate('12. Invalid: HAVING uses SYS_CONNECT_BY_PATH while grouped');
SELECT /*+ recompile */ col1
FROM   tbl
START WITH parnts_col1 IS NULL
CONNECT BY PRIOR col1 = parnts_col1
GROUP  BY col1
HAVING SYS_CONNECT_BY_PATH(id,'/') LIKE '/Kim%';

evaluate('13. Invalid: CONNECT_BY_ROOT + SYS_CONNECT_BY_PATH + GROUP BY positional reference');
SELECT /*+ recompile */ CONNECT_BY_ROOT id, SYS_CONNECT_BY_PATH(id,'/') AS path_col
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
GROUP BY 1;

evaluate('14. Invalid: CONNECT_BY_ROOT + SYS_CONNECT_BY_PATH + GROUP BY explicit column');
SELECT /*+ recompile */ col1, CONNECT_BY_ROOT id, SYS_CONNECT_BY_PATH(id,'/') AS path_col
FROM   tbl
START WITH parnts_col1 IS NULL
CONNECT BY PRIOR col1 = parnts_col1
GROUP BY col1;

evaluate('15. Invalid: CONNECT_BY_ROOT + SYS_CONNECT_BY_PATH alias grouped');
SELECT /*+ recompile */ CONNECT_BY_ROOT id AS root_id, SYS_CONNECT_BY_PATH(id,'/') AS path_col
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
GROUP BY path_col;

evaluate('16. Invalid (prepare/execute): SYS_CONNECT_BY_PATH + GROUP BY explicit column');
prepare stmt from
'SELECT /*+ recompile */ col1,
        SYS_CONNECT_BY_PATH(id,''/'') AS path
 FROM   tbl
 CONNECT BY PRIOR col1 = parnts_col1
 START WITH parnts_col1 IS NULL
 GROUP  BY col1';
execute stmt;
drop prepare stmt;

evaluate('17. Invalid (prepare/execute + binding): bind var in START WITH + SYS_CONNECT_BY_PATH + GROUP BY explicit column');
prepare stmt from
'SELECT /*+ recompile */ col1,
        SYS_CONNECT_BY_PATH(id,''/'') AS path
 FROM   tbl
 CONNECT BY PRIOR col1 = parnts_col1
 START WITH parnts_col1 IS NULL AND id <> ?
 GROUP  BY col1';
execute stmt using '__dummy__';
drop prepare stmt;

------------------------------------------------------------------------
--  18 – 22  VALID CONTROLS (should succeed)
------------------------------------------------------------------------

evaluate('18. Valid (prepare/execute): SYS_CONNECT_BY_PATH without GROUP BY');
prepare stmt from
'SELECT /*+ recompile */ col1,
        SYS_CONNECT_BY_PATH(id,''/'') AS full_path
 FROM   tbl
 START WITH parnts_col1 IS NULL
 CONNECT BY PRIOR col1 = parnts_col1
 ORDER  BY col1';
execute stmt;
drop prepare stmt;

evaluate('19. Valid (prepare/execute + binding): bind var in START WITH + SYS_CONNECT_BY_PATH without GROUP BY');
prepare stmt from
'SELECT /*+ recompile */ col1,
        SYS_CONNECT_BY_PATH(id,''/'') AS full_path
 FROM   tbl
 START WITH parnts_col1 IS NULL AND id <> ?
 CONNECT BY PRIOR col1 = parnts_col1
 ORDER  BY col1';
execute stmt using '__dummy__';
drop prepare stmt;

evaluate('20. Valid: CONNECT_BY_ROOT without GROUP BY');
SELECT /*+ recompile */ col1,
       CONNECT_BY_ROOT id AS root_id
FROM   tbl
CONNECT BY PRIOR col1 = parnts_col1
START WITH parnts_col1 IS NULL
ORDER  BY col1;

evaluate('21. Valid: SYS_CONNECT_BY_PATH without GROUP BY');
SELECT /*+ recompile */ col1,
       SYS_CONNECT_BY_PATH(id,'/') AS full_path
FROM   tbl
START WITH parnts_col1 IS NULL
CONNECT BY PRIOR col1 = parnts_col1
ORDER  BY col1;

evaluate('22. Valid: CONNECT_BY_ROOT in subquery, outer GROUP BY');
SELECT /*+ recompile */ root_id, COUNT(*)
FROM (
    SELECT /*+ recompile */ CONNECT_BY_ROOT id AS root_id
    FROM   tbl
    CONNECT BY PRIOR col1 = parnts_col1
    START WITH parnts_col1 IS NULL
) s
GROUP BY root_id
ORDER BY root_id;

-- cleanup
DROP TABLE tbl;

