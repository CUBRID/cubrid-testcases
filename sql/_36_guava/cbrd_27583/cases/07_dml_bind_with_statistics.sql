/**
 *  This test case verifies CBRD-27583 with CBRD-27582: a driver-bound UPDATE, DELETE, MERGE,
 *  SELECT and INSERT ... SELECT on a table with statistics use the values of each EXECUTE,
 *  also when the bind types change between the executions.
 *
 *  The first EXECUTE of such a statement compiles it with its values bound.  A cached plan
 *  that kept those values made every later EXECUTE reuse them (CBRD-27582, fixed by #8176),
 *  and with a plan per bind type signature (CBRD-27583) no signature's plan may keep them.
 *  The answers are develop's since #8176.  Before it the UPDATE and DELETE executions after
 *  the first used the first values again: Case 1 and Case 3 wrote 11 and 21 into every row,
 *  and the second DELETE of Case 2 and the second UPDATE of Case 6 found no row.  MERGE,
 *  SELECT and INSERT ... SELECT got the values of each execution there too.
 *
 *  Judged by the literal results: the rows each SELECT answers are the ones the bound values
 *  of every execution give.  The SMALLINT host variables stand for a third number type, as
 *  the test tool binds no BIGINT.
 *
 *  Coverage:
 *    Case 1:  UPDATE SET n = 10 + ? WHERE id = ?, three executions
 *    Case 2:  DELETE WHERE id > ? AND n = 10 + ?, two executions
 *    Case 3:  the value's and the key's bind types alternating (INT, DOUBLE, VARCHAR, SMALLINT)
 *    Case 4:  MERGE WHEN MATCHED UPDATE SET n = 50 + ?, the value's type changing
 *    Case 5:  SELECT COUNT (*) WHERE id > ? AND n = 10 + ?, five executions
 *    Case 6:  INSERT ... SELECT ... WHERE n = 10 + ? and UPDATE ... WHERE n = 10 + ?
 */

drop table if exists t_upd, t_del, t_val, t_key, t_mrg, t_sel, t_ins;


evaluate 'Case 1: UPDATE SET n = 10 + ? WHERE id = ?, three executions';
create table t_upd (id int primary key, n int);
insert into t_upd select rownum, 0 from db_class a, db_class b limit 300;
update statistics on t_upd with fullscan;
$int,$1,$int,$1;
update t_upd set n = 10 + ? where id = ?;
$int,$7,$int,$2;
update t_upd set n = 10 + ? where id = ?;
$int,$5,$int,$3;
update t_upd set n = 10 + ? where id = ?;
select id, n from t_upd where id <= 3 order by id;


evaluate 'Case 2: DELETE WHERE id > ? AND n = 10 + ?, two executions';
create table t_del (id int primary key, n int);
insert into t_del select rownum, 0 from db_class a, db_class b limit 300;
update t_del set n = 10 + mod (id, 10);
update statistics on t_del with fullscan;
$int,$0,$int,$1;
delete from t_del where id > ? and n = 10 + ?;
$int,$0,$int,$7;
delete from t_del where id > ? and n = 10 + ?;
select count (*), sum (case when n in (11, 17) then 1 else 0 end) from t_del;


evaluate 'Case 3: the value''s and the key''s bind types alternating (INT, DOUBLE, VARCHAR, SMALLINT)';
create table t_val (id int primary key, n int);
insert into t_val select rownum, 0 from db_class a, db_class b limit 300;
update statistics on t_val with fullscan;
$int,$1,$int,$1;
update t_val set n = 10 + ? where id = ?;
$double,$2.5,$int,$2;
update t_val set n = 10 + ? where id = ?;
$varchar,$3,$int,$3;
update t_val set n = 10 + ? where id = ?;
$int,$7,$int,$4;
update t_val set n = 10 + ? where id = ?;
$double,$4.25,$int,$5;
update t_val set n = 10 + ? where id = ?;
$smallint,$6,$int,$6;
update t_val set n = 10 + ? where id = ?;
$varchar,$8,$int,$7;
update t_val set n = 10 + ? where id = ?;
select id, n from t_val where id <= 7 order by id;
create table t_key (id int primary key, n int);
insert into t_key select rownum, 0 from db_class a, db_class b limit 300;
update statistics on t_key with fullscan;
$int,$1,$int,$1;
update t_key set n = 20 + ? where id = ?;
$int,$2,$varchar,$2;
update t_key set n = 20 + ? where id = ?;
$int,$3,$double,$3.0;
update t_key set n = 20 + ? where id = ?;
$int,$4,$int,$4;
update t_key set n = 20 + ? where id = ?;
$int,$5,$smallint,$5;
update t_key set n = 20 + ? where id = ?;
select id, n from t_key where id <= 5 order by id;


evaluate 'Case 4: MERGE WHEN MATCHED UPDATE SET n = 50 + ?, the value''s type changing';
create table t_mrg (id int primary key, n int);
insert into t_mrg select rownum, 0 from db_class a, db_class b limit 300;
update statistics on t_mrg with fullscan;
$int,$1,$int,$1;
merge into t_mrg t using (select ? k from db_root) s on (t.id = s.k) when matched then update set t.n = 50 + ?;
$int,$2,$int,$7;
merge into t_mrg t using (select ? k from db_root) s on (t.id = s.k) when matched then update set t.n = 50 + ?;
$int,$3,$varchar,$5;
merge into t_mrg t using (select ? k from db_root) s on (t.id = s.k) when matched then update set t.n = 50 + ?;
select id, n from t_mrg where id <= 3 order by id;


evaluate 'Case 5: SELECT COUNT (*) WHERE id > ? AND n = 10 + ?, five executions';
create table t_sel (id int primary key, n int);
insert into t_sel select rownum, 0 from db_class a, db_class b limit 300;
update t_sel set n = 10 + mod (id, 10);
update statistics on t_sel with fullscan;
$int,$0,$int,$1;
select count (*) from t_sel where id > ? and n = 10 + ?;
$int,$0,$int,$7;
select count (*) from t_sel where id > ? and n = 10 + ?;
$int,$0,$double,$2.0;
select count (*) from t_sel where id > ? and n = 10 + ?;
$int,$0,$varchar,$3;
select count (*) from t_sel where id > ? and n = 10 + ?;
$int,$100,$int,$7;
select count (*) from t_sel where id > ? and n = 10 + ?;


evaluate 'Case 6: INSERT ... SELECT ... WHERE n = 10 + ? and UPDATE ... WHERE n = 10 + ?';
create table t_ins (id int, n int);
$int,$0,$int,$1;
insert into t_ins select id, n from t_sel where id > ? and n = 10 + ?;
$int,$0,$int,$7;
insert into t_ins select id, n from t_sel where id > ? and n = 10 + ?;
select count (*), sum (case when n = 11 then 1 else 0 end), sum (case when n = 17 then 1 else 0 end) from t_ins;
$int,$0,$int,$3;
update t_sel set n = n + 1000 where id > ? and n = 10 + ?;
$int,$0,$int,$9;
update t_sel set n = n + 1000 where id > ? and n = 10 + ?;
select sum (case when n >= 1000 then 1 else 0 end), sum (case when n in (1013, 1019) then 1 else 0 end) from t_sel;

drop table t_upd, t_del, t_val, t_key, t_mrg, t_sel, t_ins;
