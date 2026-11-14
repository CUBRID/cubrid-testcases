/**
 *  This test case verifies CBRD-25582: REVOKE does not cascade to a grant that still traces
 *  back to the owner through another grantor, and removes the grants that no longer do.
 *
 *  Grant chains on u1.tbl run through u1 to u5. The steps 3-1, 3-2 and 3-3 of CBRD-25580
 *  (a GRANT to the owner, to a user who already holds the privilege, and to dba) are run on
 *  the way.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  dba grants to dba with no effect, and a GRANT to the owner u1 fails with an error
 *    Case 2:  a grant chain from u1 to u5, and a repeated GRANT of u2 to itself has no effect
 *    Case 3:  as dba, a GRANT to the owner fails with an error, and REVOKE from u2 removes the whole chain
 *    Case 4:  a GRANT to the owner fails with an error, and u1 grants to u2 and u3 and builds a chain again
 *    Case 5:  u1 revokes from u2, the grant of u2 to u3 goes, and u3 keeps its grant from u1 and its grants below
 *    Case 6:  u1 revokes from u3, and no grant remains
 *    Case 7:  u1 grants ALL PRIVILEGES to u2, and a SELECT chain from u2 to u5 follows
 *    Case 8:  u2 revokes SELECT from u3, and the grants below u3 go too
 *    Case 9:  u2 grants ALL PRIVILEGES to u3 and SELECT, UPDATE, INSERT, DELETE to u4
 *    Case 10: dba revokes SELECT from u2, and only the SELECT rows of u2 and below go
 *    Case 11: dba revokes ALL PRIVILEGES from u2, and every grant on u1.tbl goes
 *    Case 12: every user grants SELECT to the others, a GRANT of u2 to u5 to the owner fails with an error, and u4 fails to grant INDEX with an error
 *    Case 13: u1 revokes from u2, u3 and u4, and the grants among u2 to u5 stay
 *    Case 14: u1 revokes from u5, and no grant remains
 */

create user u1;
create user u2;
create user u3;
create user u4;
create user u5;

create table u1.tbl (col1 int);


evaluate 'Case 1: dba grants to dba with no effect, and a GRANT to the owner u1 fails with an error';
GRANT SELECT ON u1.TBL TO dba WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

evaluate 'Case 2: a grant chain from u1 to u5, and a repeated GRANT of u2 to itself has no effect';
call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;

call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;

call login('u3','') on class db_user;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;

call login('u4','') on class db_user;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'Case 3: as dba, a GRANT to the owner fails with an error, and REVOKE from u2 removes the whole chain';
call login('dba','') on class db_user;
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

REVOKE SELECT ON u1.TBL FROM u2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;



evaluate 'Case 4: a GRANT to the owner fails with an error, and u1 grants to u2 and u3 and builds a chain again';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;

call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

call login('u3','') on class db_user;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;

call login('u4','') on class db_user;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'Case 5: u1 revokes from u2, the grant of u2 to u3 goes, and u3 keeps its grant from u1 and its grants below';
call login('u1','') on class db_user;
REVOKE SELECT ON u1.TBL FROM u2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'Case 6: u1 revokes from u3, and no grant remains';
REVOKE SELECT ON u1.TBL FROM u3;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

call login('dba','') on class db_user;



evaluate 'Case 7: u1 grants ALL PRIVILEGES to u2, and a SELECT chain from u2 to u5 follows';
call login('u1','') on class db_user;
GRANT ALL PRIVILEGES ON u1.TBL TO u2 WITH GRANT OPTION;

call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

call login('u3','') on class db_user;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;

call login('u4','') on class db_user;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, auth_type, grantee_name;


evaluate 'Case 8: u2 revokes SELECT from u3, and the grants below u3 go too';
call login('u2','') on class db_user;
REVOKE SELECT ON u1.TBL FROM u3;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC'  order by grantor_name, auth_type, grantee_name;


evaluate 'Case 9: u2 grants ALL PRIVILEGES to u3 and SELECT, UPDATE, INSERT, DELETE to u4';
call login('u2','') on class db_user;
GRANT ALL PRIVILEGES ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT, UPDATE, INSERT, DELETE ON u1.TBL TO u4 WITH GRANT OPTION;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, auth_type, grantee_name;


evaluate 'Case 10: dba revokes SELECT from u2, and only the SELECT rows of u2 and below go';
call login('dba','') on class db_user;
REVOKE SELECT ON u1.TBL FROM u2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC'  order by grantor_name, auth_type, grantee_name;

evaluate 'Case 11: dba revokes ALL PRIVILEGES from u2, and every grant on u1.tbl goes';
REVOKE ALL PRIVILEGES ON u1.TBL FROM u2;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC'  order by grantor_name, auth_type, grantee_name;



evaluate 'Case 12: every user grants SELECT to the others, a GRANT of u2 to u5 to the owner fails with an error, and u4 fails to grant INDEX with an error';
call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u3','') on class db_user;
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u4','') on class db_user;
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;

GRANT INDEX ON u1.TBL TO u5 WITH GRANT OPTION;


call login('u5','') on class db_user;
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;



evaluate 'Case 13: u1 revokes from u2, u3 and u4, and the grants among u2 to u5 stay';
call login('u1','') on class db_user;
REVOKE SELECT ON u1.TBL FROM u2;
REVOKE SELECT ON u1.TBL FROM u3;
REVOKE SELECT ON u1.TBL FROM u4;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'Case 14: u1 revokes from u5, and no grant remains';
REVOKE SELECT ON u1.TBL FROM u5;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


call login('dba','') on class db_user;
drop table u1.tbl;
drop user u5;
drop user u4;
drop user u3;
drop user u2;
drop user u1;
