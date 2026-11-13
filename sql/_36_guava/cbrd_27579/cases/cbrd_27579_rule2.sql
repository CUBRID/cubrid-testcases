/**
 *  This test case verifies CBRD-27579 rule 2: a stored procedure / function invoked inside a query (SELECT)
 *  may not change any data, whatever the table.
 *    - INSERT, UPDATE, DELETE, MERGE, write locks (SELECT ... FOR UPDATE) and INCR () are refused.
 *    - A nested call inherits the outer query.
 *    - Reading is allowed, and a top-level CALL is not inside a query.
 *
 *  Coverage:
 *    Case 1: DML in a function invoked by SELECT
 *    Case 2: a function invoked by a subquery, DO or a view
 *    Case 3: a write lock and INCR () in a function invoked by SELECT
 *    Case 4: nested calls
 *    Case 5: reading and a top-level CALL
 *    Case 6: rows written by the allowed cases only
 */

--+ server-message on

drop view if exists v_dml;
drop view if exists v_sel;
drop table if exists t;
drop table if exists log_t;
drop table if exists cnt_t;

create table t (a int);
insert into t values (1), (2), (3);
create table log_t (x int);
insert into log_t values (0);
create table cnt_t (id int, cnt int);
insert into cnt_t values (1, 0);

create or replace function f_exec (q varchar) return int as begin execute immediate q; return 1; end;
create or replace function f_exec2 (q1 varchar, q2 varchar) return int as begin execute immediate q1; execute immediate q2; return 1; end;
create or replace function f_ins (n int) return int as begin insert into log_t values (n); return 1; end;
create or replace function f_cnt return int as c int; begin select count (*) into c from t; return c; end;
create or replace procedure p_exec (q varchar) as begin execute immediate q; end;
create or replace procedure p_sel_ins as c int; begin select f_ins (2) into c from db_root; end;
create or replace procedure p_sel_then_ins as c int; begin select f_cnt () into c from db_root; insert into log_t values (3); end;

create view v_dml as select a, f_ins (1) as c from t;
create view v_sel as select a, f_cnt () as c from t;
commit;


evaluate 'Case 1: DML in a function invoked by SELECT';
select f_ins (1) from db_root;
select f_exec ('update log_t set x = 1') from db_root;
select f_exec ('delete from log_t') from db_root;
select f_exec ('merge into log_t using db_root on (1 = 1) when matched then update set x = 1') from db_root;


evaluate 'Case 2: a function invoked by a subquery, DO or a view';
select (select f_ins (1) from db_root) from t where a = 1;
do f_ins (1);
select * from v_dml;


evaluate 'Case 3: a write lock and INCR () in a function invoked by SELECT';
select f_exec ('select x from log_t for update') from db_root;
select f_exec ('select incr (cnt) from cnt_t where id = 1') from db_root;
select f_exec ('select incr (cnt) from cnt_t where id = 1 union all select 1 from db_root') from db_root;
select f_exec2 ('prepare s_incr from ''select incr (cnt) from cnt_t where id = 1''', 'execute s_incr') from db_root;


evaluate 'Case 4: nested calls';
-- SELECT -> function -> CALL -> DML
select f_exec ('call p_exec (''insert into log_t values (1)'')') from db_root;
-- CALL -> SELECT -> function -> DML
call p_sel_ins ();
-- CALL -> SELECT ends -> the procedure's own DML (allowed)
call p_sel_then_ins ();


evaluate 'Case 5: reading and a top-level CALL';
select * from v_sel order by a;
call p_exec ('insert into log_t values (4)');


evaluate 'Case 6: rows written by the allowed cases only';
select x from log_t order by x;
select cnt from cnt_t;

--+ server-message off

drop view v_dml;
drop view v_sel;
drop function f_exec;
drop function f_exec2;
drop function f_ins;
drop function f_cnt;
drop procedure p_exec;
drop procedure p_sel_ins;
drop procedure p_sel_then_ins;
drop table t;
drop table log_t;
drop table cnt_t;
