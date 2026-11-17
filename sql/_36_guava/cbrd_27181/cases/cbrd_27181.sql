/**
 *  This test case verifies CBRD-27181: LIKE returns the same rows when it takes
 *  the byte-lockstep fast path, for valid UTF-8, ISO-8859-1 and binary data.
 *
 *  Before the fix every LIKE decoded code points or looked up collation weights
 *  per character. The fix (engine PR #7626) compares bytes in lockstep when the
 *  collation weights are the identity (utf8_bin, utf8_en_cs, utf8_ko_cs,
 *  iso88591_bin, iso88591_en_cs, binary) and the ESCAPE is absent or one byte
 *  other than % and _. Other collations, multi-byte escapes and EUC-KR keep the
 *  old loop.
 *
 *  The fast path has no hint, parameter or trace line. Each fast-path query is
 *  followed by a twin with ESCAPE '¶': a multi-byte escape that never occurs in
 *  the patterns sends the same LIKE to the old loop, so the two result blocks
 *  must match. Queries that stay on the old loop on every build pin literal
 *  values. Patterns come from a table column, because a constant pattern on a
 *  column is rewritten to =, BETWEEN or IS NOT NULL before LIKE runs.
 *  The pre-fix build also passes (correctness TC).
 *
 *  Coverage:
 *    Case 1: utf8_bin, no ESCAPE (wildcards, multi-byte _, same lead byte, trailing space, space = NUL)
 *    Case 2: utf8_bin, ESCAPE ! (twin rewrites ! to the multi-byte escape), trailing escape
 *    Case 3: utf8_en_cs and utf8_ko_cs, twin
 *    Case 4: utf8_en_ci, not eligible, case-insensitive matches
 *    Case 5: iso88591_bin and iso88591_en_cs with twins, iso88591_en_ci, ESCAPE ! and ESCAPE space
 *    Case 6: binary, twin (NUL differs from space, _ is one byte)
 *    Case 7: ESCAPE % and ESCAPE _, old loop
 *    Case 8: EUC-KR bytes inside a character, old loop
 *    Case 9: utf8_de_exp_ai_ci (expansion, accent and case folding), old loop
 */

drop table if exists t_target, t_pattern, t_latin, t_latin_pat, t_bytes, t_bytes_pat, t_euc, t_euc_pat;

-- UTF-8 targets (database collation utf8_bin): ASCII, Korean, 2- and 4-byte characters, trailing spaces, NUL, NULL
create table t_target (id int primary key, s varchar(64));
insert into t_target values
 (1, 'SMALL PLATED BRASS'), (2, 'STANDARD BRASS'), (3, 'BRASS'), (4, 'brass'), (5, 'Brass'),
 (6, '한글매칭테스트'), (7, '가나다라'), (8, 'abc   '), (9, 'abc'), (10, 'a b'),
 (11, '100%할인'), (12, '100X할인'), (13, 'a_c'), (14, ''), (15, 'MEDIUM POLISHED BRASS'),
 (16, '가'), (17, '각'), (18, '가각'), (19, 'é'), (20, 'ê'), (21, 'éê'),
 (22, '😀🧪'), (23, 'Aé가😀Z'), (24, NULL), (25, 'abc!'), (26, 'Straße'), (27, 'Strasse');
insert into t_target values (28, 'a' || chr(0) || 'b'), (29, 'a' || chr(0)), (30, 'abc' || chr(0));

-- patterns as column values: a constant pattern on a column is rewritten before LIKE runs
create table t_pattern (id int primary key, p varchar(64));
insert into t_pattern values
 (1, '%BRASS'), (2, 'BRASS'), (3, '%POLISHED%'), (4, 'S%BRASS'), (5, '%%%BRASS'),
 (6, '한_매칭테스트'), (7, '가__라'), (8, '가%라'), (9, '한글%'), (10, '%각'),
 (11, '%ê'), (12, '%🧪'), (13, 'A_가_Z'), (14, 'ê'), (15, '각'),
 (16, 'abc'), (17, 'abc '), (18, 'a_c'), (19, 'a b'), (20, '_'),
 (21, '__'), (22, '%'), (23, ''), (24, '%_%_%'), (25, '%가%'),
 (26, '100!%할인'), (27, '%!_%'), (28, 'a!_c'), (29, '100%할인'), (30, 'brass'),
 (31, '%S%S%'), (32, '% b'), (33, 'Strasse'), (34, 'Stra_e'), (35, '%ss%');
