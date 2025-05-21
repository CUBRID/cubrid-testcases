--+ server-message on
-- verified the CBRD-24912
-- Support grant/revoke authorization for stored procedures( error case )

evaluate '0. create procedure & user';
CREATE OR REPLACE FUNCTION sp1() return varchar as begin return 'hello'; end;
CREATE OR REPLACE PROCEDURE sp2() as begin dbms_output.put_line('call sp2'); end;
CREATE USER u1;

evaluate '1. error - Granting unavailable permissions.';
--function
GRANT select ON PROCEDURE sp1 TO u1;
GRANT insert ON PROCEDURE sp1 TO u1;
GRANT update ON PROCEDURE sp1 TO u1;
GRANT delete ON PROCEDURE sp1 TO u1;
GRANT create ON PROCEDURE sp1 TO u1;
GRANT alter  ON PROCEDURE sp1 TO u1;
GRANT index  ON PROCEDURE sp1 TO u1;
GRANT drop   ON PROCEDURE sp1 TO u1;
GRANT ALL PRIVILEGES ON PROCEDURE sp1 TO u1;
GRANT EXECUTE, select ON PROCEDURE sp1 TO u1;
GRANT EXECUTE, drop   ON PROCEDURE sp1 TO u1;

--procedure
GRANT select ON PROCEDURE sp2 TO u1;
GRANT insert ON PROCEDURE sp2 TO u1;
GRANT update ON PROCEDURE sp2 TO u1;
GRANT delete ON PROCEDURE sp2 TO u1;
GRANT create ON PROCEDURE sp2 TO u1;
GRANT alter  ON PROCEDURE sp2 TO u1;
GRANT index  ON PROCEDURE sp2 TO u1;
GRANT drop   ON PROCEDURE sp2 TO u1;
GRANT ALL PRIVILEGES ON PROCEDURE sp2 TO u1;
GRANT EXECUTE, select ON PROCEDURE sp2 TO u1;
GRANT EXECUTE, drop   ON PROCEDURE sp2 TO u1;



evaluate '2. error - Granting permissions to non-existent users.';
GRANT EXECUTE ON PROCEDURE sp1 TO t2;
GRANT EXECUTE ON PROCEDURE sp2 TO t2;


evaluate '3. error - unavailable permissions and non-existent users.';
GRANT SELECT ON PROCEDURE sp1 TO t2;
GRANT SELECT ON PROCEDURE sp2 TO t2;


evaluate '4. error - Grant processing for non-existent procedures.';
GRANT SELECT ON PROCEDURE xxx_sp1 TO u1;
GRANT SELECT ON PROCEDURE xxx_sp2 TO u1;
GRANT EXECUTE ON PROCEDURE xxx_sp1 TO u1;


evaluate '5. error - Typo(grants, revokes, AS, FOR )';
GRANTS  EXECUTE ON PROCEDURE sp1 TO u1;
REVOKES EXECUTE ON PROCEDURE sp1 TO u1;

GRANT  EXECUTE FOR PROCEDURE sp1 TO u1;
REVOKE EXECUTE FOR PROCEDURE sp1 TO u1;

GRANT  EXECUTE AS PROCEDURE sp1 TO u1;
REVOKE EXECUTE AS PROCEDURE sp1 TO u1;

GRANT  EXECUTE ON PROCEDURE sp1 AS u1;
REVOKE EXECUTE ON PROCEDURE sp1 AS u1;

GRANT  EXECUTE ON PROCEDURE sp1 FOR u1;
REVOKE EXECUTE ON PROCEDURE sp1 FOR u1;


evaluate '6. Run GRANT twice.( Not error )';
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth where grantee.name = 'U1';
GRANT EXECUTE ON PROCEDURE sp1 TO u1;
GRANT EXECUTE ON PROCEDURE sp1 TO u1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth where grantee.name = 'U1';
GRANT EXECUTE ON PROCEDURE sp2 TO u1;
GRANT EXECUTE ON PROCEDURE sp2 TO u1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth where grantee.name = 'U1';

evaluate '7. error - Run REVOKE twice.';
REVOKE EXECUTE ON PROCEDURE sp1 FROM u1;
REVOKE EXECUTE ON PROCEDURE sp1 FROM u1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth where grantee.name = 'U1';
REVOKE EXECUTE ON PROCEDURE sp2 FROM u1;
REVOKE EXECUTE ON PROCEDURE sp2 FROM u1;
SELECT grantor.name, grantee.name, object_type, object_of, auth_type, is_grantable FROM _db_auth where grantee.name = 'U1';

drop FUNCTION sp1;
drop PROCEDURE sp2;
drop user u1;

--+ server-message off
