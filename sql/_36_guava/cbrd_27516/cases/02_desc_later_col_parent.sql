/**
 * This test case verifies CBRD-27516.
 *
 * CBRD-27516: a foreign key check fails when the primary key has a DESC column.
 * A foreign key index is always ASC, whatever the declaration says, so its
 * columns and the primary key index's columns differ in direction.
 * pr_midxkey_compare () does not compare two columns of different directions:
 * it returns DB_UNK, and a debug build asserts just before. A parent DELETE,
 * a parent key UPDATE and ALTER TABLE ... ADD FOREIGN KEY on a child that has
 * rows all searched one index with a key carrying the other index's domain.
 * Fix: the search key takes the domain of the index it searches.
 *
 * DESC in the second or third primary key column.
 */

-- Case 01: PRIMARY KEY (a, b DESC), CASCADE, delete (1,1): children 10, 11 go
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a, b DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 02: same key, RESTRICT, delete (1,1) that has children: restricted
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a, b DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 03: PRIMARY KEY (a DESC, b, x DESC), CASCADE, delete (1,1,1): only the two rows that refer to it go
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, x INT, PRIMARY KEY (a DESC, b, x DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, fx INT, FOREIGN KEY (fa, fb, fx) REFERENCES fk27516_p (a, b, x) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES (1,1,1),(1,1,2),(1,2,1),(2,1,1);
INSERT INTO fk27516_c VALUES (10,1,1,1),(11,1,1,2),(12,1,2,1),(13,2,1,1),(14,1,1,1);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1 AND x=1;
SELECT 'R=p:' || GROUP_CONCAT(a || '/' || b || '/' || x ORDER BY 1) FROM fk27516_p;
SELECT 'R=c:' || GROUP_CONCAT(id ORDER BY 1) FROM fk27516_c;

DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_p;
