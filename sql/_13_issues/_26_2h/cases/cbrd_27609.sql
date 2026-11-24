/**
 *  This test case verifies CBRD-27609: INSERT, UPDATE, and MERGE on a WITH CHECK OPTION
 *  view whose predicate has a clock function refuse rows that satisfy the predicate.
 *
 *  The client evaluates the CHECK OPTION predicate with the clock of the statement, and
 *  the statement fetched that clock from the server only when its own text had a clock
 *  function. The predicate comes from the view, so UNIX_TIMESTAMP() was NULL and the
 *  other clock functions read an unset value. The clock DEFAULT of a base column that
 *  the view does not expose was evaluated on the client with the same unset clock.
 *  The fix fetches the clock when the translated statement has such a predicate or
 *  such a DEFAULT.
 *
 *  A view on a REUSE_OID table is not updatable, so the base tables use DONT_REUSE_OID.
 *  The current time changes from run to run, so the cases store values far below it
 *  (small numbers, dates of 2000 and 2001) or far above it (99999999999, dates of 2037
 *  and 2999) and print the stored rows and the error code of a refusal. A DEFAULT of
 *  SYS_DATETIME is printed as its distance from the current time in hours.
 *
 *  Coverage:
 *    Case 1:  INSERT VALUES of rows that satisfy n < UNIX_TIMESTAMP() succeeds
 *    Case 2:  INSERT SELECT of rows that satisfy the predicate succeeds
 *    Case 3:  UPDATE to a value that satisfies the predicate succeeds
 *    Case 4:  MERGE updates and inserts rows that satisfy the predicate
 *    Case 5:  INSERT, INSERT SELECT, UPDATE, and MERGE of a value above the clock fail with an error
 *    Case 6:  a view with CASCADED CHECK OPTION on the clock view checks the same predicate
 *    Case 7:  a prepared INSERT checks the predicate at each execution
 *    Case 8:  a clock function that follows a subquery in a value list is evaluated
 *    Case 9:  an INSERT into the clock view by a trigger action checks the predicate
 *    Case 10: a CHECK OPTION view without a clock function works as before
 *    Case 11: UNIX_TIMESTAMP with an argument and a view without CHECK OPTION work as before
 *    Case 12: a predicate of SYS_DATETIME accepts a past value and fails a future value with an error
 *    Case 13: a predicate of CURRENT_DATE accepts a past value and fails a future value with an error
 *    Case 14: a predicate of SYS_TIMESTAMP accepts a past value and fails a future value with an error
 *    Case 15: a predicate of UTC_TIMESTAMP and TZ_OFFSET accepts a past value and fails a future value with an error
 *    Case 16: the client path of INSERT_EXECUTION_MODE(0) fills the SYS_DATETIME DEFAULT of a column that the view hides
 *    Case 17: a CHECK OPTION view fills the SYS_DATETIME DEFAULT of a column that it hides
 */

drop view if exists v_casc, v_unix, v_sub_next, v_sysdt, v_curd, v_systs, v_utc, v_plain, v_uxarg, v_nochk, v_dflt_chk, v_dflt_no;
drop table if exists t_base, t_src, t_trg, t_dflt;

create table t_base (id int, n bigint, d date, dt datetime, ts timestamp) dont_reuse_oid;
create table t_src (id int, n bigint);
insert into t_src values (21, 5), (22, 6);

create view v_unix as select id, n from t_base where n is null or n < unix_timestamp() with check option;


evaluate 'Case 1: INSERT VALUES of rows that satisfy n < UNIX_TIMESTAMP() succeeds';
insert into v_unix (id, n) values (1, 5);
insert into v_unix (id, n) values (2, 6), (3, null);
select id, n from t_base order by id;


evaluate 'Case 2: INSERT SELECT of rows that satisfy the predicate succeeds';
insert into v_unix (id, n) select 20, 5 from db_root;
insert into v_unix (id, n) select id, n from t_src;
select id, n from t_base where id between 20 and 29 order by id;


