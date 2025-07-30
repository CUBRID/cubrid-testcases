-- evalulate 1 - Mixed CASE branches (Integer in THEN, NULL in ELSE)
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

-- evalulate 2 - THEN returns 0 or 1
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

-- evalulate 3 - THEN returns TRUE or FALSE
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

-- evalulate 4 - THEN returns string literals
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

-- evalulate 5 - THEN returns 1, 2, or NULL
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

-- evalulate 6 - THEN contains scalar subquery
SELECT DISTINCT dummy
FROM dual T1
WHERE
    CASE
        WHEN T1.dummy IN ('X', 'Y', 'Z')
        THEN (SELECT 1) = 1
        ELSE FALSE
    END = TRUE;

-- evalulate 7 - CASE expression in SELECT clause
SELECT dummy,
       CASE
           WHEN dummy = 'X' THEN 'label-X'
           WHEN dummy = 'Y' THEN 'label-Y'
           ELSE 'Other'
       END AS label
FROM dual;

