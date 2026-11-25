/**
 *  This test case verifies CBRD-27611: a CAST to a string type shorter than the value
 *  fails on the client path.
 *
 *  The server truncates the value of a CAST that the user wrote, but the client evaluator
 *  failed with a coercion error, so the same INSERT gave a row or an error depending on
 *  where it ran. The fix makes the client evaluator truncate as the server does.
 *
 *  Cases 1 to 16 run the same expression on the server path (a plain INSERT into t_plain,
 *  path server) and on the client paths (the INSERT_EXECUTION_MODE(0) hint, path hint,
 *  an INSERT into t_trig, which has a trigger, path trigger, and SET of a session
 *  variable), and print the stored values side by side. BIT values are read back from
 *  the tables only, not through a session variable.
 *
 *  Case 9 also changes rows of its own in t_upd, which has no trigger, and in t_upd_trig,
 *  which has an AFTER UPDATE trigger that writes to t_trig_log. An UPDATE of t_upd_trig
 *  runs on the client but takes the new value from a SELECT that the server runs, so it
 *  gave the same value before the fix. INSERT ON DUPLICATE KEY UPDATE with the hint or
 *  into t_upd_trig runs on the client and evaluates the new value on the client.
 *
 *  Cases 17 to 20 put the CAST in the DEFAULT clause of CREATE TABLE and ALTER TABLE,
 *  which the client evaluates when the statement runs, and print the default that
 *  db_attribute stores and the value that an INSERT fills in.
 *
 *  Cases 21 to 23 check CASTs that the compiler adds, for a view column and for DEFAULT(c).
 *  The server evaluates them as it does a CAST that the user wrote, so they gave the same
 *  values before the fix.
 *
 *  Case 24 sets allow_truncated_string to yes, which is no in all other cases, and sets
 *  it back to its default at its end.
 *
 *  Coverage:
 *    Case 1:  a CAST of a date string to VARCHAR(4) keeps the first four characters on every path
 *    Case 2:  a CAST to a shorter CHAR truncates on every path
 *    Case 3:  a CAST to a shorter NCHAR and NCHAR VARYING truncates on every path
 *    Case 4:  a CAST of a bit string to a shorter BIT VARYING and BIT truncates on every path
 *    Case 5:  a CAST of a character string to a shorter BIT truncates on every path
 *    Case 6:  a nested CAST truncates the inner value and converts the rest on every path
 *    Case 7:  a CAST inside CONCAT and a CAST of a function result truncate on every path
 *    Case 8:  a length just below, on, and just above the length of the value, the empty string, and NULL
 *    Case 9:  UPDATE and INSERT ON DUPLICATE KEY UPDATE on a table with an AFTER UPDATE trigger, and REPLACE into the table with a trigger, truncate as on the server path
 *    Case 10: a CAST that truncates nothing gives the same value as before
 *    Case 11: a CAST of a number or a date to a string that is too short still fails on every path
 *    Case 12: a numeric overflow in a CAST still fails on every path
 *    Case 13: a CAST of an invalid date or number string still fails on every path
 *    Case 14: a string longer than its VARCHAR(4) or CHAR(4) column still fails without a CAST
 *    Case 15: a CAST that truncates to six characters still fails in a VARCHAR(4) column
 *    Case 16: a CAST that truncates to four characters fits a VARCHAR(4) column on every path
 *    Case 17: a DEFAULT of a CAST to a shorter VARCHAR keeps the first three characters at CREATE TABLE
 *    Case 18: ALTER TABLE MODIFY with a DEFAULT of a CAST to a shorter VARCHAR keeps the first three characters
 *    Case 19: ALTER COLUMN SET DEFAULT and ADD COLUMN with a CAST to a shorter VARCHAR keep the first two characters
 *    Case 20: a DEFAULT of a number CAST to a shorter VARCHAR, or of a string longer than its column, still fails, and the column keeps its default
 *    Case 21: a VARCHAR(3) view column over a constant keeps the first three characters on every path
 *    Case 22: a VARCHAR(3) view column over a VARCHAR(10) column keeps the first three characters on every path
 *    Case 23: DEFAULT(c) of a VARCHAR(3) column gives its default on the server path and with the hint
 *    Case 24: with allow_truncated_string=yes every path truncates a string CAST and a string longer than its column alike, a number CAST to a short string still fails, and after the reset a long string fails again
 */

