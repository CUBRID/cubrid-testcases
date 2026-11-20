/**
 *  This test case verifies CBRD-27607: CURRENT_DATE evaluated on the client overwrites
 *  the statement clock, and UNIX_TIMESTAMP() without an argument is off by the offset
 *  of the session time zone.
 *
 *  When the session time zone differs from the server time zone, the client evaluator
 *  of CURRENT_DATE stored the converted time back into the statement clock, so the clock
 *  functions evaluated after it in the same statement read a shifted clock. UNIX_TIMESTAMP()
 *  without an argument read the statement clock as a DATETIME of the session time zone, on
 *  the client and in a column DEFAULT. The fix makes CURRENT_DATE only read the clock and
 *  makes UNIX_TIMESTAMP() use the epoch value of the statement clock.
 *
 *  The server time zone is Asia/Seoul, and the session uses -11:00, 20 hours behind it.
 *  A statement runs on the client with the INSERT_EXECUTION_MODE(0) hint, on a table with
 *  a trigger, or as SET of a session variable. Clock values change from run to run, so each
 *  case prints the difference between a stored value and the clock of the server right
 *  after it, rounded to hours. The file keeps one CAS with the holdcas control line.
 *
 *  Coverage:
 *    Case 1:  SYS_DATETIME after CURRENT_DATE in a client INSERT is the statement time
 *    Case 2:  CURRENT_DATETIME and CURRENT_TIMESTAMP after CURRENT_DATE are the statement time
 *    Case 3:  CURRENT_DATE in three rows of one client INSERT is one date
 *    Case 4:  SYS_DATETIME in the row after a CURRENT_DATE row is the statement time
 *    Case 5:  SYS_DATETIME after CURRENT_DATE in SET of session variables is the statement time
 *    Case 6:  SYS_DATETIME after CURRENT_DATE in an INSERT on a table with a trigger is the statement time
 *    Case 7:  UNIX_TIMESTAMP() in a client INSERT is the statement time
 *    Case 8:  UNIX_TIMESTAMP() in SET of a session variable is the statement time
 *    Case 9:  DEFAULT UNIX_TIMESTAMP() is the statement time in server and client INSERTs
 *    Case 10: DEFAULT UNIX_TIMESTAMP() is the statement time on a table with a trigger and in UPDATE SET DEFAULT
 *    Case 11: UNIX_TIMESTAMP() before or after CURRENT_DATE in a client INSERT is the statement time
 *    Case 12: a server INSERT of the same values is unchanged
 *    Case 13: SYS_DATETIME before CURRENT_DATE, or after another clock function, is unchanged
 *    Case 14: UNIX_TIMESTAMP with an argument still reads it in the session time zone
 *    Case 15: a session in the +14:00 time zone, ahead of the server, gets the statement time
 *    Case 16: a session in the server time zone is unchanged
 */

--+ holdcas on;

drop table if exists t_cd, t_cur, t_rows, t_trg, t_trg_log, t_ux, t_def, t_dtrg, t_arg;

create table t_cd (id int, d date, v datetime);
create table t_cur (id int, d date, dt datetime, ts timestamp);
create table t_rows (id int, d date, v datetime);
create table t_trg (id int, d date, v datetime, u int);
create table t_trg_log (id int);
create trigger trg_27607 after insert on t_trg execute insert into t_trg_log values (obj.id);
create table t_ux (id int, d date, u int);
create table t_def (id int, u int default unix_timestamp());
create table t_dtrg (id int, u int default unix_timestamp());
create trigger trg_27607_def after insert on t_dtrg execute insert into t_trg_log values (obj.id);
create table t_arg (id int, u int);

set time zone '-11:00';


evaluate 'Case 1: SYS_DATETIME after CURRENT_DATE in a client INSERT is the statement time; result = 0 hours';
insert /*+ insert_execution_mode(0) */ into t_cd values (1, current_date, sys_datetime);
select id, cast(round((v - sys_datetime) / 3600000.0) as int) as hours from t_cd where id = 1;


-- CURRENT_DATETIME is the session time of the statement clock, so its date is the CURRENT_DATE of the same statement
evaluate 'Case 2: CURRENT_DATETIME and CURRENT_TIMESTAMP after CURRENT_DATE are the statement time; result = 0 hours, 0 days';
insert /*+ insert_execution_mode(0) */ into t_cur values (2, current_date, current_datetime, current_timestamp);
select id, cast(round((dt - current_datetime) / 3600000.0) as int) as dt_hours, cast(round((ts - current_timestamp) / 3600.0) as int) as ts_hours, d - cast(dt as date) as days from t_cur where id = 2;


evaluate 'Case 3: CURRENT_DATE in three rows of one client INSERT is one date; result = 0 days';
insert /*+ insert_execution_mode(0) */ into t_rows values (31, current_date, null), (32, current_date, null), (33, current_date, null);
select count(*), count(distinct d), max(d) - min(d) as days from t_rows where id between 31 and 33;


evaluate 'Case 4: SYS_DATETIME in the row after a CURRENT_DATE row is the statement time; result = 0 hours';
insert /*+ insert_execution_mode(0) */ into t_rows values (41, current_date, null), (42, null, sys_datetime);
select id, cast(round((v - sys_datetime) / 3600000.0) as int) as hours from t_rows where id = 42;


evaluate 'Case 5: SYS_DATETIME after CURRENT_DATE in SET of session variables is the statement time; result = 0 hours';
set @d_27607 = current_date, @t_27607 = sys_datetime;
select cast(round((@t_27607 - sys_datetime) / 3600000.0) as int) as hours;


