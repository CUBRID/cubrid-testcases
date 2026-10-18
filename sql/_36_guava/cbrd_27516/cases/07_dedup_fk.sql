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
 * deduplicate_key_level on: the foreign key index carries one more column.
 * Session parameter, restored at the end of this file.
 */

-- Case 01: (a DESC, b), CASCADE, delete (1,1): children 10, 11 go
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
SET SYSTEM PARAMETERS 'deduplicate_key_level=10';
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 02: RESTRICT, delete (3,3) without children, then update the key of (2,2) with a child: deleted, then restricted
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
SET SYSTEM PARAMETERS 'deduplicate_key_level=10';
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT, FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE RESTRICT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
DELETE FROM fk27516_p WHERE a=3 AND b=3;
UPDATE fk27516_p SET b=9 WHERE a=2 AND b=2;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;

-- Case 03: (a DESC, b), add the foreign key to a child with rows: created, then 10, 11 cascade
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
SET SYSTEM PARAMETERS 'deduplicate_key_level=10';
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 04: same key, a child (9,9) without parent: ER_FK_INVALID
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
SET SYSTEM PARAMETERS 'deduplicate_key_level=10';
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2),(30,9,9);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

SET SYSTEM PARAMETERS 'deduplicate_key_level=-1';

DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_p;
