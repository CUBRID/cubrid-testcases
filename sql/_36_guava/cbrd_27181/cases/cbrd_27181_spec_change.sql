/**
 *  This test case verifies CBRD-27181: the two LIKE result changes the issue
 *  specifies for the byte-lockstep fast path of engine PR #7626.
 *
 *  1. The old LIKE loop keeps at most 100 backtracking points and fails with
 *  an error beyond that. The fast path recurses once per % literal group up to
 *  256 levels, so such patterns now return a result, and deeper ones fall back
 *  to the old loop. 101 groups therefore show which LIKE takes the fast path.
 *  2. For invalid UTF-8 bytes in a UTF-8 value the result is not guaranteed:
 *  the fast path compares bytes and finds % candidates with memchr.
 *
 *  Each tested query is followed by a twin with ESCAPE '¶', a multi-byte escape
 *  that never occurs in the patterns, which sends the same LIKE to the old
 *  loop. This file fails on a pre-fix build by design. Invalid bytes are
 *  decoded by from_base64 at evaluation time and printed with hex.
 *
 *  Coverage:
 *    Case 1: a run of 120 % _ groups over 300 characters, twin = error
 *    Case 2: 150 % literal groups, no match and match, twin = error
 *    Case 3: 300 % literal groups fall back to the old loop, error on both
 *    Case 4: invalid UTF-8 targets and patterns (truncated, orphan, overlong, surrogate, out of range)
 *    Case 5: 100 and 101 groups, the edge of the old loop
 *    Case 6: 256 groups kept, 257 fall back, 257 over 256 characters, % _ runs add no level
 *    Case 7: NOT LIKE, LIKE over two constants and JSON_SEARCH use the same matcher
 *    Case 8: which collations take the fast path (101 groups)
 *    Case 9: which ESCAPE takes the fast path (101 groups)
 */

drop table if exists t_deep, t_bad, t_bad_pat;

-- target and pattern are columns: LIKE over two constants is folded before execution
create table t_deep (id int primary key, tgt varchar(1000), pat varchar(1000));
insert into t_deep values
 (1, repeat('x', 300), repeat('%_', 120)),
 (2, repeat('a', 600), repeat('%a', 150) || 'x'),
 (3, repeat('a', 600), repeat('%a', 150)),
 (4, repeat('a', 600), repeat('%a', 300) || 'x');
-- the edge of the old loop: 100 and 101 groups, and 101 groups over a target one character short
insert into t_deep values
 (5, repeat('a', 100), repeat('%a', 100)), (6, repeat('a', 101), repeat('%a', 101)), (7, repeat('a', 100), repeat('%a', 101)),
 (8, repeat('x', 100), repeat('%_', 100)), (9, repeat('x', 101), repeat('%_', 101)), (10, repeat('x', 100), repeat('%_', 101));
-- the edge of the fast path: 256 and 257 groups, 257 groups over 256 characters, 300 % _ groups, 51 groups of % a % _
insert into t_deep values
 (11, repeat('a', 256), repeat('%a', 256)), (12, repeat('a', 257), repeat('%a', 257)), (13, repeat('a', 256), repeat('%a', 257)),
 (14, repeat('x', 300), repeat('%_', 300)), (15, repeat('a', 102), repeat('%a%_', 51));

-- invalid UTF-8 targets as base64, decoded by from_base64 at evaluation time: a varchar column drops a
-- truncated last character on insert. 1 orphan continuation, 2-4 truncated 2/3/4-byte character,
-- 5-6 overlong NUL and A, 7 lead byte before ASCII, 8 surrogate, 9 above U+10FFFF, 10 invalid lead byte,
-- 11-15 the same defects between ASCII letters, 16 valid
create table t_bad (id int primary key, b varchar(16));
insert into t_bad values (1, 'gA=='), (2, 'wg=='), (3, '4YA='), (4, '8JCA'), (5, 'wIA='), (6, 'wYE='), (7, 'wkE='), (8, '7aCA'),
 (9, '9JCAgA=='), (10, '9YCAgA=='), (11, 'QcGBWg=='), (12, 'QYBa'), (13, 'QeGA'), (14, '4YBa'), (15, 'QcIgWg=='), (16, 'QVo=');

-- patterns as base64: 1-14 valid, 15-22 holding invalid bytes
create table t_bad_pat (id int primary key, b varchar(16));
insert into t_bad_pat values (1, 'JQ=='), (2, 'Xw=='), (3, 'X18='), (4, 'JUEl'), (5, 'QSU='), (6, 'JVo='), (7, 'QV9a'), (8, 'QV9fWg=='), (9, 'QQ=='), (10, 'JV8='), (11, 'XyVf'),
 (12, 'Wg=='), (13, 'X1o='), (14, 'QSVa'), (15, 'JYA='), (16, 'gCU='), (17, 'JcGBJQ=='), (18, 'wYE='), (19, 'QcEl'), (20, 'QSWAWg=='), (21, 'QV+BWg=='), (22, 'QeE=');


