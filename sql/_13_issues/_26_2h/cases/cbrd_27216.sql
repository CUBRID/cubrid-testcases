/**
 * This test case verifies CBRD-27216: REPEAT()'s result byte size must be
 * computed without int32 overflow, so an oversize result errors cleanly
 * instead of corrupting the heap.
 *
 * Coverage:
 * 1. A small multibyte REPEAT through a column is unaffected by the fix.
 * 2. The issue's literal repro: multibyte byte-size overflow now errors.
 * 3. Same char length and count, single-byte source: stays within int32
 *    and returns NULL, matching why single-byte never reproduced this.
 */

DROP TABLE IF EXISTS repeat_overflow_t1;
DROP TABLE IF EXISTS repeat_overflow_t2;

CREATE TABLE repeat_overflow_t1 (id INT, s VARCHAR(4000) COLLATE utf8_bin, n INT);
CREATE TABLE repeat_overflow_t2 (id INT, s VARCHAR(4000) COLLATE iso88591_bin, n INT);

INSERT INTO repeat_overflow_t1 VALUES (1, _utf8'가', 3);
INSERT INTO repeat_overflow_t1 VALUES (2, REPEAT(_utf8'가', 1000), 1431656);
INSERT INTO repeat_overflow_t2 VALUES (1, REPEAT('a', 1000), 1431656);

evaluate 'Case 1: a small multibyte REPEAT through a column is unaffected by the fix';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 1;

evaluate 'Case 2: literal issue repro - multibyte byte-size overflow now errors cleanly instead of crashing';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 3: same char length and count, single-byte source has no byte-size overflow and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 1;

DROP TABLE IF EXISTS repeat_overflow_t1;
DROP TABLE IF EXISTS repeat_overflow_t2;
