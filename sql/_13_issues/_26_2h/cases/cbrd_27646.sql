/**
 *  This test case verifies CBRD-27646: CONV(str, from_base, to_base) with an empty string as str
 *  returns the error of any other invalid input and leaves the server and the client alive.
 *
 *  An invalid first argument returns "Function called with missing or invalid arguments." The empty
 *  string must return the same error whether it comes from a column (evaluated by the server), a
 *  literal or a constant expression (evaluated while the statement is prepared), a host variable or a
 *  subquery, for every string type, charset and base. The build before the fix stops the server or
 *  the broker at the first empty string, so every later block differs there.
 *
 *  Each tested query is followed by its twin, the same query with the invalid string '~' (or a row
 *  holding it), whose block must equal the tested block. Results of other inputs are written literally.
 *
 *  Coverage:
 *    Case 1:  VARCHAR column holding the empty string, as reported
 *    Case 2:  empty string literal
 *    Case 3:  valid inputs keep their results
 *    Case 4:  blank strings and a lone minus sign give the same error
 *    Case 5:  CHAR(n) and NCHAR(n) columns padding the empty value, CAST to CHAR(n)
 *    Case 6:  NCHAR VARYING and STRING columns, national literal
 *    Case 7:  iso88591, euckr and utf8 charsets and collations
 *    Case 8:  valid bases 2, 8, 10 and 36, bases read from columns
 *    Case 9:  negative bases give the error, bases out of range or NULL give NULL
 *    Case 10: NULL input and SUBSTR past the end give NULL
 *    Case 11: expressions that produce the empty string
 *    Case 12: host variables
 *    Case 13: subqueries and a derived table
 *    Case 14: WHERE, INSERT SELECT and UPDATE leave the data unchanged
 *    Case 15: the session still reads and writes after all errors
 */

drop table if exists tc, t_twin, t_conv, t_out;

-- the table of the report, one empty string, and its twin holding an invalid character
create table tc (s varchar(10));
insert into tc values ('');
create table t_twin (s varchar(10));
insert into t_twin values ('~');
-- one row per input; every string type, charset and collation holds the same value
create table t_conv (k varchar(10), s varchar(10), c char(5), nc nchar(5), nv nchar varying(10), st string, si varchar(10) collate iso88591_bin, se varchar(10) collate euckr_bin, su varchar(10) collate utf8_en_ci, w varchar(16), fb int, tb int);
insert into t_conv values ('empty', '', '', N'', N'', '', '', '', '', 'a', 16, 10);
insert into t_conv values ('bad', '~', '~', N'~', N'~', '~', '~', '~', '~', 'a~', 16, 10);
insert into t_conv values ('space', ' ', ' ', N' ', N' ', ' ', ' ', ' ', ' ', 'a ', 16, 10);
insert into t_conv values ('blank', '   ', '   ', N'   ', N'   ', '   ', '   ', '   ', '   ', 'a   ', 16, 10);
insert into t_conv values ('minus', '-', '-', N'-', N'-', '-', '-', '-', '-', 'a-', 16, 10);
insert into t_conv values ('hex', 'ff', 'ff', N'ff', N'ff', 'ff', 'ff', 'ff', 'ff', 'aff', 16, 10);
insert into t_conv values ('none', null, null, null, null, null, null, null, null, null, 16, 10);
create table t_out (v varchar(64));


evaluate 'Case 1: VARCHAR column holding the empty string as reported; the same error as the invalid string, then 255';
select conv(s, 16, 10) as v from tc;
select conv(s, 16, 10) as v from t_twin;
select conv('ff', 16, 10) as v;


evaluate 'Case 2: empty string literal; the same error as the invalid string literal, then 255';
select conv('', 16, 10) as v;
select conv('~', 16, 10) as v;
select conv('ff', 16, 10) as v;


