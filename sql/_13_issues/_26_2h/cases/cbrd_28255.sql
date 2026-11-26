/**
 *  This test case verifies CBRD-28255: a multi-column index key that holds the long DEFAULT of a column added by
 *  ADD COLUMN overflowed its buffer, and the server crashed or kept wrong keys
 *
 *  ADD COLUMN with a constant DEFAULT does not rewrite the rows that the table already has, and a key built from
 *  such a row takes the default value of the column. The key buffer was sized by the length of the row, which
 *  holds neither that default value nor the key header, whose size grows with the number of key columns. A key
 *  longer than 4KB from a row of 4KB or less then overflowed a 4KB stack buffer, and a key from a longer row
 *  overflowed a heap buffer of the length of the row. The fix adds the key header and the default values that
 *  the row does not hold to the size.
 *  Each case reads the keys of the indexes through covering index scans and the rows through a heap scan, and
 *  the two print the same values. Before the fix, the keys that Case 1 read held a default value cut short
 *  and changed, and CREATE INDEX of Case 2 crashed the server.
 *
 *  Coverage:
 *    Case 1:  CREATE INDEX on (c, id) keeps the whole default value of c in the keys of the rows without c
 *    Case 2:  CREATE INDEX on (c, v, id) keeps it next to 896 bytes of v
 *    Case 3:  CREATE INDEX on (id, c) WITH ONLINE keeps it
 *    Case 4:  CREATE INDEX on (c, c2, id) keeps both default values for rows without c and c2 and for a row of
 *             more than 4KB without c2
 *    Case 5:  UPDATE of rows without c keeps every index equal to the rows
 *    Case 6:  DELETE of a row without c keeps every index equal to the rows
 *    Case 7:  ADD FOREIGN KEY over child rows without c accepts them
 *    Case 8:  DELETE of a parent row ON DELETE CASCADE deletes its child row without c
 *    Case 9:  DELETE of a parent row ON DELETE SET NULL sets the key of its child row without c to NULL
 *    Case 10: CREATE INDEX on 60 SMALLINT columns and v keeps the keys that the key header makes longer than 4KB
 *             for rows of 4KB or less
 */
DROP TABLE IF EXISTS t28255, p28255, t28255_wide;

