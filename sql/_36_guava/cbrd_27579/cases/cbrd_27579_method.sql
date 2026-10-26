/**
 *  This test case verifies CBRD-27579: a stored procedure / function invoked inside a SQL statement
 *  may not run a method call with a target.
 *
 *  A method call with a target (CALL ... ON CLASS, ON an object, or the target as the first argument)
 *  runs a built-in method such as add_user, change_owner or login, so it is judged as DDL, whether
 *  it reads or writes. A CALL of a stored procedure has no target and is not restricted.
 *
 *  Covered by other test cases, not repeated here:
 *    the built-in methods called directly, and in a procedure called alone
 *
 *  Coverage:
 *    Case 1: class methods of db_root, db_user, db_serial and _db_authorization in a function invoked by SELECT
 *    Case 2: instance methods of a user in a function invoked by SELECT
 *    Case 3: add_user and login prepared in the function and run by EXECUTE
 *    Case 4: nothing was changed
 */

--+ server-message on

drop table if exists s;
drop table if exists t_m;
drop serial if exists s_m;

create table s (a int);
insert into s values (1);
create table t_m (a int);
create serial s_m;
create trigger tr_m after insert on t_m execute print 'tr_m';
create user u_m2;
create user u_m3;
create user u_m4 groups u_m2;
create user u_m_drop;
create or replace function f_m_sp return int as begin return 1; end;

create or replace function fm_add_user return int as begin execute immediate 'call add_user (''u_m_new'', '''') on class db_root'; return 1; end;
create or replace function fm_add_user_arg return int as begin execute immediate 'call add_user (class db_root, ''u_m_new'', '''')'; return 1; end;
create or replace function fm_drop_user return int as begin execute immediate 'call drop_user (''u_m_drop'') on class db_root'; return 1; end;
create or replace function fm_find_user return int as begin execute immediate 'call find_user (''dba'') on class db_root'; return 1; end;
create or replace function fm_print_authorizations return int as begin execute immediate 'call print_authorizations () on class db_root'; return 1; end;
create or replace function fm_info return int as begin execute immediate 'call info (''time'') on class db_root'; return 1; end;
create or replace function fm_change_owner return int as begin execute immediate 'call change_owner (''t_m'', ''u_m2'') on class db_root'; return 1; end;
create or replace function fm_change_trigger_owner return int as begin execute immediate 'call change_trigger_owner (''tr_m'', ''u_m2'') on class db_root'; return 1; end;
create or replace function fm_get_owner return int as begin execute immediate 'call get_owner (''t_m'') on class db_root'; return 1; end;
create or replace function fm_change_sp_owner return int as begin execute immediate 'call change_sp_owner (''f_m_sp'', ''u_m2'') on class db_root'; return 1; end;
create or replace function fm_change_serial_owner return int as begin execute immediate 'call change_serial_owner (''s_m'', ''u_m2'') on class db_serial'; return 1; end;
create or replace function fm_check_authorization return int as begin execute immediate 'call check_authorization (''t_m'', 1) on class _db_authorization'; return 1; end;
create or replace function fm_login return int as begin execute immediate 'call login (''u_m2'', '''') on class db_user'; return 1; end;
create or replace function fm_user_find_user return int as begin execute immediate 'call find_user (''dba'') on class db_user'; return 1; end;
create or replace function fm_set_password return int as begin execute immediate 'call set_password (''x'') on (select u from db_user u where name = ''U_M2'')'; return 1; end;
create or replace function fm_set_password_arg return int as begin execute immediate 'call set_password ((select u from db_user u where name = ''U_M2''), ''x'')'; return 1; end;
create or replace function fm_set_password_encoded return int as begin execute immediate 'call set_password_encoded (''x'') on (select u from db_user u where name = ''U_M2'')'; return 1; end;
create or replace function fm_set_password_encoded_sha1 return int as begin execute immediate 'call set_password_encoded_sha1 (''x'') on (select u from db_user u where name = ''U_M2'')'; return 1; end;
create or replace function fm_add_member return int as begin execute immediate 'call add_member (''u_m3'') on (select u from db_user u where name = ''U_M2'')'; return 1; end;
create or replace function fm_drop_member return int as begin execute immediate 'call drop_member (''u_m4'') on (select u from db_user u where name = ''U_M2'')'; return 1; end;
create or replace function fm_user_print_authorizations return int as begin execute immediate 'call print_authorizations () on (select u from db_user u where name = ''U_M2'')'; return 1; end;
create or replace function fm_add_user_execute return int as
begin
  execute immediate 'prepare s_add from ''call add_user (''''u_m_new'''', '''''''') on class db_root''';
  execute immediate 'execute s_add';
  return 1;
end;
create or replace function fm_login_execute return int as
begin
  execute immediate 'prepare s_login from ''call login (''''u_m2'''', '''''''') on class db_user''';
  execute immediate 'execute s_login';
  return 1;
end;
commit;


evaluate 'Case 1: class methods of db_root, db_user, db_serial and _db_authorization in a function invoked by SELECT';
select fm_add_user () from s;
select fm_add_user_arg () from s;
select fm_drop_user () from s;
select fm_find_user () from s;
select fm_print_authorizations () from s;
select fm_info () from s;
select fm_change_owner () from s;
select fm_change_trigger_owner () from s;
select fm_get_owner () from s;
select fm_change_sp_owner () from s;
select fm_change_serial_owner () from s;
select fm_check_authorization () from s;
select fm_login () from s;
select fm_user_find_user () from s;


evaluate 'Case 2: instance methods of a user in a function invoked by SELECT';
select fm_set_password () from s;
select fm_set_password_arg () from s;
select fm_set_password_encoded () from s;
select fm_set_password_encoded_sha1 () from s;
select fm_add_member () from s;
select fm_drop_member () from s;
select fm_user_print_authorizations () from s;


evaluate 'Case 3: add_user and login prepared in the function and run by EXECUTE';
select fm_add_user_execute () from s;
select fm_login_execute () from s;


evaluate 'Case 4: nothing was changed';
select current_user from db_root;
select name from db_user where name in ('U_M_NEW', 'U_M_DROP') order by 1;
select owner_name from db_class where class_name = 't_m';
select owner from db_serial where name = 's_m';
select owner_name from db_trigger where trigger_name = 'tr_m';
select owner from db_stored_procedure where sp_name = 'f_m_sp';
select name, direct_groups from db_user where name in ('U_M3', 'U_M4') order by 1;

--+ server-message off

drop function fm_add_user;
drop function fm_add_user_arg;
drop function fm_drop_user;
drop function fm_find_user;
drop function fm_print_authorizations;
drop function fm_info;
drop function fm_change_owner;
drop function fm_change_trigger_owner;
drop function fm_get_owner;
drop function fm_change_sp_owner;
drop function fm_change_serial_owner;
drop function fm_check_authorization;
drop function fm_login;
drop function fm_user_find_user;
drop function fm_set_password;
drop function fm_set_password_arg;
drop function fm_set_password_encoded;
drop function fm_set_password_encoded_sha1;
drop function fm_add_member;
drop function fm_drop_member;
drop function fm_user_print_authorizations;
drop function fm_add_user_execute;
drop function fm_login_execute;
drop function f_m_sp;
drop trigger tr_m;
drop serial s_m;
drop table t_m;
drop table s;
drop user u_m4;
drop user u_m3;
drop user u_m2;
drop user u_m_drop;
