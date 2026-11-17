/*
 * CBRD-27655: REGEXP functions with a pattern that can match an empty string
 * ('a|', 'b*', '^', '$', ...) under regexp_engine=re2.
 *
 * REGEXP_COUNT and REGEXP_REPLACE never returned (the search position did not
 * move past an empty match), and REGEXP_INSTR / REGEXP_SUBSTR returned the same
 * empty match for every occurrence.
 * Every query here must return, and re2 must give the same result as cppstd.
 *
 * Cases 8 to 15 run one identical block under both engines so that every
 * argument form of the four functions is covered by that comparison, not only
 * the column queries. They also add the empty-match shapes the earlier cases
 * leave out: a zero-width assertion that matches inside the string, a subject
 * with nothing to advance over, and a long multibyte string.
 *
 * Case 16 runs under re2 only. The engines are documented to disagree on
 * patterns that prefer an empty match where a non-empty one also starts, so
 * the point there is that re2 terminates and enumerates every position, not
 * that the two engines agree.
 *
 * Coverage:
 *   Case 1: REGEXP_COUNT with constants, the queries from the report
 *   Case 2: REGEXP_COUNT over column values, one empty-match pattern per row
 *   Case 3: REGEXP_INSTR, every occurrence of an empty match
 *   Case 4: REGEXP_SUBSTR, the same occurrences
 *   Case 5: REGEXP_REPLACE, all matches, from a position, and one occurrence
 *   Case 6: a long subject with an empty match at every position
 *   Case 7: the column queries under cppstd, and under re2 again
 *   Case 8: the constant queries of Case 1, 3, 4, 5, and a multibyte position, under re2
 *   Case 9: a zero-width assertion that matches inside the subject, under re2
 *   Case 10: nothing to advance over, an empty subject and a position past the end, under re2
 *   Case 11: a long multibyte subject, under re2
 *   Case 12: Case 8 repeated under cppstd
 *   Case 13: Case 9 repeated under cppstd
 *   Case 14: Case 10 repeated under cppstd
 *   Case 15: Case 11 repeated under cppstd
 *   Case 16: patterns that prefer an empty match at a position a non-empty one also starts at, under re2
 */
set system parameters 'regexp_engine=re2';

drop table if exists t_27655;
create table t_27655 (id int primary key, s varchar(100), p varchar(20));
insert into t_27655 values (1, 'abc', 'a|'), (2, 'abc', 'b*'), (3, 'abc', 'x?'), (4, 'abc', '^'),
  (5, 'abc', '$'), (6, '가나다', '나*'), (7, 'aaa', 'a*'), (8, 'abcb', 'b'), (9, 'abcabc', '[ac]');

evaluate 'Case 1: REGEXP_COUNT with constants, the queries from the report';
select regexp_count('abc', 'a|'), regexp_count('abc', 'b*'), regexp_count('abc', '^'), regexp_count('abc', '$');
select regexp_count('abc', 'b*', 2), regexp_count('abc', 'a|', 3), regexp_count('AbA', 'a*', 1, 'i');

evaluate 'Case 2: REGEXP_COUNT over column values, one empty-match pattern per row';
select id, regexp_count(s, p) from t_27655 order by id;

evaluate 'Case 3: REGEXP_INSTR, each occurrence of b* in abc is at 1, 2, 3, 4 and there is no 5th';
select regexp_instr('abc', 'b*', 1, 1), regexp_instr('abc', 'b*', 1, 2), regexp_instr('abc', 'b*', 1, 3),
  regexp_instr('abc', 'b*', 1, 4), regexp_instr('abc', 'b*', 1, 5), regexp_instr('abc', 'b*', 1, 2, 1);
select id, regexp_instr(s, p, 1, 2), regexp_instr(s, p, 1, 3) from t_27655 order by id;

evaluate 'Case 4: REGEXP_SUBSTR, the same occurrences';
select regexp_substr('abc', 'b*', 1, 2), regexp_substr('abc', 'b*', 1, 3), regexp_substr('abc', 'b*', 1, 5),
  regexp_substr('가나다', '나*', 1, 2);
