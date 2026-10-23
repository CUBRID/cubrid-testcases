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
 * ALTER TABLE ... ADD FOREIGN KEY on a child that has rows: the existing
 * rows are checked against the primary key index.
 */

-- Case 01: PRIMARY KEY (a, b): created, then 10, 11 cascade (control)
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 02: PRIMARY KEY (a DESC, b): created, then 10, 11 cascade
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
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

-- Case 03: PRIMARY KEY (a DESC, b DESC): created, then 10, 11 cascade
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 04: PRIMARY KEY (a DESC), one column: created, then 10, 11 cascade (control)
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 05: partitioned parent (a DESC, b): created, then 10, 11 cascade
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b)) PARTITION BY RANGE (a) (PARTITION p0 VALUES LESS THAN (2), PARTITION p1 VALUES LESS THAN MAXVALUE);
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 06: CHAR(4) parent, CHAR(8) child, (a DESC, b): created, then 10, 11 cascade
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a CHAR(4), b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa CHAR(8), fb INT);
INSERT INTO fk27516_p VALUES ('1',1),('2',2),('3',3);
INSERT INTO fk27516_c VALUES (10,'1',1),(11,'1',1),(20,'2',2);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a='1' AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(TRIM(a) || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(TRIM(fa),'-') || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 07: (a DESC, b), a child (9,9) without parent: ER_FK_INVALID, no foreign key
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
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

-- Case 08: (a, b), a child (9,9) without parent: ER_FK_INVALID, no foreign key (control)
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2),(30,9,9);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 09: (a DESC, b), a child whose foreign key columns are NULL: created, the NULL row is not checked
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p VALUES (1,1),(2,2),(3,3);
INSERT INTO fk27516_c VALUES (10,1,1),(11,1,1),(20,2,2),(30,NULL,9);
COMMIT;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a=1 AND b=1;
SELECT 'R=p:' || NVL(GROUP_CONCAT(a || '/' || b ORDER BY 1), 'none') FROM fk27516_p;
SELECT 'R=c:' || NVL(GROUP_CONCAT(id || '/' || NVL(fa,-1) || '/' || NVL(fb,-1) ORDER BY 1), 'none') FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_p;