-- Rows 1 to 6 come before ADD COLUMN c, so they hold neither c nor c2: their keys take the default values.
-- Rows 3 and 4 hold 896 bytes of v, and rows 5 and 6 stay as they are until Case 8 and Case 9.
CREATE TABLE t28255 (id INT, v VARCHAR(1000));
INSERT INTO t28255 VALUES (1, 'small'), (2, 'small'), (5, 'small'), (6, 'small');
INSERT INTO t28255 VALUES (3, SHA2 ('t28255 3 1', 512) || SHA2 ('t28255 3 2', 512) || SHA2 ('t28255 3 3', 512) || SHA2 ('t28255 3 4', 512) || SHA2 ('t28255 3 5', 512) || SHA2 ('t28255 3 6', 512) || SHA2 ('t28255 3 7', 512));
INSERT INTO t28255 VALUES (4, SHA2 ('t28255 4 1', 512) || SHA2 ('t28255 4 2', 512) || SHA2 ('t28255 4 3', 512) || SHA2 ('t28255 4 4', 512) || SHA2 ('t28255 4 5', 512) || SHA2 ('t28255 4 6', 512) || SHA2 ('t28255 4 7', 512));
-- 4,200 random letters and digits, which LZ4 does not shrink: the key of a row without c is about 4,200 bytes
-- and the row about 40 bytes, or about 940 bytes for rows 3 and 4.
ALTER TABLE t28255 ADD COLUMN c VARCHAR(6000) DEFAULT
'dlYohxmYTzAOJbAzY276CTbiqVthsSwSaPycmQmCAznYuNnMXGjNt8CJFVMYbNyN19NEhqWnD8bCcLDygrnMTaOAnAz1bSJNvuAI'
'9EnNQlIZowEn0HcDeiMy4RVlcRDmdACBFpVtwseTrTfCjMoIVgofyGhZzplMyl2ovhBoXEDwg9hYkDYP4Pjj3ViQHsEbt453PV9h'
'wrEhRAIjGLG3abmAT43Y5v7XWT6QVQ0AvxM0NQxm0Wxxc7me20ZAvKTGujoYxD03uw6TahRXqCF1K4aLBr8lz7P8aQ6iBciiG9mC'
'CPhSaq8MksPk4towebYFQqs7uWtvB4tNy4I6Y0vu64Sbw7yx72hDxOlFJ8gMqGziHOyUGxFvx0xVuczdonrDNz3KQ7wlP3KHJyBB'
'XycwDehL2ibS5huhVm5RgmzGnJ0NBbM7cYwYw8fJEzCNphWCBUQcsEWFF0757DgMUuQDZxb2fiqbSNDhFNC7T7yGtaEexLOkzBMK'
'P699bgcoFhsHQQT5Ol1e4Vw2gd8JsP4J2ygsMHQ8SrwnRgifhgJ8q7yA4xYxrRG3Ub4jucdY6S8ka3VnY8TsKpLtNNAt5YIrC7Rj'
'AywVI18CEFjiagllCJy4TzelfHwAa117W3C1GkEsDLhEf2fOyms1MFtUUParUPINbJZs6qrhgVuggH1IXBGsqSxyLIzwqONDwj4K'
'VPjz3qC8Jt0RQxAS7lccQJfVKeNd3m9Xr6ij2vTMcUHTKElQjeB55LDru8WnaDMrQCrIOqralQj55q6e2JIos03EjHeVWUtMRxea'
'GiDifXNqpy2jtOsyeMdj5eyHMems0veHDuO7SZ92x6pXCWHLAWO0XKMnJt4WadmAzJXBmorm7otM4SVWZdfu3iXrB8RX2tsPKwTk'
'KzMVXj7csSHA9Z6FG0XuxDLcv9K21OnA35HI7lXGbxOcJMzKmugAGkregSGGzIFuEfSc3sCeDLoFGVU517FIgPcg7Ks8uS34gTl3'
'cXlOpQQvYBhr0Xlif3rKyJTCgiaCQukPkqUqvsta2JD12DFTM4acl8eEbEU80X8qeo8vZF1Vsmd3wErZgdEAwlAHc8O8zmmdIBeN'
'o74UaIgHZbnrsWXuzOpRc6ZeE3ecFi7CRSdiAnFUGQe7s6yhOyUSuF3HcBPulp82HaDTb0f5mDfJRlJ9kEFt4iVig0mo7dNnZtRv'
'FDSfbykbRSrDzUWqfDdkHCqJXGnTnwJfzdcfWWFxgHyED2v65Z0S4d6aAaXEmB4oDjoK1sNVCUQDCgCAid332Nycw48xWPYNkMwM'
'SPMuSTD28K7VtJXbcJI36pXYU4TB9N0KbEQ3tGXl1Ex7uzH18nDhPZNcqrXtzbVIpjCoT8JRxWlCIOJURFam2FP4S51Bu1e5QwL2'
'5L6uYyqOZw1MoqoOZvrHmrjgNEtWGktgiyRJJe9YNaQwx5Af3pPXyUkyDezobLOaLlVhfVjbNaLaYJ3iIjJRxdZqvdGGTD7x1yj7'
'OkFlO35lsLNmnNY7RJXPC4VzK8iJzlSriVsmfp8gsQyiF7Xexz7ZJVzHXRt3hiHwQWZDb7mv9IGm0f83MVGf7dpvLmbKEUq0i8uj'
'53Xci26p6y5PLlUqqU1dMc469M1aWCTlaxxh9JdA1ZQfmvMKdjBB4E5DTHTbi8TPmV4CRAvciTWnKZR8sT1coEKYNbgT0xWw2YH3'
'Bqf9bpTTFFIvMZ7nKnWQCMurwPKg5qhTRFQOrDlMDfAGHOeZKg4pkRSYOfZjO0j24Oe5Xqo2Cz9yOqHxxduoVoMwcLLPW12Oit5L'
'GdGY7UMCgjLGTRngxm0efgBjCk5WCtUJs4k4hk7rKS2ZyTuUPAPiK1wXJsUmQyqGwwxp151QDEFABQHErcAJYbylk9eLOYeyuBNk'
'dPGtavmifUqnA50RE5SbDUxFPvhQSzyP5guwxvLadoyemVILyQm6bTDjDPQXZew7H52TZdOqTSptdctgCaiMRrKZ0BkkSP7eW5lp'
'2Vaeiw3EPAbSokyK7lE9hmR7yM6nXtIjgHCWbUy3LF0B8kuMOq3GwkLhBSXdhquSJOcnIibwRibTzxkQ42MM2OEDwkXq5flbYVLA'
'VRcdCMA0PRsWtLnhWzThLXftzEyFpklWg1AcNEMJYIIsrHIfyRlLAzo8XnrJUN5lAL5Jts6w80hqfz0ZEVrUZGAb70ROhdrMrGyf'
'iYUEKFcQeMDRJTTMTz0gLoPcNQPTkDtdPLfcv58trmsGUz71zewB8BeIV0a4GNVZ4kmv1z3G6a48W47AGdLfhIW1yHKbJ1QXc9ja'
'TWMcknfYW2KjAVbb74SPxEgE3mr0FfUSkuPMJIshM5Mz78oUnySwT7suqpQn9AbZLCl2gdUyPS6xH5Bey8hRFAwQgCLlxasqAFfw'
'hEESZWQMsw2meej50X2sBBbem45KSQI9buFOBHuFjU6sEdohqP11EGPZ5VdmKDADnaZxe2p32Q5vPEMW4mmgc6qK1qLYWMfnVEMa'
'l2n7wVfJTeQy1z5gcgJDBbGsKNcnJQnRwvhQuYuE2Yt5G4BcWPSA20iZ0YOfFl77zcPkrpq9QrbgqFBgfA25z8BnpFBjEhal8MPM'
'rWtK6YvestEquBwj2aJMpyYyCulS09d7PgHtEirghOT0aIhMAkl4tpxPZLSkJIMQ0C38DNyoeVFjbcUgpOpiESoGHElAe7GB4Pwj'
'dDcsBcKYalmiXimGaUf1qYL6BSIz9dcwJ43pTPmNQw1xFUmY7UMlXn7mRjOCEeCS73yiunElAh5EzaikGRjAYzJO6eGA0viF7jVn'
'8MeFSC8eWrLu1togbJgrVJkfb6vYwDzkEX8A2tWGLA0ZbxQ36TZdVmTYkkWwh5I4yNHLqR4VgrGq2jFDCrxwOwFEGnWVLNLamjUk'
'B964aEhOejuRYWUSd2YDFLJogR06DzoIyIxB7SEmMPO7kRaFYC72agtkYHX6JByqQbMeTdJToNKhcveDKbXfS2ZDlpI9ZJltRtts'
'XEfIVowmdlYEveCILN0WXzcnYqsW01SauY8j6hfbaYhIeix4YJdB0Ii5EST49zwldej1IOKDUaEJFQ2y2CyxC4mCmlcnb9NQjW6F'
'PoxPHEBtmchSyiMJejGxfw0QFe6XWyLDLgb6BSXVIdR1gWEQ3cJLGGHsrpOlKW8qTIJAaxDqEnVZfdleuOl2sloTY5TOTPzvqjhY'
'whQfe6HnX7j0PY10QBBLl08ryjgXWLH0nKetsAVFiL6hbFnAL0UIymgeaLphdDvlCTvz5LYF9HWj83XR2AMDmty2c5Dl2qjORWEP'
'Y0kbRgS5tBkqS78ieX0eLr4GzRD5ITzSF0vy6sFGRNvftV9VnobjJmtLqdnuK0MFh2vHIEMtvsRYuUHH6C1vlJeH8gainkTDLVBW'
'dkcexSKj20V1RGstK0D59BEKy3fzxCsJO7A1KmLGwpWkuBTN9wEZ9wZ5P3c0MmCdii6cyeRSfGLlZ0Q1CuXmAYqVu6Tfz0c0R9Sz'
'x5B67QNrsYQ3Wkjr08aYgukIRv12kOEC7uOGki7YIs8Qc4ITql6rDZBaIpTLSH3xihaXlKAtyCFoHBW2bqXRpBPtiNSILKB3lk2C'
'4kyHbb0bu1eohRSFwj9ssUUMo79s76fE2qFhqF7nXf2yjxKXuNwRZY9vlsylkIthK6xl9rArT5QJMPA4SO6p2Pjn1UGw2FQPErkd'
'fbj6xHGsaj2yKlYZz49vn1dthGK7dINp8Dw1sqhy2GNuUTTkMo269wY3SqdLXWH86ROsU59BbL8ipBEMpAVCep3iX4ljOt2KNmE4'
'U7jTCEb6Nqgi5bomkCxuolr9vpopfXrTuDTM7HptuBPqKocg5G8vICEtYmZVN5fRNNAeLCAqvf67CtZQ8lL4U4k0qYMRWriH4S65'
'5xP3R0hHkuDnysRlVLrZsUepT5Da29TSoTCTe6JeYN25BJlN576xPMX8tfzL777Ll1iFdfkHB6noU2CoFcrTWor6DHSfx51h8a8Y'
'qdtGS7sA4qhEbNfcHKiBLiovCd5fMOWj9L8sU4yplOFyvBqnRBmng0m9YmvLU9IbIC0LQuX1ckIDENSKQ6txwdlfDVOHhq9pZh8d'
'f7PzCNjS4Zly3raVaGQYYCZDgyaHbzWwzXqfR0g0RLQWBfKpZ0BAXBcyaJ0DGNZh0cmV2huQMTrdVMkKEl28I932lctdtN5ZFeT8';
-- Row 7 holds c, so the row takes more than 4KB, and its key on (c, c2, id) takes c2 as well.
INSERT INTO t28255 (id, v) VALUES (7, 'small');
-- 300 random letters and digits
ALTER TABLE t28255 ADD COLUMN c2 VARCHAR(1000) DEFAULT
'hwVNjI4oDZ8mT7fL2ZZHtLr2exl3WCPT61qEU3C6DWa4P9yWPgA11B3TMLUsJqwa19XnIAyTSvvjJV7lAP2FeThinXoFa1LrZ0OW'
'HAfjtqiVNOMUEHDr74O0FdnNDfF1IThK2AyQawfNWzM4V8PsOO3dAAS0CiRciSJJONXm74Z9bee8umkH9Cm3k4vRW2VX7YycZCa2'
'GUDq2KXDfCj3ysP7Y2PW0bKLhKxi0TaRkNjlBUPeSmdyz3TpKANFTg8uWZbOZG8PVxSHGbwt0vz487YLFId9I9405MSmwmNHRwqL';