select id, regexp_substr(s, p, 1, 2) from t_27655 order by id;

evaluate 'Case 5: REGEXP_REPLACE, all matches, from a position, and one occurrence';
select regexp_replace('abc', 'b*', 'X'), regexp_replace('abc', 'a|', 'X'), regexp_replace('abc', '^', '>'),
  regexp_replace('abc', '$', '<');
select regexp_replace('abc', 'b*', 'X', 2), regexp_replace('abc', 'b*', 'X', 1, 2), regexp_replace('AbA', 'a*', 'X', 1, 0, 'i');
select id, regexp_replace(s, p, '-') from t_27655 order by id;

evaluate 'Case 6: a long subject with an empty match at every position';
select regexp_count(repeat('ab', 5000), 'x*'), length(regexp_replace(repeat('ab', 5000), 'b*', 'X'));

evaluate 'Case 7: the column queries under cppstd, and under re2 again, which must agree';
set system parameters 'regexp_engine=cppstd';
select id, regexp_count(s, p), regexp_instr(s, p, 1, 2), regexp_instr(s, p, 1, 3), regexp_substr(s, p, 1, 2),
  regexp_replace(s, p, '-') from t_27655 order by id;
select regexp_count(repeat('ab', 5000), 'x*'), length(regexp_replace(repeat('ab', 5000), 'b*', 'X'));

set system parameters 'regexp_engine=re2';
select id, regexp_count(s, p), regexp_instr(s, p, 1, 2), regexp_instr(s, p, 1, 3), regexp_substr(s, p, 1, 2),
  regexp_replace(s, p, '-') from t_27655 order by id;

/*
 * Every argument form, and the empty-match shapes the cases above leave out,
 * compared between the two engines. Cases 12 to 15 repeat the text of cases
 * 8 to 11, so their results must be identical line for line.
 */

-- ---- re2 ----------------------------------------------------------------
set system parameters 'regexp_engine=re2';

evaluate 'Case 8: the constant queries of Case 1, 3, 4, 5, and a multibyte position, under re2, to pair with Case 12';
select regexp_count('abc', 'a|'), regexp_count('abc', 'b*'), regexp_count('abc', '^'), regexp_count('abc', '$');
select regexp_count('abc', 'b*', 2), regexp_count('abc', 'a|', 3), regexp_count('AbA', 'a*', 1, 'i');
select regexp_instr('abc', 'b*', 1, 1), regexp_instr('abc', 'b*', 1, 2), regexp_instr('abc', 'b*', 1, 3),
  regexp_instr('abc', 'b*', 1, 4), regexp_instr('abc', 'b*', 1, 5), regexp_instr('abc', 'b*', 1, 2, 1);
select regexp_substr('abc', 'b*', 1, 2), regexp_substr('abc', 'b*', 1, 3), regexp_substr('abc', 'b*', 1, 5),
  regexp_substr('가나다', '나*', 1, 2);
select regexp_replace('abc', 'b*', 'X'), regexp_replace('abc', 'a|', 'X'), regexp_replace('abc', '^', '>'),
  regexp_replace('abc', '$', '<');
select regexp_replace('abc', 'b*', 'X', 2), regexp_replace('abc', 'b*', 'X', 1, 2), regexp_replace('AbA', 'a*', 'X', 1, 0, 'i');
-- a position inside a multibyte subject: the prefix must be cut by character, so '가' survives
select regexp_count('가나다', '나*', 2), regexp_instr('가나다', '나*', 2, 2), regexp_substr('가나다', '나*', 2, 2),
  regexp_replace('가나다', '나*', 'X', 2);

evaluate 'Case 9: a zero-width assertion matches inside the subject, unlike ^ and $, under re2';
-- '\b' is a single backslash: no_backslash_escapes defaults to yes, so it reaches the engine as written
select regexp_count('ab cd', '\b'), regexp_instr('ab cd', '\b', 1, 3), regexp_substr('ab cd', '\b', 1, 2),
  regexp_replace('ab cd', '\b', '|');

