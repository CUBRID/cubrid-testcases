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
 * Primary key whose first column is DESC: parent DELETE and parent key UPDATE
 * under the four referential actions. Before the fix a debug build cored on
 * every case but 01, and a release build failed with Query execution failure.
 */

-- Case 01: PRIMARY KEY (a, b), ON DELETE CASCADE, delete (1,1): children 10, 11 go (control)
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 02: PRIMARY KEY (a DESC, b), ON DELETE CASCADE, delete (1,1): children 10, 11 go
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 03: same key, ON DELETE SET NULL: the foreign keys of 10, 11 become NULL
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE SET NULL);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 04: RESTRICT, delete (3,3) that has no child: deleted
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=3 AND b=3;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 05: RESTRICT, delete (1,1) that has children: restricted by the foreign key
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 06: RESTRICT, update the key of (3,3) that has no child: updated
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
UPDATE fk27516_p SET b=9 WHERE a=3 AND b=3;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 07: RESTRICT, update the key of (1,1) that has children: restricted
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
UPDATE fk27516_p SET b=9 WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 08: NO ACTION, delete (3,3) without children, then update the key of (1,1) with children: deleted, then restricted
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE NO ACTION ON UPDATE NO ACTION);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=3 AND b=3;
UPDATE fk27516_p SET b=9 WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 09: NO ACTION, delete (2,2) that has a child: restricted
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE NO ACTION ON UPDATE NO ACTION);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=2 AND b=2;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 10: ON UPDATE SET NULL, update the key of (1,1): the foreign keys of 10, 11 become NULL
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON UPDATE SET NULL);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
UPDATE fk27516_p SET b=9 WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_p;
