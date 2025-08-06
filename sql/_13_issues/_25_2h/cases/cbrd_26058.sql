/**
 *  This test case verifies CBRD-26058 : Fix error in CASE expression with logical type
 *  
 *  Coverage:
 *  Different Scenario
1 - Mixed CASE branches (Integer in THEN, NULL in ELSE)
2 - THEN returns 0 or 1
3 - THEN returns TRUE or FALSE
4 - THEN returns string literals
5 - THEN returns 1, 2, or NULL
6 - THEN contains scalar subquery
7 - CASE in SELECT list (comparison vs NULL)
8 - THEN comparison predicate, ELSE NULL
9 - THEN NULL, ELSE comparison predicate
10 - CASE in ORDER BY (comparison vs NULL)
 */

evaluate '1 - Mixed CASE branches (Integer in THEN, NULL in ELSE)';
SELECT DISTINCT dummy
FROM dual T1
WHERE
    CASE
        WHEN T1.dummy IN ('X', 'Y', 'Z')
        THEN
            CASE
                WHEN T1.dummy != 'Z'
                THEN 2
                ELSE 1
            END = 1
        ELSE T1.dummy IN
            (
              SELECT 'N'
              FROM dual
              WHERE dummy = NULL
            )
    END = 1;

evaluate '2 - THEN returns 0 or 1';
SELECT DISTINCT dummy
FROM dual T1
WHERE
    CASE
        WHEN T1.dummy IN ('X', 'Y', 'Z')
        THEN
            CASE
                WHEN T1.dummy != 'Z'
                THEN 0
                ELSE 1
            END = 1
        ELSE FALSE
    END = 1;

evaluate '3 - THEN returns TRUE or FALSE';
SELECT DISTINCT dummy
FROM dual T1
WHERE
    CASE
        WHEN T1.dummy IN ('X', 'Y', 'Z')
        THEN
            CASE
                WHEN T1.dummy != 'Z'
                THEN TRUE
                ELSE FALSE
            END = TRUE
        ELSE FALSE
    END = TRUE;

evaluate '4 - THEN returns string literals';
SELECT DISTINCT dummy
FROM dual T1
WHERE
    CASE
        WHEN T1.dummy IN ('X', 'Y', 'Z')
        THEN
            CASE
                WHEN T1.dummy != 'Z'
                THEN 'two'
                ELSE 'one'
            END = 'one'
        ELSE FALSE
    END = TRUE;

evaluate '5 - THEN returns 1, 2, or NULL';
SELECT DISTINCT dummy
FROM dual T1
WHERE
    CASE
        WHEN T1.dummy IN ('X', 'Y', 'Z')
        THEN
            CASE
                WHEN T1.dummy = 'X' THEN 1
                WHEN T1.dummy = 'Y' THEN 2
                ELSE NULL
            END = 1
        ELSE FALSE
    END = TRUE;

evaluate '6 - THEN contains scalar subquery';
SELECT DISTINCT dummy
FROM dual T1
WHERE
    CASE
        WHEN T1.dummy IN ('X', 'Y', 'Z')
        THEN (SELECT 1) = 1
        ELSE FALSE
    END = TRUE;

evaluate '7 - CASE in SELECT list (comparison vs NULL)';
-- THEN : comparison predicate (dummy = 'X')
-- ELSE : NULL
SELECT dummy,
       CASE
           WHEN dummy = 'X' THEN dummy = 'X'
           ELSE NULL
       END AS flag
FROM dual;

evaluate '8 - THEN comparison predicate, ELSE NULL';
-- THEN : comparison predicate (dummy != 'X')
-- ELSE : NULL
SELECT DISTINCT dummy
FROM dual
WHERE
    CASE
        WHEN dummy = 'X' THEN dummy != 'X'
        ELSE NULL
    END = TRUE;

evaluate '9 - THEN NULL, ELSE comparison predicate';
-- THEN : NULL
-- ELSE : comparison predicate (dummy = 'X')
SELECT DISTINCT dummy
FROM dual
WHERE
    CASE
        WHEN dummy != 'X' THEN NULL
        ELSE dummy = 'X'
    END = TRUE;

evaluate '10 - CASE in ORDER BY (comparison vs NULL)';
-- THEN : comparison predicate (dummy = 'X')
-- ELSE : NULL
SELECT dummy
FROM dual
ORDER BY CASE
             WHEN dummy = 'X' THEN dummy = 'X'
             ELSE NULL
         END;
         