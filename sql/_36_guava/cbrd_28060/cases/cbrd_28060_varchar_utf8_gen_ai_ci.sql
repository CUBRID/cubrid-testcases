/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A hash join, a hash GROUP BY, and a hash partition prune hash a string key with the hash
 *  function of its collation. The change hashes byte collations eight bytes at a time and makes
 *  the hash of every collation follow its comparison, so two keys that compare equal get one hash.
 *
 *  Each hash case is followed by a twin that skips the hash path - a nested loop join, a sort
 *  GROUP BY, or a table without partitions - and the two results must match row by row.
 *  SHOW TRACE shows the path that each hash case took. CTP masks the digits of a trace, so the
 *  answer checks only the path - HASHJOIN, hash true in GROUPBY, and one PARTITION line for each
 *  value of a prune case.
 *
 *  For utf8_gen_ai_ci, a loaded collation of the CTP database, ta, tb, and tc hold VARCHAR(40) keys
 *  with the case pairs, accents, expansions, and contractions that the collation compares as equal.
 *
 *  Coverage:
 *    Case 1:  hash join of ta and tb returns the pairs of the nested loop join
 *    Case 2:  hash GROUP BY on ta returns the groups of the sort GROUP BY
 *    Case 3:  tc prune per VARCHAR(40) constant reads one partition and matches ta
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server
-- The keys with trailing spaces compare as they do because of ignore_trailing_space=no,
-- the default of the CTP database

