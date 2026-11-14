/**
 *  This test case verifies CBRD-25574: DROP USER removes the rows of the dropped user from
 *  db_auth and from the grants of db_authorization, instead of leaving them with NULL.
 *
 *  The dropped user u2 is in the middle of a grant chain from u1 to u2 to u3 to u4, so the
 *  grants that u2 gave and the grants that came down from them go with it.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  a second GRANT SELECT to u2 without grant option adds no row and keeps is_grantable
 *    Case 2:  the grant chain from u1 to u2 to u3 to u4 shows in db_auth and db_authorization
 *    Case 3:  after DROP USER u2, the grants to and from u2 and those below them are gone, and the grant of u1.v1_tbl to u3 stays
 */

create user u1;
create user u2;
create user u3;
create user u4;

create table u1.tbl (col1 int);

CREATE FUNCTION u1.hello(i varchar) RETURN STRING
AS LANGUAGE JAVA
NAME 'SpTest.Hello(String) return java.lang.String';

create view u1.v1_tbl as select * from u1.tbl;


call login('u1','') on class db_user;

evaluate 'Case 1: a second GRANT SELECT to u2 without grant option adds no row and keeps is_grantable';
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

GRANT SELECT ON u1.tbl TO u2;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;


evaluate 'Case 2: the grant chain from u1 to u2 to u3 to u4 shows in db_auth and db_authorization';
GRANT INSERT ON u1.tbl TO u2 WITH GRANT OPTION;

GRANT EXECUTE ON PROCEDURE u1.hello TO u2;
GRANT SELECT ON u1.v1_tbl TO u3;

call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl TO u3;

call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl TO u4 WITH GRANT OPTION;

-- the two queries below run as u3
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 3: after DROP USER u2, the grants to and from u2 and those below them are gone, and the grant of u1.v1_tbl to u3 stays';
call login('dba','') on class db_user;
DROP USER u2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC';

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;

select name from db_user order by name;


drop function u1.hello;
drop table u1.tbl;
drop view u1.v1_tbl;
drop user u1;
drop user u3;
drop user u4;
