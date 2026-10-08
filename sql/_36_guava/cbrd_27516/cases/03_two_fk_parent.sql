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
 * Two foreign keys referencing the same primary key: each scan has to get
 * its own foreign key index's domain.
 */

-- Case 01: c is CASCADE, c2 is SET NULL, delete (1,1): 10, 11 of c go, 30 of c2 becomes NULL
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
CREATE TABLE fk27516_c2 (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE SET NULL);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
INSERT INTO fk27516_c2 VALUES (30,1,1),(40,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id ORDER BY 1),'none') FROM fk27516_c;
SELECT 'R=c2:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) ORDER BY 1),'none') FROM fk27516_c2;

-- Case 02: c is CASCADE, c2 is RESTRICT with a child, delete (1,1) then (3,3): the first is restricted and c is untouched, (3,3) goes
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
CREATE TABLE fk27516_c2 (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
INSERT INTO fk27516_c2 VALUES (30,1,1),(40,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
DELETE FROM fk27516_p WHERE a=3 AND b=3;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id ORDER BY 1),'none') FROM fk27516_c;
SELECT 'R=c2:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) ORDER BY 1),'none') FROM fk27516_c2;

DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_p;