evaluate 'Case 1: CREATE INDEX on (c, id) keeps the whole default value of c in the keys of the rows without c';
CREATE INDEX i28255_c_id ON t28255 (c, id);
--@queryplan
SELECT id, CHAR_LENGTH (c), MD5 (c) FROM t28255 WHERE c > '' USING INDEX i28255_c_id(+) ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c), CHAR_LENGTH (v), MD5 (v), CHAR_LENGTH (c2), MD5 (c2) FROM t28255 USING INDEX NONE ORDER BY id;

evaluate 'Case 2: CREATE INDEX on (c, v, id) keeps it next to 896 bytes of v';
CREATE INDEX i28255_c_v ON t28255 (c, v, id);
--@queryplan
SELECT id, MD5 (c), MD5 (v) FROM t28255 WHERE c > '' USING INDEX i28255_c_v(+) ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c), CHAR_LENGTH (v), MD5 (v), CHAR_LENGTH (c2), MD5 (c2) FROM t28255 USING INDEX NONE ORDER BY id;

evaluate 'Case 3: CREATE INDEX on (id, c) WITH ONLINE keeps it';
CREATE INDEX i28255_id_c ON t28255 (id, c) WITH ONLINE;
--@queryplan
SELECT id, MD5 (c) FROM t28255 WHERE id > 0 USING INDEX i28255_id_c(+) ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c), CHAR_LENGTH (v), MD5 (v), CHAR_LENGTH (c2), MD5 (c2) FROM t28255 USING INDEX NONE ORDER BY id;

