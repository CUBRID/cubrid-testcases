/**
 * This test case verifies CBRD-27216: REPEAT()'s result byte size must be
 * computed without int32 overflow, so an oversize result errors cleanly
 * instead of corrupting the heap. Cases are grouped by table.
 *
 * Coverage (repeat_overflow_t1 unless noted, all COLLATE utf8_bin/
 * iso88591_bin - portable across branches except t3):
 * 1-3.  baseline, seed length, then the annotated issue repro.
 * 4-5.  the INT32_MAX byte-size boundary, one count below/above.
 * 6-8.  count_i<=0 / src_length<=0 short-circuits before the size math -
 *       a regression here sends a negative count into the copy loop.
 * 9.    multibyte, both checks overflowing: character-length guard still
 *       reports first, unlike single-byte Case 11 where they coincide.
 * 10-11. repeat_overflow_t2 (single-byte): Case 3's scale returns NULL,
 *       a larger count hits the unrelated character-length guard instead.
 * 12-13. repeat_overflow_t3 (unannotated, develop's utf8 basicdb - not
 *       portable below 11.5, drop/re-answer when backporting): seed
 *       length, then the issue's exact SQL.
 */

DROP TABLE IF EXISTS repeat_overflow_t1;
CREATE TABLE repeat_overflow_t1 (id INT, s VARCHAR(4000) COLLATE utf8_bin, n INT);
INSERT INTO repeat_overflow_t1 VALUES (1, _utf8'가', 3);
INSERT INTO repeat_overflow_t1 VALUES (2, REPEAT(_utf8'가', 1000), 1431656);
INSERT INTO repeat_overflow_t1 VALUES (3, REPEAT(_utf8'가', 1000), 715827);
INSERT INTO repeat_overflow_t1 VALUES (4, REPEAT(_utf8'가', 1000), 715828);
INSERT INTO repeat_overflow_t1 VALUES (5, _utf8'', 1431656);
INSERT INTO repeat_overflow_t1 VALUES (6, REPEAT(_utf8'가', 1000), 2200000);

evaluate 'Case 1: a small multibyte REPEAT through a column is unaffected by the fix';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 1;

evaluate 'Case 2: the multibyte seed is 1000 characters and 3000 bytes, as the later cases assume';
SELECT CHAR_LENGTH(s), OCTET_LENGTH(s) FROM repeat_overflow_t1 WHERE id = 2;

-- ERROR -1042: Trying to create a string requiring 4294968000 bytes of memory, while the maximum allowed is 1048576 bytes.
evaluate 'Case 3: annotated issue repro, portable across branches - multibyte byte-size overflow now errors';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 4: one below the INT32_MAX byte-size boundary does not wrap, so it is rejected by the max-size guard and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 3;

-- ERROR -1042: Trying to create a string requiring 2147484000 bytes of memory, while the maximum allowed is 1048576 bytes.
evaluate 'Case 5: one above the INT32_MAX byte-size boundary now errors cleanly instead of wrapping negative';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 4;

evaluate 'Case 6: a zero count returns an empty string before reaching the size math';
SELECT CHAR_LENGTH(REPEAT(s, 0)) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 7: a negative count returns an empty string and never enters the copy loop';
SELECT CHAR_LENGTH(REPEAT(s, -1)) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 8: an empty seed returns an empty string regardless of the count';
SELECT CHAR_LENGTH(REPEAT(s, n)) FROM repeat_overflow_t1 WHERE id = 5;

-- ERROR -1192: Value's precision of 2200000000 exceeds maximum allowed 2147483647
evaluate 'Case 9: multibyte with both checks overflowing still reports the character length error first';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 6;

DROP TABLE IF EXISTS repeat_overflow_t2;
CREATE TABLE repeat_overflow_t2 (id INT, s VARCHAR(4000) COLLATE iso88591_bin, n INT);
INSERT INTO repeat_overflow_t2 VALUES (1, REPEAT(_iso88591'a', 1000), 1431656);
INSERT INTO repeat_overflow_t2 VALUES (2, REPEAT(_iso88591'a', 1000), 2200000);

evaluate 'Case 10: same char length and count as Case 3, single-byte source has no byte-size overflow and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 1;

-- ERROR -1192: Value's precision of 2200000000 exceeds maximum allowed 2147483647
evaluate 'Case 11: single-byte at this count overflows character length first, never reaching the byte-size path';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 2;

-- CTP's SQL-category basicdb is created as utf8 on CUBRID 11.5+, which is
-- what proves the base scenario below with no charset annotation at all.
-- On 11.4 and earlier basicdb defaults to iso88591 instead, so the same
-- unannotated SQL gives a different result there.
DROP TABLE IF EXISTS repeat_overflow_t3;
CREATE TABLE repeat_overflow_t3 (s VARCHAR(4000), n INT);
INSERT INTO repeat_overflow_t3 VALUES (REPEAT('가', 1000), 1431656);

evaluate 'Case 12: the unannotated seed is also 1000 characters and 3000 bytes on develops default utf8 basicdb';
SELECT CHAR_LENGTH(s), OCTET_LENGTH(s) FROM repeat_overflow_t3 WHERE n = 1431656;

-- ERROR -1042: Trying to create a string requiring 4294968000 bytes of memory, while the maximum allowed is 1048576 bytes.
evaluate 'Case 13: the issue exact SQL, unannotated, on develops default utf8 basicdb';
SELECT REPEAT(s, n) FROM repeat_overflow_t3 WHERE n = 1431656;

DROP TABLE IF EXISTS repeat_overflow_t1;
DROP TABLE IF EXISTS repeat_overflow_t2;
DROP TABLE IF EXISTS repeat_overflow_t3;
