/**
 *  This test case verifies CBRD-25486: dropping an object that is granted to other users
 *  removes its rows from db_auth and its entries from the grants of db_authorization.
 *
 *  Scenario 03 drops a Java SP whose EXECUTE privilege u1 granted to u2 and u3.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants EXECUTE on u1.hello to u2 and u3, and both catalogs show the grants
 *    Case 2:  after DROP FUNCTION u1.hello, its grant rows and its SP row are gone
 */

create user u1;
create user u2;
create user u3;

CREATE FUNCTION u1.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

evaluate 'Case 1: u1 grants EXECUTE on u1.hello to u2 and u3, and both catalogs show the grants';
call login('u1','') on class db_user;
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT EXECUTE ON PROCEDURE u1.hello TO u3;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 2: after DROP FUNCTION u1.hello, its grant rows and its SP row are gone';
call login('dba','') on class db_user;
DROP FUNCTION u1.hello;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC'  order by grantor_name;
select owner, grants from db_authorization where owner != 'PUBLIC'  order by owner;
select sp_name, pkg_name, sp_type, return_type, arg_count, lang, authid, is_deterministic, target, owner, code, comment from db_stored_procedure;


drop user u1;
drop user u2;
drop user u3;