evaluate 'Case 4: CREATE INDEX on (c, c2, id) keeps both default values, also for a row of more than 4KB without c2';
CREATE INDEX i28255_c_c2 ON t28255 (c, c2, id);
--@queryplan
SELECT id, MD5 (c), MD5 (c2) FROM t28255 WHERE c > '' USING INDEX i28255_c_c2(+) ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c), CHAR_LENGTH (v), MD5 (v), CHAR_LENGTH (c2), MD5 (c2) FROM t28255 USING INDEX NONE ORDER BY id;

evaluate 'Case 5: UPDATE of rows without c keeps every index equal to the rows';
UPDATE t28255 SET id = id + 10 WHERE id IN (2, 4);
SELECT id, CHAR_LENGTH (c), MD5 (c) FROM t28255 WHERE c > '' USING INDEX i28255_c_id(+) ORDER BY id;
SELECT id, MD5 (c), MD5 (v) FROM t28255 WHERE c > '' USING INDEX i28255_c_v(+) ORDER BY id;
SELECT id, MD5 (c) FROM t28255 WHERE id > 0 USING INDEX i28255_id_c(+) ORDER BY id;
SELECT id, MD5 (c), MD5 (c2) FROM t28255 WHERE c > '' USING INDEX i28255_c_c2(+) ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c), CHAR_LENGTH (v), MD5 (v), CHAR_LENGTH (c2), MD5 (c2) FROM t28255 USING INDEX NONE ORDER BY id;

