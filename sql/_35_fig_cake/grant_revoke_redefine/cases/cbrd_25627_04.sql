/**
 *  This test case verifies CBRD-25627: changing the owner of an object updates db_auth. The
 *  new owner becomes the grantor of the grants that stay, and a grant to the new owner itself
 *  is removed.
 *
 *  This file changes the owner of tables on which other users hold the ALTER privilege.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants ALTER on u1.tbl and u1.tbl2 to u2, and u2 grants ALTER on u1.tbl2 to u3
 *    Case 2:  u3 fails to change the owners with an error, only dba or the dba group can
 *    Case 3:  u2 fails to change the owners with an error, although it holds ALTER
 *    Case 4:  after dba changes both owners to u3, u3 is the grantor to u2 and the grant to u3 is gone
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
select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;


evaluate 'Case 2: u3 fails to change the owners with an error, only dba or the dba group can';
call login('u3','') on class db_user;
ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;

evaluate 'Case 3: u2 fails to change the owners with an error, although it holds ALTER';
call login('u2','') on class db_user;
ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;


evaluate 'Case 4: after dba changes both owners to u3, u3 is the grantor to u2 and the grant to u3 is gone';
call login('dba','') on class db_user;

ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;

select class_name, owner_name from db_class where class_name in ('tbl', 'tbl2') order by class_name;

drop table u3.tbl;
drop table u3.tbl2;
drop user u1;
drop user u2;
drop user u3;
