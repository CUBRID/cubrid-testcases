/**
 *  This test case verifies CBRD-25923: the SEQUENCE value in the db_authorization catalog on GRANT and REVOKE
 *
 *  The grants column of db_authorization holds a SEQUENCE of the grants of a user. Each case
 *  grants and revokes through the grant options of u1, u2 and u3 and checks db_auth and
 *  db_authorization, so that the SEQUENCE and the permission checks agree.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  GRANT and REVOKE through grant options show the same grants in db_auth and in the grants SEQUENCE of db_authorization
 *    Case 2:  the order of grants changes the position in the SEQUENCE but not the permission check
 *    Case 3:  a user without WITH GRANT OPTION on any grant cannot grant
 *    Case 4:  when u2 cannot add a second grant path, u3 cannot grant after the REVOKE of its only path
 *    Case 5:  SELECT and INSERT grants are told apart, and a GRANT to the owner fails
 */

CREATE USER U1;
CREATE USER U2;
CREATE USER U3;

evaluate 'Case 1: GRANT and REVOKE through grant options show the same grants in db_auth and in the grants SEQUENCE of db_authorization';

CREATE TABLE u1.tbl1 (col1 int);
CREATE TABLE u1.tbl2 (col1 int);

-- u1 grants SELECT to u2 and INSERT to u3, both WITH GRANT OPTION
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl1 TO U2 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl1 TO U3 WITH GRANT OPTION;

-- u2 grants SELECT to u3 WITH GRANT OPTION
call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u3 WITH GRANT OPTION;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner, grants;


-- u3 grants SELECT to u2
call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u2;

-- expected to fail: u3 has no SELECT on tbl2
GRANT SELECT ON u1.tbl2 TO u2;

-- expected to fail: u3 has no UPDATE on tbl1
GRANT UPDATE ON u1.tbl1 TO u2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner, grants;


-- expected to fail: u3 has no UPDATE on tbl1
REVOKE UPDATE ON u1.tbl1 FROM u2;

-- expected to fail: u3 has no SELECT on tbl2
REVOKE SELECT ON u1.tbl2 FROM u2;

-- u3 revokes the SELECT it granted to u2
REVOKE SELECT ON u1.tbl1 FROM u2;


-- back to dba
call login('dba','') on class db_user;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner, grants;


-- cleanup of Case 1
drop table u1.tbl2;
drop table u1.tbl1;


evaluate 'Case 2: the order of grants changes the position in the SEQUENCE but not the permission check';

CREATE TABLE u1.tbl1 (col1 int);

call login('u2','') on class db_user;
-- expected to fail: u2 has no SELECT on tbl1 yet
GRANT SELECT ON u1.tbl1 TO U3 WITH GRANT OPTION;

-- u1 grants SELECT to u3 WITH GRANT OPTION
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl1 TO U3 WITH GRANT OPTION;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner, grants;


-- u3 grants SELECT to u2
call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl1 TO U2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner, grants;


-- cleanup of Case 2
call login('dba','') on class db_user;
drop table u1.tbl1;


evaluate 'Case 3: a user without WITH GRANT OPTION on any grant cannot grant';

CREATE TABLE u1.tbl1 (col1 int);

-- u1 grants SELECT to u2 without WITH GRANT OPTION
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl1 TO U2;

call login('u2','') on class db_user;
-- expected to fail: u2 has no grant option
GRANT SELECT ON u1.tbl1 TO U3;

call login('u3','') on class db_user;
-- expected to fail: u3 has no SELECT on tbl1
GRANT SELECT ON u1.tbl1 TO u2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner, grants;


-- cleanup of Case 3
call login('dba','') on class db_user;
drop table u1.tbl1;


evaluate 'Case 4: when u2 cannot add a second grant path, u3 cannot grant after the REVOKE of its only path';

CREATE TABLE u1.tbl1 (col1 int);

-- u1 grants SELECT to u3 WITH GRANT OPTION
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl1 TO U3 WITH GRANT OPTION;

call login('u2','') on class db_user;
-- expected to fail: u2 has no SELECT on tbl1
GRANT SELECT ON u1.tbl1 TO U3 WITH GRANT OPTION;


-- dba revokes the SELECT of u3
call login('dba','') on class db_user;
REVOKE SELECT ON u1.tbl1 FROM U3;

call login('u3','') on class db_user;
-- expected to fail: the SELECT of u3 was revoked
GRANT SELECT ON u1.tbl1 TO U2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner, grants;

-- cleanup of Case 4
call login('dba','') on class db_user;
drop table u1.tbl1;


evaluate 'Case 5: SELECT and INSERT grants are told apart, and a GRANT to the owner fails';

CREATE TABLE u1.tbl1 (col1 int);

-- u1 grants SELECT to u2 WITH GRANT OPTION and INSERT to u3 without it
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl1 TO U2 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl1 TO U3;

-- u2 grants SELECT to u3
call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl1 TO U3;

call login('u3','') on class db_user;
-- expected to fail: u3 has INSERT without grant option
GRANT INSERT ON u1.tbl1 TO U2;
-- expected to fail: u1 owns tbl1
GRANT SELECT ON u1.tbl1 TO U1;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner, grants;


-- cleanup
call login('dba','') on class db_user;
drop table u1.tbl1;

drop user u1;
drop user u2;
drop user u3;