insert into t_pattern values (36, 'a' || chr(0) || 'b'), (37, 'a' || chr(0) || '%'), (38, '%' || chr(0));


evaluate 'Case 1: utf8_bin, no ESCAPE; result = ESCAPE twin';
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on t.s like p.p group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on t.s like p.p escape '¶' group by p.id order by p.id;


evaluate 'Case 2: utf8_bin, ESCAPE !; result = twin with ! rewritten to the multi-byte escape';
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on t.s like p.p escape '!' group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on t.s like replace(p.p, '!', '¶') escape '¶' group by p.id order by p.id;
-- a trailing escape is a normal character (a twin would turn it into another character, so the values are literal)
select id, s like 'abc!' escape '!', s like 'ab!' escape '!' from t_target where id in (9, 25) order by id;


evaluate 'Case 3: utf8_en_cs and utf8_ko_cs; result = ESCAPE twin';
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on cast(t.s as varchar(64) collate utf8_en_cs) like cast(p.p as varchar(64) collate utf8_en_cs) group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on cast(t.s as varchar(64) collate utf8_en_cs) like cast(p.p as varchar(64) collate utf8_en_cs) escape '¶' group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on cast(t.s as varchar(64) collate utf8_ko_cs) like cast(p.p as varchar(64) collate utf8_ko_cs) group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on cast(t.s as varchar(64) collate utf8_ko_cs) like cast(p.p as varchar(64) collate utf8_ko_cs) escape '¶' group by p.id order by p.id;


evaluate 'Case 4: utf8_en_ci matches case-insensitively on the old loop; literal values';
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on cast(t.s as varchar(64) collate utf8_en_ci) like cast(p.p as varchar(64) collate utf8_en_ci) group by p.id order by p.id;


-- ISO-8859-1 targets and patterns: one byte per character, é and ê stored as E9 and EA
create table t_latin (id int primary key, s varchar(32) collate iso88591_bin);
insert into t_latin values
 (1, 'BRASS'), (2, 'brass'), (3, 'Brass'), (4, 'abc   '), (5, 'abc'), (6, 'a b'),
 (7, 'é'), (8, 'ê'), (9, 'éê'), (10, 'café'), (11, 'a%b'), (12, 'a_c'), (13, 'axxb');
insert into t_latin values (14, 'a' || chr(0) || 'b'), (15, 'abc' || chr(0));
create table t_latin_pat (id int primary key, p varchar(32) collate iso88591_bin);
insert into t_latin_pat values
 (1, '%BRASS'), (2, 'brass'), (3, '%ê'), (4, 'é'), (5, '_'), (6, '__'),
 (7, 'a b'), (8, 'abc'), (9, 'abc '), (10, 'caf_'), (11, '%é%'), (12, 'a %b'),
 (13, 'a!%b'), (14, '%!_%'), (15, '% b'), (16, '%');
insert into t_latin_pat values (17, 'a' || chr(0) || 'b'), (18, '%' || chr(0));


