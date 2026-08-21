/**
 * This test case verifies CBRD-27216: REPEAT()'s result byte size must be
 * computed without int32 overflow, so an oversize result errors cleanly
 * instead of corrupting the heap.
 *
 * Coverage:
 * 1.   Small multibyte REPEAT through a column, unaffected by the fix.
 * 2,4. Assert the multibyte seeds' char/byte length the later cases assume.
 * 3.   Annotated (portable) issue repro: byte-size overflow now errors.
 * 5.   Same repro unannotated, on develop's default utf8 basicdb - not
 *      portable below 11.5 (iso88591 default there); drop or re-answer
 *      this case when backporting.
 * 6-7. The INT32_MAX byte-size boundary, one count below and one above.
 * 8.   Same scale, single-byte source: no byte-size overflow, NULL.
 * 9.   Single-byte at a count overflowing character length instead: hits
 *      the unrelated pre-existing guard, never reaching this fix's path.
 */

DROP TABLE IF EXISTS repeat_overflow_t1;
DROP TABLE IF EXISTS repeat_overflow_t2;
DROP TABLE IF EXISTS repeat_overflow_t3;

CREATE TABLE repeat_overflow_t1 (id INT, s VARCHAR(4000) COLLATE utf8_bin, n INT);
CREATE TABLE repeat_overflow_t2 (id INT, s VARCHAR(4000) COLLATE iso88591_bin, n INT);
CREATE TABLE repeat_overflow_t3 (s VARCHAR(4000), n INT);

INSERT INTO repeat_overflow_t1 VALUES (1, _utf8'가', 3);
INSERT INTO repeat_overflow_t1 VALUES (2, REPEAT(_utf8'가', 1000), 1431656);
INSERT INTO repeat_overflow_t1 VALUES (3, REPEAT(_utf8'가', 1000), 715827);
INSERT INTO repeat_overflow_t1 VALUES (4, REPEAT(_utf8'가', 1000), 715828);
INSERT INTO repeat_overflow_t2 VALUES (1, REPEAT(_iso88591'a', 1000), 1431656);
INSERT INTO repeat_overflow_t2 VALUES (2, REPEAT(_iso88591'a', 1000), 2200000);
INSERT INTO repeat_overflow_t3 VALUES (REPEAT('가', 1000), 1431656);

evaluate 'Case 1: a small multibyte REPEAT through a column is unaffected by the fix';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 1;

evaluate 'Case 2: the multibyte seed is 1000 characters and 3000 bytes, as the later cases assume';
SELECT CHAR_LENGTH(s), OCTET_LENGTH(s) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 3: annotated issue repro, portable across branches - multibyte byte-size overflow now errors';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 4: the unannotated seed is also 1000 characters and 3000 bytes on develops default utf8 basicdb';
SELECT CHAR_LENGTH(s), OCTET_LENGTH(s) FROM repeat_overflow_t3 WHERE n = 1431656;

evaluate 'Case 5: the issue exact SQL, unannotated, on develops default utf8 basicdb';
SELECT REPEAT(s, n) FROM repeat_overflow_t3 WHERE n = 1431656;

evaluate 'Case 6: one below the INT32_MAX byte-size boundary stays within range and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 3;

evaluate 'Case 7: one above the INT32_MAX byte-size boundary now errors cleanly instead of wrapping negative';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 4;

evaluate 'Case 8: same char length and count as Case 3, single-byte source has no byte-size overflow and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 1;

evaluate 'Case 9: single-byte at this count overflows character length first, never reaching the byte-size path';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 2;

DROP TABLE IF EXISTS repeat_overflow_t1;
DROP TABLE IF EXISTS repeat_overflow_t2;
DROP TABLE IF EXISTS repeat_overflow_t3;
