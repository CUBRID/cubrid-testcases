--+ server-message on
-- verified the CBRD-25211
-- Support grant/revoke authorization for stored procedures

evaluate '1. U1 user is general.';
call login('dba','') on class db_user;
CREATE USER U1;
CREATE PROCEDURE sp1 () AS BEGIN dbms_output.put_line('run OK'); END;
CALL sp1 ();

evaluate '1-1 error-No permission.';
call login('u1','') on class db_user;
CALL dba.sp1 ();
DROP PROCEDURE dba.sp1;


evaluate '1-2 authorization';
call login('dba','') on class db_user;
GRANT EXECUTE ON PROCEDURE sp1 TO u1;


evaluate '1-3 Execution succeeded, drop statement failed.';
call login('u1','') on class db_user;
CALL dba.sp1 ();
DROP PROCEDURE dba.sp1;


evaluate '1-4 Remove Permissions';
call login('dba','') on class db_user;
REVOKE EXECUTE ON PROCEDURE sp1 FROM u1;


evaluate '1-5 fail - u1 fails because it does not have permission.';
call login('u1','') on class db_user;
CALL dba.sp1 ();
DROP PROCEDURE dba.sp1;


evaluate '1-6 End';
call login('dba','') on class db_user;
drop PROCEDURE sp1;
drop user U1;

evaluate '2. Create user. U2 user is a member of dba. ';
call login('dba','') on class db_user;
CREATE USER U2 groups dba;
CREATE PROCEDURE sp1 () AS BEGIN dbms_output.put_line('run OK'); END;
CALL sp1 ();

evaluate '2-1 permission.(success) It runs normally without granting permission. u2 is a dba member. ';
call login('u2','') on class db_user;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U2';
CALL dba.sp1 ();
DROP PROCEDURE dba.sp1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U2';


evaluate '2-2 authorization - owner grants permission to u2.';
call login('dba','') on class db_user;
CREATE PROCEDURE sp1 () AS BEGIN dbms_output.put_line('run OK'); END;
GRANT EXECUTE ON PROCEDURE sp1 TO u2;


evaluate '2-3 For the u2 user, the execution succeeds. The Revoke command fails because he is not the owner.';
call login('u2','') on class db_user;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U2';
REVOKE EXECUTE ON PROCEDURE dba.sp1 FROM u2;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U2';
CALL dba.sp1 ();


evaluate '2-4 Remove Permissions( success )';
call login('dba','') on class db_user;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U2';
REVOKE EXECUTE ON PROCEDURE sp1 FROM u2;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U2';

evaluate '2-5 For the u2 user, the execution succeeds.( dba group ).';
call login('u2','') on class db_user;
CALL dba.sp1 ();


evaluate '2-6 End';
call login('dba','') on class db_user;
drop PROCEDURE sp1;
drop user U2;

--+ server-message off