evaluate 'Case 5: iso88591_bin and iso88591_en_cs, result = ESCAPE twin; iso88591_en_ci, ESCAPE ! and ESCAPE space, literal values';
select p.id, group_concat(t.id order by t.id) from t_latin_pat p left outer join t_latin t on t.s like p.p group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_latin_pat p left outer join t_latin t on t.s like p.p escape '¶' group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_latin_pat p left outer join t_latin t on cast(t.s as varchar(32) collate iso88591_en_cs) like cast(p.p as varchar(32) collate iso88591_en_cs) group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_latin_pat p left outer join t_latin t on cast(t.s as varchar(32) collate iso88591_en_cs) like cast(p.p as varchar(32) collate iso88591_en_cs) escape '¶' group by p.id order by p.id;
-- iso88591_en_ci is not eligible: case-insensitive matches on the old loop (literal values)
select p.id, group_concat(t.id order by t.id) from t_latin_pat p left outer join t_latin t on cast(t.s as varchar(32) collate iso88591_en_ci) like cast(p.p as varchar(32) collate iso88591_en_ci) group by p.id order by p.id;
-- ESCAPE ! on ISO data has no twin: replace() stores ¶ as one ISO byte while ESCAPE '¶' keeps two UTF-8 bytes (literal values)
select p.id, group_concat(t.id order by t.id) from t_latin_pat p left outer join t_latin t on t.s like p.p escape '!' group by p.id order by p.id;
-- an ISO space escape stays on the old loop on every build (literal values)
select p.id, group_concat(t.id order by t.id) from t_latin_pat p left outer join t_latin t on t.s like p.p escape ' ' group by p.id order by p.id;


-- binary targets and patterns: raw UTF-8 bytes, so 가 is three bytes and é two
create table t_bytes (id int primary key, s varchar(32) collate binary);
insert into t_bytes values
 (1, 'BRASS'), (2, 'brass'), (3, 'a b'), (4, 'abc   '), (5, 'abc'), (6, '가'), (7, 'é'), (8, 'ê'), (9, 'éê');
insert into t_bytes values (10, 'a' || chr(0) || 'b');
create table t_bytes_pat (id int primary key, p varchar(32) collate binary);
insert into t_bytes_pat values
 (1, '%BRASS'), (2, 'brass'), (3, 'a b'), (4, 'abc'), (5, '_'), (6, '__'), (7, '___'),
 (8, '% b'), (9, 'ê'), (10, '%ê'), (11, '%'), (12, 'a_b');
insert into t_bytes_pat values (13, 'a' || chr(0) || 'b'), (14, '%' || chr(0) || '%');


evaluate 'Case 6: binary; result = ESCAPE twin';
select p.id, group_concat(t.id order by t.id) from t_bytes_pat p left outer join t_bytes t on t.s like p.p group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_bytes_pat p left outer join t_bytes t on t.s like p.p escape '¶' group by p.id order by p.id;


evaluate 'Case 7: ESCAPE % and ESCAPE _ stay on the old loop; literal values';
select id, s like '100%%할인' escape '%', s like '100%할인' escape '%', s like 'a__c' escape '_', s like 'a_c' escape '_' from t_target where id in (11, 12, 13, 9) order by id;


-- EUC-KR: A1 41 and A2 20 are single characters whose second byte is an ASCII letter or a space
create table t_euc (id int primary key, s varchar(16) collate euckr_bin);
insert into t_euc values (1, chr(41281 using euckr)), (2, chr(41504 using euckr)), (3, chr(9388354 using euckr)), (4, '한글'), (5, 'A');
create table t_euc_pat (id int primary key, p varchar(16) collate euckr_bin);
insert into t_euc_pat values (1, '%A'), (2, '%A%'), (3, chr(41472 using euckr)), (4, '한_'), (5, '%글'), (6, '_'), (7, '% ');


evaluate 'Case 8: EUC-KR bytes inside a character never start a match; literal values';
select id, hex(s) from t_euc order by id;
select p.id, hex(p.p), group_concat(t.id order by t.id) from t_euc_pat p left outer join t_euc t on t.s like p.p group by p.id, p.p order by p.id;


evaluate 'Case 9: utf8_de_exp_ai_ci expands and folds on the old loop; literal values';
select p.id, group_concat(t.id order by t.id) from t_pattern p left outer join t_target t on cast(t.s as varchar(64) collate utf8_de_exp_ai_ci) like cast(p.p as varchar(64) collate utf8_de_exp_ai_ci) where p.id in (1, 11, 14, 19, 30, 33, 34, 35) group by p.id order by p.id;

drop table t_target, t_pattern, t_latin, t_latin_pat, t_bytes, t_bytes_pat, t_euc, t_euc_pat;