evaluate 'Case 6: DELETE of a row without c keeps every index equal to the rows';
DELETE FROM t28255 WHERE id = 1;
SELECT id, CHAR_LENGTH (c), MD5 (c) FROM t28255 WHERE c > '' USING INDEX i28255_c_id(+) ORDER BY id;
SELECT id, MD5 (c), MD5 (v) FROM t28255 WHERE c > '' USING INDEX i28255_c_v(+) ORDER BY id;
SELECT id, MD5 (c) FROM t28255 WHERE id > 0 USING INDEX i28255_id_c(+) ORDER BY id;
SELECT id, MD5 (c), MD5 (c2) FROM t28255 WHERE c > '' USING INDEX i28255_c_c2(+) ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c), CHAR_LENGTH (v), MD5 (v), CHAR_LENGTH (c2), MD5 (c2) FROM t28255 USING INDEX NONE ORDER BY id;

evaluate 'Case 7: ADD FOREIGN KEY over child rows without c accepts them';
-- p28255 takes (c, id) of every row of t28255, so each child row has its parent row: rows 3, 5 and 6 still
-- hold no c.
CREATE TABLE p28255 (c VARCHAR(6000), id INT, PRIMARY KEY (c, id));
INSERT INTO p28255 SELECT c, id FROM t28255;
ALTER TABLE t28255 ADD CONSTRAINT fk_t28255_cascade FOREIGN KEY (c, id) REFERENCES p28255 (c, id) ON DELETE CASCADE;
SELECT index_name, is_foreign_key FROM db_index WHERE class_name = 't28255' ORDER BY index_name;

evaluate 'Case 8: DELETE of a parent row ON DELETE CASCADE deletes its child row without c';
DELETE FROM p28255 WHERE id = 5;
SELECT id, MD5 (c) FROM p28255 ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c) FROM t28255 WHERE c > '' USING INDEX i28255_c_id(+) ORDER BY id;
SELECT id, MD5 (c), MD5 (v) FROM t28255 WHERE c > '' USING INDEX i28255_c_v(+) ORDER BY id;
SELECT id, MD5 (c) FROM t28255 WHERE id > 0 USING INDEX i28255_id_c(+) ORDER BY id;
SELECT id, MD5 (c), MD5 (c2) FROM t28255 WHERE c > '' USING INDEX i28255_c_c2(+) ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c), CHAR_LENGTH (v), MD5 (v), CHAR_LENGTH (c2), MD5 (c2) FROM t28255 USING INDEX NONE ORDER BY id;

evaluate 'Case 9: DELETE of a parent row ON DELETE SET NULL sets the key of its child row without c to NULL';
ALTER TABLE t28255 DROP FOREIGN KEY fk_t28255_cascade;
ALTER TABLE t28255 ADD CONSTRAINT fk_t28255_setnull FOREIGN KEY (c, id) REFERENCES p28255 (c, id) ON DELETE SET NULL;
DELETE FROM p28255 WHERE id = 6;
SELECT id, MD5 (c) FROM p28255 ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c) FROM t28255 WHERE c > '' USING INDEX i28255_c_id(+) ORDER BY id;
SELECT id, MD5 (c), MD5 (v) FROM t28255 WHERE c > '' USING INDEX i28255_c_v(+) ORDER BY id;
SELECT id, MD5 (c) FROM t28255 WHERE id > 0 USING INDEX i28255_id_c(+) ORDER BY id;
SELECT id, MD5 (c), MD5 (c2) FROM t28255 WHERE c > '' USING INDEX i28255_c_c2(+) ORDER BY id;
SELECT id, CHAR_LENGTH (c), MD5 (c), CHAR_LENGTH (v), MD5 (v), CHAR_LENGTH (c2), MD5 (c2) FROM t28255 USING INDEX NONE ORDER BY id;