evaluate 'Case 3: valid inputs keep their results';
select conv('ff', 16, 10), conv('f', 16, 10), conv(' ff', 16, 10), conv('ff ', 16, 10), conv('-1', 16, 10);
select conv('11111111', 2, 10), conv('377', 8, 16), conv('zz', 36, 10), conv('255', 10, 36), conv(255, 10, 16);
select k, conv(s, 16, 10), conv(c, 16, 10), conv(nv, 16, 10), conv(se, 16, 10) from t_conv where k = 'hex' order by k;


evaluate 'Case 4: blank strings and a lone minus sign give the error of an invalid string';
select conv(' ', 16, 10) as v;
select conv('   ', 16, 10) as v;
select conv('-', 16, 10) as v;
select conv(s, 16, 10) as v from t_conv where k = 'space';
select conv(s, 16, 10) as v from t_conv where k = 'blank';
select conv(s, 16, 10) as v from t_conv where k = 'minus';


evaluate 'Case 5: CHAR(5) and NCHAR(5) columns padding the empty value, CAST to CHAR(5); same error as the twin';
select conv(c, 16, 10) as v from t_conv where k = 'empty';
select conv(c, 16, 10) as v from t_conv where k = 'bad';
select conv(nc, 16, 10) as v from t_conv where k = 'empty';
select conv(nc, 16, 10) as v from t_conv where k = 'bad';
select conv(cast('' as char(5)), 16, 10) as v;
select conv(cast('~' as char(5)), 16, 10) as v;


evaluate 'Case 6: NCHAR VARYING and STRING columns, national literal; same error as the twin';
select conv(nv, 16, 10) as v from t_conv where k = 'empty';
select conv(nv, 16, 10) as v from t_conv where k = 'bad';
select conv(st, 16, 10) as v from t_conv where k = 'empty';
select conv(st, 16, 10) as v from t_conv where k = 'bad';
select conv(N'', 16, 10) as v;
select conv(N'~', 16, 10) as v;


evaluate 'Case 7: iso88591, euckr and utf8 charsets and collations; same error as the twin';
select conv(_iso88591'', 16, 10) as v;
select conv(_iso88591'~', 16, 10) as v;
select conv(_euckr'', 16, 10) as v;
select conv(_euckr'~', 16, 10) as v;
select conv(_utf8'', 16, 10) as v;
select conv(_utf8'~', 16, 10) as v;
select conv(si, 16, 10) as v from t_conv where k = 'empty';
select conv(si, 16, 10) as v from t_conv where k = 'bad';
select conv(se, 16, 10) as v from t_conv where k = 'empty';
select conv(se, 16, 10) as v from t_conv where k = 'bad';
select conv(su, 16, 10) as v from t_conv where k = 'empty';
select conv(su, 16, 10) as v from t_conv where k = 'bad';


evaluate 'Case 8: valid bases 2, 8, 10 and 36 and bases read from columns; same error as the twin';
select conv('', 2, 10) as v;
select conv('~', 2, 10) as v;
select conv('', 8, 10) as v;
select conv('~', 8, 10) as v;
select conv('', 10, 10) as v;
select conv('~', 10, 10) as v;
select conv('', 36, 10) as v;
select conv('~', 36, 10) as v;
select conv('', 10, 2) as v;
select conv('~', 10, 2) as v;
select conv('', 10, 36) as v;
select conv('~', 10, 36) as v;
select conv(s, 36, 2) as v from t_conv where k = 'empty';
select conv(s, 36, 2) as v from t_conv where k = 'bad';
select conv(s, fb, tb) as v from t_conv where k = 'empty';
select conv(s, fb, tb) as v from t_conv where k = 'bad';


