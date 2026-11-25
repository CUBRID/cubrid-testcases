/**
 *  This test case verifies CBRD-25627: changing the owner of an object updates db_auth. The
 *  new owner becomes the grantor of the grants that stay, and a grant to the new owner itself
 *  is removed.
 *
 *  This file changes the owner of a view to the user who holds SELECT on it.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants SELECT on u1.tbl to u2 and on u1.v1_tbl to u3, and u2 grants SELECT on u1.tbl to u3
 *    Case 2:  u3 can select from u1.v1_tbl
 *    Case 3:  after ALTER VIEW OWNER TO u3, u3 owns the view, the grant of the view to u3 is gone, and the grants on u1.tbl stay
 */


create user u1;
create user u2;
create user u3;

create table u1.tbl (col1 int);
create view u1.v1_tbl as select * from u1.tbl;

evaluate 'Case 1: u1 grants SELECT on u1.tbl to u2 and on u1.v1_tbl to u3, and u2 grants SELECT on u1.tbl to u3';
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.v1_tbl TO u3 WITH GRANT OPTION;

call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl TO u3 WITH GRANT OPTION;


call login(class db_user,'dba','');
select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'Case 2: u3 can select from u1.v1_tbl';
call login('u3','') on class db_user;
select * from u1.v1_tbl;


evaluate 'Case 3: after ALTER VIEW OWNER TO u3, u3 owns the view, the grant of the view to u3 is gone, and the grants on u1.tbl stay';
call login('dba','') on class db_user;
ALTER VIEW u1.v1_tbl OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select class_name, owner_name from db_class where class_name = 'v1_tbl' order by class_name;

show create view u3.v1_tbl;


drop table u1.tbl;
drop view u3.v1_tbl;
drop user u1;
drop user u2;
drop user u3;
