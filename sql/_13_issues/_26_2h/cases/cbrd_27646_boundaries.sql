/**
 *  This test case verifies the code paths of CBRD-27646 (scope extension) that the black-box file
 *  cbrd_27646_scope.sql does not reach: the heap copy that CONV makes of an input too long for its
 *  66-byte buffer (a string of 66 bytes or more, a bit string of 33 bytes or more), and the euckr
 *  backward walk intl_prevchar_euc, which RTRIM, TRIM, INSTR and SUBSTRING_INDEX also use.
 *
 *  Before the fix CONV read only the first 65 bytes of a string and 32 bytes of a bit string, and
 *  the backward walk read an ASCII byte after a two-byte euckr char as the second byte of that
 *  char, so RTRIM or TRIM with a trim string, INSTR with a negative position and SUBSTRING_INDEX
 *  with a negative count gave other results on euckr than on the same text in utf8.
 *
 *  Each tested query is followed by its twin, whose block must equal the tested block: the short
 *  input, or the same text in utf8 with a string result converted back to euckr. Plain queries
 *  without a twin give the same block before and after the fix.
 *
 *  Coverage:
 *    Case 1:  invalid or blank chars at bytes 65 to 70 of a string, CHAR(65) and CHAR(66) columns
 *    Case 2:  sign, signed bases, overflow, the 0x prefix and a decimal point in long strings
 *    Case 3:  euckr full-width spaces and a utf8 char across the old 65-byte limit
 *    Case 4:  bit strings of 32, 33 and 34 bytes, 256 and 257 bits, column and host variable
 *    Case 5:  return_null_on_function_errors=yes gives NULL for long strings and empty bit strings
 *    Case 6:  RTRIM and TRIM with a trim string on euckr give the result of the same utf8 text
 *    Case 7:  INSTR with a negative position and SUBSTRING_INDEX with a negative count on euckr
 *    Case 8:  the same functions on constant euckr strings, evaluated before execution
 *    Case 9:  CONV of euckr strings ending in a full-width space and a tab or a blank
 *    Case 10: RTRIM without a trim string keeps its result, and the session still reads and writes
 */

drop table if exists t_lng, t_sht, t_ch, t_lse, t_bv, t_e;

-- long strings and their short twins, keyed alike
create table t_lng (k varchar(10), s varchar(200));
create table t_sht (k varchar(10), s varchar(200));
insert into t_lng values ('blankcut', concat('ff', repeat(' ', 63), 'zz')), ('hexpfx', concat('0x', repeat('0', 62), 'ff'));
insert into t_sht values ('blankcut', 'ff zz'), ('hexpfx', '0xff');
create table t_ch (k varchar(10), a char(65), b char(66), v varchar(66));
insert into t_ch values ('ff', 'ff', 'ff', 'ff');
-- euckr: ff and 32 full-width spaces (66 bytes); the twin is its RTRIM
create table t_lse (k varchar(10), se varchar(100) collate euckr_bin);
insert into t_lse values ('fw', cast('ff' as varchar(100) collate euckr_bin) || repeat(chr(41377 using euckr), 32));
-- bit varying values of 33 bytes and their one-byte twins
create table t_bv (k varchar(10), b bit varying(2000));
insert into t_bv values ('long', X'0000000000000000000000000000000000000000000000000000000000000000ff'), ('short', X'ff'), ('empty', X'');
-- the same text in utf8 (su, trim string tu) and in euckr (se, te); G is U+AC00 (euckr B0A1), A is U+00E1 (euckr 8FABA1)
create table t_e (k varchar(10), su varchar(40) collate utf8_bin, tu varchar(10) collate utf8_bin, se varchar(40) collate euckr_bin, te varchar(10) collate euckr_bin);
insert into t_e (k, su, tu) values ('gs', chr(15380608 using utf8) || ' ', ' ');
insert into t_e (k, su, tu) values ('gss', chr(15380608 using utf8) || '  ', ' ');
insert into t_e (k, su, tu) values ('ga', chr(15380608 using utf8) || 'a', 'a');
insert into t_e (k, su, tu) values ('gab', chr(15380608 using utf8) || 'ab', 'ab');
insert into t_e (k, su, tu) values ('ggs', chr(15380608 using utf8) || chr(15380608 using utf8) || ' ', chr(15380608 using utf8) || ' ');
insert into t_e (k, su, tu) values ('gdel', chr(15380608 using utf8) || chr(127 using utf8), chr(127 using utf8));
insert into t_e (k, su, tu) values ('gfw', chr(15380608 using utf8) || chr(14909568 using utf8), chr(14909568 using utf8));
insert into t_e (k, su, tu) values ('acs', chr(50081 using utf8) || ' ', ' ');
insert into t_e (k, su, tu) values ('acab', chr(50081 using utf8) || 'ab', 'a');
insert into t_e (k, su, tu) values ('agaga', 'a' || chr(15380608 using utf8) || 'a' || chr(15380608 using utf8) || 'a', 'a');
insert into t_e (k, su, tu) values ('gabc', chr(15380608 using utf8) || 'abc', 'a');
insert into t_e (k, su, tu) values ('agab', 'a' || chr(15380608 using utf8) || 'ab', 'a');
insert into t_e (k, su, tu) values ('ggab', chr(15380608 using utf8) || chr(15380608 using utf8) || 'ab', chr(15380608 using utf8));
insert into t_e (k, su, tu) values ('gsb', chr(15380608 using utf8) || ' b', ' ');
update t_e set se = cast(su as varchar(40) collate euckr_bin), te = cast(tu as varchar(10) collate euckr_bin);


