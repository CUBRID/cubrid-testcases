/**
 *  This test case verifies CBRD-25574: DROP USER removes the rows of the dropped user from
 *  db_auth and from the grants of db_authorization, instead of leaving them with NULL.
 *
 *  The dropped user u3 is the last grantee of a grant chain from u1 to u2 to u3 on a table,
 *  and a grantee of EXECUTE on a Java SP of u1.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 and u2 grant SELECT on u1.tbl and EXECUTE on u1.hello, and both catalogs show the grants
 *    Case 2:  after DROP USER u3, the rows granted to u3 are gone and the other rows stay
 */

create user u1;
create user u2;
create user u3;

create table u1.tbl (col1 int);

CREATE FUNCTION u1.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

evaluate 'Case 1: u1 and u2 grant SELECT on u1.tbl and EXECUTE on u1.hello, and both catalogs show the grants';
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT EXECUTE ON PROCEDURE u1.hello TO u3;

call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;

-- the two queries below run as u2, which sees only the grants that it gave or received
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, object_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 2: after DROP USER u3, the rows granted to u3 are gone and the other rows stay';
call login('dba','') on class db_user;
drop user u3;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, object_name;

select owner, grants from db_authorization where owner != 'PUBLIC';


drop user u2;
drop table u1.tbl;
drop function u1.hello;
drop user u1;
