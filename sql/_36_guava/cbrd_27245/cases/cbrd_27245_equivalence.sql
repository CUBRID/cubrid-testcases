/**
 * This test case verifies CBRD-27245: Improve lexer input handling for UTF-8 statements
 *
 * Coverage:
 * 1-3   - multilingual literals (Korean, Han/emoji, full-width space) with
 *         LENGTH/OCTET_LENGTH/CHARSET
 * 4     - multilingual and quoted/bracketed/backtick-quoted identifiers
 * 5-6   - quoting edge cases and special bytes (semicolon, comment markers)
 *         inside a string literal
 * 7-9   - multi-line literal, line comment, block comment (with quotes and
 *         multilingual text inside each)
 * 10    - two statements on one line
 */

DROP TABLE IF EXISTS tbl1;

evaluate 'Case 1: Korean string literal with LENGTH/OCTET_LENGTH/CHARSET';
SELECT '한글', LENGTH('한글'), OCTET_LENGTH('한글'), CHARSET('한글') FROM db_root;

evaluate 'Case 2: Han character and emoji (multi-byte UTF-8) literal';
SELECT '漢字', '😀', LENGTH('😀'), OCTET_LENGTH('😀') FROM db_root;

evaluate 'Case 3: full-width space literal, LENGTH vs OCTET_LENGTH';
SELECT '전각　공백', LENGTH('　'), OCTET_LENGTH('　') FROM db_root;

CREATE TABLE tbl1 (한글열 INT, "따옴표 열" INT, [대괄호열] INT, `역따옴표열` INT);
INSERT INTO tbl1 VALUES (1, 2, 3, 4);

evaluate 'Case 4: multilingual, double-quoted, bracketed, and backtick-quoted identifiers';
SELECT 한글열 AS 별칭한글, "따옴표 열", [대괄호열], `역따옴표열` FROM tbl1;

evaluate 'Case 5: doubled quote, empty string, embedded double quote';
SELECT '중복''따옴표', '', '문자열 안 " 큰따옴표' FROM db_root;

evaluate 'Case 6: semicolon and comment markers inside a string literal';
SELECT 'semi;colon 문자열', '-- 주석 아님', '/* 주석 아님 */' FROM db_root;

evaluate 'Case 7: multi-line string literal';
SELECT '여러
줄 문자열' FROM db_root;

evaluate 'Case 8: line comment containing a quote and multilingual text';
-- 줄 주석: '따옴표' 와 한글
SELECT 1 FROM db_root;

evaluate 'Case 9: block comment containing a quote and multilingual text';
/* 블록 주석: "따옴표" 와 한글 */
SELECT 1 FROM db_root;

evaluate 'Case 10: two statements on one line';
SELECT 1 FROM db_root; SELECT 2 FROM db_root;

DROP TABLE IF EXISTS tbl1;