evaluate 'Case 1: invalid or blank chars at bytes 65 to 70 of a string, CHAR(65) and CHAR(66); result = the short input';
select conv(concat('ff', repeat(' ', 63), 'zz'), 16, 10) as v;
select conv('ff zz', 16, 10) as v;
select conv(s, 16, 10) as v from t_lng where k = 'blankcut';
select conv(s, 16, 10) as v from t_sht where k = 'blankcut';
select conv(concat(repeat('0', 64), 'f', 'z'), 16, 10) as v;
select conv('fz', 16, 10) as v;
select conv(concat(repeat('0', 63), 'z', 'ff'), 16, 10) as v;
select conv('zff', 16, 10) as v;
select conv(concat(repeat('0', 64), 'f', ' '), 16, 10) as v;
select conv('f ', 16, 10) as v;
select conv(repeat(' ', 70), 16, 10) as v;
select conv(' ', 16, 10) as v;
select conv(a, 16, 10) as a, conv(b, 16, 10) as b from t_ch;
select conv(v, 16, 10) as a, conv(v, 16, 10) as b from t_ch;


evaluate 'Case 2: sign, signed bases, overflow, the 0x prefix and a decimal point in long strings; result = the short input';
select conv(concat('-', repeat('0', 64), '1'), -10, -10) as a, conv(concat('-', repeat('0', 64), '1'), -10, 10) as b;
select conv('-1', -10, -10) as a, conv('-1', -10, 10) as b;
select conv(concat(repeat('0', 50), '8000000000000000'), -16, 10) as v;
select conv('8000000000000000', -16, 10) as v;
select conv(concat(repeat('0', 50), '8000000000000000'), 16, 10) as v;
select conv('8000000000000000', 16, 10) as v;
select conv(concat(repeat('0', 50), '18446744073709551616'), 10, 10) as v;
select conv('18446744073709551616', 10, 10) as v;
select conv(concat('0x', repeat('0', 62), 'ff'), 16, 10) as v;
select conv('0xff', 16, 10) as v;
select conv(s, 16, 10) as v from t_lng where k = 'hexpfx';
select conv(s, 16, 10) as v from t_sht where k = 'hexpfx';
select conv(concat('255.', repeat('0', 61), 'z'), 10, 10) as v;
select conv('255.z', 10, 10) as v;
select conv(concat('255.', repeat('0', 70)), 10, 10) as v;
select conv('255.0', 10, 10) as v;