-- 71 rows whose v holds 3,850 to 3,990 hex digits, which LZ4 does not shrink. A key on the 61 columns of
-- i28255_wide has a header of about 70 bytes, which is more than the row spends on its header and its 60
-- SMALLINT values beyond their 120 bytes, so the keys of the rows of about 3,900 to 3,930 hex digits are
-- longer than 4KB while the rows are not. s00 holds a different value in each row.
CREATE TABLE t28255_wide (id INT, s00 SMALLINT, s01 SMALLINT, s02 SMALLINT, s03 SMALLINT, s04 SMALLINT, s05 SMALLINT, s06 SMALLINT, s07 SMALLINT, s08 SMALLINT, s09 SMALLINT, s10 SMALLINT, s11 SMALLINT, s12 SMALLINT, s13 SMALLINT, s14 SMALLINT, s15 SMALLINT, s16 SMALLINT, s17 SMALLINT, s18 SMALLINT, s19 SMALLINT, s20 SMALLINT, s21 SMALLINT, s22 SMALLINT, s23 SMALLINT, s24 SMALLINT, s25 SMALLINT, s26 SMALLINT, s27 SMALLINT, s28 SMALLINT, s29 SMALLINT, s30 SMALLINT, s31 SMALLINT, s32 SMALLINT, s33 SMALLINT, s34 SMALLINT, s35 SMALLINT, s36 SMALLINT, s37 SMALLINT, s38 SMALLINT, s39 SMALLINT, s40 SMALLINT, s41 SMALLINT, s42 SMALLINT, s43 SMALLINT, s44 SMALLINT, s45 SMALLINT, s46 SMALLINT, s47 SMALLINT, s48 SMALLINT, s49 SMALLINT, s50 SMALLINT, s51 SMALLINT, s52 SMALLINT, s53 SMALLINT, s54 SMALLINT, s55 SMALLINT, s56 SMALLINT, s57 SMALLINT, s58 SMALLINT, s59 SMALLINT, v VARCHAR(6000));
INSERT INTO t28255_wide
  WITH RECURSIVE r (n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM r WHERE n < 71)
  SELECT n, MOD (n * 7919 + 0, 30000) + 1, MOD (n * 7919 + 104729, 30000) + 1, MOD (n * 7919 + 209458, 30000) + 1, MOD (n * 7919 + 314187, 30000) + 1, MOD (n * 7919 + 418916, 30000) + 1, MOD (n * 7919 + 523645, 30000) + 1, MOD (n * 7919 + 628374, 30000) + 1, MOD (n * 7919 + 733103, 30000) + 1, MOD (n * 7919 + 837832, 30000) + 1, MOD (n * 7919 + 942561, 30000) + 1, MOD (n * 7919 + 1047290, 30000) + 1, MOD (n * 7919 + 1152019, 30000) + 1, MOD (n * 7919 + 1256748, 30000) + 1, MOD (n * 7919 + 1361477, 30000) + 1, MOD (n * 7919 + 1466206, 30000) + 1, MOD (n * 7919 + 1570935, 30000) + 1, MOD (n * 7919 + 1675664, 30000) + 1, MOD (n * 7919 + 1780393, 30000) + 1, MOD (n * 7919 + 1885122, 30000) + 1, MOD (n * 7919 + 1989851, 30000) + 1, MOD (n * 7919 + 2094580, 30000) + 1, MOD (n * 7919 + 2199309, 30000) + 1, MOD (n * 7919 + 2304038, 30000) + 1, MOD (n * 7919 + 2408767, 30000) + 1, MOD (n * 7919 + 2513496, 30000) + 1, MOD (n * 7919 + 2618225, 30000) + 1, MOD (n * 7919 + 2722954, 30000) + 1, MOD (n * 7919 + 2827683, 30000) + 1, MOD (n * 7919 + 2932412, 30000) + 1, MOD (n * 7919 + 3037141, 30000) + 1, MOD (n * 7919 + 3141870, 30000) + 1, MOD (n * 7919 + 3246599, 30000) + 1, MOD (n * 7919 + 3351328, 30000) + 1, MOD (n * 7919 + 3456057, 30000) + 1, MOD (n * 7919 + 3560786, 30000) + 1, MOD (n * 7919 + 3665515, 30000) + 1, MOD (n * 7919 + 3770244, 30000) + 1, MOD (n * 7919 + 3874973, 30000) + 1, MOD (n * 7919 + 3979702, 30000) + 1, MOD (n * 7919 + 4084431, 30000) + 1, MOD (n * 7919 + 4189160, 30000) + 1, MOD (n * 7919 + 4293889, 30000) + 1, MOD (n * 7919 + 4398618, 30000) + 1, MOD (n * 7919 + 4503347, 30000) + 1, MOD (n * 7919 + 4608076, 30000) + 1, MOD (n * 7919 + 4712805, 30000) + 1, MOD (n * 7919 + 4817534, 30000) + 1, MOD (n * 7919 + 4922263, 30000) + 1, MOD (n * 7919 + 5026992, 30000) + 1, MOD (n * 7919 + 5131721, 30000) + 1, MOD (n * 7919 + 5236450, 30000) + 1, MOD (n * 7919 + 5341179, 30000) + 1, MOD (n * 7919 + 5445908, 30000) + 1, MOD (n * 7919 + 5550637, 30000) + 1, MOD (n * 7919 + 5655366, 30000) + 1, MOD (n * 7919 + 5760095, 30000) + 1, MOD (n * 7919 + 5864824, 30000) + 1, MOD (n * 7919 + 5969553, 30000) + 1, MOD (n * 7919 + 6074282, 30000) + 1, MOD (n * 7919 + 6179011, 30000) + 1,
    SUBSTR (SHA2 ('t28255_wide 1', 512) || SHA2 ('t28255_wide 2', 512) || SHA2 ('t28255_wide 3', 512) || SHA2 ('t28255_wide 4', 512) || SHA2 ('t28255_wide 5', 512) || SHA2 ('t28255_wide 6', 512) || SHA2 ('t28255_wide 7', 512) || SHA2 ('t28255_wide 8', 512) || SHA2 ('t28255_wide 9', 512) || SHA2 ('t28255_wide 10', 512) || SHA2 ('t28255_wide 11', 512) || SHA2 ('t28255_wide 12', 512) || SHA2 ('t28255_wide 13', 512) || SHA2 ('t28255_wide 14', 512) || SHA2 ('t28255_wide 15', 512) || SHA2 ('t28255_wide 16', 512) || SHA2 ('t28255_wide 17', 512) || SHA2 ('t28255_wide 18', 512) || SHA2 ('t28255_wide 19', 512) || SHA2 ('t28255_wide 20', 512) || SHA2 ('t28255_wide 21', 512) || SHA2 ('t28255_wide 22', 512) || SHA2 ('t28255_wide 23', 512) || SHA2 ('t28255_wide 24', 512) || SHA2 ('t28255_wide 25', 512) || SHA2 ('t28255_wide 26', 512) || SHA2 ('t28255_wide 27', 512) || SHA2 ('t28255_wide 28', 512) || SHA2 ('t28255_wide 29', 512) || SHA2 ('t28255_wide 30', 512) || SHA2 ('t28255_wide 31', 512) || SHA2 ('t28255_wide 32', 512), 1, 3848 + 2 * n) FROM r;

