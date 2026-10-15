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
 * Foreign key columns whose precision differs from the primary key's. The
 * search key bytes are read with the searched index's column domains.
 */

-- Case 01: VARCHAR(10) parent, VARCHAR(20) child, (a DESC, b), CASCADE: children 10, 11 go
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a VARCHAR(10), b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa VARCHAR(20), fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES ('1',1),('2',2),('3',3);
INSERT INTO fk27516_c VALUES (10,'1',1),(11,'1',1),(20,'2',2);
COMMIT;
DELETE FROM fk27516_p WHERE a='1' AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 02: NUMERIC(10,2) parent, NUMERIC(12,4) child, (a DESC, b), CASCADE: children 10, 11 go
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a NUMERIC(10,2), b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa NUMERIC(12,4), fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES (1.5,1),(2.5,2),(3.5,3);
INSERT INTO fk27516_c VALUES (10,1.5,1),(11,1.5,1),(20,2.5,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1.5 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 03: CHAR(4) parent, CHAR(8) child, (a DESC, b), CASCADE: children 10, 11 go
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a CHAR(4), b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa CHAR(8), fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES ('1',1),('2',2),('3',3);
INSERT INTO fk27516_c VALUES (10,'1',1),(11,'1',1),(20,'2',2);
COMMIT;
DELETE FROM fk27516_p WHERE a='1' AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(TRIM(a) || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(TRIM(fa),'-') || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 04: CHAR(4) parent, CHAR(8) child, RESTRICT, delete a parent with children then one without: restricted, then deleted
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a CHAR(4), b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa CHAR(8), fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES ('1',1),('2',2),('3',3);
INSERT INTO fk27516_c VALUES (10,'1',1),(11,'1',1),(20,'2',2);
COMMIT;
DELETE FROM fk27516_p WHERE a='1' AND b=1;
DELETE FROM fk27516_p WHERE a='3' AND b=3;
SELECT 'R=p:' || NVL(GROUP_CONCAT(TRIM(a) || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(TRIM(fa),'-') || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 05: VARCHAR(10) parent, VARCHAR(20) child, all ASC, CASCADE (control)
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a VARCHAR(10), b INT, PRIMARY KEY (a, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa VARCHAR(20), fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES ('1',1),('2',2),('3',3);
INSERT INTO fk27516_c VALUES (10,'1',1),(11,'1',1),(20,'2',2);
COMMIT;
DELETE FROM fk27516_p WHERE a='1' AND b=1;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(TO_CHAR(fb),'-') ORDER BY 1), 'none') FROM fk27516_c;

-- Case 06: CHAR(4) parent, CHAR(8) child, all ASC, RESTRICT (control)
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a CHAR(4), b INT, PRIMARY KEY (a, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa CHAR(8), fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES ('1',1),('2',2),('3',3);
INSERT INTO fk27516_c VALUES (10,'1',1),(11,'1',1),(20,'2',2);
COMMIT;
DELETE FROM fk27516_p WHERE a='1' AND b=1;
DELETE FROM fk27516_p WHERE a='3' AND b=3;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(TO_CHAR(fb),'-') ORDER BY 1), 'none') FROM fk27516_c;

-- Case 07: NUMERIC(10,2) parent, NUMERIC(12,4) child, all ASC, CASCADE (control)
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a NUMERIC(10,2), b INT, PRIMARY KEY (a, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa NUMERIC(12,4), fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES (1.5,1),(2.5,2),(3.5,3);
INSERT INTO fk27516_c VALUES (10,1.5,1),(11,1.5,1),(20,2.5,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1.5 AND b=1;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(TO_CHAR(fb),'-') ORDER BY 1), 'none') FROM fk27516_c;

-- Case 08: BIT VARYING(16) parent, BIT VARYING(8) child, all ASC, CASCADE (control)
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a BIT VARYING(16), b INT, PRIMARY KEY (a, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa BIT VARYING(8), fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES (X'AB',1),(X'CD',2),(X'EF',3);
INSERT INTO fk27516_c VALUES (10,X'AB',1),(11,X'AB',1),(20,X'CD',2);
COMMIT;
DELETE FROM fk27516_p WHERE a=X'AB' AND b=1;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(TO_CHAR(fb),'-') ORDER BY 1), 'none') FROM fk27516_c;

DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_p;
