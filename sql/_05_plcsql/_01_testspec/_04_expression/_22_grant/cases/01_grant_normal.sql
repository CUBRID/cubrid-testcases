--+ server-message on
-- verified the CBRD-25499, CBRD-25506

-- GRANT test
CREATE OR REPLACE FUNCTION sp1() return varchar as
begin
    return 'hello';
end;
CREATE USER t1 GROUPS dba;
GRANT EXECUTE ON PROCEDURE sp1 TO t1;

CREATE OR REPLACE FUNCTION t1.sp2() return varchar as
begin
    return 't1 hello';
end;
GRANT EXECUTE ON PROCEDURE t1.sp2 TO dba;

SELECT * FROM db_auth WHERE grantee_name = 'T1';
SHOW GRANTS FOR T1;

-- DBA needs not permission
SHOW GRANTS FOR DBA;

call login('t1','') on class db_user;

-- in t1
SELECT * FROM db_auth WHERE grantee_name = 'T1';
SHOW GRANTS;

drop function sp2;


call login('dba','') on class db_user;

-- REVOKE test (verify with CBRD-25506)
REVOKE EXECUTE ON PROCEDURE sp1 FROM t1;
SHOW GRANTS FOR T1;

drop user t1;
drop function sp1;

--+ server-message off
