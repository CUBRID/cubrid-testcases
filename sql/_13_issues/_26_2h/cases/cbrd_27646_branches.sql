/**
 *  This test case verifies CBRD-27646 on the branches of CONV next to the fix: the copy of a
 *  string argument and the trim of its trailing spaces run only for a string of one byte or more.
 *
 *  Before the fix an empty string entered the trim loop and stopped the server or the client that
 *  evaluated it. The fix skips the copy and the trim, so the empty range is rejected like any
 *  other invalid string. Strings of one byte or more still run the loop and keep their results.
 *
 *  Each query that must fail is followed by its twin, the same shape with the invalid string '~',
 *  whose block must equal the tested block. Valid inputs are written with their results. Case 6
 *  turns return_null_on_function_errors on, so the empty string and the twin both give NULL, and
 *  turns it back to the default, so the error comes back.
 *
 *  Coverage:
 *    Case 1:  binary charset literal and column, where the loop steps over raw bytes
 *    Case 2:  euckr full-width space, one two-byte char that the loop trims
 *    Case 3:  tab and newline, trimmed like the space
 *    Case 4:  strings longer than 65 bytes, trailing spaces trimmed whatever the length
 *    Case 5:  a sign or the 0x prefix without digits
 *    Case 6:  return_null_on_function_errors gives NULL for the empty string and its twin
 */

drop table if exists t_src, t_bin, t_ws;

-- strings read by the server: the empty string and its twin, a tab, strings longer than 65 bytes
create table t_src (k varchar(10), s varchar(200));
insert into t_src values ('empty', ''), ('bad', '~'), ('tab', chr(9)), ('tabbad', concat('~', chr(9))), ('long', concat('ff', repeat(' ', 100))), ('blank', repeat(' ', 100)), ('blankbad', concat('~', repeat(' ', 99)));
-- binary charset strings: the empty value, its twin, a lone space and values with trailing spaces
create table t_bin (k varchar(10), b varchar(10) collate binary);
insert into t_bin values ('empty', ''), ('bad', '~'), ('space', ' '), ('hex', 'ff'), ('pad', 'ff  ');
-- euckr strings with the full-width space, stored as the two bytes A1A1
create table t_ws (k varchar(10), se varchar(10) collate euckr_bin);
insert into t_ws values ('ws', '　'), ('wsws', '　　'), ('ffws', 'ff　'), ('bad', '~');


evaluate 'Case 1: binary charset literal and column; the empty string and a lone space give the error of the twin, values keep their results';
select k, charset(b) as cs from t_bin order by k;
select conv(_binary'', 16, 10) as v;
select conv(_binary'~', 16, 10) as v;
select conv(_binary' ', 16, 10) as v;
select conv(_binary'~ ', 16, 10) as v;
select conv(b, 16, 10) as v from t_bin where k = 'empty';
select conv(b, 16, 10) as v from t_bin where k = 'bad';
select conv(b, 16, 10) as v from t_bin where k = 'space';
select conv(b, 16, 10) as v from t_bin where k = 'bad';
select conv(_binary'ff', 16, 10) as plain_hex, conv(_binary'ff ', 16, 10) as padded_hex;
select k, conv(b, 16, 10) as v from t_bin where k in ('hex', 'pad') order by k;


evaluate 'Case 2: euckr full-width space is one two-byte char; trimmed to nothing it gives the error of the twin, after digits it is trimmed';
select k, hex(se) as h, char_length(se) as char_cnt, octet_length(se) as byte_cnt from t_ws order by k;
select conv(se, 16, 10) as v from t_ws where k = 'ws';
select conv(se, 16, 10) as v from t_ws where k = 'bad';
select conv(se, 16, 10) as v from t_ws where k = 'wsws';
select conv(se, 16, 10) as v from t_ws where k = 'bad';
select conv(cast('　' as varchar(10) collate euckr_bin), 16, 10) as v;
select conv(cast('~' as varchar(10) collate euckr_bin), 16, 10) as v;
select k, conv(se, 16, 10) as v from t_ws where k = 'ffws' order by k;
select conv(cast('ff　' as varchar(10) collate euckr_bin), 16, 10) as v;


evaluate 'Case 3: tab and newline are trimmed like the space; alone they give the error of the twin';
select conv(chr(9), 16, 10) as v;
select conv(chr(126), 16, 10) as v;
select conv(concat(chr(9), chr(10)), 16, 10) as v;
select conv(concat(chr(126), chr(10)), 16, 10) as v;
select conv(s, 16, 10) as v from t_src where k = 'tab';
select conv(s, 16, 10) as v from t_src where k = 'tabbad';
select conv(concat('ff', chr(9)), 16, 10) as tab_end, conv(concat('ff', chr(10), chr(13)), 16, 10) as newline_end;


evaluate 'Case 4: strings longer than 65 bytes; trailing spaces are trimmed, blanks only give the error of the twin';
select k, octet_length(s) as byte_cnt, conv(s, 16, 10) as v from t_src where k = 'long' order by k;
select conv(s, 16, 10) as v from t_src where k = 'blank';
select conv(s, 16, 10) as v from t_src where k = 'blankbad';
select conv(repeat(' ', 100), 16, 10) as v;
select conv(concat('~', repeat(' ', 99)), 16, 10) as v;
select conv(concat(repeat('0', 63), 'ff'), 16, 10) as fits, conv(concat(repeat('0', 63), 'ff', ' '), 16, 10) as one_blank_more, conv(concat('ff', repeat(' ', 100)), 16, 10) as long_pad;


evaluate 'Case 5: a sign or the 0x prefix without digits gives the error of the twin, with digits the value';
select conv('+', 16, 10) as v;
select conv('~', 16, 10) as v;
select conv('0x', 16, 10) as v;
select conv('~', 16, 10) as v;
select conv('0xff', 16, 10) as lower_x, conv('0XFF', 16, 10) as upper_x;


evaluate 'Case 6: return_null_on_function_errors=yes gives NULL for the empty string as for the twin, the default gives the error again';
set system parameters 'return_null_on_function_errors=yes';
select conv('', 16, 10) as v;
select conv('~', 16, 10) as v;
select conv(s, 16, 10) as v from t_src where k = 'empty';
select conv(s, 16, 10) as v from t_src where k = 'bad';
select conv(_binary'', 16, 10) as v;
select conv(_binary'~', 16, 10) as v;
prepare st from 'select conv(?, 16, 10) as v';
execute st using '';
execute st using '~';
execute st using 'ff';
deallocate prepare st;
set system parameters 'return_null_on_function_errors=default';
select conv(s, 16, 10) as v from t_src where k = 'empty';
select conv(s, 16, 10) as v from t_src where k = 'bad';

drop table t_src, t_bin, t_ws;
