/**
 * This test case verifies CBRD-27516, part 2: ALTER TABLE ... ADD FOREIGN KEY
 * against a primary key whose columns are all DESC.
 *
 * The check reads the new foreign key index (always ASC) from its last leaf
 * backward and merges it with the primary key index. Bug: when the walk moved
 * to the previous leaf it set the start slot before reading that leaf's key
 * count, so it started at the key count of the leaf it left.
 *   - The previous leaf has more keys: its largest keys are not checked, and a
 *     value without a parent there passes; the foreign key is created.
 *   - The previous leaf has fewer keys: the walk starts on a slot that does
 *     not exist, and correct data fails with an internal error (a debug build
 *     asserts).
 * Fix: the start slot is set from the new leaf's key count. The same walk now
 * also checks a primary key of several DESC columns (it looked each key up
 * from the root before).
 *
 * Every case runs from CREATE TABLE to COMMIT in one transaction. The rows are
 * not committed when the foreign key index is built, so their MVCC
 * information is in the leaf records and the leaf layout is the same on every
 * run: 39301 lies among the largest keys of the second-to-last leaf, which the
 * old walk skipped. Cases 03 and 04 then move the orphan to nine more depths
 * from the top of the index (50 to 950 keys, every 100) and add the foreign
 * key again each time, so a change in the leaf capacity still leaves orphans
 * inside the skipped range: an ALTER that wrongly succeeds makes the next one
 * fail differently. Case 07 makes the low keys longer, so a leaf holds fewer
 * keys the further left it is.
 *
 *   01 PRIMARY KEY (a), orphan 39301: ER_FK_INVALID (control, read forward)
 *   02 PRIMARY KEY (a DESC), correct data: created, then cascade
 *   03 PRIMARY KEY (a DESC), orphan 39301 and nine more positions:
 *      ER_FK_INVALID each time (before the fix: no error, the foreign key was
 *      created)
 *   04 03 with deduplicate_key_level=10: ER_FK_INVALID each time
 *      (before the fix: no error, the foreign key was created)
 *   05 PRIMARY KEY (a DESC, b DESC), correct data: created, then cascade
 *   06 same key, (38302, 38301) has no parent, only its second column
 *      differs: ER_FK_INVALID
 *   07 PRIMARY KEY (a VARCHAR(300) DESC), correct data, low keys longer:
 *      created, then cascade (before the fix: internal error)
 */

SET SYSTEM PARAMETERS 'deduplicate_key_level=-1';
DROP TABLE IF EXISTS fk27516_c2;

-- Case 01
autocommit off;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, PRIMARY KEY (a));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT);
INSERT INTO fk27516_p SELECT LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c SELECT LEVEL, LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c VALUES (99999, 39301);
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a = 2;
COMMIT;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || COUNT(*) FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 02
autocommit off;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, PRIMARY KEY (a DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT);
INSERT INTO fk27516_p SELECT LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c SELECT LEVEL, LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a = 2;
COMMIT;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || COUNT(*) FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 03
autocommit off;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, PRIMARY KEY (a DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT);
INSERT INTO fk27516_p SELECT LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c SELECT LEVEL, LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c VALUES (99999, 39301);
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 39901 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 39701 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 39501 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 39101 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38901 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38701 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38501 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38301 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38101 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a = 2;
COMMIT;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || COUNT(*) FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 04
autocommit off;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
SET SYSTEM PARAMETERS 'deduplicate_key_level=10';
CREATE TABLE fk27516_p (a INT, PRIMARY KEY (a DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT);
INSERT INTO fk27516_p SELECT LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c SELECT LEVEL, LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c VALUES (99999, 39301);
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 39901 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 39701 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 39501 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 39101 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38901 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38701 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38501 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38301 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
UPDATE fk27516_c SET fa = 38101 WHERE id = 99999;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a = 2;
COMMIT;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || COUNT(*) FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';
SET SYSTEM PARAMETERS 'deduplicate_key_level=-1';

-- Case 05
autocommit off;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p SELECT LEVEL*2, LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c SELECT LEVEL, LEVEL*2, LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a = 2 AND b = 2;
COMMIT;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || COUNT(*) FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 06
autocommit off;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a INT, b INT, PRIMARY KEY (a DESC, b DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa INT, fb INT);
INSERT INTO fk27516_p SELECT LEVEL*2, LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c SELECT LEVEL, LEVEL*2, LEVEL*2 FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c VALUES (99999, 38302, 38301);
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa, fb) REFERENCES fk27516_p (a, b) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a = 2 AND b = 2;
COMMIT;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || COUNT(*) FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

-- Case 07
autocommit off;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_p;
CREATE TABLE fk27516_p (a VARCHAR(300), PRIMARY KEY (a DESC));
CREATE TABLE fk27516_c (id INT PRIMARY KEY, fa VARCHAR(300));
INSERT INTO fk27516_p SELECT LPAD (LEVEL, 5, '0') || REPEAT ('x', (20000 - LEVEL) / 100) FROM db_root CONNECT BY LEVEL <= 20000;
INSERT INTO fk27516_c SELECT LEVEL, LPAD (LEVEL, 5, '0') || REPEAT ('x', (20000 - LEVEL) / 100) FROM db_root CONNECT BY LEVEL <= 20000;
ALTER TABLE fk27516_c ADD CONSTRAINT fk_c FOREIGN KEY (fa) REFERENCES fk27516_p (a) ON DELETE CASCADE;
DELETE FROM fk27516_p WHERE a LIKE '00001%';
COMMIT;
SELECT 'R=p:' || COUNT(*) FROM fk27516_p;
SELECT 'R=c:' || COUNT(*) FROM fk27516_c;
SELECT 'R=fk:' || COUNT(*) FROM db_index WHERE class_name = 'fk27516_c' AND is_foreign_key = 'YES';

autocommit on;
DROP TABLE IF EXISTS fk27516_c;
DROP TABLE IF EXISTS fk27516_c2;
DROP TABLE IF EXISTS fk27516_p;