evaluate 'Case 1: 120 groups of % _ over 300 characters; fast path = 1, twin = error';
select id, tgt like pat from t_deep where id = 1;
select id, tgt like pat escape '¶' from t_deep where id = 1;


evaluate 'Case 2: 150 groups of % a, no match then match; fast path = 0 and 1, twin = error';
select id, tgt like pat from t_deep where id in (2, 3) order by id;
select id, tgt like pat escape '¶' from t_deep where id = 2;
select id, tgt like pat escape '¶' from t_deep where id = 3;


evaluate 'Case 3: 300 groups of % a fall back to the old loop; error on both';
select id, tgt like pat from t_deep where id = 4;
select id, tgt like pat escape '¶' from t_deep where id = 4;


evaluate 'Case 4: invalid UTF-8; fast path rows pinned, twin = old loop';
select id, hex(from_base64(b)) from t_bad order by id;
select id, hex(from_base64(b)) from t_bad_pat order by id;
select p.id, group_concat(t.id order by t.id) from t_bad_pat p left outer join t_bad t on from_base64(t.b) like from_base64(p.b) group by p.id order by p.id;
select p.id, group_concat(t.id order by t.id) from t_bad_pat p left outer join t_bad t on from_base64(t.b) like from_base64(p.b) escape '¶' group by p.id order by p.id;



evaluate 'Case 5: 100 and 101 groups; fast path = 1 1 0 1 1 0, twin = the same up to 100 points and error at 101';
select id, tgt like pat from t_deep where id between 5 and 10 order by id;
select id, tgt like pat escape '¶' from t_deep where id in (5, 7, 8, 10) order by id;
select id, tgt like pat escape '¶' from t_deep where id = 6;
select id, tgt like pat escape '¶' from t_deep where id = 9;


evaluate 'Case 6: 256 groups = 1, 257 fall back = error, 257 over 256 characters = 0, % _ runs = 1; twin = error';
select id, tgt like pat from t_deep where id in (11, 13, 14, 15) order by id;
select id, tgt like pat from t_deep where id = 12;
select id, tgt like pat escape '¶' from t_deep where id = 11;
select id, tgt like pat escape '¶' from t_deep where id = 12;
select id, tgt like pat escape '¶' from t_deep where id = 13;
select id, tgt like pat escape '¶' from t_deep where id = 14;
select id, tgt like pat escape '¶' from t_deep where id = 15;


evaluate 'Case 7: NOT LIKE, LIKE over two constants and JSON_SEARCH with 101 groups; twin or 257 groups = error';
select id, tgt not like pat from t_deep where id = 6;
select id, tgt not like pat escape '¶' from t_deep where id = 6;
select repeat('a', 101) like repeat('%a', 101);
select repeat('a', 101) like repeat('%a', 101) escape '¶';
select json_search(json_array(repeat('a', 101)), 'one', repeat('%a', 101));
select json_search(json_array(repeat('a', 257)), 'one', repeat('%a', 257));


evaluate 'Case 8: 101 groups per collation; fast path = 1, old loop = error';
select id, cast(tgt as varchar(1000) collate utf8_en_cs) like cast(pat as varchar(1000) collate utf8_en_cs) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate utf8_ko_cs) like cast(pat as varchar(1000) collate utf8_ko_cs) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate iso88591_bin) like cast(pat as varchar(1000) collate iso88591_bin) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate iso88591_en_cs) like cast(pat as varchar(1000) collate iso88591_en_cs) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate binary) like cast(pat as varchar(1000) collate binary) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate utf8_en_ci) like cast(pat as varchar(1000) collate utf8_en_ci) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate utf8_tr_cs) like cast(pat as varchar(1000) collate utf8_tr_cs) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate iso88591_en_ci) like cast(pat as varchar(1000) collate iso88591_en_ci) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate euckr_bin) like cast(pat as varchar(1000) collate euckr_bin) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate utf8_gen) like cast(pat as varchar(1000) collate utf8_gen) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate utf8_gen_ci) like cast(pat as varchar(1000) collate utf8_gen_ci) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate utf8_gen_ai_ci) like cast(pat as varchar(1000) collate utf8_gen_ai_ci) from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate utf8_de_exp_ai_ci) like cast(pat as varchar(1000) collate utf8_de_exp_ai_ci) from t_deep where id = 6;


evaluate 'Case 9: 101 groups per ESCAPE; fast path = 1, old loop = error';
select id, tgt like pat escape '!' from t_deep where id = 6;
select id, tgt like pat escape null from t_deep where id = 6;
select id, tgt like pat escape ' ' from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate binary) like cast(pat as varchar(1000) collate binary) escape ' ' from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate iso88591_bin) like cast(pat as varchar(1000) collate iso88591_bin) escape '!' from t_deep where id = 6;
select id, cast(tgt as varchar(1000) collate iso88591_bin) like cast(pat as varchar(1000) collate iso88591_bin) escape ' ' from t_deep where id = 6;
select id, tgt like pat escape 'é' from t_deep where id = 6;
select id, tgt like pat escape '_' from t_deep where id = 6;

drop table t_deep, t_bad, t_bad_pat;
