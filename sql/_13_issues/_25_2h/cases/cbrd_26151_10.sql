/**
 * This test case verifies CBRD-26151: db_auth catalog view should only show
 * authorizations where the logged-in user is the grantor or grantee.
 *
 * Scenario 10 (SERIAL / SERVER / SYNONYM): these object types are not
 * independently grantable, so they must never appear in db_auth.
 *   - GRANT ON SERIAL  : syntax error (not supported)
 *   - GRANT ON SERVER  : syntax error (not supported)
 *   - GRANT ON SYNONYM : accepted but redirected to the underlying table,
 *                        recorded as a CLASS authorization (the synonym name
 *                        never appears in db_auth)
 * db_auth must contain no SERIAL/SERVER/SYNONYM object_type rows.
 */

--+ server-message on

create user u1;
create user u2;

call login('u1','') on class db_user;
create table base_tbl (col1 int);
create serial s1 start with 1 increment by 1;
create synonym syn1 for u1.base_tbl;
create server srv1 (host='localhost', port=1523, dbname=demodb, user='dba');

evaluate('10-1. GRANT on SERIAL is not supported (syntax error expected)');
GRANT SELECT ON SERIAL u1.s1 TO u2;

evaluate('10-2. GRANT on SERVER is not supported (syntax error expected)');
GRANT SELECT ON SERVER u1.srv1 TO u2;

evaluate('10-3. GRANT on SYNONYM is redirected to the target table (recorded as CLASS)');
GRANT SELECT ON u1.syn1 TO u2;

evaluate('10-4. login as u2: only the redirected CLASS grant on base_tbl is visible; no SERIAL/SERVER/SYNONYM rows');
call login('u2','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

evaluate('10-5. login as dba: db_auth contains no SERIAL/SERVER/SYNONYM object_type');
call login('dba','') on class db_user;
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where object_type in ('SERIAL', 'SERVER', 'SYNONYM');

evaluate('10-6. login as dba: only the synonym-redirected CLASS grant exists for u2');
select grantor_name, grantee_name, object_type, object_name, owner_name, auth_type, is_grantable from db_auth where grantee_name != 'PUBLIC' order by grantor_name, grantee_name, auth_type;

drop synonym u1.syn1;
drop server u1.srv1;
drop serial u1.s1;
drop table u1.base_tbl;
drop user u1;
drop user u2;

--+ server-message off