drop table if exists t_plain, t_trig, t_trig_log, t_narrow, t_narrow_trig;

create table t_plain (id int, path varchar(10), v varchar(20), nv nchar varying(20), bv bit varying(64), d date, n int);
create table t_trig (id int, path varchar(10), v varchar(20), nv nchar varying(20), bv bit varying(64), d date, n int);
create table t_trig_log (id int, v varchar(20));
create trigger trg_27611 after insert on t_trig execute insert into t_trig_log values (obj.id, obj.v);

create table t_narrow (id int, path varchar(10), v varchar(4), c char(4), bv bit varying(8));
create table t_narrow_trig (id int, path varchar(10), v varchar(4), c char(4), bv bit varying(8));
create trigger trg_27611_narrow after insert on t_narrow_trig execute insert into t_trig_log values (obj.id, obj.v);


evaluate 'Case 1: a CAST of a date string to VARCHAR(4) keeps the first four characters on every path';
select cast('2026-10-12' as varchar(4)) from db_root;
insert into t_plain (id, path, v) values (1, 'server', cast('2026-10-12' as varchar(4)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (1, 'hint', cast('2026-10-12' as varchar(4)));
insert into t_trig (id, path, v) values (1, 'trigger', cast('2026-10-12' as varchar(4)));
select id, path, v, char_length(v) from t_plain where id = 1 union all select id, path, v, char_length(v) from t_trig where id = 1 order by 1, 2;
select id, v from t_trig_log where id = 1 order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = cast('2026-10-12' as varchar(4));
select @v_27611 from db_root;


evaluate 'Case 2: a CAST to a shorter CHAR truncates on every path';
insert into t_plain (id, path, v) values (2, 'server', cast('abcdef' as char(2)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (2, 'hint', cast('abcdef' as char(2)));
insert into t_trig (id, path, v) values (2, 'trigger', cast('abcdef' as char(2)));
select id, path, v, char_length(v) from t_plain where id = 2 union all select id, path, v, char_length(v) from t_trig where id = 2 order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = cast('abcdef' as char(2));
select @v_27611 from db_root;


evaluate 'Case 3: a CAST to a shorter NCHAR and NCHAR VARYING truncates on every path';
insert into t_plain (id, path, nv) values (3, 'server', cast(N'abcdef' as nchar(2)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, nv) values (3, 'hint', cast(N'abcdef' as nchar(2)));
insert into t_trig (id, path, nv) values (3, 'trigger', cast(N'abcdef' as nchar(2)));
insert into t_plain (id, path, nv) values (31, 'server', cast(N'uvwxyz' as nchar varying(3)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, nv) values (31, 'hint', cast(N'uvwxyz' as nchar varying(3)));
insert into t_trig (id, path, nv) values (31, 'trigger', cast(N'uvwxyz' as nchar varying(3)));
select id, path, nv, char_length(nv) from t_plain where id in (3, 31) union all select id, path, nv, char_length(nv) from t_trig where id in (3, 31) order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = cast(N'uvwxyz' as nchar varying(3));
select @v_27611 from db_root;


evaluate 'Case 4: a CAST of a bit string to a shorter BIT VARYING and BIT truncates on every path';
insert into t_plain (id, path, bv) values (4, 'server', cast(X'abcd' as bit varying(8)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, bv) values (4, 'hint', cast(X'abcd' as bit varying(8)));
insert into t_trig (id, path, bv) values (4, 'trigger', cast(X'abcd' as bit varying(8)));
insert into t_plain (id, path, bv) values (41, 'server', cast(X'cdef' as bit(8)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, bv) values (41, 'hint', cast(X'cdef' as bit(8)));
insert into t_trig (id, path, bv) values (41, 'trigger', cast(X'cdef' as bit(8)));
insert into t_plain (id, path, bv) values (42, 'server', cast(B'10100000' as bit(4)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, bv) values (42, 'hint', cast(B'10100000' as bit(4)));
insert into t_trig (id, path, bv) values (42, 'trigger', cast(B'10100000' as bit(4)));
select id, path, bv, bit_length(bv) from t_plain where id in (4, 41, 42) union all select id, path, bv, bit_length(bv) from t_trig where id in (4, 41, 42) order by 1, 2;


evaluate 'Case 5: a CAST of a character string to a shorter BIT truncates on every path';
insert into t_plain (id, path, bv) values (5, 'server', cast('abc' as bit(8)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, bv) values (5, 'hint', cast('abc' as bit(8)));
insert into t_trig (id, path, bv) values (5, 'trigger', cast('abc' as bit(8)));
select id, path, bv, bit_length(bv) from t_plain where id = 5 union all select id, path, bv, bit_length(bv) from t_trig where id = 5 order by 1, 2;


evaluate 'Case 6: a nested CAST truncates the inner value and converts the rest on every path';
insert into t_plain (id, path, v, d) values (6, 'server', cast(cast('2026-10-12' as varchar(7)) as char(4)), cast(cast('2026-10-12 11:22:33' as varchar(10)) as date));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v, d) values (6, 'hint', cast(cast('2026-10-12' as varchar(7)) as char(4)), cast(cast('2026-10-12 11:22:33' as varchar(10)) as date));
insert into t_trig (id, path, v, d) values (6, 'trigger', cast(cast('2026-10-12' as varchar(7)) as char(4)), cast(cast('2026-10-12 11:22:33' as varchar(10)) as date));
select id, path, v, d from t_plain where id = 6 union all select id, path, v, d from t_trig where id = 6 order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = cast(cast('2026-10-12 11:22:33' as varchar(10)) as date);
select @v_27611 from db_root;


evaluate 'Case 7: a CAST inside CONCAT and a CAST of a function result truncate on every path';
insert into t_plain (id, path, v) values (7, 'server', concat(cast('abcdef' as varchar(2)), 'z'));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (7, 'hint', concat(cast('abcdef' as varchar(2)), 'z'));
insert into t_trig (id, path, v) values (7, 'trigger', concat(cast('abcdef' as varchar(2)), 'z'));
insert into t_plain (id, path, v) values (71, 'server', cast(repeat('xy', 3) as varchar(3)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (71, 'hint', cast(repeat('xy', 3) as varchar(3)));
insert into t_trig (id, path, v) values (71, 'trigger', cast(repeat('xy', 3) as varchar(3)));
select id, path, v from t_plain where id in (7, 71) union all select id, path, v from t_trig where id in (7, 71) order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = concat(cast('abcdef' as varchar(2)), 'z');
select @v_27611 from db_root;


evaluate 'Case 8: a length just below, on, and just above the length of the value, the empty string, and NULL';
insert into t_plain (id, path, v) values (81, 'server', cast('abcd' as varchar(3)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (81, 'hint', cast('abcd' as varchar(3)));
insert into t_trig (id, path, v) values (81, 'trigger', cast('abcd' as varchar(3)));
insert into t_plain (id, path, v) values (82, 'server', cast('abcd' as varchar(4)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (82, 'hint', cast('abcd' as varchar(4)));
insert into t_trig (id, path, v) values (82, 'trigger', cast('abcd' as varchar(4)));
insert into t_plain (id, path, v) values (83, 'server', cast('abcd' as varchar(5)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (83, 'hint', cast('abcd' as varchar(5)));
insert into t_trig (id, path, v) values (83, 'trigger', cast('abcd' as varchar(5)));
insert into t_plain (id, path, v) values (84, 'server', cast('' as varchar(1)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (84, 'hint', cast('' as varchar(1)));
insert into t_trig (id, path, v) values (84, 'trigger', cast('' as varchar(1)));
insert into t_plain (id, path, v) values (85, 'server', cast(null as varchar(1)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (85, 'hint', cast(null as varchar(1)));
insert into t_trig (id, path, v) values (85, 'trigger', cast(null as varchar(1)));
select id, path, v, char_length(v) from t_plain where id between 81 and 85 union all select id, path, v, char_length(v) from t_trig where id between 81 and 85 order by 1, 2;


-- Case 9 changes rows of its own, which INSERTs without a CAST store first: rows 91 for UPDATE and rows 92 for INSERT ON DUPLICATE KEY UPDATE
-- t_upd_trig has an AFTER UPDATE trigger, so an UPDATE of it and an INSERT ON DUPLICATE KEY UPDATE into it run on the client
evaluate 'Case 9: UPDATE and INSERT ON DUPLICATE KEY UPDATE on a table with an AFTER UPDATE trigger, and REPLACE into the table with a trigger, truncate as on the server path';
drop table if exists t_upd, t_upd_trig;
create table t_upd (id int, path varchar(10), v varchar(20), primary key (id, path));
create table t_upd_trig (id int, path varchar(10), v varchar(20), primary key (id, path));
create trigger trg_27611_upd after update on t_upd_trig execute insert into t_trig_log values (obj.id, obj.v);
insert into t_upd (id, path, v) values (91, 'server', 'before');
insert into t_upd_trig (id, path, v) values (91, 'trigger', 'before');
insert into t_upd (id, path, v) values (92, 'server', 'before');
insert into t_upd (id, path, v) values (92, 'hint', 'before');
insert into t_upd_trig (id, path, v) values (92, 'trigger', 'before');
update t_upd set v = cast('updated value' as varchar(6)) where id = 91;
update t_upd_trig set v = cast('updated value' as varchar(6)) where id = 91;
insert into t_upd (id, path, v) values (92, 'server', 'not updated') on duplicate key update v = cast('duplicate key' as varchar(5));
insert /*+ insert_execution_mode(0) */ into t_upd (id, path, v) values (92, 'hint', 'not updated') on duplicate key update v = cast('duplicate key' as varchar(5));
insert into t_upd_trig (id, path, v) values (92, 'trigger', 'not updated') on duplicate key update v = cast('duplicate key' as varchar(5));
replace into t_plain (id, path, v) values (9, 'server', cast('replaced value' as char(8)));
replace into t_trig (id, path, v) values (9, 'trigger', cast('replaced value' as char(8)));
select id, path, v from t_upd union all select id, path, v from t_upd_trig order by 1, 2;
select id, path, v from t_plain where id = 9 union all select id, path, v from t_trig where id = 9 order by 1, 2;
select id, v from t_trig_log where id in (9, 91, 92) order by 1, 2;


evaluate 'Case 10: a CAST that truncates nothing gives the same value as before';
insert into t_plain (id, path, v, d, n) values (10, 'server', cast(123456 as varchar(10)), cast('2026-10-12' as date), cast('123' as int));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v, d, n) values (10, 'hint', cast(123456 as varchar(10)), cast('2026-10-12' as date), cast('123' as int));
insert into t_trig (id, path, v, d, n) values (10, 'trigger', cast(123456 as varchar(10)), cast('2026-10-12' as date), cast('123' as int));
select id, path, v, d, n from t_plain where id = 10 union all select id, path, v, d, n from t_trig where id = 10 order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = cast(123456 as varchar(10));
select @v_27611 from db_root;


evaluate 'Case 11: a CAST of a number or a date to a string that is too short still fails on every path';
select cast(123456 as varchar(3)) from db_root;
insert into t_plain (id, path, v) values (11, 'server', cast(123456 as varchar(3)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (11, 'hint', cast(123456 as varchar(3)));
insert into t_trig (id, path, v) values (11, 'trigger', cast(123456 as varchar(3)));
insert into t_plain (id, path, v) values (11, 'server', cast(1234.5678 as char(3)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (11, 'hint', cast(1234.5678 as char(3)));
insert into t_trig (id, path, v) values (11, 'trigger', cast(1234.5678 as char(3)));
insert into t_plain (id, path, v) values (11, 'server', cast(date'2026-10-12' as varchar(4)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (11, 'hint', cast(date'2026-10-12' as varchar(4)));
insert into t_trig (id, path, v) values (11, 'trigger', cast(date'2026-10-12' as varchar(4)));
set @v_27611 = 'not set';
set @v_27611 = cast(123456 as varchar(3));
select @v_27611 from db_root;
select (select count(*) from t_plain where id = 11) as plain_rows, (select count(*) from t_trig where id = 11) as trig_rows, (select count(*) from t_trig_log where id = 11) as log_rows from db_root;


evaluate 'Case 12: a numeric overflow in a CAST still fails on every path';
insert into t_plain (id, path, n) values (12, 'server', cast(99999999999 as int));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, n) values (12, 'hint', cast(99999999999 as int));
insert into t_trig (id, path, n) values (12, 'trigger', cast(99999999999 as int));
insert into t_plain (id, path, n) values (12, 'server', cast('99999999999' as int));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, n) values (12, 'hint', cast('99999999999' as int));
insert into t_trig (id, path, n) values (12, 'trigger', cast('99999999999' as int));
insert into t_plain (id, path, n) values (12, 'server', cast(123456 as smallint));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, n) values (12, 'hint', cast(123456 as smallint));
insert into t_trig (id, path, n) values (12, 'trigger', cast(123456 as smallint));
insert into t_plain (id, path, n) values (12, 'server', cast(123456789.5 as numeric(4,2)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, n) values (12, 'hint', cast(123456789.5 as numeric(4,2)));
insert into t_trig (id, path, n) values (12, 'trigger', cast(123456789.5 as numeric(4,2)));
set @v_27611 = 'not set';
set @v_27611 = cast(99999999999 as int);
select @v_27611 from db_root;
select (select count(*) from t_plain where id = 12) as plain_rows, (select count(*) from t_trig where id = 12) as trig_rows, (select count(*) from t_trig_log where id = 12) as log_rows from db_root;


evaluate 'Case 13: a CAST of an invalid date or number string still fails on every path';
insert into t_plain (id, path, d) values (13, 'server', cast('2026-13-45' as date));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, d) values (13, 'hint', cast('2026-13-45' as date));
insert into t_trig (id, path, d) values (13, 'trigger', cast('2026-13-45' as date));
insert into t_plain (id, path, n) values (13, 'server', cast('12ab' as int));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, n) values (13, 'hint', cast('12ab' as int));
insert into t_trig (id, path, n) values (13, 'trigger', cast('12ab' as int));
set @v_27611 = 'not set';
set @v_27611 = cast('2026-13-45' as date);
select @v_27611 from db_root;
select (select count(*) from t_plain where id = 13) as plain_rows, (select count(*) from t_trig where id = 13) as trig_rows, (select count(*) from t_trig_log where id = 13) as log_rows from db_root;


evaluate 'Case 14: a string longer than its VARCHAR(4) or CHAR(4) column still fails without a CAST';
insert into t_narrow (id, path, v) values (14, 'server', 'abcdef');
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, v) values (14, 'hint', 'abcdef');
insert into t_narrow_trig (id, path, v) values (14, 'trigger', 'abcdef');
insert into t_narrow (id, path, c) values (14, 'server', 'abcdef');
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, c) values (14, 'hint', 'abcdef');
insert into t_narrow_trig (id, path, c) values (14, 'trigger', 'abcdef');
insert into t_narrow (id, path, bv) values (14, 'server', X'abcd');
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, bv) values (14, 'hint', X'abcd');
insert into t_narrow_trig (id, path, bv) values (14, 'trigger', X'abcd');
insert into t_narrow (id, path, v) values (14, 'server', 123456);
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, v) values (14, 'hint', 123456);
insert into t_narrow_trig (id, path, v) values (14, 'trigger', 123456);
select (select count(*) from t_narrow where id = 14) as plain_rows, (select count(*) from t_narrow_trig where id = 14) as trig_rows, (select count(*) from t_trig_log where id = 14) as log_rows from db_root;


evaluate 'Case 15: a CAST that truncates to six characters still fails in a VARCHAR(4) column';
insert into t_narrow (id, path, v) values (15, 'server', cast('abcdefgh' as varchar(6)));
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, v) values (15, 'hint', cast('abcdefgh' as varchar(6)));
insert into t_narrow_trig (id, path, v) values (15, 'trigger', cast('abcdefgh' as varchar(6)));
select (select count(*) from t_narrow where id = 15) as plain_rows, (select count(*) from t_narrow_trig where id = 15) as trig_rows, (select count(*) from t_trig_log where id = 15) as log_rows from db_root;


evaluate 'Case 16: a CAST that truncates to four characters fits a VARCHAR(4) column on every path';
insert into t_narrow (id, path, v, c, bv) values (16, 'server', cast('2026-10-12' as varchar(4)), cast('abcdef' as char(4)), cast(X'abcd' as bit varying(8)));
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, v, c, bv) values (16, 'hint', cast('2026-10-12' as varchar(4)), cast('abcdef' as char(4)), cast(X'abcd' as bit varying(8)));
insert into t_narrow_trig (id, path, v, c, bv) values (16, 'trigger', cast('2026-10-12' as varchar(4)), cast('abcdef' as char(4)), cast(X'abcd' as bit varying(8)));
select id, path, v, c, bv from t_narrow where id = 16 union all select id, path, v, c, bv from t_narrow_trig where id = 16 order by 1, 2;
select id, v from t_trig_log where id = 16 order by 1, 2;


evaluate 'Case 17: a DEFAULT of a CAST to a shorter VARCHAR keeps the first three characters at CREATE TABLE';
drop table if exists t_def_create;
create table t_def_create (id int, c varchar(10) default (cast('abcdef' as varchar(3))));
insert into t_def_create (id) values (17);
insert /*+ insert_execution_mode(0) */ into t_def_create (id) values (171);
select id, c, char_length(c) from t_def_create order by 1;
select attr_name, default_value from db_attribute where class_name = 't_def_create' and attr_name = 'c';


-- the row with id 18 is inserted before the ALTER
evaluate 'Case 18: ALTER TABLE MODIFY with a DEFAULT of a CAST to a shorter VARCHAR keeps the first three characters';
drop table if exists t_def_alter;
create table t_def_alter (id int, c varchar(10));
insert into t_def_alter (id) values (18);
alter table t_def_alter modify c varchar(10) default (cast('abcdef' as varchar(3)));
insert into t_def_alter (id) values (181);
select id, c from t_def_alter order by 1;
select attr_name, default_value from db_attribute where class_name = 't_def_alter' and attr_name = 'c';


-- the row with id 19 is inserted before ADD COLUMN adds c2
evaluate 'Case 19: ALTER COLUMN SET DEFAULT and ADD COLUMN with a CAST to a shorter VARCHAR keep the first two characters';
drop table if exists t_def_set;
create table t_def_set (id int, c varchar(10));
alter table t_def_set alter column c set default (cast('uvwxyz' as varchar(2)));
insert into t_def_set (id) values (19);
alter table t_def_set add column c2 varchar(10) default (cast('uvwxyz' as varchar(2)));
insert into t_def_set (id) values (191);
select id, c, c2 from t_def_set order by 1;
select attr_name, default_value from db_attribute where class_name = 't_def_set' and attr_name in ('c', 'c2') order by 1;


evaluate 'Case 20: a DEFAULT of a number CAST to a shorter VARCHAR, or of a string longer than its column, still fails, and the column keeps its default';
drop table if exists t_def_num;
create table t_def_num (id int, c varchar(10) default (cast(123456 as varchar(3))));
select count(*) from db_class where class_name = 't_def_num';
create table t_def_num (id int, c varchar(10) default 'kept');
alter table t_def_num modify c varchar(10) default (cast(123456 as varchar(3)));
alter table t_def_num alter column c set default (cast(123456 as varchar(3)));
alter table t_def_num alter column c set default 'abcdefghijkl';
insert into t_def_num (id) values (20);
select id, c from t_def_num order by 1;
select attr_name, default_value from db_attribute where class_name = 't_def_num' and attr_name = 'c';


evaluate 'Case 21: a VARCHAR(3) view column over a constant keeps the first three characters on every path';
drop view if exists v_const;
create view v_const (a varchar(3)) as select 'abcdef' from db_root;
select a, char_length(a) from v_const;
insert into t_plain (id, path, v) select 21, 'server', a from v_const;
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) select 21, 'hint', a from v_const;
insert into t_trig (id, path, v) select 21, 'trigger', a from v_const;
select id, path, v, char_length(v) from t_plain where id = 21 union all select id, path, v, char_length(v) from t_trig where id = 21 order by 1, 2;
select id, v from t_trig_log where id = 21 order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = (select a from v_const);
select @v_27611 from db_root;


evaluate 'Case 22: a VARCHAR(3) view column over a VARCHAR(10) column keeps the first three characters on every path';
drop view if exists v_col;
drop table if exists t_view_src;
create table t_view_src (id int, c varchar(10));
insert into t_view_src (id, c) values (22, 'abcdef');
create view v_col (id int, a varchar(3)) as select id, c from t_view_src;
select id, a, char_length(a) from v_col order by 1;
insert into t_plain (id, path, v) select id, 'server', a from v_col;
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) select id, 'hint', a from v_col;
insert into t_trig (id, path, v) select id, 'trigger', a from v_col;
select id, path, v, char_length(v) from t_plain where id = 22 union all select id, path, v, char_length(v) from t_trig where id = 22 order by 1, 2;
select id, v from t_trig_log where id = 22 order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = (select a from v_col where id = 22);
select @v_27611 from db_root;


evaluate 'Case 23: DEFAULT(c) of a VARCHAR(3) column gives its default on the server path and with the hint';
drop table if exists t_def_col;
create table t_def_col (id int, path varchar(10), c varchar(3) default 'abc');
insert into t_def_col (id, path, c) values (23, 'server', default(c));
insert /*+ insert_execution_mode(0) */ into t_def_col (id, path, c) values (23, 'hint', default(c));
select id, path, c, char_length(c) from t_def_col order by 1, 2;


-- allow_truncated_string is no by default, and the other cases run with no
-- rows 24 take a string CAST, rows 241 a number CAST, rows 242 a string longer than the column, rows 243 a CAST to six characters into a VARCHAR(4) column
-- rows 244 are inserted after allow_truncated_string is set back to its default
evaluate 'Case 24: with allow_truncated_string=yes every path truncates a string CAST and a string longer than its column alike, a number CAST to a short string still fails, and after the reset a long string fails again';
set system parameters 'allow_truncated_string=yes';
insert into t_plain (id, path, v) values (24, 'server', cast('2026-10-12' as varchar(4)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (24, 'hint', cast('2026-10-12' as varchar(4)));
insert into t_trig (id, path, v) values (24, 'trigger', cast('2026-10-12' as varchar(4)));
insert into t_plain (id, path, v) values (241, 'server', cast(123456 as varchar(3)));
insert /*+ insert_execution_mode(0) */ into t_plain (id, path, v) values (241, 'hint', cast(123456 as varchar(3)));
insert into t_trig (id, path, v) values (241, 'trigger', cast(123456 as varchar(3)));
select id, path, v, char_length(v) from t_plain where id in (24, 241) union all select id, path, v, char_length(v) from t_trig where id in (24, 241) order by 1, 2;
insert into t_narrow (id, path, v, c) values (242, 'server', 'abcdef', 'uvwxyz');
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, v, c) values (242, 'hint', 'abcdef', 'uvwxyz');
insert into t_narrow_trig (id, path, v, c) values (242, 'trigger', 'abcdef', 'uvwxyz');
insert into t_narrow (id, path, v) values (243, 'server', cast('abcdefgh' as varchar(6)));
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, v) values (243, 'hint', cast('abcdefgh' as varchar(6)));
insert into t_narrow_trig (id, path, v) values (243, 'trigger', cast('abcdefgh' as varchar(6)));
select id, path, v, c from t_narrow where id in (242, 243) union all select id, path, v, c from t_narrow_trig where id in (242, 243) order by 1, 2;
select id, v from t_trig_log where id in (24, 241, 242, 243) order by 1, 2;
set @v_27611 = 'not set';
set @v_27611 = cast('2026-10-12' as varchar(4));
select @v_27611 from db_root;
set @v_27611 = 'not set';
set @v_27611 = cast(123456 as varchar(3));
select @v_27611 from db_root;
set system parameters 'allow_truncated_string=default';
insert into t_narrow (id, path, v) values (244, 'server', 'abcdef');
insert /*+ insert_execution_mode(0) */ into t_narrow (id, path, v) values (244, 'hint', 'abcdef');
insert into t_narrow_trig (id, path, v) values (244, 'trigger', 'abcdef');
select (select count(*) from t_narrow where id = 244) as plain_rows, (select count(*) from t_narrow_trig where id = 244) as trig_rows, (select count(*) from t_trig_log where id = 244) as log_rows from db_root;


drop variable @v_27611;
drop trigger trg_27611;
drop trigger trg_27611_narrow;
drop trigger trg_27611_upd;
drop view if exists v_const, v_col;
drop table t_plain, t_trig, t_trig_log, t_narrow, t_narrow_trig;
drop table if exists t_def_create, t_def_alter, t_def_set, t_def_num, t_upd, t_upd_trig, t_view_src, t_def_col;
