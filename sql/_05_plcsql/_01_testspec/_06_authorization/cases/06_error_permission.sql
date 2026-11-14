/**
 *  This test case verifies CBRD-25506: errors of GRANT and REVOKE of EXECUTE on stored procedures
 *
 *  It compares GRANT and REVOKE of EXECUTE on a table with the same on a stored function,
 *  as dba, as public, as a member of dba that is not the owner, and as the owner.
 *  u1 owns tbl1 and test1, and u2 is a member of the dba group.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Case 3: the GRANT of u2 to itself succeeds and grants nothing, see CBRD-25585
 *
 *  Coverage:
 *    Case 1:  dba grants and revokes EXECUTE on the table u1.tbl1 and on the function u1.test1 to u2, and db_auth shows the grant and then no row
 *    Case 2:  as public, GRANT and REVOKE of EXECUTE on u1.tbl1 and u1.test1 fail with authorization errors
 *    Case 3:  as u2, a member of dba, a GRANT to the owner u1 fails, a GRANT to u2 itself succeeds with no grant in SHOW GRANTS, and a REVOKE from itself fails
 *    Case 4:  as u1, SHOW GRANTS FOR u1 lists no grant
 *    Case 5:  GRANT EXECUTE ON FUNCTION fails with a syntax error
 *    Case 6:  GRANT without PROCEDURE, GRANT ALL PRIVILEGES ON PROCEDURE and the name test1 without its owner u1 fail
 *    Case 7:  GRANT and REVOKE EXECUTE ON PROCEDURE in mixed letter case succeed
 */

--+ server-message on

create user u1;
create user u2 groups dba;

evaluate 'Case 1: dba grants and revokes EXECUTE on the table u1.tbl1 and on the function u1.test1 to u2, and db_auth shows the grant and then no row';
CREATE TABLE u1.tbl1 (a INT);

GRANT EXECUTE ON u1.tbl1 TO u2;
SELECT grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable FROM db_auth WHERE grantee_name = 'U2' ORDER BY object_name;
REVOKE EXECUTE ON u1.tbl1 FROM u2;
SELECT grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable FROM db_auth WHERE grantee_name = 'U2' ORDER BY object_name;

CREATE OR REPLACE FUNCTION u1.test1() return varchar as
begin
    return 'hello';
end;

GRANT EXECUTE ON PROCEDURE u1.test1 TO u2;
SELECT grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable FROM db_auth WHERE grantee_name = 'U2' ORDER BY object_name;
REVOKE EXECUTE ON PROCEDURE u1.test1 FROM u2;
SELECT grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable FROM db_auth WHERE grantee_name = 'U2' ORDER BY object_name;


evaluate 'Case 2: as public, GRANT and REVOKE of EXECUTE on u1.tbl1 and u1.test1 fail with authorization errors';
call login('public','') on class db_user;

GRANT EXECUTE ON u1.tbl1 TO u2;
REVOKE EXECUTE ON u1.tbl1 FROM u2;
GRANT EXECUTE ON PROCEDURE u1.test1 TO u2;
REVOKE EXECUTE ON PROCEDURE u1.test1 FROM u2;


evaluate 'Case 3: as u2, a member of dba, a GRANT to the owner u1 fails, a GRANT to u2 itself succeeds with no grant in SHOW GRANTS, and a REVOKE from itself fails';
call login('u2','') on class db_user;

GRANT EXECUTE ON u1.tbl1 TO u1;

GRANT EXECUTE ON u1.tbl1 TO u2;
SHOW GRANTS FOR u2;
REVOKE EXECUTE ON u1.tbl1 FROM u2;

GRANT EXECUTE ON PROCEDURE u1.test1 TO u2;
SHOW GRANTS FOR u2;
REVOKE EXECUTE ON PROCEDURE u1.test1 FROM u2;


evaluate 'Case 4: as u1, SHOW GRANTS FOR u1 lists no grant';
call login('u1','') on class db_user;

SHOW GRANTS FOR u1;


-- back to dba
call login('dba','') on class db_user;

evaluate 'Case 5: GRANT EXECUTE ON FUNCTION fails with a syntax error';
GRANT EXECUTE ON FUNCTION u1.test1 to u2;

evaluate 'Case 6: GRANT without PROCEDURE, GRANT ALL PRIVILEGES ON PROCEDURE and the name test1 without its owner u1 fail';
GRANT EXECUTE ON u1.test1 to u2;
GRANT ALL PRIVILEGES ON PROCEDURE u1.test1 to u2;
GRANT EXECUTE ON PROCEDURE test1 to u2;

evaluate 'Case 7: GRANT and REVOKE EXECUTE ON PROCEDURE in mixed letter case succeed';
GraNT eXecUTE oN ProceDure u1.test1 to u2;
reVOkE ExeCutE On pROceDure u1.test1 from u2;


drop table u1.tbl1;
drop function u1.test1;
drop user u1;
drop user u2;


--+ server-message off
