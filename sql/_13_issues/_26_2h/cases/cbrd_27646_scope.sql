/**
 *  This test case verifies CBRD-27646 (scope extension): CONV(str, from_base, to_base) gives the
 *  same result for an input of any length, treats trailing blanks of a multibyte charset as RTRIM
 *  does, and rejects an empty BIT or BIT VARYING value as it rejects the empty string.
 *
 *  Before the fix an input longer than 65 bytes lost its last characters without an error (64
 *  zeros and ff gave 15), an euckr string ending in blank, full-width space, blank gave an error
 *  although its RTRIM gave 255, and X'' or B'' gave 0.
 *
 *  Each tested query is followed by its twin, whose block must equal the tested block: the short
 *  input without the leading zeros or extra blanks, the RTRIM of the input, or the invalid string
 *  '~' in the same form for an empty BIT value. Results of non-empty BIT values are kept literally.
 *
 *  Coverage:
 *    Case 1:  64 zeros and ff as a constant expression and as a literal, as reported
 *    Case 2:  total lengths 60 to 70, 128, 256 and 1000 bytes
 *    Case 3:  bases 2, 8, 10 and 36, a full 64-bit value, a negative base
 *    Case 4:  leading blanks, trailing blanks and a minus sign in long inputs
 *    Case 5:  an invalid character or a value out of range in a long input gives the error
 *    Case 6:  VARCHAR, CHAR, NCHAR and STRING columns
 *    Case 7:  iso88591, euckr and utf8 columns and literals
 *    Case 8:  host variables, subqueries and a derived table
 *    Case 9:  euckr strings ending in blanks and full-width spaces give their RTRIM result
 *    Case 10: other tails, blank-only strings and the utf8 and iso88591 charsets
 *    Case 11: empty BIT literals give the error of an invalid string
 *    Case 12: empty BIT VARYING column, host variable and subquery give the error
 *    Case 13: non-empty and NULL BIT values keep their results
 *    Case 14: the session still reads and writes after all errors
 */

drop table if exists t_len, t_short, t_badlong, t_badshort, t_ws, t_twin, t_bit;