evaluate 'Case 3: euckr full-width spaces and a utf8 char across the old 65-byte limit; result = RTRIM or the short input';
select octet_length(se) as n, hex(rtrim(se)) as h from t_lse;
select conv(se, 16, 10) as v from t_lse;
select conv(rtrim(se), 16, 10) as v from t_lse;
select conv(cast('ff' as varchar(100) collate euckr_bin) || repeat(chr(41377 using euckr), 32), 16, 10) as v;
select conv(rtrim(cast('ff' as varchar(100) collate euckr_bin) || repeat(chr(41377 using euckr), 32)), 16, 10) as v;
select conv(cast('ff' as varchar(100) collate euckr_bin) || repeat(chr(41377 using euckr), 31) || ' ' || chr(41377 using euckr), 16, 10) as v;
select conv(rtrim(cast('ff' as varchar(100) collate euckr_bin) || repeat(chr(41377 using euckr), 31) || ' ' || chr(41377 using euckr)), 16, 10) as v;
select conv(cast('f' as varchar(100) collate euckr_bin) || repeat(chr(41377 using euckr), 32), 16, 10) as v;
select conv(rtrim(cast('f' as varchar(100) collate euckr_bin) || repeat(chr(41377 using euckr), 32)), 16, 10) as v;
select conv(concat('ff', repeat(' ', 63), chr(15380608 using utf8)), 16, 10) as v;
select conv(concat('ff ', chr(15380608 using utf8)), 16, 10) as v;


evaluate 'Case 4: bit strings of 32, 33 and 34 bytes, 256 and 257 bits, column and host variable; result = the short bit string';
select conv(X'00000000000000000000000000000000000000000000000000000000000000ff', 16, 10) as a, conv(X'0000000000000000000000000000000000000000000000000000000000000000ff', 16, 10) as b, conv(X'000000000000000000000000000000000000000000000000000000000000000000ff', 16, 10) as c;
select conv(X'ff', 16, 10) as a, conv(X'ff', 16, 10) as b, conv(X'ff', 16, 10) as c;
select conv(X'00000000000000000000000000000000000000000000000000ffffffffffffffff', 16, 10) as a, conv(X'00000000000000000000000000000000000000000000000000ffffffffffffffff', 16, -10) as b;
select conv(X'ffffffffffffffff', 16, 10) as a, conv(X'ffffffffffffffff', 16, -10) as b;
select conv(X'000000000000000000000000000000000000000000000000010000000000000000', 16, 10) as v;
select conv(X'010000000000000000', 16, 10) as v;
select conv(B'00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001', 2, 10) as a, conv(B'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001', 2, 10) as b;
select conv(B'1', 2, 10) as a, conv(X'01', 2, 10) as b;
select k, bit_length(b) as n from t_bv order by k;
select conv(b, 16, 10) as v from t_bv where k = 'long';
select conv(b, 16, 10) as v from t_bv where k = 'short';
prepare st from 'select conv(?, 16, 10) as v';
execute st using X'0000000000000000000000000000000000000000000000000000000000000000ff';
execute st using X'ff';
deallocate prepare st;


evaluate 'Case 5: return_null_on_function_errors=yes gives NULL for long strings and empty bit strings, as for the invalid string';
set system parameters 'return_null_on_function_errors=yes';
select conv(concat('ff', repeat(' ', 63), 'zz'), 16, 10) as a, conv(concat(repeat('0', 64), 'ffz'), 16, 10) as b, conv(X'', 16, 10) as c;
select conv('~', 16, 10) as a, conv('~', 16, 10) as b, conv('~', 16, 10) as c;
select k, conv(b, 16, 10) as v from t_bv where k <> 'short' order by k;
select k, conv(case when k = 'long' then 'ff' else '~' end, 16, 10) as v from t_bv where k <> 'short' order by k;
set system parameters 'return_null_on_function_errors=default';
select conv(b, 16, 10) as v from t_bv where k = 'empty';
select conv(s, 16, 10) as v from t_sht where k = 'blankcut';


