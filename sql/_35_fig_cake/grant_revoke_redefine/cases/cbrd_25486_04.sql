/**
 *  This test case verifies CBRD-25486: dropping an object that is granted to other users
 *  removes its rows from db_auth and its entries from the grants of db_authorization.
 *
 *  Scenario 04 drops tables as users that hold the ALTER privilege on them.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants ALTER on u1.tbl and u1.tbl2 to u2, and u2 grants ALTER on u1.tbl2 to u3
 *    Case 2:  u3, which has no ALTER on u1.tbl, fails to drop it with an error
 *    Case 3:  u2 drops u1.tbl, and its grant rows and its class row are gone
 *    Case 4:  u3 drops u1.tbl2, and its grant rows and its class row are gone
 */

create user u1;
create user u2;
create user u3;

create table u1.tbl (col1 int);
create table u1.tbl2 (col1 int);

evaluate 'Case 1: u1 grants ALTER on u1.tbl and u1.tbl2 to u2, and u2 grants ALTER on u1.tbl2 to u3';
call login('u1','') on class db_user;
GRANT ALTER ON u1.tbl TO u2;
GRANT ALTER ON u1.tbl2 TO u2 WITH GRANT OPTION;

call login('u2','') on class db_user;
GRANT ALTER ON u1.tbl2 TO u3 WITH GRANT OPTION;

call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 2: u3, which has no ALTER on u1.tbl, fails to drop it with an error';
call login('u3','') on class db_user;
DROP TABLE u1.tbl;

evaluate 'Case 3: u2 drops u1.tbl, and its grant rows and its class row are gone';
call login('u2','') on class db_user;
DROP TABLE u1.tbl;

call login('dba','') on class db_user;


select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name = 'tbl';


evaluate 'Case 4: u3 drops u1.tbl2, and its grant rows and its class row are gone';
call login('u3','') on class db_user;
DROP TABLE u1.tbl2;


call login('dba','') on class db_user;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name = 'tbl2';


drop user u1;
drop user u2;
drop user u3;
