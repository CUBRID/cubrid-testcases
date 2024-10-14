--+ server-message on
-- verified the CBRD-25506


create user u1 groups dba;
create user u2 groups dba;

-- 1. Comparison to table and sp grant/revoke
evaluate('Comparison to table and sp grant/revoke');
CREATE TABLE u1.tbl1 (a INT);

GRANT EXECUTE ON u1.tbl1 TO u2;
REVOKE EXECUTE ON u1.tbl1 FROM u2;

CREATE OR REPLACE FUNCTION u1.test1() return varchar as
begin
    return 'hello';
end;

GRANT EXECUTE ON PROCEDURE u1.test1 TO u2;
REVOKE EXECUTE ON PROCEDURE u1.test1 FROM u2;


-- in public
evaluate('in public');
call login('public','') on class db_user;

-- ERROR: EXECUTE authorization failure
GRANT EXECUTE ON u1.tbl1 TO u2;
REVOKE EXECUTE ON u1.tbl1 FROM u2;
GRANT EXECUTE ON PROCEDURE u1.test1 TO u2;
REVOKE EXECUTE ON PROCEDURE u1.test1 FROM u2;


-- in u2
evaluate('in u2');
call login('u2','') on class db_user;

-- ERROR: Cannot issue GRANT/REVOKE to owner of a class
GRANT EXECUTE ON u1.tbl1 TO u1;

-- Execute OK. but no operate because u2 does not have permission on tb1
GRANT EXECUTE ON u1.tbl1 TO u2;
-- Return empty
SHOW GRANTS FOR u2;
-- ERROR: Cannot revoke privileges from self
REVOKE EXECUTE ON u1.tbl1 FROM u2;

-- Execute OK. but no operate because u2 does not have permission on test1
GRANT EXECUTE ON PROCEDURE u1.test1 TO u2;
-- Return empty
SHOW GRANTS FOR u2;
-- ERROR: Cannot revoke privileges from self
REVOKE EXECUTE ON PROCEDURE u1.test1 FROM u2;


-- init
evaluate('in dba');
call login('dba','') on class db_user;
drop table u1.tbl1;
drop FUNCTION u1.test1;
drop user u1;
drop user u2;



--+ server-message off