-- Case 3 and Case 4 update rows that they add to the base table first
evaluate 'Case 3: UPDATE to a value that satisfies the predicate succeeds';
insert into t_base (id, n) values (30, 1), (31, 1);
update v_unix set n = 7 where id = 30;
update v_unix set n = n + 10 where id = 31;
select id, n from t_base where id between 30 and 39 order by id;


evaluate 'Case 4: MERGE updates and inserts rows that satisfy the predicate';
insert into t_base (id, n) values (40, 1);
merge into v_unix t using (select 40 as id, 8 as n from db_root) s on (t.id = s.id) when matched then update set t.n = s.n;
merge into v_unix t using (select 41 as id, 9 as n from db_root) s on (t.id = s.id) when not matched then insert (id, n) values (s.id, s.n);
select id, n from t_base where id between 40 and 49 order by id;


evaluate 'Case 5: INSERT, INSERT SELECT, UPDATE, and MERGE of a value above the clock fail with an error';
insert into v_unix (id, n) values (50, 99999999999);
insert into v_unix (id, n) select 51, 99999999999 from db_root;
update v_unix set n = 99999999999 where id = 30;
merge into v_unix t using (select 40 as id, 99999999999 as n from db_root) s on (t.id = s.id) when matched then update set t.n = s.n;
merge into v_unix t using (select 52 as id, 99999999999 as n from db_root) s on (t.id = s.id) when not matched then insert (id, n) values (s.id, s.n);
select id, n from t_base where id in (30, 40) or id between 50 and 59 order by id;
select count(*) from t_base where n > 100;


evaluate 'Case 6: a view with CASCADED CHECK OPTION on the clock view checks the same predicate';
create view v_casc as select id, n from v_unix where id > 0 with cascaded check option;
insert into v_casc (id, n) values (60, 5);
update v_casc set n = 6 where id = 60;
insert into v_casc (id, n) values (61, 99999999999);
select id, n from t_base where id between 60 and 69 order by id;


evaluate 'Case 7: a prepared INSERT checks the predicate at each execution';
prepare st_27609 from 'insert into v_unix (id, n) values (?, ?)';
execute st_27609 using 70, 5;
execute st_27609 using 71, 99999999999;
execute st_27609 using 72, 6;
deallocate prepare st_27609;
select id, n from t_base where id between 70 and 79 order by id;


evaluate 'Case 8: a clock function that follows a subquery in a value list is evaluated';
create view v_sub_next as select id, n from t_base where n not in ((select 0 from db_root), unix_timestamp() + 100) with check option;
insert into v_sub_next (id, n) values (80, 5);
insert into v_sub_next (id, n) values (81, 0);
select id, n from t_base where id between 80 and 89 order by id;


evaluate 'Case 9: an INSERT into the clock view by a trigger action checks the predicate';
create table t_trg (id int, n bigint);
create trigger trg_27609 after insert on t_trg execute insert into v_unix (id, n) values (obj.id, obj.n);
insert into t_trg values (90, 5);
insert into t_trg values (91, 99999999999);
select id, n from t_trg order by id;
select id, n from t_base where id between 90 and 99 order by id;


evaluate 'Case 10: a CHECK OPTION view without a clock function works as before';
create view v_plain as select id, n from t_base where n < 100 with check option;
insert into v_plain (id, n) values (160, 5);
update v_plain set n = 6 where id = 160;
insert into v_plain (id, n) values (161, 500);
update v_plain set n = 600 where id = 160;
select id, n from t_base where id between 160 and 169 order by id;


evaluate 'Case 11: UNIX_TIMESTAMP with an argument and a view without CHECK OPTION work as before';
create view v_uxarg as select id, n from t_base where n < unix_timestamp(timestamp '2001-01-01 00:00:00') with check option;
create view v_nochk as select id, n from t_base where n < unix_timestamp();
insert into v_uxarg (id, n) values (170, 5);
insert into v_uxarg (id, n) values (171, 99999999999);
insert into v_nochk (id, n) values (172, 99999999999);
select id, n from t_base where id between 170 and 179 order by id;
select id, n from v_unix where id between 170 and 179 order by id;


