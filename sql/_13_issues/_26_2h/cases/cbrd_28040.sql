/**
 *  This test case verifies CBRD-28040: INSERT ... SELECT DISTINCT into an updatable
 *  view inserts duplicate rows because of the SYS_GUID() DEFAULT of an omitted column.
 *
 *  An INSERT on a view gives each view column that it omits the DEFAULT of the view.
 *  The DEFAULT values were appended to the select list of the source query, so DISTINCT
 *  and the set operations other than UNION ALL compared them too, and a DEFAULT that
 *  differs on each row, such as SYS_GUID(), kept the duplicate rows. The fix runs the
 *  source query as written and gives the DEFAULTs to the rows that it makes.
 *
 *  A view on a REUSE_OID table is not updatable, so the base tables use DONT_REUSE_OID.
 *  SYS_GUID() and SYS_DATETIME values change from run to run, so the cases print only
 *  whether a value is set and how many distinct values there are.
 *
 *  Coverage:
 *    Case 1:  SELECT DISTINCT inserts each distinct source row once
 *    Case 2:  UNION removes the duplicates of both arms
 *    Case 3:  INTERSECT keeps the rows common to both arms
 *    Case 4:  DIFFERENCE removes the rows of the second arm
 *    Case 5:  UNION ALL keeps every row
 *    Case 6:  a primary key on the base table takes the distinct rows without a unique violation
 *    Case 7:  ON DUPLICATE KEY UPDATE updates a conflicting row once
 *    Case 8:  ON DUPLICATE KEY UPDATE reads a column of the source
 *    Case 9:  a DEFAULT declared by the view wins over the DEFAULT of the base table
 *    Case 10: ALTER VIEW SET DEFAULT takes effect on the next run of the same statement
 *    Case 11: the DEFAULT of an expression column is inverted into the base column
 *    Case 12: the client path of INSERT_EXECUTION_MODE(0) gives the DEFAULTs the same way
 *    Case 13: the client path of a base table with a trigger gives the DEFAULTs the same way
 *    Case 14: REPLACE replaces the row whose unique column the view DEFAULT fills
 *    Case 15: a column count that differs from the source fails
 */

drop view if exists v_all, v_pk, v_cnt, v_own, v_set, v_expr, v_trg, v_uq;
drop table if exists t_src, t_all, t_pk, t_cnt, t_own, t_trg, t_trg_log, t_uq;

create table t_src (x int, y int);
insert into t_src values (1, 10), (1, 10), (2, 20);

create table t_all (a int, k int default 1, r varchar(40) default sys_guid(), d datetime default sys_datetime) dont_reuse_oid;
create view v_all as select a, k, r, d from t_all;


evaluate 'Case 1: SELECT DISTINCT inserts each distinct source row once';
insert into v_all (a) select distinct x from t_src;
select a, k, if (r is null, 'no guid', 'guid') from t_all order by a;
select count(*), count(distinct r), count(distinct d) from t_all;
delete from t_all;


evaluate 'Case 2: UNION removes the duplicates of both arms';
insert into v_all (a) select x from t_src union select x from t_src;
select a, k from t_all order by a;
select count(*), count(distinct r) from t_all;
delete from t_all;


evaluate 'Case 3: INTERSECT keeps the rows common to both arms';
insert into v_all (a) select x from t_src intersect select x from t_src;
select a, k from t_all order by a;
select count(*), count(distinct r) from t_all;
delete from t_all;


evaluate 'Case 4: DIFFERENCE removes the rows of the second arm';
insert into v_all (a) select x from t_src difference select x from t_src where x = 2;
select a, k from t_all order by a;
select count(*), count(distinct r) from t_all;
delete from t_all;


evaluate 'Case 5: UNION ALL keeps every row';
insert into v_all (a) select x from t_src union all select x from t_src;
select a, count(*) from t_all group by a order by a;
select count(*), count(distinct r) from t_all;
delete from t_all;