evaluate 'Case 10: nothing to advance over, an empty subject and a position past the end, under re2';
select regexp_count('', 'b*'), regexp_instr('', 'b*', 1, 1), regexp_substr('', 'b*', 1, 1), regexp_replace('', 'b*', 'X');
select regexp_count('abc', 'b*', 10), regexp_instr('abc', 'b*', 10, 1), regexp_substr('abc', 'b*', 10, 1),
  regexp_replace('abc', 'b*', 'X', 10);

evaluate 'Case 11: a long multibyte subject, the step over an empty match is one character, not one byte, under re2';
select regexp_count(repeat('가나', 5000), 'x*'), length(regexp_replace(repeat('가나', 5000), '나*', 'X'));

-- ---- cppstd (same block) ------------------------------------------------
set system parameters 'regexp_engine=cppstd';

evaluate 'Case 12: Case 8 repeated under cppstd';
select regexp_count('abc', 'a|'), regexp_count('abc', 'b*'), regexp_count('abc', '^'), regexp_count('abc', '$');
select regexp_count('abc', 'b*', 2), regexp_count('abc', 'a|', 3), regexp_count('AbA', 'a*', 1, 'i');
select regexp_instr('abc', 'b*', 1, 1), regexp_instr('abc', 'b*', 1, 2), regexp_instr('abc', 'b*', 1, 3),
  regexp_instr('abc', 'b*', 1, 4), regexp_instr('abc', 'b*', 1, 5), regexp_instr('abc', 'b*', 1, 2, 1);
select regexp_substr('abc', 'b*', 1, 2), regexp_substr('abc', 'b*', 1, 3), regexp_substr('abc', 'b*', 1, 5),
  regexp_substr('가나다', '나*', 1, 2);
select regexp_replace('abc', 'b*', 'X'), regexp_replace('abc', 'a|', 'X'), regexp_replace('abc', '^', '>'),
  regexp_replace('abc', '$', '<');
select regexp_replace('abc', 'b*', 'X', 2), regexp_replace('abc', 'b*', 'X', 1, 2), regexp_replace('AbA', 'a*', 'X', 1, 0, 'i');
select regexp_count('가나다', '나*', 2), regexp_instr('가나다', '나*', 2, 2), regexp_substr('가나다', '나*', 2, 2),
  regexp_replace('가나다', '나*', 'X', 2);

evaluate 'Case 13: Case 9 repeated under cppstd';
select regexp_count('ab cd', '\b'), regexp_instr('ab cd', '\b', 1, 3), regexp_substr('ab cd', '\b', 1, 2),
  regexp_replace('ab cd', '\b', '|');

evaluate 'Case 14: Case 10 repeated under cppstd';
select regexp_count('', 'b*'), regexp_instr('', 'b*', 1, 1), regexp_substr('', 'b*', 1, 1), regexp_replace('', 'b*', 'X');
select regexp_count('abc', 'b*', 10), regexp_instr('abc', 'b*', 10, 1), regexp_substr('abc', 'b*', 10, 1),
  regexp_replace('abc', 'b*', 'X', 10);

evaluate 'Case 15: Case 11 repeated under cppstd';
select regexp_count(repeat('가나', 5000), 'x*'), length(regexp_replace(repeat('가나', 5000), '나*', 'X'));

-- ---- re2 only -----------------------------------------------------------
set system parameters 'regexp_engine=re2';

evaluate 'Case 16: patterns that prefer an empty match at a position a non-empty one also starts at, under re2';
select regexp_count('abc', '|b'), regexp_count('abc', 'b*?'), regexp_replace('abc', '|b', 'X'),
  regexp_instr('abc', 'b*?', 1, 3);
select regexp_instr('abc', '|b', 1, 1), regexp_instr('abc', '|b', 1, 2), regexp_instr('abc', '|b', 1, 3),
  regexp_instr('abc', '|b', 1, 4), regexp_instr('abc', '|b', 1, 5);

drop table t_27655;
set system parameters 'regexp_engine=default';
