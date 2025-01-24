/* Verfified the CBRD-25627
As-is: if changed the owner of objects then it is not updated on db_auth
To-be: If changed the owner of objects then revoke all grantors
*/



create user u1;
create user u2;
create user u3;

evaluate 'case 4: changed owner for table (with grant alter privilege)';

evaluate 'create u1.tbl, u1.tbl2 table';
create table u1.tbl (col1 int);
create table u1.tbl2 (col1 int);

evaluate 'connect to u1 & u1.tbl, u1.tbl2 grant alter to u2';
call login('u1','') on class db_user;
GRANT ALTER ON u1.tbl TO u2;
GRANT ALTER ON u1.tbl2 TO u2 WITH GRANT OPTION;

evaluate 'connect to u2 & u1.tbl2 grant alter to u3';
call login('u2','') on class db_user;
GRANT ALTER ON u1.tbl2 TO u3 WITH GRANT OPTION;

evaluate 'connect to dba';
call login('dba','') on class db_user;
select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_name;


evaluate 'connect to u3 & changed owner u1.tbl, u1.tbl2 -> u3.tbl, u3.tbl2, ERROR: can only be performed by the DBA or a DBA group member';
call login('u3','') on class db_user;
ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;

evaluate 'connect to u2 & changed owner u1.tbl, u1.tbl2 -> u3.tbl, u3.tbl2, ERROR: can only be performed by the DBA or a DBA group member';
call login('u2','') on class db_user;
ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;


evaluate 'connect to dba & changed owner u1.tbl, u1.tbl2 -> u3.tbl, u3.tbl2';
call login('dba','') on class db_user;

ALTER TABLE u1.tbl OWNER TO u3;
ALTER TABLE u1.tbl2 OWNER TO u3;

select grantor_name, grantee_name, owner_name, object_type, object_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, object_type;

select class_name, owner_name from db_class where class_name in ('tbl', 'tbl2') order by class_name;

evaluate 'Test init';
drop table u3.tbl;
drop table u3.tbl2;
drop user u1;
drop user u2;
drop user u3;