evaluate 'Case 6: RTRIM and TRIM with a trim string on euckr; result = the same text in utf8, converted back to euckr';
select k, hex(su) as hu, hex(se) as he, hex(te) as ht from t_e order by k;
select k, hex(rtrim(se, te)) as h, char_length(rtrim(se, te)) as n from t_e order by k;
select k, hex(cast(rtrim(su, tu) as varchar(40) collate euckr_bin)) as h, char_length(rtrim(su, tu)) as n from t_e order by k;
select k, hex(trim(trailing te from se)) as h from t_e order by k;
select k, hex(cast(trim(trailing tu from su) as varchar(40) collate euckr_bin)) as h from t_e order by k;
select k, hex(trim(both te from se)) as h from t_e order by k;
select k, hex(cast(trim(both tu from su) as varchar(40) collate euckr_bin)) as h from t_e order by k;


evaluate 'Case 7: INSTR with a negative position and SUBSTRING_INDEX with a negative count on euckr; result = the same text in utf8';
select k, instr(se, te, -1) as a, instr(se, te, -2) as b, instr(se, te, 1) as c from t_e order by k;
select k, instr(su, tu, -1) as a, instr(su, tu, -2) as b, instr(su, tu, 1) as c from t_e order by k;
select k, hex(substring_index(se, te, -1)) as a, hex(substring_index(se, te, -2)) as b, hex(substring_index(se, te, 1)) as c from t_e order by k;
select k, hex(cast(substring_index(su, tu, -1) as varchar(40) collate euckr_bin)) as a, hex(cast(substring_index(su, tu, -2) as varchar(40) collate euckr_bin)) as b, hex(cast(substring_index(su, tu, 1) as varchar(40) collate euckr_bin)) as c from t_e order by k;


evaluate 'Case 8: the same functions on constant euckr strings, evaluated before execution; result = the same text in utf8';
select hex(rtrim(chr(11575584 using euckr), chr(32 using euckr))) as a, hex(rtrim(chr(2963366242 using euckr), chr(24930 using euckr))) as b, hex(trim(both chr(97 using euckr) from chr(1638965601 using euckr))) as c, instr(chr(2963366242 using euckr), chr(97 using euckr), -1) as d, hex(substring_index(chr(2963366242 using euckr), chr(97 using euckr), -1)) as e;
select hex(cast(rtrim(chr(15380608 using utf8) || ' ', ' ') as varchar(40) collate euckr_bin)) as a, hex(cast(rtrim(chr(15380608 using utf8) || 'ab', 'ab') as varchar(40) collate euckr_bin)) as b, hex(cast(trim(both 'a' from 'a' || chr(15380608 using utf8) || 'a') as varchar(40) collate euckr_bin)) as c, instr(chr(15380608 using utf8) || 'ab', 'a', -1) as d, hex(cast(substring_index(chr(15380608 using utf8) || 'ab', 'a', -1) as varchar(40) collate euckr_bin)) as e;


evaluate 'Case 9: CONV of euckr strings ending in a full-width space and a tab or a blank; result = without the full-width space or RTRIM';
select conv(cast('12' as varchar(10) collate euckr_bin) || chr(41377 using euckr) || chr(9 using euckr), 10, 16) as v;
select conv(cast('12' as varchar(10) collate euckr_bin) || chr(9 using euckr), 10, 16) as v;
select conv(cast('A' as varchar(10) collate euckr_bin) || chr(41377 using euckr) || ' ', 16, 10) as v;
select conv(rtrim(cast('A' as varchar(10) collate euckr_bin) || chr(41377 using euckr) || ' '), 16, 10) as v;
select conv(cast('12' as varchar(10) collate euckr_bin) || chr(41377 using euckr) || chr(41377 using euckr) || ' ', 10, 16) as v;
select conv(rtrim(cast('12' as varchar(10) collate euckr_bin) || chr(41377 using euckr) || chr(41377 using euckr) || ' '), 10, 16) as v;


evaluate 'Case 10: RTRIM without a trim string keeps its result, and the session still reads and writes';
select k, hex(rtrim(se)) as h from t_e where k in ('gs', 'gss', 'ga', 'ggs', 'gfw', 'acs') order by k;
insert into t_bv values ('more', X'0f');
select k, conv(b, 16, 10) as v from t_bv where k in ('short', 'more') order by k;

drop table t_lng, t_sht, t_ch, t_lse, t_bv, t_e;
