/**
 *  This test case verifies CBRD-27579 rule 1: a stored procedure / function invoked inside a SQL statement
 *  or a trigger may not end the transaction or change the schema.
 *    - TCL (COMMIT, ROLLBACK, SAVEPOINT, 2PC, SET) and DDL are refused.
 *    - A method call with a target (CALL ... ON CLASS, add_user, login, set_password, ...) is DDL.
 *    - SET @v and SET TRACE are allowed.
 *    - A top-level CALL is not inside a statement, so it is allowed.
 *
 *  Coverage:
 *    Case 1: TCL in a function invoked by SELECT
 *    Case 2: SET statements in a function invoked by SELECT
 *    Case 3: DDL and method calls with a target in a function invoked by SELECT
 *    Case 4: TCL and DDL in a function invoked by DML
 *    Case 5: TCL and DDL in a procedure called by a trigger action
 *    Case 6: TCL and DDL in a top-level CALL
 *    Case 7: nothing was changed by the refused cases
 */

--+ server-message on

drop table if exists t;
drop table if exists t_tr;
drop table if exists t_new;
drop table if exists t_call;

create table t (a int);
insert into t values (1), (2);
create table t_tr (a int);
create user u_r1;

create or replace function f_exec (q varchar) return int as begin execute immediate q; return 1; end;
create or replace function f_exec2 (q1 varchar, q2 varchar) return int as begin execute immediate q1; execute immediate q2; return 1; end;
create or replace function f_commit return int as begin commit; return 1; end;
create or replace procedure p_exec (q varchar) as begin execute immediate q; end;
commit;


evaluate 'Case 1: TCL in a function invoked by SELECT';
select f_commit () from db_root;
select f_exec ('rollback') from db_root;
select f_exec ('savepoint sp1') from db_root;
select f_exec ('prepare to commit 77') from db_root;
select f_exec ('attach 77') from db_root;


evaluate 'Case 2: SET statements in a function invoked by SELECT';
select f_exec ('set transaction isolation level 4') from db_root;
select f_exec ('set system parameters ''xasl_debug_dump=no''') from db_root;
select f_exec ('set optimization level 1') from db_root;
select f_exec ('set trigger trace on') from db_root;
select f_exec ('set names utf8') from db_root;
select f_exec ('set time zone ''Asia/Seoul''') from db_root;
-- allowed
select f_exec ('set @v_r1 = 7') from db_root;
select @v_r1 from db_root;
select f_exec2 ('set trace on', 'set trace off') from db_root;


evaluate 'Case 3: DDL and method calls with a target in a function invoked by SELECT';
select f_exec ('create table t_new (a int)') from db_root;
select f_exec ('call add_user (''u_r1_new'', '''') on class db_root') from db_root;
select f_exec ('call add_user (class db_root, ''u_r1_new'', '''')') from db_root;
select f_exec ('call set_password (''x'') on (select u from db_user u where name = ''U_R1'')') from db_root;
select f_exec2 ('prepare s_login from ''call login (''''u_r1'''', '''''''') on class db_user''', 'execute s_login') from db_root;


evaluate 'Case 4: TCL and DDL in a function invoked by DML';
update t set a = f_exec ('commit');
update t set a = f_exec ('create table t_new (a int)');


evaluate 'Case 5: TCL and DDL in a procedure called by a trigger action';
create trigger tr_r1 after insert on t_tr execute call p_exec ('commit');
insert into t_tr values (1);
drop trigger tr_r1;
create trigger tr_r1 after insert on t_tr execute call p_exec ('create table t_new (a int)');
insert into t_tr values (2);
drop trigger tr_r1;


evaluate 'Case 6: TCL and DDL in a top-level CALL';
call p_exec ('create table t_call (a int)');
call p_exec ('commit');
select count (*) from db_class where class_name = 't_call';


evaluate 'Case 7: nothing was changed by the refused cases';
select a from t order by a;
select count (*) from t_tr;
select count (*) from db_class where class_name = 't_new';
select name from db_user where name like 'U_R1%' order by 1;
select current_user from db_root;

--+ server-message off

drop function f_exec;
drop function f_exec2;
drop function f_commit;
drop procedure p_exec;
drop table t;
drop table t_tr;
drop table t_call;
drop user u_r1;
