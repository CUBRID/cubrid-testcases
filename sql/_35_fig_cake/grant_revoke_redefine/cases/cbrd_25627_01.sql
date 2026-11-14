/**
 *  This test case verifies CBRD-25627: changing the owner of an object updates db_auth. The
 *  new owner becomes the grantor of the grants that stay, and a grant to the new owner itself
 *  is removed.
 *
 *  This file changes the owner of a table.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants SELECT on u1.tbl to u2, and u2 grants it to u3
 *    Case 2:  after ALTER TABLE OWNER TO u3, u3 is the owner and the grantor to u2, and the grant to u3 is gone
 */


create user u1;
create user u2;
create user u3;

create table u1.tbl (col1 int);

evaluate 'Case 1: u1 grants SELECT on u1.tbl to u2, and u2 grants it to u3';
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;

call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;


select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'Case 2: after ALTER TABLE OWNER TO u3, u3 is the owner and the grantor to u2, and the grant to u3 is gone';
call login('dba','') on class db_user;
ALTER TABLE u1.tbl OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select class_name, owner_name from db_class where class_name = 'tbl' order by class_name;

drop table u3.tbl;
drop user u1;
drop user u2;
drop user u3;
