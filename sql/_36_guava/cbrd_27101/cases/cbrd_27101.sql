-- This test case verifies CBRD-27101 : a CALL statement prepared as a call
-- (JDBC prepareCall, CCI_PREPARE_CALL) was rejected with "Illegal CALL
-- statement" (-10023) when the statement began with a comment.
--
-- Bug: before classifying a statement as CALL and before detecting the leading
-- out parameter of "? = call", the broker looked at the raw first character of
-- the text. It did not skip leading whitespace or comments, so a valid CALL
-- preceded by a comment was rejected. A comment placed between "?" and "="
-- was not skipped either.
--
-- Fix: whitespace and comments (block, "--" and "//") are skipped,
-- without modifying the text, before detecting "?" and again after "? =",
-- before classifying the statement.
--
-- Note: CTP decides prepareCall only from the LAST line of a statement: after
-- removing spaces it must start with "call" (lower case, with "?" inside the
-- parentheses on that line) or with "?=call". Lines starting with "--" are
-- dropped and every line is trimmed. So in every case below the part under
-- test is put on the preceding line(s) and the last line starts with "call",
-- and that preceding text reaches prepareCall as it is, joined with a newline.
--
-- Note: "--" comment lines like these ones are not sent to the server.

create table t_call (a int);
insert into t_call values (1), (2), (3);

create or replace procedure p_count (n out int) as
begin
    select count(*) into n from t_call;
end;

create or replace function f_add (x int) return int as
begin
    return x + 100;
end;


-- Case 1 (baseline): no leading comment
$out:integer,$NULL;
call p_count(?);

-- Case 2: block comment before CALL
--   before fix : Error:-10023, after fix : 3
$out:integer,$NULL;
/* leading comment */
call p_count(?);

-- Case 3: "//" line comment before CALL
--   the comment stops at the newline, which must be consumed as whitespace
--   before the statement is classified
$out:integer,$NULL;
// leading line comment
call p_count(?);

-- Case 4: "--" line comment before CALL
--   a line starting with "--" is dropped by CTP, so a block comment is put
--   in front of it to keep the "--" comment in the statement text
$out:integer,$NULL;
/* c */ -- leading line comment
call p_count(?);

-- Case 5 (baseline): "? = call" without comment
$out:integer,$NULL,$integer,$10;
? = call f_add(?);

-- Case 6: block comment before "? = call"
--   the first character is not "?", so the out parameter was not detected
$out:integer,$NULL,$integer,$10;
/* c */
? = call f_add(?);

-- Case 7: block comment between "?" and "="
--   before fix : passes (the first "=" is the real separator; coverage only)
$out:integer,$NULL,$integer,$10;
? /* c */ =
call f_add(?);

-- Case 8: comment containing "=" between "?" and "="
--   the "=" inside the comment must not be taken as the separator
$out:integer,$NULL,$integer,$10;
? /* a=b */ =
call f_add(?);

-- Case 9: comments before "?" and between "=" and CALL
$out:integer,$NULL,$integer,$10;
/* c */ ? = /* d */
call f_add(?);

-- Case 10: "?:1 = call" form (numbered marker before "=")
--   the "=" scan now advances one position at a time, skipping comments;
--   ":1" must still be passed over to reach the separator
--   before fix : passes (regression check)
$out:integer,$NULL,$integer,$10;
?:1 =
call f_add(?);

-- Case 11: "?:1" with a block comment before "="
--   before fix : passes (regression check)
$out:integer,$NULL,$integer,$10;
?:1 /* c */ =
call f_add(?);

-- Case 12: "--" line comment containing "=" between "?" and "="
--   the comment runs to the newline, and the "=" inside it must not be taken
--   as the separator
--   before fix : Error:-10023, after fix : 110
$out:integer,$NULL,$integer,$10;
? -- a=b
=
call f_add(?);

-- Case 13: "//" line comment containing "=" between "?" and "="
--   before fix : Error:-10023, after fix : 110
$out:integer,$NULL,$integer,$10;
? // a=b
=
call f_add(?);

-- Case 14: hint style comment before CALL
--   the skip treats a hint comment like any other comment
$out:integer,$NULL;
/*+ RECOMPILE */
call p_count(?);


-- Negative cases: must be rejected with -10023 after the fix

-- Case 15: not a CALL statement although prepared as a call
--   the "call (?)" part is inside the block comment
select a from t_call /*
call (?) */;

-- Case 16: "?" with no "="
$out:integer,$NULL,$integer,$10;
?
call f_add(?);

-- Case 17: unterminated block comment containing "=" after "?"
--   the "=" is inside the comment, so no separator exists and the statement
--   must be rejected
--   before fix : 110 (the "=" in the comment was taken as the separator and
--   the rest was accepted), after fix : Error:-10023
--   placed before the drops so that f_add still exists for the old behavior;
--   CTP keeps its comment state after this, which matters only for PL/CSQL
--   text, and none follows
$out:integer,$NULL,$integer,$10;
? /* =
call f_add(?);


drop function f_add;
drop procedure p_count;
drop table t_call;

-- Case 18: unterminated block comment swallows the whole statement
--   the skip must stop at the end of the text
--   kept as the last statement: CTP keeps its comment state after this
/* c
call p_count(?);
