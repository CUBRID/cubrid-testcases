--Inheritance
DROP TABLE IF EXISTS a_t, b_t, c_t, a_b_c;
CREATE class a_t(a int PRIMARY KEY, b int);
CREATE class b_t(a int PRIMARY KEY, b int, c int);
CREATE class c_t(b int PRIMARY KEY, d int);
CREATE class a_b_c under a_t, b_t, c_t inherit a OF b_t, b OF b_t;
INSERT INTO a_b_c
VALUES (1,1,1,1);
INSERT INTO a_t
VALUES (2,2);
INSERT INTO b_t
VALUES (3,3,3);
INSERT INTO c_t
VALUES (4,4);
--only
SELECT /*+ recompile */ count(*)
FROM all a_t a
LEFT OUTER JOIN a_t b
ON   a.a = b.a;
SELECT /*+ recompile */ count(*)
FROM all a_t a
LEFT OUTER JOIN only a_t b
ON a.a = b.a;
--all
SELECT /*+ recompile */ count(*)
FROM all a_t a
LEFT OUTER JOIN ALL a_t b
ON a.a = b.a;
DROP TABLE a_t, b_t, c_t, a_b_c;