evaluate 'Case 6: SYS_DATETIME after CURRENT_DATE in an INSERT on a table with a trigger is the statement time; result = 0 hours';
insert into t_trg values (6, current_date, sys_datetime, null);
select id, cast(round((v - sys_datetime) / 3600000.0) as int) as hours from t_trg where id = 6;
select id from t_trg_log order by id;


evaluate 'Case 7: UNIX_TIMESTAMP() in a client INSERT is the statement time; result = 0 hours';
insert /*+ insert_execution_mode(0) */ into t_ux values (71, null, unix_timestamp());
insert into t_trg values (72, null, null, unix_timestamp());
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_ux where id = 71;
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_trg where id = 72;


evaluate 'Case 8: UNIX_TIMESTAMP() in SET of a session variable is the statement time; result = 0 hours';
set @u_27607 = unix_timestamp();
select cast(round((@u_27607 - unix_timestamp()) / 3600.0) as int) as hours;


-- id 1 and 3 run on the server, id 2 and 4 on the client, id 5 is INSERT ... SELECT
evaluate 'Case 9: DEFAULT UNIX_TIMESTAMP() is the statement time in server and client INSERTs; result = 0 hours';
insert into t_def (id) values (1);
insert /*+ insert_execution_mode(0) */ into t_def (id) values (2);
insert into t_def values (3, default);
insert /*+ insert_execution_mode(0) */ into t_def values (4, default);
insert into t_def (id) select 5 from db_root;
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_def order by id;


evaluate 'Case 10: DEFAULT UNIX_TIMESTAMP() is the statement time on a table with a trigger and in UPDATE SET DEFAULT; result = 0 hours';
insert into t_dtrg (id) values (10);
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_dtrg where id = 10;
update t_def set u = 0 where id = 1;
update t_def set u = default where id = 1;
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_def where id = 1;


evaluate 'Case 11: UNIX_TIMESTAMP() before or after CURRENT_DATE in a client INSERT is the statement time; result = 0 hours';
insert /*+ insert_execution_mode(0) */ into t_ux values (111, current_date, unix_timestamp());
insert /*+ insert_execution_mode(0) */ into t_ux (id, u, d) values (112, unix_timestamp(), current_date);
insert /*+ insert_execution_mode(0) */ into t_ux values (113, null, unix_timestamp()), (114, current_date, unix_timestamp()), (115, null, unix_timestamp());
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_ux where id between 111 and 115 order by id;


evaluate 'Case 12: a server INSERT of the same values is unchanged; result = 0 hours';
insert into t_cd values (12, current_date, sys_datetime);
insert into t_ux values (12, current_date, unix_timestamp());
select id, cast(round((v - sys_datetime) / 3600000.0) as int) as hours from t_cd where id = 12;
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_ux where id = 12;


evaluate 'Case 13: SYS_DATETIME before CURRENT_DATE, or after another clock function, is unchanged; result = 0 hours';
insert /*+ insert_execution_mode(0) */ into t_cd (id, v, d) values (131, sys_datetime, current_date);
insert /*+ insert_execution_mode(0) */ into t_cd values (132, sys_date, sys_datetime);
insert /*+ insert_execution_mode(0) */ into t_cur values (133, utc_date(), sys_datetime, current_timestamp);
select id, cast(round((v - sys_datetime) / 3600000.0) as int) as hours from t_cd where id in (131, 132) order by id;
select id, cast(round((dt - sys_datetime) / 3600000.0) as int) as dt_hours, cast(round((ts - current_timestamp) / 3600.0) as int) as ts_hours from t_cur where id = 133;


-- 2020-01-01 00:00:00 at -11:00 is 2020-01-01 11:00:00 UTC
evaluate 'Case 14: UNIX_TIMESTAMP with an argument still reads it in the session time zone; result = 1577876400';
insert /*+ insert_execution_mode(0) */ into t_arg values (141, unix_timestamp('2020-01-01 00:00:00'));
insert into t_arg values (142, unix_timestamp('2020-01-01 00:00:00'));
set @a_27607 = unix_timestamp('2020-01-01 00:00:00');
select id, u from t_arg order by id;
select @a_27607;


evaluate 'Case 15: a session in the +14:00 time zone, ahead of the server, gets the statement time; result = 0 hours';
set time zone '+14:00';
insert /*+ insert_execution_mode(0) */ into t_cd values (151, current_date, sys_datetime);
insert /*+ insert_execution_mode(0) */ into t_ux values (152, null, unix_timestamp());
insert into t_def (id) values (153);
select id, cast(round((v - sys_datetime) / 3600000.0) as int) as hours from t_cd where id = 151;
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_ux where id = 152;
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_def where id = 153;


evaluate 'Case 16: a session in the server time zone is unchanged; result = 0 hours';
set time zone 'Asia/Seoul';
insert /*+ insert_execution_mode(0) */ into t_cd values (161, current_date, sys_datetime);
insert /*+ insert_execution_mode(0) */ into t_ux values (162, current_date, unix_timestamp());
insert /*+ insert_execution_mode(0) */ into t_ux values (163, null, unix_timestamp());
insert into t_def (id) values (164);
set @u_27607 = unix_timestamp();
select id, cast(round((v - sys_datetime) / 3600000.0) as int) as hours from t_cd where id = 161;
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_ux where id in (162, 163) order by id;
select id, cast(round((u - unix_timestamp()) / 3600.0) as int) as hours from t_def where id = 164;
select cast(round((@u_27607 - unix_timestamp()) / 3600.0) as int) as hours;


set time zone 'Asia/Seoul';
drop trigger trg_27607;
drop trigger trg_27607_def;
drop table t_cd, t_cur, t_rows, t_trg, t_trg_log, t_ux, t_def, t_dtrg, t_arg;

--+ holdcas off;