-- utf8_gen_ai_ci
DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(40) COLLATE utf8_gen_ai_ci);
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_gen_ai_ci);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE utf8_gen_ai_ci) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (2, CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (7, CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (11, CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (14, CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 15 to 24: the 8-byte chunks of the hash: a space or NUL inside the first chunk, right past it, and past two chunks
-- ca | cb                   | note
-- ---+----------------------+--------------------------------------
-- 15 | 'abcdefgh'           | 8 bytes, one full 8-byte chunk
-- 16 | 'abcdefgh '          | space as byte 9, past the first chunk
-- 17 | 'abcdefgh\0'         | NUL as byte 9, past the first chunk
-- 18 | 'abcdefgh \0'        | space and NUL past the first chunk
-- 19 | 'abcdefghi'          | 9 bytes
-- 20 | 'ABCDEFGHI'          | upper case of 'abcdefghi'
-- 21 | 'abc def gh'         | spaces inside the first chunk
-- 22 | 'abc\0def\0gh'       | NULs inside the first chunk
-- 23 | 'abcdefghijklmnop'   | 16 bytes, two full chunks
-- 24 | 'abcdefghijklmnop  ' | trailing spaces past two chunks
INSERT INTO ta VALUES
  (15, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (16, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (17, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (18, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (19, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (20, CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (21, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (22, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (23, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (24, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 25 to 30: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 25 | 'i'    |
-- 26 | 'I'    | upper case of 'i'
-- 27 | 'ss'   | expansion of sharp s (U+00DF)
-- 28 | 'e'    |
-- 29 | 'E'    | upper case of 'e'
-- 30 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (25, CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (26, CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (27, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (28, CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (29, CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (30, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 31 to 37: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+---------------------------------------------
-- 31 | '<U+0131>'  | dotless i (utf8_tr_cs case pair of I)
-- 32 | '<U+0130>'  | dotted capital I (utf8_tr_cs case pair of i)
-- 33 | '<U+00E9>'  | e acute, 2 bytes
-- 34 | '<U+00C9>'  | upper case of '<U+00E9>'
-- 35 | '<U+00DF>'  | sharp s, 2 bytes
-- 36 | 'a<U+00E9>' | ASCII then a 2-byte character
-- 37 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (31, CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (32, CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (33, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (34, CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (35, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (36, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (37, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 38 to 39: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
-- ca | cb           | note
-- ---+--------------+---------------------------
-- 38 | '<U+3000>'   | ideographic space, 3 bytes
-- 39 | 'a<U+3000>b' | U+3000 in the middle
INSERT INTO ta VALUES
  (38, CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (39, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 40 to 43: a 3-byte character followed by a space, a NUL or U+3000
-- ca | cb                 | note
-- ---+--------------------+----------------------------------------
-- 40 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 41 | '<U+AC00> '        | trailing space after a 3-byte character
-- 42 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 43 | '<U+AC00><U+3000>' | trailing U+3000
INSERT INTO ta VALUES
  (40, CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (41, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (42, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (43, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 44 to 48: an accent precomposed and decomposed, and sharp s against its expansion
-- ca | cb          | note
-- ---+-------------+--------------------------------------
-- 44 | '<U+00E9>'  | e acute, precomposed
-- 45 | 'e<U+0301>' | e, then combining acute accent U+0301
-- 46 | '<U+00DF>'  | sharp s
-- 47 | 'ss'        | expansion of sharp s
-- 48 | 'SS'        | upper case of 'ss'
INSERT INTO ta VALUES
  (44, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (45, CAST (CHR (101 USING utf8) || CHR (52353 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (46, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (47, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (48, CAST (CHR (83 USING utf8) || CHR (83 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 49 to 51: an accent and upper case in a word
-- ca | cb            | note
-- ---+---------------+-----------------------
-- 49 | 'cafe'        |
-- 50 | 'caf<U+00E9>' | e acute
-- 51 | 'CAF<U+00C9>' | upper case and E acute
INSERT INTO ta VALUES
  (49, CAST (CHR (99 USING utf8) || CHR (97 USING utf8) || CHR (102 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (50, CAST (CHR (99 USING utf8) || CHR (97 USING utf8) || CHR (102 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (51, CAST (CHR (67 USING utf8) || CHR (65 USING utf8) || CHR (70 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 52 to 58: weight 0 characters, soft hyphen U+00AD and zero width space U+200B, against nothing, a space and a NUL
-- ca | cb           | note
-- ---+--------------+-------------------------------
-- 52 | 'a<U+00AD>b' | soft hyphen in the middle
-- 53 | 'ab'         |
-- 54 | 'a<U+200B>b' | zero width space in the middle
-- 55 | 'a<U+200B>'  | trailing zero width space
-- 56 | '<U+200B>'   | a zero width space only
-- 57 | 'a b'        | space in the middle
-- 58 | 'a\0b'       | NUL in the middle
INSERT INTO ta VALUES
  (52, CAST (CHR (97 USING utf8) || CHR (49837 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (53, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (54, CAST (CHR (97 USING utf8) || CHR (14844043 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (55, CAST (CHR (97 USING utf8) || CHR (14844043 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (56, CAST (CHR (14844043 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (57, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (58, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 59 to 62: more accents, precomposed and decomposed
-- ca | cb          | note
-- ---+-------------+-----------------------------------
-- 59 | '<U+00E4>'  | a diaeresis, precomposed
-- 60 | 'a<U+0308>' | a, then combining diaeresis U+0308
-- 61 | '<U+00F1>'  | n tilde, precomposed
-- 62 | 'n<U+0303>' | n, then combining tilde U+0303
INSERT INTO ta VALUES
  (59, CAST (CHR (50084 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (60, CAST (CHR (97 USING utf8) || CHR (52360 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (61, CAST (CHR (50097 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (62, CAST (CHR (110 USING utf8) || CHR (52355 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 63 to 70: the expansions of ae and oe, in lower, upper and mixed case
-- ca | cb         | note
-- ---+------------+-----------------------
-- 63 | '<U+00E6>' | ae ligature
-- 64 | 'ae'       |
-- 65 | 'AE'       | upper case
-- 66 | '<U+00C6>' | upper case ae ligature
-- 67 | 'Ae'       | mixed case
-- 68 | '<U+0153>' | oe ligature
-- 69 | 'oe'       |
-- 70 | '<U+0152>' | upper case oe ligature
INSERT INTO ta VALUES
  (63, CAST (CHR (50086 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (64, CAST (CHR (97 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (65, CAST (CHR (65 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (66, CAST (CHR (50054 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (67, CAST (CHR (65 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (68, CAST (CHR (50579 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (69, CAST (CHR (111 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (70, CAST (CHR (50578 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 71 to 73: a ring above: precomposed, decomposed, and upper case
-- ca | cb          | note
-- ---+-------------+------------------------------------
-- 71 | '<U+00E5>'  | a ring, precomposed
-- 72 | 'a<U+030A>' | a, then combining ring above U+030A
-- 73 | '<U+00C5>'  | upper case a ring
INSERT INTO ta VALUES
  (71, CAST (CHR (50085 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (72, CAST (CHR (97 USING utf8) || CHR (52362 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (73, CAST (CHR (50053 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 74 to 77: accents on the second and the last letter of a word, and upper case without accents
-- ca | cb                   | note
-- ---+----------------------+-------------------------
-- 74 | 'c<U+00F4>t<U+00E9>' | o circumflex and e acute
-- 75 | 'c<U+00F4>te'        | o circumflex only
-- 76 | 'cot<U+00E9>'        | e acute only
-- 77 | 'COTE'               | upper case, no accent
INSERT INTO ta VALUES
  (74, CAST (CHR (99 USING utf8) || CHR (50100 USING utf8) || CHR (116 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (75, CAST (CHR (99 USING utf8) || CHR (50100 USING utf8) || CHR (116 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (76, CAST (CHR (99 USING utf8) || CHR (111 USING utf8) || CHR (116 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (77, CAST (CHR (67 USING utf8) || CHR (79 USING utf8) || CHR (84 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 78 to 80: sharp s in a word against its upper case expansion, and a space before an accent
-- ca | cb              | note
-- ---+-----------------+-----------------------
-- 78 | 'stra<U+00DF>e' | sharp s in a word
-- 79 | 'STRASSE'       | upper case expansion
-- 80 | 'a <U+00E9>'    | a space before e acute
INSERT INTO ta VALUES
  (78, CAST (CHR (115 USING utf8) || CHR (116 USING utf8) || CHR (114 USING utf8) || CHR (97 USING utf8) || CHR (50079 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (79, CAST (CHR (83 USING utf8) || CHR (84 USING utf8) || CHR (82 USING utf8) || CHR (65 USING utf8) || CHR (83 USING utf8) || CHR (83 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (80, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 81 to 86: punctuation in the middle, at the start and at the end
-- ca | cb     | note
-- ---+--------+----------------
-- 81 | 'a-b'  | hyphen
-- 82 | 'a_b'  | underscore
-- 83 | 'a''b' | apostrophe
-- 84 | '-a'   | leading hyphen
-- 85 | 'a-'   | trailing hyphen
-- 86 | 'a.b'  | period
INSERT INTO ta VALUES
  (81, CAST (CHR (97 USING utf8) || CHR (45 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (82, CAST (CHR (97 USING utf8) || CHR (95 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (83, CAST (CHR (97 USING utf8) || CHR (39 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (84, CAST (CHR (45 USING utf8) || CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (85, CAST (CHR (97 USING utf8) || CHR (45 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (86, CAST (CHR (97 USING utf8) || CHR (46 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 87 to 92: Khmer: a consonant, a vowel sign, the coeng sign that joins two consonants, and a hyphen between consonants
-- ca | cb                         | note
-- ---+----------------------------+------------------------------
-- 87 | '<U+1780>'                 | KA
-- 88 | '<U+1780><U+17B6>'         | KA, then vowel sign AA
-- 89 | '<U+1780><U+17D2><U+1780>' | KA, coeng, KA: a subscript KA
-- 90 | '<U+1781>'                 | KHA
-- 91 | '<U+1780>-<U+1780>'        | KA, hyphen, KA
-- 92 | '<U+1780><U+1780>'         | KA twice
INSERT INTO ta VALUES
  (87, CAST (CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (88, CAST (CHR (14786176 USING utf8) || CHR (14786230 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (89, CAST (CHR (14786176 USING utf8) || CHR (14786450 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (90, CAST (CHR (14786177 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (91, CAST (CHR (14786176 USING utf8) || CHR (45 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (92, CAST (CHR (14786176 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

-- 93 to 94: U+03A9 and U+2126, which differ only at level 4
-- ca | cb         | note
-- ---+------------+--------------------
-- 93 | '<U+03A9>' | Greek capital omega
-- 94 | '<U+2126>' | ohm sign
INSERT INTO ta VALUES
  (93, CAST (CHR (52905 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)),
  (94, CAST (CHR (14845094 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci));

INSERT INTO tb SELECT * FROM ta;
INSERT INTO tc SELECT * FROM ta;

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

evaluate 'Case 1: hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from ta x, tb y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from ta x, tb y where x.cb = y.cb order by 1, 2;

evaluate 'Case 2: hash GROUP BY on ta returns the groups of the sort GROUP BY';
set trace on;
select min(ca), count(*) from ta group by cb order by 1, 2;
show trace;
set trace off;
select /*+ no_hash_aggregate */ min(ca), count(*) from ta group by cb order by 1, 2;

evaluate 'Case 3: tc prune per VARCHAR(40) constant reads one partition and matches ta';
set trace on;
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 34 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 35 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 36 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 37 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 38 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 39 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 40 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 41 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 42 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 43 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 44 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 45 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (101 USING utf8) || CHR (52353 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (101 USING utf8) || CHR (52353 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 46 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 47 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 48 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (83 USING utf8) || CHR (83 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (83 USING utf8) || CHR (83 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 49 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (99 USING utf8) || CHR (97 USING utf8) || CHR (102 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (99 USING utf8) || CHR (97 USING utf8) || CHR (102 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 50 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (99 USING utf8) || CHR (97 USING utf8) || CHR (102 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (99 USING utf8) || CHR (97 USING utf8) || CHR (102 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 51 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (67 USING utf8) || CHR (65 USING utf8) || CHR (70 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (67 USING utf8) || CHR (65 USING utf8) || CHR (70 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 52 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (49837 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (49837 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 53 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 54 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (14844043 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (14844043 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 55 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (14844043 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (14844043 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 56 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14844043 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14844043 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 57 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 58 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 59 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50084 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50084 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 60 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (52360 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (52360 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 61 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50097 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50097 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 62 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (110 USING utf8) || CHR (52355 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (110 USING utf8) || CHR (52355 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 63 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50086 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50086 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 64 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 65 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 66 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50054 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50054 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 67 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 68 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50579 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50579 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 69 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (111 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (111 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 70 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50578 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50578 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 71 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50085 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50085 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 72 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (52362 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (52362 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 73 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50053 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50053 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 74 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (99 USING utf8) || CHR (50100 USING utf8) || CHR (116 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (99 USING utf8) || CHR (50100 USING utf8) || CHR (116 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 75 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (99 USING utf8) || CHR (50100 USING utf8) || CHR (116 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (99 USING utf8) || CHR (50100 USING utf8) || CHR (116 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 76 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (99 USING utf8) || CHR (111 USING utf8) || CHR (116 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (99 USING utf8) || CHR (111 USING utf8) || CHR (116 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 77 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (67 USING utf8) || CHR (79 USING utf8) || CHR (84 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (67 USING utf8) || CHR (79 USING utf8) || CHR (84 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 78 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (115 USING utf8) || CHR (116 USING utf8) || CHR (114 USING utf8) || CHR (97 USING utf8) || CHR (50079 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (115 USING utf8) || CHR (116 USING utf8) || CHR (114 USING utf8) || CHR (97 USING utf8) || CHR (50079 USING utf8) || CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 79 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (83 USING utf8) || CHR (84 USING utf8) || CHR (82 USING utf8) || CHR (65 USING utf8) || CHR (83 USING utf8) || CHR (83 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (83 USING utf8) || CHR (84 USING utf8) || CHR (82 USING utf8) || CHR (65 USING utf8) || CHR (83 USING utf8) || CHR (83 USING utf8) || CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 80 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 81 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (45 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (45 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 82 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (95 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (95 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 83 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (39 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (39 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 84 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (45 USING utf8) || CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (45 USING utf8) || CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 85 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (45 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (45 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 86 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (46 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (46 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 87 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 88 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14786176 USING utf8) || CHR (14786230 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14786176 USING utf8) || CHR (14786230 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 89 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14786176 USING utf8) || CHR (14786450 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14786176 USING utf8) || CHR (14786450 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 90 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14786177 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14786177 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 91 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14786176 USING utf8) || CHR (45 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14786176 USING utf8) || CHR (45 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 92 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14786176 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14786176 USING utf8) || CHR (14786176 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 93 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (52905 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (52905 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
  UNION ALL
  SELECT 94 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14845094 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14845094 USING utf8) AS VARCHAR(40) COLLATE utf8_gen_ai_ci)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- cleanup
set trace off;

drop table if exists ta, tb, tc;
