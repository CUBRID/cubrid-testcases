/**
 * This test case verifies CBRD-27067: changing login capability needs
 * the DBA/DBA-group permission ALTER USER's other clauses already use,
 * NOLOGIN blocks a CALL-login switch before the password is checked, and
 * DBA, INFORMATION_SCHEMA and the caller itself can never be targeted,
 * even by a DBA-group member, while PUBLIC is exempt and its grants keep
 * working. CALL login() switches the session's active user, checked by
 * the issue the same way as a real reconnection.
 *
 * Coverage:
 * 1-4   plain user vs DBA-group member changing login capability
 * 5-7   NOLOGIN blocks a CALL-login switch before the password is
 *       checked, contrasted with a real password error, then LOGIN
 *       restores it
 * 8-9   DBA and a DBA-group member's own login capability can never be
 *       changed, even by itself
 * 10    INFORMATION_SCHEMA denied both directions, stays NO
 * 11-13 PUBLIC is not protected, its grants keep resolving while it is
 *       NOLOGIN, and connecting as PUBLIC itself follows the same flag
 */

--+ holdcas on;

CALL login('dba', '') ON CLASS db_user;
CREATE USER user_u1 PASSWORD 'p1';
CREATE USER user_u2 PASSWORD 'p2';
CREATE USER group_dbamem PASSWORD 'pd' GROUPS dba;

--+ server-message on

-- 변경 권한
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

-- 로그인 차단
evaluate 'Case 5: NOLOGIN blocks a CALL login switch, checked before the password';
CREATE USER user_nologin PASSWORD 'pw' NOLOGIN;
CREATE USER user_login PASSWORD 'pw' LOGIN;
CALL login('user_nologin', 'pw') ON CLASS db_user;

evaluate 'Case 6: a wrong password gives the same rejection for a NOLOGIN user, but the real password error for a LOGIN-capable one, checked as a non-DBA caller so the password is actually verified';
CALL login('user_u1', 'p1') ON CLASS db_user;
CALL login('user_nologin', 'wrongpw') ON CLASS db_user;
CALL login('user_login', 'wrongpw') ON CLASS db_user;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 7: LOGIN restores connects with the original password, checked as a non-DBA caller';
ALTER USER user_nologin LOGIN;
CALL login('user_u1', 'p1') ON CLASS db_user;
CALL login('user_nologin', 'pw') ON CLASS db_user;
SELECT current_user FROM db_root;

CALL login('dba', '') ON CLASS db_user;

-- 변경할 수 없는 사용자
evaluate 'Case 8: ALTER USER dba NOLOGIN is denied, and so is the no-op LOGIN direction';
ALTER USER dba NOLOGIN;
ALTER USER dba LOGIN;

evaluate 'Case 9: a DBA-group member cannot target itself, even with DBA-group permission';
CALL login('group_dbamem', 'pd') ON CLASS db_user;
ALTER USER group_dbamem NOLOGIN;
ALTER USER group_dbamem LOGIN;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 10: INFORMATION_SCHEMA is denied in both directions and stays NO';
ALTER USER information_schema LOGIN;
ALTER USER information_schema NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'INFORMATION_SCHEMA';

evaluate 'Case 11: ALTER USER public NOLOGIN is allowed, PUBLIC is not protected';
ALTER USER public NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'PUBLIC';

evaluate 'Case 12: a grant to PUBLIC, old or newly added, still resolves for another user while PUBLIC itself is NOLOGIN';
CREATE TABLE pt1 (a INT);
INSERT INTO pt1 VALUES (1);
GRANT SELECT ON pt1 TO PUBLIC;
CALL login('user_u1', 'p1') ON CLASS db_user;
SELECT a FROM dba.pt1;

CALL login('dba', '') ON CLASS db_user;
CREATE TABLE pt2 (a INT);
INSERT INTO pt2 VALUES (2);
GRANT SELECT ON pt2 TO PUBLIC;
CALL login('user_u1', 'p1') ON CLASS db_user;
SELECT a FROM dba.pt2;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 13: connecting as PUBLIC itself fails while NOLOGIN, succeeds once restored to LOGIN';
CALL login('public', '') ON CLASS db_user;
ALTER USER public LOGIN;
CALL login('public', '') ON CLASS db_user;
SELECT current_user FROM db_root;

CALL login('dba', '') ON CLASS db_user;

--+ server-message off

DROP TABLE pt1;
DROP TABLE pt2;
DROP USER user_u1;
DROP USER user_u2;
DROP USER group_dbamem;
DROP USER user_nologin;
DROP USER user_login;

--+ holdcas off;