evaluate 'Case 10: CREATE INDEX on 60 SMALLINT columns and v keeps the keys that the key header makes longer than 4KB for rows of 4KB or less';
CREATE INDEX i28255_wide ON t28255_wide (s00, s01, s02, s03, s04, s05, s06, s07, s08, s09, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, s32, s33, s34, s35, s36, s37, s38, s39, s40, s41, s42, s43, s44, s45, s46, s47, s48, s49, s50, s51, s52, s53, s54, s55, s56, s57, s58, s59, v);
--@queryplan
SELECT s00, CHAR_LENGTH (v), MD5 (CONCAT_WS (',', s01, s02, s03, s04, s05, s06, s07, s08, s09, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, s32, s33, s34, s35, s36, s37, s38, s39, s40, s41, s42, s43, s44, s45, s46, s47, s48, s49, s50, s51, s52, s53, s54, s55, s56, s57, s58, s59, v)) FROM t28255_wide WHERE s00 > 0 USING INDEX i28255_wide(+) ORDER BY s00;
SELECT s00, CHAR_LENGTH (v), MD5 (CONCAT_WS (',', s01, s02, s03, s04, s05, s06, s07, s08, s09, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, s32, s33, s34, s35, s36, s37, s38, s39, s40, s41, s42, s43, s44, s45, s46, s47, s48, s49, s50, s51, s52, s53, s54, s55, s56, s57, s58, s59, v)) FROM t28255_wide USING INDEX NONE ORDER BY s00;

DROP TABLE t28255;
DROP TABLE p28255;
DROP TABLE t28255_wide;
