/*
    1. Check the SEQUENCE value in the db_authorization catalog when execute GRANT/REVOKE
*/
CREATE USER U1;
CREATE USER U2;
CREATE USER U3;

CREATE TABLE u1.tbl1 (col1 int);
CREATE TABLE u1.tbl2 (col1 int);

evaluate('connect to u1 & GRANT SELECT ON u1.tbl1 TO U2 WITH GRANT OPTION, GRANT INSERT ON u1.tbl1 TO U3 WITH GRANT OPTION');
call login('u1','') on class db_user;
GRANT SELECT ON u1.tbl1 TO U2 WITH GRANT OPTION;
GRANT INSERT ON u1.tbl1 TO U3 WITH GRANT OPTION;

evaluate('connect to u2 & GRANT SELECT ON u1.tbl1 TO u3 WITH GRANT OPTION');
call login('u2','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u3 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name, grants;


evaluate('connect to u3 & GRANT SELECT ON u1.tbl1 TO u2');
call login('u3','') on class db_user;
GRANT SELECT ON u1.tbl1 TO u2;

evaluate('ERROR: SELECT authorization failure');
GRANT SELECT ON u1.tbl2 TO u2;

evaluate('ERROR: UPDATE authorization failure');
GRANT UPDATE ON u1.tbl1 TO u2;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name, grants;


evaluate('ERROR: ERROR: UPDATE authorization failure');
REVOKE UPDATE ON u1.tbl1 FROM u2;

evaluate('ERROR: SELECT authorization failure');
REVOKE SELECT ON u1.tbl2 FROM u2;

evaluate('REVOKE SELECT ON u1.tbl1 FROM u2');
REVOKE SELECT ON u1.tbl1 FROM u2;


evaluate('connect to dba');
call login('dba','') on class db_user;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;
select owner.name, grants from db_authorization where owner.name != 'PUBLIC' order by owner.name, grants;


evaluate('Test done & init');
drop table u1.tbl2;
drop table u1.tbl1;
drop user u1;
drop user u2;
drop user u3;