evaluate 'Case 6: a primary key on the base table takes the distinct rows without a unique violation';
create table t_pk (a int primary key, k int default 1, r varchar(40) default sys_guid()) dont_reuse_oid;
create view v_pk as select a, k, r from t_pk;
insert into v_pk (a) select distinct x from t_src;
select a, k, if (r is null, 'no guid', 'guid') from t_pk order by a;


create table t_cnt (a int primary key, cnt int default 0, r varchar(40) default sys_guid()) dont_reuse_oid;
create view v_cnt as select a, cnt, r from t_cnt;
insert into t_cnt (a, cnt) values (1, 100);

evaluate 'Case 7: ON DUPLICATE KEY UPDATE updates a conflicting row once';
insert into v_cnt (a) select distinct x from t_src on duplicate key update cnt = cnt + 1;
select a, cnt from t_cnt order by a;

-- Case 8 runs on the rows (1, 101) and (2, 0) that Case 7 left in t_cnt
evaluate 'Case 8: ON DUPLICATE KEY UPDATE reads a column of the source';
insert into v_cnt (a) select distinct x from t_src on duplicate key update cnt = t_src.y + cnt;
select a, cnt from t_cnt order by a;


evaluate 'Case 9: a DEFAULT declared by the view wins over the DEFAULT of the base table';
create table t_own (a int, k int default 1, r varchar(40) default sys_guid()) dont_reuse_oid;
create view v_own (a int, k int default 7, r varchar(40)) as select a, k, r from t_own;
insert into v_own (a) select distinct x from t_src;
select a, k, if (r is null, 'no guid', 'guid') from t_own order by a;
delete from t_own;


evaluate 'Case 10: ALTER VIEW SET DEFAULT takes effect on the next run of the same statement';
create view v_set as select a, k, r from t_own;
alter view v_set alter column k set default 9;
insert into v_set (a) select distinct x from t_src;
alter view v_set alter column k set default 11;
insert into v_set (a) select distinct x from t_src;
select k, count(*) from t_own group by k order by k;
delete from t_own;


evaluate 'Case 11: the DEFAULT of an expression column is inverted into the base column';
create view v_expr as select a, k + 1 as k2, r from t_own;
alter view v_expr alter column k2 set default 5;
insert into v_expr (a) select distinct x from t_src;
select a, k from t_own order by a;
select count(*), count(distinct r) from t_own;
delete from t_own;


evaluate 'Case 12: the client path of INSERT_EXECUTION_MODE(0) gives the DEFAULTs the same way';
insert /*+ insert_execution_mode(0) */ into v_own (a) select distinct x from t_src;
select a, k, if (r is null, 'no guid', 'guid') from t_own order by a;
select count(*), count(distinct r) from t_own;


evaluate 'Case 13: the client path of a base table with a trigger gives the DEFAULTs the same way';
create table t_trg (a int, k int default 1, r varchar(40) default sys_guid()) dont_reuse_oid;
create table t_trg_log (a int, k int);
create view v_trg as select a, k, r from t_trg;
alter view v_trg alter column k set default 7;
create trigger trg_28040 after insert on t_trg execute insert into t_trg_log values (obj.a, obj.k);
insert into v_trg (a) select distinct x from t_src;
select a, k, if (r is null, 'no guid', 'guid') from t_trg order by a;
select a, k from t_trg_log order by a;


evaluate 'Case 14: REPLACE replaces the row whose unique column the view DEFAULT fills';
create table t_uq (a int, b int unique) dont_reuse_oid;
create view v_uq as select a, b from t_uq;
alter view v_uq alter column b set default 1;
insert into v_uq (a) select 5 from db_root;
replace into v_uq (a) select distinct x from t_src where x = 2;
select a, b from t_uq order by a;


evaluate 'Case 15: a column count that differs from the source fails';
insert into v_all (a, k) select distinct x from t_src;
select count(*) from t_all;


drop trigger trg_28040;
drop view v_all, v_pk, v_cnt, v_own, v_set, v_expr, v_trg, v_uq;
drop table t_src, t_all, t_pk, t_cnt, t_own, t_trg, t_trg_log, t_uq;
