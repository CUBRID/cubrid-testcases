/**
 * This test case verifies CBRD-27216: REPEAT()'s result byte size must be
 * computed without int32 overflow, so an oversize result errors cleanly
 * instead of corrupting the heap. Cases are grouped by table.
 *
 * Coverage:
 * 1-3. repeat_overflow_t1 (multibyte, COLLATE utf8_bin - portable across
 *      branches): baseline, seed length, then the annotated issue repro.
 * 4-5. repeat_overflow_t1: the INT32_MAX byte-size boundary, one count
 *      below and one above.
 * 6-7. repeat_overflow_t2 (single-byte): same scale as Case 3 returns NULL
 *      (no byte-size overflow); a larger count overflows character length
 *      first, hitting the unrelated pre-existing guard instead.
 * 8-9. repeat_overflow_t3 (unannotated issue SQL): on this branch (11.4
 *      and below, iso88591 basicdb) each UTF-8 literal byte becomes its
 *      own char (seed is 3000 chars, not 1000), tripping the character-
 *      length guard instead of this fix's byte-size path - documentation,
 *      not a regression guard here (see Case 3 for that).
 */

DROP TABLE IF EXISTS repeat_overflow_t1;
CREATE TABLE repeat_overflow_t1 (id INT, s VARCHAR(4000) COLLATE utf8_bin, n INT);
INSERT INTO repeat_overflow_t1 VALUES (1, _utf8'가', 3);
INSERT INTO repeat_overflow_t1 VALUES (2, REPEAT(_utf8'가', 1000), 1431656);
INSERT INTO repeat_overflow_t1 VALUES (3, REPEAT(_utf8'가', 1000), 715827);
INSERT INTO repeat_overflow_t1 VALUES (4, REPEAT(_utf8'가', 1000), 715828);

evaluate 'Case 1: a small multibyte REPEAT through a column is unaffected by the fix';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 1;

evaluate 'Case 2: the multibyte seed is 1000 characters and 3000 bytes, as the later cases assume';
SELECT CHAR_LENGTH(s), OCTET_LENGTH(s) FROM repeat_overflow_t1 WHERE id = 2;

-- ERROR -1042: Trying to create a string requiring 4294968000 bytes of memory, while the maximum allowed is 1048576 bytes.
evaluate 'Case 3: annotated issue repro, portable across branches - multibyte byte-size overflow now errors';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 2;

evaluate 'Case 4: one below the INT32_MAX byte-size boundary stays within range and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 3;

-- ERROR -1042: Trying to create a string requiring 2147484000 bytes of memory, while the maximum allowed is 1048576 bytes.
evaluate 'Case 5: one above the INT32_MAX byte-size boundary now errors cleanly instead of wrapping negative';
SELECT REPEAT(s, n) FROM repeat_overflow_t1 WHERE id = 4;

DROP TABLE IF EXISTS repeat_overflow_t2;
CREATE TABLE repeat_overflow_t2 (id INT, s VARCHAR(4000) COLLATE iso88591_bin, n INT);
INSERT INTO repeat_overflow_t2 VALUES (1, REPEAT(_iso88591'a', 1000), 1431656);
INSERT INTO repeat_overflow_t2 VALUES (2, REPEAT(_iso88591'a', 1000), 2200000);

evaluate 'Case 6: same char length and count as Case 3, single-byte source has no byte-size overflow and returns NULL';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 1;

-- ERROR -1192: Value's precision of 2200000000 exceeds maximum allowed 2147483647
evaluate 'Case 7: single-byte at this count overflows character length first, never reaching the byte-size path';
SELECT REPEAT(s, n) FROM repeat_overflow_t2 WHERE id = 2;

-- CTP's SQL-category basicdb is created as utf8 on CUBRID 11.5+, which is
-- what makes the unannotated seed below multibyte there. On this branch
-- (11.4 and below) basicdb defaults to iso88591 instead, so the same
-- unannotated SQL is single-byte and does not reproduce the issue here.
DROP TABLE IF EXISTS repeat_overflow_t3;
CREATE TABLE repeat_overflow_t3 (s VARCHAR(4000), n INT);
INSERT INTO repeat_overflow_t3 VALUES (REPEAT('가', 1000), 1431656);

evaluate 'Case 8: the unannotated seed is 3000 characters and 3000 bytes here, not 1000 - see header';
SELECT CHAR_LENGTH(s), OCTET_LENGTH(s) FROM repeat_overflow_t3 WHERE n = 1431656;

-- ERROR -1192: Value's precision of 4294968000 exceeds maximum allowed 2147483647
evaluate 'Case 9: the issue exact SQL, unannotated, hits the character-length guard on this branchs iso88591 basicdb';
SELECT REPEAT(s, n) FROM repeat_overflow_t3 WHERE n = 1431656;

DROP TABLE IF EXISTS repeat_overflow_t1;
DROP TABLE IF EXISTS repeat_overflow_t2;
DROP TABLE IF EXISTS repeat_overflow_t3;
