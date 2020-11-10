DROP TABLE IF EXISTS T1;
DROP TABLE IF EXISTS T2;
DROP TABLE IF EXISTS T3;

CREATE TABLE T1 (C1 INT, c2 INT, c3 INT);
CREATE TABLE T2 (C1 INT, c2 INT, c3 INT, C4 VARCHAR(10));
CREATE TABLE T3 (C1 INT, c2 INT, c3 INT, C4 VARCHAR(10));

INSERT INTO T1 VALUES
    (1, 10, 100),
    (2, 20, 200),
    (3, 30, 300);
INSERT INTO T2 VALUES
    (1, 10, 100, 'R'),
    (2, 20, 200, 'G');
INSERT INTO T3 VALUES
    (1, 10, 100, 'Red'),
    (3, 30, 300, 'Blue');

SELECT /*+ RECOMPILE */
    T2.C4 AS T2_C4, 
    T3.C4 AS T3_C4
FROM
    T1
    LEFT OUTER JOIN T2 ON ( T1.C1 = T2.C1 AND T1.C2 = T2.C2 AND  T1.C3 = T2.C3 )
    LEFT OUTER JOIN T3 ON ( T1.C1 = T3.C1 AND T1.C2 = T3.C2 AND  T1.C3 = T3.C3 )
WHERE
    (
        1 = 1
        AND T1.C1 = 1
        AND T1.C2 = 10
        AND T1.C3 = 100
        AND T2.C1 = 1
        AND T2.C2 = 10
        AND T2.C3 = 100
        AND T3.C1 = 1
        AND T3.C2 = 10
        AND T3.C3 = 100
        AND T2.c4 = 'R'
        AND T3.C4 = 'Red'
    )
    OR (
        1 = 1
        AND T1.C1 = 3
        AND T1.C2 = 30
        AND T1.C3 = 300
        AND T2.C1 IS NULL
        AND T2.C2 IS NULL
        AND T2.C3 IS NULL
        AND T3.C1 = 3
        AND T3.C2 = 30
        AND T3.C3 = 300
        AND T2.c4 IS NULL
        AND T3.C4 = 'Blue'
    );

DROP TABLE T1;
DROP TABLE T2;
DROP TABLE T3;
