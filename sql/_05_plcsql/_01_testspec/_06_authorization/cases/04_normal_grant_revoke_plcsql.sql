--+ server-message on
-- verified the CBRD-25499


-- GRANT test
CREATE OR REPLACE FUNCTION sp1() return varchar as
begin
    return 'hello';
end;

CREATE USER t1 GROUPS dba;
GRANT EXECUTE ON PROCEDURE sp1 TO t1;

-- test with table&view
create table test1 (col1 int);
insert into test1 values(0),(2);
create view view1 as select * from test1;
GRANT ALL PRIVILEGES ON test1 TO t1;
GRANT ALL PRIVILEGES ON view1 TO t1;

SELECT * FROM db_auth WHERE grantee_name = 'T1' ORDER BY object_name, auth_type;
SHOW GRANTS FOR T1;

call login('t1','') on class db_user;

-- in t1
SELECT * FROM db_auth WHERE grantee_name = 'T1' ORDER BY object_name, auth_type;
SHOW GRANTS;

CREATE OR REPLACE FUNCTION t1.sp2() return varchar as
begin
    return 't1 hello';
end;
GRANT EXECUTE ON PROCEDURE t1.sp2 TO dba;


call login('dba','') on class db_user;

SHOW GRANTS FOR DBA;

drop function t1.sp2;


-- drop user when before revoke from t1
drop user t1;

-- REVOKE error (because user t1 is drop)
REVOKE EXECUTE ON PROCEDURE sp1 FROM t1;
SHOW GRANTS FOR T1;

drop function sp1;

drop user t1;
drop test1, view1;

--+ server-message off
