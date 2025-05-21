-- verified the CBRD-25834
-- Verify that the db_stored_procedure view is queried according to permissions.
create user owner_user;
create user grantee_user;
create user dba_member_user groups dba;
create user owner_member_user groups owner_user;
create user grantee_member_user groups grantee_user;

CREATE OR REPLACE FUNCTION owner_user.hello() RETURN STRING
AS LANGUAGE JAVA
NAME 'SpCubrid.HelloCubrid() return java.lang.String';

CREATE OR REPLACE PROCEDURE owner_user.phone_info(name varchar, phoneno varchar) as language java
name 'PhoneNumber.Phone(java.lang.String, java.lang.String)';

create or replace procedure owner_user.test_sp as
	cursor c is select hello() as sp from db_class limit 5;
begin
	FOR r IN c LOOP
		DBMS_OUTPUT.put_line(r.sp);
	END LOOP;
end;

CREATE OR REPLACE FUNCTION owner_user.fibonacci(n INTEGER) RETURN INTEGER
IS
	invalid_input EXCEPTION;
BEGIN
	IF n <= 0 THEN
		RAISE invalid_input;
	END IF;

	IF n = 1 OR n = 2 THEN
		RETURN 1;
	ELSE
		RETURN fibonacci(n-1) + fibonacci(n-2);
	END IF;
EXCEPTION
	WHEN invalid_input THEN
		DBMS_OUTPUT.put_line('invalid input: ' || n);
		RETURN -1;
	WHEN OTHERS THEN
		DBMS_OUTPUT.put_line('unknown exception');
		RETURN -1;
END;

evaluate 'dba';
call login('dba','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'dba_member';
call login('dba_member_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'owner';
call login('owner_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'owner_member';
call login('owner_member_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'unauthorized user select - grantee_user, dont show';
call login('grantee_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'unauthorized user select - grantee_member_user, dont show';
call login('grantee_member_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'grant permission to grantee_user';
call login('dba','') on class db_user;
grant execute on procedure owner_user.hello to grantee_user;
grant execute on procedure owner_user.phone_info to grantee_user;
grant execute on procedure owner_user.test_sp to grantee_user;

evaluate 'grantee_user select, the code appears as null';
call login('grantee_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'grantee_member_user select, the code appears as null';
call login('grantee_member_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'revoke permission to grantee_user';
call login('dba','') on class db_user;
revoke execute on procedure owner_user.hello from grantee_user;
revoke execute on procedure owner_user.phone_info from grantee_user;
revoke execute on procedure owner_user.test_sp from grantee_user;

call login('grantee_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

call login('grantee_member_user','') on class db_user;
select sp_name, owner, code from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

call login('dba','') on class db_user;
drop function owner_user.hello;
drop procedure owner_user.phone_info;
drop procedure owner_user.test_sp;
drop function owner_user.fibonacci;

drop user owner_user;
drop user grantee_user;
drop user dba_member_user;
drop user owner_member_user;
drop user grantee_member_user;
