-- This test case verifies the following issue: CBRD-25396.
-- Validate that when using GROUP BY and ORDER BY simultaneously within a subquery, 
-- the NO_MERGE and QUERY_CACHE hints function correctly.

drop table if exists tbl_a;
drop table if exists tbl_b;

evaluate 'test data';
create table tbl_a (col_a int, col_b int);
create table tbl_b (col_c int, col_d int);

insert into tbl_a values (1,1),(2,2),(3,3);
insert into tbl_b values (1,1),(2,2),(3,3);

set optimization level 513;

update statistics on tbl_a with fullscan;
update statistics on tbl_b with fullscan;

evaluate '1. GROUP BY & ORDER BY with NO_MERGE Hint';
SELECT /*+ RECOMPILE */
    (
        SELECT 
            col_c
        FROM
            tbl_b 
        WHERE
            col_c = X.col_a
            AND ROWNUM =1
        ) AS test
FROM
    (
        SELECT /*+ NO_MERGE */
            t.col_a
            ,( select 1 from tbl_a where col_a = t.col_a ) as col_x
        FROM
            tbl_a t
        GROUP BY
            t.col_a
        ORDER BY
            t.col_a
    ) X;

evaluate '2. GROUP BY & ORDER BY with QUERY_CACHE Hint';
SELECT /*+ RECOMPILE */
    (
        SELECT 
            col_c
        FROM
            tbl_b 
        WHERE
            col_c = X.col_a
            AND ROWNUM =1
        ) AS test
FROM
    (
        SELECT /*+ QUERY_CACHE */
            t.col_a
            ,( select 1 from tbl_a where col_a = t.col_a ) as col_x
        FROM
            tbl_a t
        GROUP BY
            t.col_a
        ORDER BY
            t.col_a
    ) X;

evaluate '3. GROUP BY & ORDER BY with NO_MERGE hint in a nested subquery';
SELECT /*+ RECOMPILE */
    (
        SELECT 
            col_c
        FROM
            tbl_b 
        WHERE
            col_c = X.col_a
            AND ROWNUM =1
        ) AS test
FROM
    (
        SELECT /*+ NO_MERGE */
            t.col_a
            ,(
                SELECT /*+ NO_MERGE */
                    col_a 
                FROM 
                    tbl_a 
                WHERE 
                    col_a = t.col_a 
                GROUP BY 
                    col_a 
                ORDER BY 
                    col_a
             ) as col_x
        FROM
            tbl_a t
        GROUP BY
            t.col_a
        ORDER BY
            t.col_a
    ) X;


evaluate '4. Multiple Subqueries with NO_MERGE AND QUERY_CACHE Hints';
SELECT /*+ RECOMPILE */
    (
        SELECT 
            col_c
        FROM
            tbl_b 
        WHERE
            col_c = X.col_a
            AND ROWNUM =1
        ) AS test
FROM
    (
        SELECT /*+ NO_MERGE */
            t.col_a
            ,( 
                SELECT /*+ QUERY_CACHE */
                    col_a 
                FROM 
                    tbl_a 
                WHERE 
                    col_a = t.col_a 
             ) as col_x
        FROM
            tbl_a t
        GROUP BY
            t.col_a
        ORDER BY
            t.col_a
    ) X;


--Verify subquery merge still functions correctly when NO_MERGE hint is not given
evaluate '5. NO_MERGE Hint on Outer Query Only';
SELECT /*+ RECOMPILE NO_MERGE */
    (
        SELECT 
            col_c
        FROM
            tbl_b 
        WHERE
            col_c = X.col_a
            AND ROWNUM =1
        ) AS test
FROM
    (
        SELECT 
            t.col_a
            ,( select 1 from tbl_a where col_a = t.col_a ) as col_x
        FROM
            tbl_a t
        GROUP BY
            t.col_a
        ORDER BY
            t.col_a
    ) X;

--Verify NO_MERGE hint functions correctly in the WHERE clause by using an embedded inline view
evaluate '6. NO_MERGE Hint in an inline view within the WHERE clause';
SELECT /*+ RECOMPILE */
    (
        SELECT 
            col_c
        FROM
            tbl_b 
        WHERE
            col_c = (
                SELECT inline_view.col_a 
                FROM (
                    SELECT /*+ NO_MERGE */
                        t.col_a
                        ,( select 1 from tbl_a where col_a = t.col_a ) as col_x
                    FROM
                        tbl_a t
                    GROUP BY
                        t.col_a
                    ORDER BY
                        t.col_a
                ) inline_view
                WHERE ROWNUM = 1
            )
        AND ROWNUM = 1
    ) AS X;


evaluate '7. NO_MERGE Hint in a View';
CREATE OR REPLACE VIEW view_a AS
SELECT /*+ NO_MERGE */
    t.col_a
    ,( select 1 from tbl_a where col_a = t.col_a ) as col_x
FROM
    tbl_a t
GROUP BY
    t.col_a
ORDER BY
    t.col_a;

SELECT /*+ RECOMPILE */
    (
        SELECT 
            col_c
        FROM
            tbl_b 
        WHERE
            col_c = view_a.col_a
        AND ROWNUM = 1
    ) AS test
FROM
    view_a;


drop view view_a;
drop table tbl_a;
drop table tbl_b;