-- long inputs: each row holds zeros and ff (or blanks, a sign) so that its total length is the given number of bytes;
-- t_short holds the same keys with the short input of the same value, the twin of every row
create table t_len (k varchar(10), s varchar(1000), c char(1000), nc nchar(1000), st string, si varchar(1000) collate iso88591_bin, se varchar(1000) collate euckr_bin, su varchar(1000) collate utf8_bin);
create table t_short (k varchar(10), s varchar(1000), c char(1000), nc nchar(1000), st string, si varchar(1000) collate iso88591_bin, se varchar(1000) collate euckr_bin, su varchar(1000) collate utf8_bin);
insert into t_len (k, s) values ('l63', concat(repeat('0', 61), 'ff'));
insert into t_short (k, s) values ('l63', 'ff');
insert into t_len (k, s) values ('l64', concat(repeat('0', 62), 'ff'));
insert into t_short (k, s) values ('l64', 'ff');
insert into t_len (k, s) values ('l65', concat(repeat('0', 63), 'ff'));
insert into t_short (k, s) values ('l65', 'ff');
insert into t_len (k, s) values ('l66', concat(repeat('0', 64), 'ff'));
insert into t_short (k, s) values ('l66', 'ff');
insert into t_len (k, s) values ('l67', concat(repeat('0', 65), 'ff'));
insert into t_short (k, s) values ('l67', 'ff');
insert into t_len (k, s) values ('l128', concat(repeat('0', 126), 'ff'));
insert into t_short (k, s) values ('l128', 'ff');
insert into t_len (k, s) values ('l1000', concat(repeat('0', 998), 'ff'));
insert into t_short (k, s) values ('l1000', 'ff');
insert into t_len (k, s) values ('lead', concat(repeat(' ', 64), 'ff'));
insert into t_short (k, s) values ('lead', ' ff');
insert into t_len (k, s) values ('trail', concat('ff', repeat(' ', 126)));
insert into t_short (k, s) values ('trail', 'ff ');
insert into t_len (k, s) values ('neg', concat('-', repeat('0', 64), '1'));
insert into t_short (k, s) values ('neg', '-1');
update t_len set c = s, nc = s, st = s, si = s, se = s, su = s;
update t_short set c = s, nc = s, st = s, si = s, se = s, su = s;
-- long inputs that must fail like their short forms: an invalid character, a value beyond 64 bits
create table t_badlong (k varchar(10), s varchar(1000));
insert into t_badlong values ('inv', concat(repeat('0', 64), 'ff~')), ('ovf', concat(repeat('0', 64), '1ffffffffffffffff'));
create table t_badshort (k varchar(10), s varchar(1000));
insert into t_badshort values ('inv', 'ff~'), ('ovf', '1ffffffffffffffff');
-- euckr strings with blank (20) and full-width space (A1A1) tails built from code values, utf8 and iso88591 strings
create table t_ws (k varchar(10), se varchar(20) collate euckr_bin, ce char(8) collate euckr_bin, su varchar(20) collate utf8_bin, sg varchar(20) collate utf8_en_ci, sk varchar(20) collate utf8_ko_cs, si varchar(20) collate iso88591_bin);
insert into t_ws (k, se) values ('sfs', cast('ff ' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || ' ');
insert into t_ws (k, se) values ('fw', cast('ff' as varchar(20) collate euckr_bin) || chr(41377 using euckr));
insert into t_ws (k, se) values ('sf', cast('ff ' as varchar(20) collate euckr_bin) || chr(41377 using euckr));
insert into t_ws (k, se) values ('fwfwss', cast('ff' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || chr(41377 using euckr) || '  ');
insert into t_ws (k, se) values ('sss', cast('ff   ' as varchar(20) collate euckr_bin));
insert into t_ws (k, se) values ('hg', cast('ff' as varchar(20) collate euckr_bin) || chr(45217 using euckr));
insert into t_ws (k, se) values ('hgs', cast('ff' as varchar(20) collate euckr_bin) || chr(45217 using euckr) || ' ');
insert into t_ws (k, se) values ('hgfw', cast('ff' as varchar(20) collate euckr_bin) || chr(45217 using euckr) || chr(41377 using euckr));
insert into t_ws (k, se) values ('blank', cast(' ' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || ' ');
insert into t_ws (k, se) values ('fwonly', chr(41377 using euckr));
insert into t_ws (k, se) values ('tilde', cast('~' as varchar(20) collate euckr_bin));
update t_ws set ce = se where k in ('sfs', 'fw', 'sf', 'fwfwss');
insert into t_ws (k, su, sg, sk, si) values ('utf', 'ff ' || chr(14909568 using utf8) || ' ', 'ff ' || chr(14909568 using utf8) || ' ', 'ff ' || chr(14909568 using utf8) || ' ', 'ff   ');
-- the invalid string '~' as the twin of an empty BIT value read from a column
create table t_twin (s varchar(10));
insert into t_twin values ('~');
-- BIT VARYING holds the empty value; BIT(8) pads X'' to X'00', a non-empty value
create table t_bit (k varchar(10), b bit varying(64), f bit(8));
insert into t_bit values ('empty', X'', X''), ('ff', X'ff', X'ff'), ('none', null, null);


evaluate 'Case 1: 64 zeros and ff as a constant expression and as a literal give 255 as reported; result = conv of ff';
select conv(concat(repeat('0', 64), 'ff'), 16, 10) as v;
select conv('ff', 16, 10) as v;
select conv('0000000000000000000000000000000000000000000000000000000000000000ff', 16, 10) as v;
select conv('ff', 16, 10) as v;


evaluate 'Case 2: total lengths 60 to 70, 128, 256 and 1000 bytes; result = conv of ff';
select conv(concat(repeat('0', 58), 'ff'), 16, 10) as la, conv(concat(repeat('0', 60), 'ff'), 16, 10) as lb, conv(concat(repeat('0', 61), 'ff'), 16, 10) as lc, conv(concat(repeat('0', 62), 'ff'), 16, 10) as ld, conv(concat(repeat('0', 63), 'ff'), 16, 10) as le, conv(concat(repeat('0', 64), 'ff'), 16, 10) as lf, conv(concat(repeat('0', 65), 'ff'), 16, 10) as lg, conv(concat(repeat('0', 66), 'ff'), 16, 10) as lh, conv(concat(repeat('0', 68), 'ff'), 16, 10) as li;
select conv('ff', 16, 10) as la, conv('ff', 16, 10) as lb, conv('ff', 16, 10) as lc, conv('ff', 16, 10) as ld, conv('ff', 16, 10) as le, conv('ff', 16, 10) as lf, conv('ff', 16, 10) as lg, conv('ff', 16, 10) as lh, conv('ff', 16, 10) as li;
select conv(concat(repeat('0', 126), 'ff'), 16, 10) as la, conv(concat(repeat('0', 254), 'ff'), 16, 10) as lb, conv(concat(repeat('0', 998), 'ff'), 16, 10) as lc;
select conv('ff', 16, 10) as la, conv('ff', 16, 10) as lb, conv('ff', 16, 10) as lc;


evaluate 'Case 3: bases 2, 8, 10 and 36, a full 64-bit value and a negative base in long inputs; result = the short input';
select conv(concat(repeat('0', 58), '11111111'), 2, 10) as a, conv(concat(repeat('0', 63), '377'), 8, 10) as b, conv(concat(repeat('0', 63), '255'), 10, 10) as c, conv(concat(repeat('0', 64), 'zz'), 36, 10) as d, conv(concat(repeat('0', 64), 'ff'), 16, 2) as e, conv(concat(repeat('0', 64), 'ff'), 16, 36) as f;
select conv('11111111', 2, 10) as a, conv('377', 8, 10) as b, conv('255', 10, 10) as c, conv('zz', 36, 10) as d, conv('ff', 16, 2) as e, conv('ff', 16, 36) as f;
select conv(concat(repeat('0', 992), '11111111'), 2, 10) as a, conv(concat(repeat('0', 997), '377'), 8, 10) as b, conv(concat(repeat('0', 997), '255'), 10, 10) as c, conv(concat(repeat('0', 998), 'zz'), 36, 10) as d, conv(concat(repeat('0', 998), 'ff'), 16, 2) as e, conv(concat(repeat('0', 998), 'ff'), 16, 36) as f;
select conv('11111111', 2, 10) as a, conv('377', 8, 10) as b, conv('255', 10, 10) as c, conv('zz', 36, 10) as d, conv('ff', 16, 2) as e, conv('ff', 16, 36) as f;
select conv(concat('0', repeat('1', 64)), 2, 10) as a, conv(concat('00', repeat('1', 64)), 2, 10) as b, conv(concat(repeat('0', 64), repeat('1', 64)), 2, 10) as c;
select conv(repeat('1', 64), 2, 10) as a, conv(repeat('1', 64), 2, 10) as b, conv(repeat('1', 64), 2, 10) as c;
select conv(concat(repeat('0', 64), 'ffffffffffffffff'), 16, 10) as a, conv(concat(repeat('0', 64), 'ffffffffffffffff'), 16, 2) as b, conv(concat(repeat('0', 64), 'zz'), -36, 10) as c;
select conv('ffffffffffffffff', 16, 10) as a, conv('ffffffffffffffff', 16, 2) as b, conv('zz', -36, 10) as c;


evaluate 'Case 4: leading blanks, trailing blanks and a minus sign in long inputs; result = the short input';
select conv(concat(repeat(' ', 62), 'ff'), 16, 10) as a, conv(concat(repeat(' ', 63), 'ff'), 16, 10) as b, conv(concat(repeat(' ', 64), 'ff'), 16, 10) as c, conv(concat(repeat(' ', 65), 'ff'), 16, 10) as d, conv(concat(repeat(' ', 126), 'ff'), 16, 10) as e, conv(concat(repeat(' ', 32), repeat('0', 32), 'ff'), 16, 10) as f;
select conv(' ff', 16, 10) as a, conv(' ff', 16, 10) as b, conv(' ff', 16, 10) as c, conv(' ff', 16, 10) as d, conv(' ff', 16, 10) as e, conv(' ff', 16, 10) as f;
select conv(concat('ff', repeat(' ', 62)), 16, 10) as a, conv(concat('ff', repeat(' ', 64)), 16, 10) as b, conv(concat('ff', repeat(' ', 126)), 16, 10) as c, conv(concat('ff', repeat(' ', 998)), 16, 10) as d;
select conv('ff ', 16, 10) as a, conv('ff ', 16, 10) as b, conv('ff ', 16, 10) as c, conv('ff ', 16, 10) as d;
select conv(concat('-', repeat('0', 62), '1'), 16, 10) as a, conv(concat('-', repeat('0', 63), '1'), 16, 10) as b, conv(concat('-', repeat('0', 64), '1'), 16, 10) as c, conv(concat('-', repeat('0', 65), '1'), 16, 10) as d, conv(concat('-', repeat('0', 126), '1'), 16, 10) as e, conv(concat('-', repeat('0', 64), 'ff'), 16, 10) as f;
select conv('-1', 16, 10) as a, conv('-1', 16, 10) as b, conv('-1', 16, 10) as c, conv('-1', 16, 10) as d, conv('-1', 16, 10) as e, conv('-ff', 16, 10) as f;


evaluate 'Case 5: an invalid character or a value beyond 64 bits in a long input gives the error of the short input';
select conv(concat(repeat('0', 64), 'ff~'), 16, 10) as v;
select conv('ff~', 16, 10) as v;
select conv(concat(repeat('0', 64), 'f~f'), 16, 10) as v;
select conv('f~f', 16, 10) as v;
select conv(concat(repeat('0', 997), 'ff~'), 16, 10) as v;
select conv('ff~', 16, 10) as v;
select conv(concat(repeat('0', 62), 'ff~'), 16, 10) as v;
select conv('ff~', 16, 10) as v;
select conv(concat(repeat('0', 64), '1ffffffffffffffff'), 16, 10) as v;
select conv('1ffffffffffffffff', 16, 10) as v;
select conv(concat(repeat('0', 40), '1ffffffffffffffff'), 16, 10) as v;
select conv('1ffffffffffffffff', 16, 10) as v;
select conv(s, 16, 10) as v from t_badlong where k = 'inv';
select conv(s, 16, 10) as v from t_badshort where k = 'inv';
select conv(s, 16, 10) as v from t_badlong where k = 'ovf';
select conv(s, 16, 10) as v from t_badshort where k = 'ovf';


evaluate 'Case 6: VARCHAR, CHAR, NCHAR and STRING columns of every length; result = the same rows of t_short';
select k, conv(s, 16, 10) as v from t_len order by k;
select k, conv(s, 16, 10) as v from t_short order by k;
select k, conv(c, 16, 10) as v from t_len order by k;
select k, conv(c, 16, 10) as v from t_short order by k;
select k, conv(nc, 16, 10) as v from t_len order by k;
select k, conv(nc, 16, 10) as v from t_short order by k;
select k, conv(st, 16, 10) as v from t_len order by k;
select k, conv(st, 16, 10) as v from t_short order by k;


evaluate 'Case 7: iso88591, euckr and utf8 columns and literals; result = the short input';
select k, conv(si, 16, 10) as v from t_len order by k;
select k, conv(si, 16, 10) as v from t_short order by k;
select k, conv(se, 16, 10) as v from t_len order by k;
select k, conv(se, 16, 10) as v from t_short order by k;
select k, conv(su, 16, 10) as v from t_len order by k;
select k, conv(su, 16, 10) as v from t_short order by k;
select conv(_iso88591'0000000000000000000000000000000000000000000000000000000000000000ff', 16, 10) as v;
select conv(_iso88591'ff', 16, 10) as v;
select conv(_euckr'0000000000000000000000000000000000000000000000000000000000000000ff', 16, 10) as v;
select conv(_euckr'ff', 16, 10) as v;
select conv(_utf8'0000000000000000000000000000000000000000000000000000000000000000ff', 16, 10) as v;
select conv(_utf8'ff', 16, 10) as v;


evaluate 'Case 8: host variables, subqueries and a derived table; result = the short input';
prepare st from 'select conv(?, 16, 10) as v';
execute st using '0000000000000000000000000000000000000000000000000000000000000000ff';
execute st using 'ff';
execute st using '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff';
execute st using 'ff';
prepare sb from 'select conv(?, ?, ?) as v';
execute sb using '000000000000000000000000000000000000000000000000000000000000000011111111', 2, 10;
execute sb using '11111111', 2, 10;
deallocate prepare st;
deallocate prepare sb;
select conv((select s from t_len where k = 'l66'), 16, 10) as v;
select conv((select s from t_short where k = 'l66'), 16, 10) as v;
select conv((select concat(repeat('0', 64), 'ff') from db_root), 16, 10) as v;
select conv((select 'ff' from db_root), 16, 10) as v;
select k, conv(x, 16, 10) as v from (select k, s as x from t_len) dt order by k;
select k, conv(x, 16, 10) as v from (select k, s as x from t_short) dt order by k;


evaluate 'Case 9: euckr strings ending in blanks and full-width spaces; result = conv of the RTRIM of the string';
select k, hex(se), hex(rtrim(se)) from t_ws where k in ('sfs', 'fw', 'sf', 'fwfwss', 'sss', 'hg', 'hgs', 'hgfw', 'blank', 'fwonly') order by k;
select conv(se, 16, 10) as v from t_ws where k = 'sfs';
select conv(rtrim(se), 16, 10) as v from t_ws where k = 'sfs';
select conv(se, 16, 10) as v from t_ws where k = 'fw';
select conv(rtrim(se), 16, 10) as v from t_ws where k = 'fw';
select conv(se, 16, 10) as v from t_ws where k = 'sf';
select conv(rtrim(se), 16, 10) as v from t_ws where k = 'sf';
select conv(se, 16, 10) as v from t_ws where k = 'fwfwss';
select conv(rtrim(se), 16, 10) as v from t_ws where k = 'fwfwss';
select conv(se, 16, 10) as v from t_ws where k = 'sss';
select conv(rtrim(se), 16, 10) as v from t_ws where k = 'sss';
select conv(ce, 16, 10) as v from t_ws where k = 'sfs';
select conv(rtrim(ce), 16, 10) as v from t_ws where k = 'sfs';
select conv(ce, 16, 10) as v from t_ws where k = 'fwfwss';
select conv(rtrim(ce), 16, 10) as v from t_ws where k = 'fwfwss';
select conv(cast('ff ' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || ' ', 16, 10) as v;
select conv(rtrim(cast('ff ' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || ' '), 16, 10) as v;
select conv(cast('ff' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || chr(41377 using euckr) || '  ', 16, 10) as v;
select conv(rtrim(cast('ff' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || chr(41377 using euckr) || '  '), 16, 10) as v;
select conv(cast(cast('ff ' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || ' ' as char(10) collate euckr_bin), 16, 10) as v;
select conv(rtrim(cast(cast('ff ' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || ' ' as char(10) collate euckr_bin)), 16, 10) as v;


evaluate 'Case 10: other tails, blank-only strings and the utf8 and iso88591 charsets; result = RTRIM or the invalid string';
select conv(se, 16, 10) as v from t_ws where k = 'hg';
select conv(rtrim(se), 16, 10) as v from t_ws where k = 'hg';
select conv(se, 16, 10) as v from t_ws where k = 'hgs';
select conv(rtrim(se), 16, 10) as v from t_ws where k = 'hgs';
select conv(se, 16, 10) as v from t_ws where k = 'hgfw';
select conv(rtrim(se), 16, 10) as v from t_ws where k = 'hgfw';
select conv(se, 16, 10) as v from t_ws where k = 'blank';
select conv(se, 16, 10) as v from t_ws where k = 'tilde';
select conv(se, 16, 10) as v from t_ws where k = 'fwonly';
select conv(se, 16, 10) as v from t_ws where k = 'tilde';
select conv(cast(' ' as varchar(20) collate euckr_bin) || chr(41377 using euckr) || ' ', 16, 10) as v;
select conv(cast('~' as varchar(20) collate euckr_bin), 16, 10) as v;
select conv(su, 16, 10) as v from t_ws where k = 'utf';
select conv(rtrim(su), 16, 10) as v from t_ws where k = 'utf';
select conv(sg, 16, 10) as v from t_ws where k = 'utf';
select conv(rtrim(sg), 16, 10) as v from t_ws where k = 'utf';
select conv(sk, 16, 10) as v from t_ws where k = 'utf';
select conv(rtrim(sk), 16, 10) as v from t_ws where k = 'utf';
select conv(si, 16, 10) as v from t_ws where k = 'utf';
select conv(rtrim(si), 16, 10) as v from t_ws where k = 'utf';
select conv('ff ' || chr(14909568 using utf8) || ' ', 16, 10) as v;
select conv(rtrim('ff ' || chr(14909568 using utf8) || ' '), 16, 10) as v;


evaluate 'Case 11: empty BIT literals give the error of the invalid string in the same form';
select conv(X'', 16, 10) as v;
select conv('~', 16, 10) as v;
select conv(B'', 2, 10) as v;
select conv('~', 2, 10) as v;
select conv(X'', 2, 10) as v;
select conv('~', 2, 10) as v;
select conv(B'', 16, 10) as v;
select conv('~', 16, 10) as v;
select conv(X'', 16, 36) as v;
select conv('~', 16, 36) as v;
select conv(X'', -16, 10) as v;
select conv('~', -16, 10) as v;
select conv(cast(X'' as bit varying(8)), 16, 10) as v;
select conv(cast('~' as varchar(8)), 16, 10) as v;
select conv(X'', 0, 10) as a, conv(X'', 37, 10) as b, conv(X'', null, 10) as c, conv(B'', 2, null) as d;
select conv('~', 0, 10) as a, conv('~', 37, 10) as b, conv('~', null, 10) as c, conv('~', 2, null) as d;


evaluate 'Case 12: empty BIT VARYING column, host variable and subquery give the error of the invalid string';
select conv(b, 16, 10) as v from t_bit where k = 'empty';
select conv(s, 16, 10) as v from t_twin;
select conv(b, 2, 10) as v from t_bit where k = 'empty';
select conv(s, 2, 10) as v from t_twin;
prepare sx from 'select conv(?, 16, 10) as v';
execute sx using X'';
execute sx using '~';
execute sx using X'ff';
deallocate prepare sx;
select conv((select b from t_bit where k = 'empty'), 16, 10) as v;
select conv((select s from t_twin), 16, 10) as v;
select conv(x, 16, 10) as v from (select b as x from t_bit where k = 'empty') dt;
select conv(x, 16, 10) as v from (select s as x from t_twin) dt;


evaluate 'Case 13: non-empty and NULL BIT values keep their results, BIT(8) pads the empty value to one zero byte';
select conv(X'ff', 16, 10), conv(B'11111111', 2, 10), conv(X'ff', 2, 10), conv(B'11111111', 16, 10), conv(B'1', 2, 10), conv(X'0f', 16, 10), conv(X'ff', 16, 36);
select conv(X'00000000000000000000000000000000000000000000000000000000000000ff', 16, 10), conv(cast(null as bit varying), 16, 10);
select k, bit_length(b), hex(b), bit_length(f), hex(f), conv(f, 16, 10) from t_bit order by k;
select k, conv(b, 16, 10) from t_bit where k <> 'empty' order by k;


evaluate 'Case 14: the session still reads and writes after all errors';
insert into t_bit values ('more', X'0f', X'0f');
insert into t_len (k, s) values ('more', concat(repeat('0', 64), 'f0'));
select k, conv(b, 16, 10) from t_bit where k in ('ff', 'more') order by k;
select count(*) from t_len;

drop table t_len, t_short, t_badlong, t_badshort, t_ws, t_twin, t_bit;
