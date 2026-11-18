/**
 *  This test case verifies CBRD-27720: the privileges granted on a stored procedure are lost by CREATE OR REPLACE
 *
 *  Before the fix, CREATE OR REPLACE dropped the existing stored procedure and created a new one, so the
 *  rows of _db_auth on it were deleted. After the fix, the row of _db_stored_procedure is overwritten in place.
 *  Its argument rows and its PL/CSQL code row are deleted and created again, and its created_time is kept.
 *  The cases replace the function sp1 of dba, on which u1 has EXECUTE, and check the privilege,
 *  the catalog rows, and a call by u1 after each replace.
 *
 *  Coverage:
 *    Case 1:  more arguments and another return type - privilege kept, new argument rows, u1 runs the new body
 *    Case 2:  fewer arguments - no old argument row is left
 *    Case 3:  PL/CSQL to Java - the old code row is deleted, privilege kept
 *    Case 4:  Java to PL/CSQL - one code row is created, privilege kept
 *    Case 5:  a replace that fails - wrong type or compile error - leaves the body and the privilege
 *    Case 6:  a grantee that is not the owner can not replace it - the body and the privilege stay
 *    Case 7:  created_time is the one of the first CREATE
 */
--+ server-message on

drop table if exists t_sp1, t_code;
create user u1;

create or replace function sp1() return varchar as begin return 'v1'; end;
grant execute on procedure sp1 to u1;
-- Case 7 compares created_time with this row
create table t_sp1 as select sp_name, created_time from _db_stored_procedure where sp_name = 'sp1';


evaluate 'Case 1: more arguments and another return type; privilege kept, u1 gets 4';
create or replace function sp1(a int, b varchar) return int as begin return a + length(b); end;
select grantor.name, grantee.name, object_type, auth_type, is_grantable from _db_auth where grantee.name = 'U1';
select index_of, arg_name, data_type from _db_stored_procedure_args where sp_of.sp_name = 'sp1' order by index_of;
call login('u1','') on class db_user;
select dba.sp1(1, 'abc');
call login('dba','') on class db_user;


evaluate 'Case 2: fewer arguments; no old argument row is left, u1 gets 20';
create or replace function sp1(x int) return int as begin return x * 10; end;
select index_of, arg_name, data_type from _db_stored_procedure_args where sp_of.sp_name = 'sp1' order by index_of;
select arg_count from _db_stored_procedure where sp_name = 'sp1';
call login('u1','') on class db_user;
select dba.sp1(2);
call login('dba','') on class db_user;


evaluate 'Case 3: PL/CSQL to Java; the old code row is deleted, u1 gets 11';
create table t_code as select target_class from _db_stored_procedure where sp_name = 'sp1';
select count(*) from _db_stored_procedure_code c, t_code t where c.name = t.target_class;
create or replace function sp1() return int as language java name 'SpTest3.typetestint0() return int';
select count(*) from _db_stored_procedure_code c, t_code t where c.name = t.target_class;
select lang, arg_count, target_class, target_method from _db_stored_procedure where sp_name = 'sp1';
select count(*) from _db_stored_procedure_args where sp_of.sp_name = 'sp1';
select grantor.name, grantee.name, object_type, auth_type, is_grantable from _db_auth where grantee.name = 'U1';
call login('u1','') on class db_user;
select dba.sp1();
call login('dba','') on class db_user;


evaluate 'Case 4: Java to PL/CSQL; one code row, u1 gets v4';
create or replace function sp1() return varchar as begin return 'v4'; end;
select count(*) from _db_stored_procedure_code c, _db_stored_procedure p where p.sp_name = 'sp1' and c.name = p.target_class;
select lang, arg_count from _db_stored_procedure where sp_name = 'sp1';
select grantor.name, grantee.name, object_type, auth_type, is_grantable from _db_auth where grantee.name = 'U1';
call login('u1','') on class db_user;
select dba.sp1();
call login('dba','') on class db_user;


evaluate 'Case 5: a failed replace keeps the body and the privilege; u1 gets v4';
-- expected error: sp1 is a function, not a procedure
create or replace procedure sp1() as begin dbms_output.put_line('procedure v5'); end;
-- expected error: no_such_variable is not declared
create or replace function sp1() return varchar as begin return no_such_variable; end;
select sp_type, lang, arg_count from _db_stored_procedure where sp_name = 'sp1';
select count(*) from _db_stored_procedure_code c, _db_stored_procedure p where p.sp_name = 'sp1' and c.name = p.target_class;
select grantor.name, grantee.name, object_type, auth_type, is_grantable from _db_auth where grantee.name = 'U1';
call login('u1','') on class db_user;
select dba.sp1();
call login('dba','') on class db_user;


evaluate 'Case 6: a grantee can not replace it; error, then u1 still gets v4';
call login('u1','') on class db_user;
-- expected error: u1 is neither the owner nor a member of DBA
create or replace function dba.sp1() return varchar as begin return 'replaced by u1'; end;
select dba.sp1();
call login('dba','') on class db_user;
select owner.name, sp_type, lang from _db_stored_procedure where sp_name = 'sp1';
select grantor.name, grantee.name, object_type, auth_type, is_grantable from _db_auth where grantee.name = 'U1';


evaluate 'Case 7: created_time is kept; result = 1 1';
select p.created_time = t.created_time, p.updated_time >= p.created_time from _db_stored_procedure p, t_sp1 t where p.sp_name = t.sp_name;


drop table t_sp1, t_code;
drop function sp1;
select grantor.name, grantee.name, object_type, auth_type, is_grantable from _db_auth where grantee.name = 'U1';
drop user u1;

--+ server-message off
