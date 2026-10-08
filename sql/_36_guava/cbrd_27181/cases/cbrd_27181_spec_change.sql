/**
 *  This test case verifies CBRD-27181: the two LIKE result changes the issue
 *  specifies for the byte-lockstep fast path of engine PR #7626.
 *
 *  1. The old LIKE loop keeps at most 100 backtracking points and fails with
 *  an error beyond that. The fast path recurses once per % group up to 256
 *  levels, so such patterns now return a result. Deeper patterns fall back to
 *  the old loop and fail as before.
 *  2. For invalid UTF-8 bytes in a UTF-8 value the LIKE result is not
 *  guaranteed. The fast path finds % candidates with memchr on the first
 *  pattern byte and compares bytes instead of decoded characters, so an
 *  overlong sequence no longer matches the ASCII letter it encodes and a
 *  letter after a broken lead byte can start a match.
 *
 *  Each tested query is followed by a twin with ESCAPE '¶', a multi-byte escape
 *  that never occurs in the patterns, which sends the same LIKE to the old
 *  loop. The twin keeps the old result, so the two blocks differ where the
 *  specification changed, and this file fails on a pre-fix build by design.
 *  Invalid bytes are decoded by from_base64 at evaluation time and printed with hex.
 *
 *  Coverage:
 *    Case 1: a run of 120 % _ groups over 300 characters, twin = error
 *    Case 2: 150 % literal groups, no match and match, twin = error
 *    Case 3: 300 % literal groups fall back to the old loop, error on both
 *    Case 4: invalid UTF-8 targets and patterns (truncated, orphan, overlong, surrogate, out of range)
 */

drop table if exists t_deep, t_bad, t_bad_pat;

-- target and pattern are columns: LIKE over two constants is folded before execution
create table t_deep (id int primary key, tgt varchar(1000), pat varchar(1000));
insert into t_deep values
 (1, repeat('x', 300), repeat('%_', 120)),
 (2, repeat('a', 600), repeat('%a', 150) || 'x'),
 (3, repeat('a', 600), repeat('%a', 150)),
 (4, repeat('a', 600), repeat('%a', 300) || 'x');

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

drop table t_deep, t_bad, t_bad_pat;