evaluate 'Case 12: a predicate of SYS_DATETIME accepts a past value and fails a future value with an error';
create view v_sysdt as select id, dt from t_base where dt < sys_datetime with check option;
insert into v_sysdt (id, dt) values (100, datetime '2000-01-01 00:00:00');
insert into v_sysdt (id, dt) select 101, datetime '2000-01-02 00:00:00' from db_root;
update v_sysdt set dt = datetime '2001-01-01 00:00:00' where id = 100;
insert into v_sysdt (id, dt) values (102, datetime '2999-01-01 00:00:00');
update v_sysdt set dt = datetime '2999-01-01 00:00:00' where id = 101;
select id, dt from t_base where id between 100 and 109 order by id;


evaluate 'Case 13: a predicate of CURRENT_DATE accepts a past value and fails a future value with an error';
create view v_curd as select id, d from t_base where d < current_date with check option;
insert into v_curd (id, d) values (110, date '2000-01-01');
update v_curd set d = date '2001-01-01' where id = 110;
insert into v_curd (id, d) values (111, date '2999-01-01');
update v_curd set d = date '2999-01-01' where id = 110;
select id, d from t_base where id between 110 and 119 order by id;


evaluate 'Case 14: a predicate of SYS_TIMESTAMP accepts a past value and fails a future value with an error';
create view v_systs as select id, ts from t_base where ts < sys_timestamp with check option;
insert into v_systs (id, ts) values (120, timestamp '2000-01-01 00:00:00');
update v_systs set ts = timestamp '2001-01-01 00:00:00' where id = 120;
insert into v_systs (id, ts) values (121, timestamp '2037-01-01 00:00:00');
update v_systs set ts = timestamp '2037-01-01 00:00:00' where id = 120;
select id, ts from t_base where id between 120 and 129 order by id;


evaluate 'Case 15: a predicate of UTC_TIMESTAMP and TZ_OFFSET accepts a past value and fails a future value with an error';
create view v_utc as select id, dt from t_base where dt < utc_timestamp() and tz_offset('Asia/Seoul') = '+09:00' with check option;
insert into v_utc (id, dt) values (130, datetime '2000-01-01 00:00:00');
update v_utc set dt = datetime '2001-01-01 00:00:00' where id = 130;
insert into v_utc (id, dt) values (131, datetime '2999-01-01 00:00:00');
select id, dt from t_base where id between 130 and 139 order by id;


create table t_dflt (id int, dt datetime default sys_datetime, n bigint) dont_reuse_oid;
create view v_dflt_no as select id, n from t_dflt where n < 100;
create view v_dflt_chk as select id, n from t_dflt where n < 100 with check option;

evaluate 'Case 16: the client path of INSERT_EXECUTION_MODE(0) fills the SYS_DATETIME DEFAULT of a column that the view hides';
insert /*+ insert_execution_mode(0) */ into v_dflt_no (id, n) values (1, 5);
insert into v_dflt_no (id, n) values (2, 6);
select id, n, floor((unix_timestamp() - unix_timestamp(dt)) / 3600) as hours_ago from t_dflt order by id;


evaluate 'Case 17: a CHECK OPTION view fills the SYS_DATETIME DEFAULT of a column that it hides';
insert into v_dflt_chk (id, n) values (10, 5);
insert into v_dflt_chk (id, n) select 11, 6 from db_root;
merge into v_dflt_chk t using (select 12 as id, 7 as n from db_root) s on (t.id = s.id) when not matched then insert (id, n) values (s.id, s.n);
insert into v_dflt_chk (id, n) values (13, 500);
select id, n, floor((unix_timestamp() - unix_timestamp(dt)) / 3600) as hours_ago from t_dflt where id >= 10 order by id;


drop trigger trg_27609;
drop view v_casc, v_unix, v_sub_next, v_sysdt, v_curd, v_systs, v_utc, v_plain, v_uxarg, v_nochk, v_dflt_chk, v_dflt_no;
drop table t_base, t_src, t_trg, t_dflt;
