/**
 * This test case verifies CBRD-27216: REPEAT()'s result byte size must be
 * computed without int32 overflow, so an oversize result errors cleanly
 * instead of corrupting the heap.
 *
 * Coverage:
 * 1. A small multibyte REPEAT through a column is unaffected by the fix.
 * 2. Asserts the multibyte seed's char/byte length the later cases rely on.
 * 3. The issue's literal repro: multibyte byte-size overflow now errors.
 * 4-5. The INT32_MAX byte-size boundary, one count below and one above.
 * 6.   Same char length and count as Case 3, single-byte source: no byte-
 *      size overflow, over the size limit instead, returns NULL.
 * 7.   Single-byte at a count large enough to overflow character length:
 *      errors on the unrelated, pre-existing character-length guard, never
 *      reaching the byte-size path this fix changed.
 */

DROP TABLE IF EXISTS repeat_overflow_t1;
DROP TABLE IF EXISTS repeat_overflow_t2;

CREATE TABLE repeat_overflow_t1 (id INT, s VARCHAR(4000) COLLATE utf8_bin, n INT);
CREATE TABLE repeat_overflow_t2 (id INT, s VARCHAR(4000) COLLATE iso88591_bin, n INT);

INSERT INTO repeat_overflow_t1 VALUES (1, _utf8'가', 3);
INSERT INTO repeat_overflow_t1 VALUES (2, REPEAT(_utf8'가', 1000), 1431656);
INSERT INTO repeat_overflow_t1 VALUES (3, REPEAT(_utf8'가', 1000), 715827);
INSERT INTO repeat_overflow_t1 VALUES (4, REPEAT(_utf8'가', 1000), 715828);
INSERT INTO repeat_overflow_t2 VALUES (1, REPEAT(_iso88591'a', 1000), 1431656);
INSERT INTO repeat_overflow_t2 VALUES (2, REPEAT(_iso88591'a', 1000), 2200000);

evaluate 'Case 1: a small multibyte REPEAT through a column is unaffected by the fix';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 1;

evaluate 'Case 2: the multibyte seed is 1000 characters and 3000 bytes, as the later cases assume';
SELECT CHAR_LENGTH(s), OCTET_LENGTH(s) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 3: literal issue repro - multibyte byte-size overflow now errors cleanly instead of crashing';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 4: one below the INT32_MAX byte-size boundary stays within range and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 3;

evaluate 'Case 5: one above the INT32_MAX byte-size boundary now errors cleanly instead of wrapping negative';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 4;

evaluate 'Case 6: same char length and count as Case 3, single-byte source has no byte-size overflow and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 1;

evaluate 'Case 7: single-byte at this count overflows character length first, never reaching the byte-size path';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 2;

DROP TABLE IF EXISTS repeat_overflow_t1;
DROP TABLE IF EXISTS repeat_overflow_t2;
