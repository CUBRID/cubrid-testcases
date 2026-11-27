/**
 *  This test case verifies CBRD-27181: the byte-lockstep LIKE matcher of engine
 *  PR #7626 returns the same rows as the old loop at the edges of its branches.
 *
 *  The matcher folds a run of % and _ after a % into one-character steps and
 *  one scan, finds each % candidate with memchr on the first literal byte (a
 *  space and a NUL are one class, so the earlier of the two is tried first),
 *  tries the next candidate after a failed one, and ends the scan when a deeper
 *  % group finds no candidate. An escape is one byte other than % and _.
 *
 *  Each fast-path query is followed by a twin with ESCAPE '¶': a multi-byte
 *  escape that never occurs in the data sends the same LIKE to the old loop,
 *  so the two result blocks must match. ESCAPE ! queries are twinned by
 *  replacing ! with ¶ in both the target and the pattern, except a trailing
 *  escape, which the old loop reads by byte length. Collations that stay on the
 *  old loop pin literal values. Patterns come from a table column, because a
 *  constant pattern on a column is rewritten before LIKE runs.
 *  The pre-fix build also passes (correctness TC).
 *
 *  Coverage:
 *    Case 1: utf8_bin, overlapping and repeated candidates, space and NUL, % _ runs, empty target, deeper % groups
 *    Case 2: the same shapes on binary (NUL differs from space, _ is one byte)
 *    Case 3: the same shapes on iso88591_bin
 *    Case 4: ESCAPE ! forms (escaped escape, letter, multi-byte, space, after a % run, inside a % _ run, trailing)
 *    Case 5: CHAR(8) and STRING targets
 *    Case 6: utf8_gen, utf8_gen_ci and utf8_gen_ai_ci stay on the old loop, literal values
 */

drop table if exists t_subject, t_shape, t_esc_subject, t_esc_shape, t_fixed, t_pad_shape, t_word, t_word_shape;

-- targets: overlapping prefixes, one candidate at the first, a middle and the last position, % group chains, empty and blank values
create table t_subject (id int primary key, s varchar(64));
insert into t_subject values
 (1, 'aaab'), (2, 'ababab'), (3, '가가가나'), (4, 'abxx'), (5, 'xxabxx'), (6, 'xxab'), (7, 'abxab'),
 (8, 'ab'), (9, 'abc'), (10, 'abcd'), (11, 'abab'), (12, 'xabyabcd'), (13, 'abcdab'), (14, 'abcdcd'),
 (15, '가'), (16, '가나'), (17, '가나다'), (18, 'a'), (19, ''), (20, '   '), (21, 'a z'), (22, 'abc x');
-- space and NUL: only the NUL, the NUL before the space, the space before the NUL, both failing; 0x7F is the last byte memchr scans in UTF-8
insert into t_subject values (23, 'a' || chr(0) || 'z'), (24, 'a' || chr(0) || 'y z'), (25, 'a y' || chr(0) || 'z'), (26, 'a y' || chr(0) || 'y'), (27, 'a' || chr(127) || 'b');

-- patterns as column values: a constant pattern on a column is rewritten to =, BETWEEN or IS NOT NULL before LIKE runs
create table t_shape (id int primary key, p varchar(64));
insert into t_shape values
 (1, '%aab'), (2, '%abab'), (3, '%가가나'), (4, '%ab%'), (5, '%ab'), (6, 'ab%'), (7, '%ab%cd'), (8, '%ab%cd%'),
 (9, '% z'), (10, '%_'), (11, '_%'), (12, '%'), (13, '%__'), (14, '%___'), (15, '%____'), (16, '%__c'),
 (17, '%_%_'), (18, '%가나'), (19, 'ab가'), (20, 'ab%_'), (21, 'abc%%'), (22, ''), (23, 'abc');
insert into t_shape values (24, '%' || chr(0) || 'z'), (25, '%' || chr(127) || 'b');


evaluate 'Case 1: utf8_bin, candidates, space and NUL, % _ runs, deeper % groups; result = ESCAPE twin';
select p.id, group_concat(t.id order by t.id) from t_shape p left outer join t_subject t on t.s like p.p group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_shape p left outer join t_subject t on t.s like p.p escape '¶' group by p.id order by p.id;


evaluate 'Case 2: binary, the same shapes; result = ESCAPE twin';
select p.id, group_concat(t.id order by t.id) from t_shape p left outer join t_subject t on cast(t.s as varchar(64) collate binary) like cast(p.p as varchar(64) collate binary) group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_shape p left outer join t_subject t on cast(t.s as varchar(64) collate binary) like cast(p.p as varchar(64) collate binary) escape '¶' group by p.id order by p.id;


