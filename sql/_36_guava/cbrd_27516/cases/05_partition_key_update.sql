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
 * Partitioned parent: a key UPDATE that moves the row to another partition.
 */

-- Case 01: (a DESC, b), RESTRICT, move (3,3) that has no child to a=13: moved
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b)) PARTITION BY RANGE (a) (PARTITION p0 VALUES LESS THAN (10), PARTITION p1 VALUES LESS THAN MAXVALUE);
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b));
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (20,2,2);
COMMIT;
UPDATE fk27516_p SET a=13 WHERE a=3 AND b=3;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 02: RESTRICT, move (2,2) that has a child to a=12: restricted
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b)) PARTITION BY RANGE (a) (PARTITION p0 VALUES LESS THAN (10), PARTITION p1 VALUES LESS THAN MAXVALUE);
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b));
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (20,2,2);
COMMIT;
UPDATE fk27516_p SET a=12 WHERE a=2 AND b=2;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 03: ON UPDATE SET NULL, move (1,1) to a=11: moved, the foreign keys of 10, 11 become NULL
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b)) PARTITION BY RANGE (a) (PARTITION p0 VALUES LESS THAN (10), PARTITION p1 VALUES LESS THAN MAXVALUE);
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON UPDATE SET NULL);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
UPDATE fk27516_p SET a=11 WHERE a=1 AND b=1;
SELECT 'R=p:' || GROUP_CONCAT(a || '/' || b ORDER BY 1) FROM fk27516_p;
SELECT 'R=c:' || GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1) FROM fk27516_c;

DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_p;
