-- verified the CBRD-25834
-- Verify that the db_stored_procedure view is queried according to permissions.
create user u1;
create user u2;

CREATE OR REPLACE FUNCTION u1.hello() RETURN STRING
AS LANGUAGE JAVA
NAME 'SpCubrid.HelloCubrid() return java.lang.String';

CREATE OR REPLACE PROCEDURE u1.phone_info(name varchar, phoneno varchar) as language java
name 'PhoneNumber.Phone(java.lang.String, java.lang.String)';

create or replace procedure u1.test_sp as
	cursor c is select hello() as sp from db_class limit 5;
begin
	FOR r IN c LOOP
		DBMS_OUTPUT.put_line(r.sp);
	END LOOP;
end;

CREATE OR REPLACE FUNCTION u1.fibonacci(n INTEGER) RETURN INTEGER
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

evaluate 'owner select';
call login('u1','') on class db_user;
select sp_name, owner from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'unauthorized user select';
call login('u2','') on class db_user;
select sp_name, owner from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'grant permission to u2';
call login('dba','') on class db_user;
grant execute on procedure u1.hello to u2;
grant execute on procedure u1.phone_info to u2;

call login('u2','') on class db_user;
select sp_name, owner from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

evaluate 'revoke permission to u2';
call login('dba','') on class db_user;
revoke execute on procedure u1.hello from u2;
revoke execute on procedure u1.phone_info from u2;

call login('u2','') on class db_user;
select sp_name, owner from db_stored_procedure order by sp_name, owner;
select sp_name, owner_name, arg_name from db_stored_procedure_args order by sp_name, owner_name, arg_name;

call login('dba','') on class db_user;
drop function u1.hello;
drop procedure u1.phone_info;
drop procedure u1.test_sp;
drop function u1.fibonacci;

drop user u1;
drop user u2;