evaluate 'Case 3: iso88591_bin, the same shapes (Korean converts to ?); result = ESCAPE twin';
select p.id, group_concat(t.id order by t.id) from t_shape p left outer join t_subject t on cast(t.s as varchar(64) collate iso88591_bin) like cast(p.p as varchar(64) collate iso88591_bin) group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_shape p left outer join t_subject t on cast(t.s as varchar(64) collate iso88591_bin) like cast(p.p as varchar(64) collate iso88591_bin) escape '¶' group by p.id order by p.id;


-- ESCAPE ! data: ¶ never occurs in it, so replacing ! with ¶ on both sides keeps every match
create table t_esc_subject (id int primary key, s varchar(16));
insert into t_esc_subject values
 (1, '!'), (2, '!!'), (3, 'a'), (4, '가'), (5, '100%'), (6, '100'), (7, 'x_'), (8, 'xy'),
 (9, 'a!b'), (10, '50%%'), (11, '_'), (12, '%_'), (13, 'ab!'), (14, '가가'), (15, 'a ');
insert into t_esc_subject values (16, 'a' || chr(0));
-- patterns 13 to 15 end with an unescaped escape, which stays a normal character
create table t_esc_shape (id int primary key, p varchar(16));
insert into t_esc_shape values
 (1, '!!'), (2, 'a!!b'), (3, '!a'), (4, '!가'), (5, '%!%'), (6, '%%!%'), (7, '%_!_'), (8, '%!가'),
 (9, '%!!%'), (10, '!%!_'), (11, 'a! '), (12, '%! '), (13, '!'), (14, '%!'), (15, 'ab!');


evaluate 'Case 4: ESCAPE ! forms; result = twin with ! replaced by ¶ on both sides, trailing escape patterns 13 to 15 literal';
select p.id, group_concat(t.id order by t.id) from t_esc_shape p left outer join t_esc_subject t on t.s like p.p escape '!' group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_esc_shape p left outer join t_esc_subject t on replace(t.s, '!', '¶') like replace(p.p, '!', '¶') escape '¶' where p.id < 13 group by p.id order by p.id;


-- the same values as CHAR(8), padded to eight characters, and as STRING
create table t_fixed (id int primary key, c char(8), s string);
insert into t_fixed values (1, 'abc', 'abc'), (2, '가나', '가나'), (3, 'a b', 'a b'), (4, 'abcdefgh', 'abcdefgh'), (5, '', '');
create table t_pad_shape (id int primary key, p varchar(16));
insert into t_pad_shape values
 (1, 'abc'), (2, 'abc_'), (3, 'abc '), (4, '%c'), (5, '%c_'), (6, '_bc%'), (7, '가나'), (8, '가나_'),
 (9, '%나'), (10, 'a_b'), (11, '%h'), (12, ''), (13, '________'), (14, '_________'), (15, '% ');


evaluate 'Case 5: CHAR(8) and STRING targets; result = ESCAPE twin';
select p.id, group_concat(t.id order by t.id) from t_pad_shape p left outer join t_fixed t on t.c like p.p group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_pad_shape p left outer join t_fixed t on t.c like p.p escape '¶' group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_pad_shape p left outer join t_fixed t on t.s like p.p group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_pad_shape p left outer join t_fixed t on t.s like p.p escape '¶' group by p.id order by p.id;


-- accent and case variants for the UCA collations of the test database
create table t_word (id int primary key, s varchar(16));
insert into t_word values (1, 'café'), (2, 'cafe'), (3, 'CAFE'), (4, 'Café'), (5, 'CAFÉ'), (6, 'brass'), (7, 'Brass');
create table t_word_shape (id int primary key, p varchar(16));
insert into t_word_shape values (1, 'café'), (2, 'caf_'), (3, '%afe'), (4, 'CAF%'), (5, '%É'), (6, 'brass'), (7, 'B%');


evaluate 'Case 6: utf8_gen, utf8_gen_ci and utf8_gen_ai_ci stay on the old loop; literal values';
select p.id, group_concat(t.id order by t.id) from t_word_shape p left outer join t_word t on cast(t.s as varchar(16) collate utf8_gen) like cast(p.p as varchar(16) collate utf8_gen) group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_word_shape p left outer join t_word t on cast(t.s as varchar(16) collate utf8_gen_ci) like cast(p.p as varchar(16) collate utf8_gen_ci) group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_word_shape p left outer join t_word t on cast(t.s as varchar(16) collate utf8_gen_ai_ci) like cast(p.p as varchar(16) collate utf8_gen_ai_ci) group by p.id order by p.id;

drop table t_subject, t_shape, t_esc_subject, t_esc_shape, t_fixed, t_pad_shape, t_word, t_word_shape;