evaluate 'Case 9: negative bases give the error, bases out of range or NULL give NULL; same as the twin';
select conv('', -16, 10) as v;
select conv('~', -16, 10) as v;
select conv('', 16, -10) as v;
select conv('~', 16, -10) as v;
select conv(s, -16, -10) as v from t_conv where k = 'empty';
select conv(s, -16, -10) as v from t_conv where k = 'bad';
select conv('', 0, 10) as a, conv('', 1, 10) as b, conv('', 37, 10) as c, conv('', null, 10) as d, conv('', 16, null) as e;
select conv('~', 0, 10) as a, conv('~', 1, 10) as b, conv('~', 37, 10) as c, conv('~', null, 10) as d, conv('~', 16, null) as e;
select conv(s, 0, 10) as a, conv(s, 1, 10) as b, conv(s, 37, 10) as c, conv(s, null, 10) as d, conv(s, 16, null) as e from t_conv where k = 'empty';
select conv(s, 0, 10) as a, conv(s, 1, 10) as b, conv(s, 37, 10) as c, conv(s, null, 10) as d, conv(s, 16, null) as e from t_conv where k = 'bad';


evaluate 'Case 10: NULL input and SUBSTR past the end of the string give NULL';
select conv(null, 16, 10) as v;
select conv(s, 16, 10) as v from t_conv where k = 'none';
select substr('a', 2) is null as n, conv(substr('a', 2), 16, 10) as v;


evaluate 'Case 11: expressions that produce the empty string; same error as the twin';
select conv(left('a', 0), 16, 10) as v;
select conv(left('~', 1), 16, 10) as v;
select conv(replace('a', 'a', ''), 16, 10) as v;
select conv(replace('a~', 'a', ''), 16, 10) as v;
select conv(rtrim(' '), 16, 10) as v;
select conv(rtrim('~ '), 16, 10) as v;
select conv(trim('   '), 16, 10) as v;
select conv(trim(' ~ '), 16, 10) as v;
select conv('' || '', 16, 10) as v;
select conv('~' || '', 16, 10) as v;
select conv(if(1 = 0, 'ff', ''), 16, 10) as v;
select conv(if(1 = 0, 'ff', '~'), 16, 10) as v;
select conv(replace(w, 'a', ''), 16, 10) as v from t_conv where k = 'empty';
select conv(replace(w, 'a', ''), 16, 10) as v from t_conv where k = 'bad';
select conv(nvl(s, 'ff'), 16, 10) as v from t_conv where k = 'empty';
select conv(nvl(s, 'ff'), 16, 10) as v from t_conv where k = 'bad';


evaluate 'Case 12: host variables; same error as the twin, then 255';
prepare st from 'select conv(?, 16, 10) as v';
execute st using '';
execute st using '~';
execute st using 'ff';
prepare sb from 'select conv(?, ?, ?) as v';
execute sb using '', 16, 10;
execute sb using '~', 16, 10;
execute sb using 'ff', 16, 10;
deallocate prepare st;
deallocate prepare sb;


evaluate 'Case 13: subqueries and a derived table; same error as the twin';
select conv((select s from tc), 16, 10) as v;
select conv((select s from t_twin), 16, 10) as v;
select conv((select '' from db_root), 16, 10) as v;
select conv((select '~' from db_root), 16, 10) as v;
select conv(x, 16, 10) as v from (select s as x from tc) dt;
select conv(x, 16, 10) as v from (select s as x from t_twin) dt;


evaluate 'Case 14: WHERE, INSERT SELECT and UPDATE give the error and leave the data unchanged';
select count(*) from t_conv where k = 'empty' and conv(s, 16, 10) is null;
select count(*) from t_conv where k = 'bad' and conv(s, 16, 10) is null;
insert into t_out select conv(s, 16, 10) from t_conv where k = 'empty';
insert into t_out select conv(s, 16, 10) from t_conv where k = 'bad';
select count(*) from t_out;
update t_conv set w = conv(s, 16, 10) where k = 'empty';
update t_conv set w = conv(s, 16, 10) where k = 'bad';
select k, w from t_conv where k in ('empty', 'bad') order by k;
select k, case when s = '' then 'empty' else conv(s, 16, 10) end as v from t_conv where k in ('empty', 'hex') order by k;


evaluate 'Case 15: the session still reads and writes after all errors';
insert into tc values ('ff');
select s, conv(s, 16, 10) from tc where s <> '' order by s;
select count(*) from tc;

drop table tc, t_twin, t_conv, t_out;
