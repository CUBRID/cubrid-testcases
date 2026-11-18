/**
 *  This test case verifies CBRD-25486: dropping an object that is granted to other users
 *  removes its rows from db_auth and its entries from the grants of db_authorization, and
 *  leaves the grants on other objects as they were.
 *
 *  Scenario 02 drops a view that u1 granted to u3, while u3 also holds SELECT on the base
 *  table through u2.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  u1 grants SELECT on u1.tbl to u2 and on u1.v1_tbl to u3, u2 grants SELECT on u1.tbl to u3
 *    Case 2:  u3 can select from u1.v1_tbl
 *    Case 3:  after DROP VIEW u1.v1_tbl, its grant rows and its class row are gone and the grants on u1.tbl stay
 *    Case 4:  SHOW CREATE VIEW of the dropped view fails with an error
 */

create user u1;
create user u2;
create user u3;

create table u1.tbl (col1 int);
create view u1.v1_tbl as select * from u1.tbl;

evaluate 'Case 1: u1 grants SELECT on u1.tbl to u2 and on u1.v1_tbl to u3, u2 grants SELECT on u1.tbl to u3';
call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.v1_tbl TO u3 WITH GRANT OPTION;

call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

call login(class db_user,'dba','');
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;


evaluate 'Case 2: u3 can select from u1.v1_tbl';
call login('u3','') on class db_user;
select col1 from u1.v1_tbl;

evaluate 'Case 3: after DROP VIEW u1.v1_tbl, its grant rows and its class row are gone and the grants on u1.tbl stay';
call login('dba','') on class db_user;
DROP VIEW u1.v1_tbl;

select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;
select owner, grants from db_authorization where owner != 'PUBLIC' order by owner;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name ='v1_tbl' order by class_name;
evaluate 'Case 4: SHOW CREATE VIEW of the dropped view fails with an error';
show create view u1.v1_tbl;

drop table u1.tbl;
drop user u1;
drop user u2;
drop user u3;
