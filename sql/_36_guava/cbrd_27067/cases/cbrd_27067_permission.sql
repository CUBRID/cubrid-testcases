/**
 * This test case verifies CBRD-27067: changing login capability requires
 * the DBA/DBA-group permission already used by ALTER USER's other clauses.
 * CALL login() on class db_user switches the session's active user, which
 * is checked the same way as a real reconnection (see the issue's own
 * "session user switch (CALL login)" note).
 *
 * Coverage:
 * 1 - a plain user changing another user's login capability is denied
 * 2 - a plain user changing their own login capability is denied the
 *     same way (login is the only clause this restricts)
 * 3 - a plain user changing their own PASSWORD/COMMENT is still allowed
 * 4 - a DBA-group member changing another user's login capability
 *     is allowed
 */

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

--+ server-message off

DROP USER user_u1;
DROP USER user_u2;
DROP USER group_dbamem;
