/**
 * This test case verifies CBRD-27067: changing login capability needs
 * the DBA/DBA-group permission ALTER USER's other clauses already use,
 * NOLOGIN blocks a CALL-login switch before the password is checked, and
 * DBA, INFORMATION_SCHEMA and the caller itself can never be targeted,
 * even by a DBA-group member. CALL login() switches the session's active
 * user, checked by the issue the same way as a real reconnection.
 *
 * Coverage:
 * 1   a plain user changing another user's login capability is denied
 * 2   a plain user changing their own is denied the same way
 * 3   a plain user changing their own PASSWORD/COMMENT is still allowed
 * 4   a DBA-group member changing another user's login capability works
 * 5   NOLOGIN blocks a CALL-login switch before the password is checked
 * 6-7 DBA cannot be targeted either direction, a DBA-group member cannot
 *     target itself
 * 8   INFORMATION_SCHEMA denied both directions, stays NO
 */

--+ holdcas on;

CALL login('dba', '') ON CLASS db_user;
CREATE USER user_u1 PASSWORD 'p1';
CREATE USER user_u2 PASSWORD 'p2';
CREATE USER group_dbamem PASSWORD 'pd' GROUPS dba;

--+ server-message on

evaluate 'Case 1: a plain user changing another user login capability is denied';
CALL login('user_u1', 'p1') ON CLASS db_user;
ALTER USER user_u2 NOLOGIN;

evaluate 'Case 2: a plain user changing their own login capability is denied the same way';
ALTER USER user_u1 NOLOGIN;

evaluate 'Case 3: a plain user changing their own PASSWORD/COMMENT is still allowed';
ALTER USER user_u1 PASSWORD 'p1' COMMENT 'self comment';
SELECT name, comment FROM db_user WHERE name = 'USER_U1';

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 4: a DBA-group member changing another user login capability is allowed';
CALL login('group_dbamem', 'pd') ON CLASS db_user;
ALTER USER user_u2 NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'USER_U2';
ALTER USER user_u2 LOGIN;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 5: NOLOGIN blocks a CALL login switch, checked before the password -- the wrong password gives the same error, not a password error';
CREATE USER user_nl PASSWORD 'pw' NOLOGIN;
CALL login('user_nl', 'pw') ON CLASS db_user;
CALL login('user_nl', 'wrongpw') ON CLASS db_user;
DROP USER user_nl;

evaluate 'Case 6: ALTER USER dba NOLOGIN is denied';
ALTER USER dba NOLOGIN;

evaluate 'Case 7: ALTER USER dba LOGIN is denied the same way, even though dba is already loginable, and a DBA-group member cannot target itself either';
ALTER USER dba LOGIN;
CALL login('group_dbamem', 'pd') ON CLASS db_user;
ALTER USER group_dbamem NOLOGIN;
ALTER USER group_dbamem LOGIN;
CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 8: INFORMATION_SCHEMA is denied in both directions and stays NO';
ALTER USER information_schema LOGIN;
ALTER USER information_schema NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'INFORMATION_SCHEMA';

--+ server-message off

DROP USER user_u1;
DROP USER user_u2;
DROP USER group_dbamem;

--+ holdcas off;
