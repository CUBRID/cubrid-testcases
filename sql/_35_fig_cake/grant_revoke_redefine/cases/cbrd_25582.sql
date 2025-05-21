-- Verified the CBRD-25582
-- bug fix: do not cascade on revoke

create user u1;
create user u2;
create user u3;
create user u4;
create user u5;

create table u1.tbl (col1 int);


evaluate 'case 1: execute to revoke on dba';
evaluate '(3-3 on CBRD-25580) dba is not target on grant: no operation';
GRANT SELECT ON u1.TBL TO dba WITH GRANT OPTION;

evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

evaluate 'connect to u1, u1.tbl grant to u2';
call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;

evaluate 'connect to u2, u1.tbl grant to u3';
call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

evaluate '(3-2 on CBRD-25580) u2 has a u1.tbl select permission: no operation';
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;

evaluate 'connect to u3, u1.tbl grant to u4';
call login('u3','') on class db_user;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;

evaluate 'connect to u4, u1.tbl grant to u5';
call login('u4','') on class db_user;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to dba';
call login('dba','') on class db_user;
evaluate '(3-1 on CBRD-25580) u1.tbl owner is u1: no operation';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

evaluate 'init test';
REVOKE SELECT ON u1.TBL FROM u2;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;



evaluate 'case 2: execute to revoke on owner';
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;

evaluate 'connect to u1, u1.tbl grant to u2, u3';
call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

evaluate 'connect to u2, u1.tbl grant to u3';
call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

evaluate 'connect to u3, u1.tbl grant to u4';
call login('u3','') on class db_user;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;

evaluate 'connect to u4, u1.tbl grant to u5';
call login('u4','') on class db_user;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'connect to u1, revoke to u1.tbl from u2';
call login('u1','') on class db_user;
REVOKE SELECT ON u1.TBL FROM u2;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'init test, connect to dba';
REVOKE SELECT ON u1.TBL FROM u3;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

call login('dba','') on class db_user;



evaluate 'case 3: execute to revoke on grantable user (u2)';
evaluate 'connect to u1, u1.tbl grant to u2';
call login('u1','') on class db_user;
GRANT ALL PRIVILEGES ON u1.TBL TO u2 WITH GRANT OPTION;

evaluate 'connect to u2, u1.tbl grant to u3';
call login('u2','') on class db_user;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;

evaluate 'connect to u3, u1.tbl grant to u4';
call login('u3','') on class db_user;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;

evaluate 'connect to u4, u1.tbl grant to u5';
call login('u4','') on class db_user;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, auth_type;


evaluate 'connect to u2, revoke to u1.tbl from u3';
call login('u2','') on class db_user;
REVOKE SELECT ON u1.TBL FROM u3;

select * from db_auth where grantee_name != 'PUBLIC'  order by grantor_name, auth_type;


evaluate 'connect to u1, test for cascade';
call login('u2','') on class db_user;
evaluate 'grant all privileges on u1.tbl to u3';
GRANT ALL PRIVILEGES ON u1.TBL TO u3 WITH GRANT OPTION;
evaluate 'grant SELECT, UPDATE, INSERT, DELETE on u1.tbl to u4';
GRANT SELECT, UPDATE, INSERT, DELETE ON u1.TBL TO u4 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, auth_type;


evaluate 'connect to dba, revoke to u1.tbl(SELECT) from u2 (cascade test)';
call login('dba','') on class db_user;
REVOKE SELECT ON u1.TBL FROM u2;

select * from db_auth where grantee_name != 'PUBLIC'  order by grantor_name, auth_type;

evaluate 'init test: revoke to u1.tbl(ALL PRIVILEGES) from u2 (cascade test)';
REVOKE ALL PRIVILEGES ON u1.TBL FROM u2;

select * from db_auth where grantee_name != 'PUBLIC'  order by grantor_name, auth_type;



evaluate 'case 4: grant to all user and execute revoke';
call login('u1','') on class db_user;
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


evaluate 'connect to u2';
call login('u2','') on class db_user;
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


evaluate 'connect to u3';
call login('u3','') on class db_user;
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;


evaluate 'connect to u4';
call login('u4','') on class db_user;
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u5 WITH GRANT OPTION;

evaluate 'ERROR: INDEX authorization failure';
GRANT INDEX ON u1.TBL TO u5 WITH GRANT OPTION;


evaluate 'connect to u5';
call login('u5','') on class db_user;
evaluate 'ERROR: Cannot issue GRANT/REVOKE to owner of a class';
GRANT SELECT ON u1.TBL TO u1 WITH GRANT OPTION;

GRANT SELECT ON u1.TBL TO u2 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u3 WITH GRANT OPTION;
GRANT SELECT ON u1.TBL TO u4 WITH GRANT OPTION;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;



evaluate 'connect to u1 and revoke u2, u3, u4';
call login('u1','') on class db_user;
REVOKE SELECT ON u1.TBL FROM u2;
REVOKE SELECT ON u1.TBL FROM u3;
REVOKE SELECT ON u1.TBL FROM u4;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;

evaluate 'connect to u1 and revoke u5';
REVOKE SELECT ON u1.TBL FROM u5;

select * from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name;


evaluate 'test done';
call login('dba','') on class db_user;
drop table u1.tbl;
drop user u5;
drop user u4;
drop user u3;
drop user u2;
drop user u1;
