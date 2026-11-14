/**
 *  This test case verifies the grantor_name column of db_auth.
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  db_auth shows DBA as the grantor of the grants that dba made, the two grants on test_class included
 */
--+ holdcas on;

call login('dba') on class db_user;
drop class if exists test_class;
create class test_class(col1 integer, col2 varchar(10));
create user test_user;
create user test_user1;
grant select on test_class to test_user;
grant alter on test_class to test_user1;

evaluate 'Case 1: db_auth shows DBA as the grantor of the grants that dba made, the two grants on test_class included';
select grantor_name, grantee_name, object_name from db_auth
where  grantor_name ='DBA' and object_name is not null and grantee_name is not null order by 1,2,3;

drop user test_user1;
drop user test_user;
drop class test_class;

--+ holdcas off;
