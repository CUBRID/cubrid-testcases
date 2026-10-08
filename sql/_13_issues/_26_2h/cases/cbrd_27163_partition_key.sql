/**
 * This test case verifies CBRD-27163: stream size assert for filtered index
 * and partitioning key (partitioning key part).
 *
 * Bug: a partition key expression is compiled into a stream and stored with
 * db_make_char(). Only the expression TEXT is checked against
 * DB_MAX_PARTITION_EXPR_LENGTH (2048), so a short text whose stream exceeds
 * 2048 bytes (here v plus forty "+ 1" terms, about 170 characters) is
 * accepted, but the stored stream becomes NULL. On a debug build the first
 * INSERT or SELECT then aborts in partition_load_partition_predicate()
 * (assert on DB_TYPE_CHAR).
 * Fix (CUBRID/cubrid PR 7858): the stream is stored as VARCHAR, and
 * do_create_partition() now also fails when an error was set while building
 * the partition info.
 *
 * The key expression is v + 40 in every case, so the partition a row lands
 * in is fully determined by hand and checked per partition.
 *
 * Coverage:
 * 1 - RANGE partition on the long expression: INSERT routes rows on both
 *     sides of the boundary (v = 59 -> 99 -> p0, v = 60 -> 100 -> p1).
 * 2 - SELECT with = and BETWEEN predicates on the same table.
 * 3 - UPDATE that moves a row from p0 to p1.
 *     3-1: REORGANIZE PARTITION p0 into p0a/p0b redistributes the rows with
 *     the stored key expression (59 -> 99 -> p0b, p0a empty).
 * 4 - LIST partition on the long expression; a value with no partition
 *     expects an error.
 *     4-1: ADD PARTITION p2 (45) copies the stored key expression, so v = 5
 *     is now accepted into p2.
 * 5 - HASH partition on the long expression: every row is stored and found.
 *     5-1: ADD PARTITION PARTITIONS 2 re-hashes the rows with the stored key
 *     expression: every row is still stored once and found.
 * 6 - ALTER TABLE ... PARTITION BY RANGE on the long expression for a table
 *     that already has rows (the do_create_partition path).
 */

DROP TABLE IF EXISTS t_part;
CREATE TABLE t_part (v INT)
PARTITION BY RANGE (v + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1) (
  PARTITION p0 VALUES LESS THAN (100),
  PARTITION p1 VALUES LESS THAN MAXVALUE
);

evaluate 'Case 1: RANGE partition with a long key expression routes rows by v + 40';
INSERT INTO t_part VALUES (1), (59), (60), (200);
SELECT 'p0' AS part, v FROM t_part__p__p0
UNION ALL
SELECT 'p1' AS part, v FROM t_part__p__p1
ORDER BY 1, 2;

evaluate 'Case 2: SELECTs with predicates on the RANGE table return the right rows';
SELECT v FROM t_part WHERE v = 1;
SELECT v FROM t_part WHERE v = 60;
SELECT v FROM t_part WHERE v BETWEEN 50 AND 70 ORDER BY v;

evaluate 'Case 3: UPDATE moves v = 1 to v = 70, from p0 to p1';
UPDATE t_part SET v = 70 WHERE v = 1;
SELECT 'p0' AS part, v FROM t_part__p__p0
UNION ALL
SELECT 'p1' AS part, v FROM t_part__p__p1
ORDER BY 1, 2;

evaluate 'Case 3-1: REORGANIZE PARTITION p0 into p0a/p0b redistributes the rows with the stored key expression';
ALTER TABLE t_part REORGANIZE PARTITION p0 INTO (
  PARTITION p0a VALUES LESS THAN (80),
  PARTITION p0b VALUES LESS THAN (100)
);
SELECT 'p0a' AS part, v FROM t_part__p__p0a
UNION ALL
SELECT 'p0b' AS part, v FROM t_part__p__p0b
UNION ALL
SELECT 'p1' AS part, v FROM t_part__p__p1
ORDER BY 1, 2;

evaluate 'Case 4: LIST partition with a long key expression; v = 5 has no partition (expects an error)';
DROP TABLE IF EXISTS t_list;
CREATE TABLE t_list (v INT)
PARTITION BY LIST (v + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1) (
  PARTITION p0 VALUES IN (41, 42),
  PARTITION p1 VALUES IN (43, 44)
);
INSERT INTO t_list VALUES (1), (2), (3), (4);
INSERT INTO t_list VALUES (5);
SELECT 'p0' AS part, v FROM t_list__p__p0
UNION ALL
SELECT 'p1' AS part, v FROM t_list__p__p1
ORDER BY 1, 2;
SELECT v FROM t_list WHERE v = 3;

evaluate 'Case 4-1: ADD PARTITION copies the stored key expression, v = 5 (-> 45) now lands in p2';
ALTER TABLE t_list ADD PARTITION (PARTITION p2 VALUES IN (45));
INSERT INTO t_list VALUES (5);
SELECT 'p0' AS part, v FROM t_list__p__p0
UNION ALL
SELECT 'p1' AS part, v FROM t_list__p__p1
UNION ALL
SELECT 'p2' AS part, v FROM t_list__p__p2
ORDER BY 1, 2;

evaluate 'Case 5: HASH partition with a long key expression stores and finds every row';
DROP TABLE IF EXISTS t_hash;
CREATE TABLE t_hash (v INT)
PARTITION BY HASH (v + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1) PARTITIONS 3;
INSERT INTO t_hash VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9);
SELECT (SELECT COUNT (*) FROM t_hash__p__p0) + (SELECT COUNT (*) FROM t_hash__p__p1)
       + (SELECT COUNT (*) FROM t_hash__p__p2) AS stored_rows;
SELECT v FROM t_hash WHERE v = 5;
SELECT v FROM t_hash WHERE v IN (2, 8) ORDER BY v;

evaluate 'Case 5-1: ADD PARTITION PARTITIONS 2 re-hashes the rows with the stored key expression';
ALTER TABLE t_hash ADD PARTITION PARTITIONS 2;
SELECT (SELECT COUNT (*) FROM t_hash__p__p0) + (SELECT COUNT (*) FROM t_hash__p__p1)
       + (SELECT COUNT (*) FROM t_hash__p__p2) + (SELECT COUNT (*) FROM t_hash__p__p3)
       + (SELECT COUNT (*) FROM t_hash__p__p4) AS stored_rows;
SELECT v FROM t_hash WHERE v = 5;
SELECT v FROM t_hash WHERE v IN (2, 8) ORDER BY v;

evaluate 'Case 6: ALTER TABLE PARTITION BY RANGE with a long key expression on a table with rows';
DROP TABLE IF EXISTS t_alter;
CREATE TABLE t_alter (v INT);
INSERT INTO t_alter VALUES (10), (59), (60), (90);
ALTER TABLE t_alter PARTITION BY RANGE (v + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1) (
  PARTITION p0 VALUES LESS THAN (100),
  PARTITION p1 VALUES LESS THAN MAXVALUE
);
SELECT 'p0' AS part, v FROM t_alter__p__p0
UNION ALL
SELECT 'p1' AS part, v FROM t_alter__p__p1
ORDER BY 1, 2;
SELECT v FROM t_alter WHERE v = 60;

DROP TABLE t_alter;
DROP TABLE t_hash;
DROP TABLE t_list;
DROP TABLE t_part;
