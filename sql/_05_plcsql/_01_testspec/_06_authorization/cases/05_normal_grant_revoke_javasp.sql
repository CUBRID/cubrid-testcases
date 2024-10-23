--+ server-message on
-- verified the CBRD-25506

-- GRANT test
CREATE FUNCTION test1() RETURN int as
language java name 'SpTest3.typetestint0() return int';

-- bug, If use the command a 'show grant' on the not DBA user group, that return a error
CREATE USER t1 GROUPS dba;
GRANT EXECUTE ON PROCEDURE test1 TO t1;

CREATE FUNCTION t1.test2() RETURN int as
language java name 'SpTest3.typetestint0() return int';
GRANT EXECUTE ON PROCEDURE t1.test2 TO dba;

SELECT * FROM db_auth WHERE grantee_name = 'T1';
SHOW GRANTS FOR T1;

-- DBA needs not permission
SHOW GRANTS FOR DBA;

call login('t1','') on class db_user;

-- in t1
SELECT * FROM db_auth WHERE grantee_name = 'T1';
SHOW GRANTS;

drop function test2;


call login('dba','') on class db_user;

-- REVOKE test
REVOKE EXECUTE ON PROCEDURE test1 FROM t1;
SHOW GRANTS FOR T1;

drop user t1;
drop function test1;

--+ server-message off
