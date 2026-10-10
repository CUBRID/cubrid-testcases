/**
 *  This test case verifies CBRD-27589: LIKE ... ESCAPE on binary-collation strings whose pattern
 *  ends with the escape character returns the right result and the server keeps running.
 *
 *  A trailing escape character is compared as a normal character. When an escaped character came
 *  earlier in the same literal run, lang_strmatch_binary stepped over the trailing escape and the
 *  loop increment then moved the pattern pointer one byte past its end, so the debug build aborted
 *  on an assert. Release builds returned the right results. The fix steps over an escape only when
 *  a character follows it.
 *
 *  ESCAPE '_' and '%' take the LIKE loop that calls the collation matcher, while other single-byte
 *  escapes go to the CBRD-27181 fast path. No hint or parameter selects another matcher, so the
 *  expected values are literal: they equal the release build before and after the fix, and the
 *  pre-fix debug build aborts on Case 1.
 *
 *  Coverage:
 *    Case 1:  issue repro with ESCAPE _, text longer than the match and text equal to it
 *    Case 2:  same pattern, text ends before the trailing escape, differs at it, trailing space
 *    Case 3:  leading percent before the escaped run, match and longer text
 *    Case 4:  ESCAPE %, match, longer text and a different escaped character
 *    Case 5:  doubled escape before the trailing escape, pattern ending in an escaped character
 *    Case 6:  trailing escape whose literal run has no escaped character
 *    Case 7:  LIKE as a WHERE condition, pattern from the column and a constant pattern
 *    Case 8:  constant LIKE expressions in the select list
 */

drop table if exists t_bin;

-- s = text, p = pattern, both binary collation; with ESCAPE _ the pattern a_%b_ is the literal a%b_
create table t_bin (id int primary key, s varchar(16) collate binary, p varchar(16) collate binary);
insert into t_bin values
 (1, 'a%b_x', 'a_%b_'), (2, 'a%b_', 'a_%b_'), (3, 'a%b', 'a_%b_'), (4, 'a%bx', 'a_%b_'), (5, 'a%b_ ', 'a_%b_'),
 (6, 'zza%b_', '%a_%b_'), (7, 'zza%b_x', '%a_%b_'),
 (8, 'a_b%', 'a%_b%'), (9, 'a_b%x', 'a%_b%'), (10, 'axb%', 'a%_b%'),
 (11, 'a__', 'a___'), (12, 'a%b_', 'a_%b__'),
 (13, 'ab_', 'ab_'), (14, 'a%xyzb_', 'a_%x%b_');


evaluate 'Case 1: issue repro with ESCAPE _, text longer than the match and text equal to it';
select id, s like p escape '_' from t_bin where id in (1, 2) order by id;


evaluate 'Case 2: same pattern, text ends before the trailing escape, differs at it, trailing space';
select id, s like p escape '_' from t_bin where id in (3, 4, 5) order by id;


evaluate 'Case 3: leading percent before the escaped run, match and longer text';
select id, s like p escape '_' from t_bin where id in (6, 7) order by id;


evaluate 'Case 4: ESCAPE %, match, longer text and a different escaped character';
select id, s like p escape '%' from t_bin where id in (8, 9, 10) order by id;


evaluate 'Case 5: doubled escape before the trailing escape, pattern ending in an escaped character';
select id, s like p escape '_' from t_bin where id in (11, 12) order by id;


evaluate 'Case 6: trailing escape whose literal run has no escaped character';
select id, s like p escape '_' from t_bin where id in (13, 14) order by id;


evaluate 'Case 7: LIKE as a WHERE condition, pattern from the column and a constant pattern';
select id from t_bin where id <= 7 and s like p escape '_' order by id;
select id from t_bin where s like _binary'a_%b_' escape '_' order by id;


evaluate 'Case 8: constant LIKE expressions in the select list';
select cast('a%b_' as varchar(16) collate binary) like cast('a_%b_' as varchar(16) collate binary) escape '_', _binary'a%b_' like _binary'a_%b_' escape '_';


drop table t_bin;
