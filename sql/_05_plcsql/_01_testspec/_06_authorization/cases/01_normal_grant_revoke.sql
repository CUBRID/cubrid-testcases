--+ server-message on
-- verified the CBRD-24912
-- Support grant/revoke authorization for stored procedures

evaluate '1. create function and search with u1(not granted)';
CREATE OR REPLACE FUNCTION sp1() return varchar as begin return 'hello'; end;
CREATE OR REPLACE PROCEDURE sp2() as begin dbms_output.put_line('call sp2'); end;
CREATE USER u1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth where grantee.name = 'U1';
SELECT unique_name, sp_name, sp_type, return_type, arg_count, target_method, owner.name FROM _db_stored_procedure where sp_name like 'sp%' ORDER BY unique_name;

call login('u1','') on class db_user;
SELECT dba.sp1();
call dba.sp2();


evaluate '2. Grant permission to u1.  Call a function.';
call login('dba','') on class db_user;
GRANT EXECUTE ON PROCEDURE sp1 TO u1;
GRANT EXECUTE ON PROCEDURE sp2 TO u1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U1';
SELECT owner.name, grants from db_authorization where owner.name = 'U1';
call login('u1','') on class db_user;

evaluate 'CUBRID does not support synonyms for procedures.';
CREATE SYNONYM u1.sp1 FOR dba.sp1;
CREATE SYNONYM u1.sp2 FOR dba.sp2;
select * from db_synonym where synonym_owner_name='U1' ORDER BY synonym_name;

evaluate '2-1. error-synonym.( SELECt sp1(); )'; 
SELECT sp1();
call sp2();
DROP SYNONYM u1.sp1;
DROP SYNONYM u1.sp2;

evaluate '2-2. success.( SELECT dba.sp1(); )'; 
SELECT dba.sp1();
call dba.sp2();



evaluate '3. REVOKE permission to u1.  Call a function.';
call login('dba','') on class db_user;
REVOKE EXECUTE ON PROCEDURE sp1 FROM u1;
REVOKE EXECUTE ON PROCEDURE sp2 FROM u1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U1';
SELECT owner.name, grants from db_authorization where owner.name = 'U1';

call login('u1','') on class db_user;
SELECT dba.sp1();
call dba.sp2();


evaluate '4. drop function.  Call a function #1.';
call login('dba','') on class db_user;
GRANT EXECUTE ON PROCEDURE sp1 TO u1;
GRANT EXECUTE ON PROCEDURE sp2 TO u1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U1';
DROP FUNCTION sp1;
DROP PROCEDURE sp2;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U1';

call login('u1','') on class db_user;
SELECT dba.sp1();
call dba.sp2();


evaluate '5. drop function.  Call a function #2.';
call login('dba','') on class db_user;
CREATE OR REPLACE FUNCTION sp1() return varchar as begin return 'hello'; end;
CREATE OR REPLACE PROCEDURE sp2() as begin dbms_output.put_line('call sp2'); end;
-- CBRD-25486 : When the 'CBRD-25486' issue is resolved, records with null in the object_of column will be deleted and not displayed.
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U1';
DROP FUNCTION sp1;
DROP PROCEDURE sp2;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U1';

call login('u1','') on class db_user;
SELECT dba.sp1();
call dba.sp2();


call login('dba','') on class db_user;
drop user u1;

SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth WHERE grantee.name = 'U1';
SELECT owner.name, grants from db_authorization where owner.name = 'U1';

--+ server-message off
