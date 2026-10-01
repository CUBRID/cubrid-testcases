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
 * 1-2   plain user changing another user's or their own login capability
 *       is denied
 * 3     a plain user combining an allowed PASSWORD change with a denied
 *       NOLOGIN-on-self in one statement rolls back the whole statement
 * 4     a plain user changing their own PASSWORD/COMMENT is still allowed
 * 5     a DBA-group member changing another user's login capability is
 *       allowed
 * 6-8   NOLOGIN blocks a CALL-login switch before the password is
 *       checked, contrasted with a real password error, then LOGIN
 *       restores it
 * 9-11  DBA is denied in both directions, even from a DBA-group member,
 *       and a DBA-group member is denied only when it targets itself, not
 *       when dba or another member does
 * 12    INFORMATION_SCHEMA denied both directions, stays NO
 * 13-14 PUBLIC is not protected; a grant made to it before it is switched
 *       to NOLOGIN keeps resolving afterward, same as one added after
 * 15    a grant made to a NOLOGIN group is still inherited by a
 *       loginable member of that group
 * 16    connecting as PUBLIC itself follows the same flag
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

evaluate 'Case 3: a plain user combining an allowed PASSWORD change with a denied NOLOGIN-on-self in one statement rolls back the whole statement, including the password';
ALTER USER user_u1 PASSWORD 'p1new' NOLOGIN;
CALL login('user_u2', 'p2') ON CLASS db_user;
CALL login('user_u1', 'p1new') ON CLASS db_user;
CALL login('user_u1', 'p1') ON CLASS db_user;

evaluate 'Case 4: a plain user changing their own PASSWORD/COMMENT is still allowed';
ALTER USER user_u1 PASSWORD 'p1' COMMENT 'self comment';
SELECT name, comment FROM db_user WHERE name = 'USER_U1';

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 5: a DBA-group member changing another user login capability is allowed';
CALL login('group_dbamem', 'pd') ON CLASS db_user;
ALTER USER user_u2 NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'USER_U2';
ALTER USER user_u2 LOGIN;

CALL login('dba', '') ON CLASS db_user;

-- 로그인 차단
evaluate 'Case 6: NOLOGIN blocks a CALL login switch, checked before the password';
CREATE USER user_nologin PASSWORD 'pw' NOLOGIN;
CREATE USER user_login PASSWORD 'pw' LOGIN;
CALL login('user_nologin', 'pw') ON CLASS db_user;

evaluate 'Case 7: a wrong password gives the same rejection for a NOLOGIN user, but the real password error for a LOGIN-capable one, checked as a non-DBA caller so the password is actually verified';
CALL login('user_u1', 'p1') ON CLASS db_user;
CALL login('user_nologin', 'wrongpw') ON CLASS db_user;
CALL login('user_login', 'wrongpw') ON CLASS db_user;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 8: LOGIN restores connects with the original password, checked as a non-DBA caller';
ALTER USER user_nologin LOGIN;
CALL login('user_u1', 'p1') ON CLASS db_user;
CALL login('user_nologin', 'pw') ON CLASS db_user;
SELECT current_user FROM db_root;

CALL login('dba', '') ON CLASS db_user;

-- 변경할 수 없는 사용자
evaluate 'Case 9: DBA is denied in both directions, even when the caller is a DBA-group member rather than DBA itself';
CALL login('group_dbamem', 'pd') ON CLASS db_user;
ALTER USER dba NOLOGIN;
ALTER USER dba LOGIN;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 10: a DBA-group member cannot target itself, even with DBA-group permission';
CALL login('group_dbamem', 'pd') ON CLASS db_user;
ALTER USER group_dbamem NOLOGIN;
ALTER USER group_dbamem LOGIN;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 11: dba can change another DBA-group member''s login capability, and so can a second DBA-group member -- only self-targeting is denied';
CREATE USER group_dbamem2 PASSWORD 'pd2' GROUPS dba;
ALTER USER group_dbamem NOLOGIN;
CALL login('group_dbamem', 'pd') ON CLASS db_user;
CALL login('group_dbamem2', 'pd2') ON CLASS db_user;
ALTER USER group_dbamem LOGIN;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 12: INFORMATION_SCHEMA is denied in both directions and stays NO';
ALTER USER information_schema LOGIN;
ALTER USER information_schema NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'INFORMATION_SCHEMA';

evaluate 'Case 13: ALTER USER public NOLOGIN is allowed, PUBLIC is not protected, and a grant made to it before the switch keeps resolving for another user afterward';
CREATE TABLE pt1 (a INT);
INSERT INTO pt1 VALUES (1);
GRANT SELECT ON pt1 TO PUBLIC;
ALTER USER public NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'PUBLIC';
CALL login('user_u1', 'p1') ON CLASS db_user;
SELECT a FROM dba.pt1;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 14: a grant newly added to PUBLIC while it is already NOLOGIN also resolves for another user';
CREATE TABLE pt2 (a INT);
INSERT INTO pt2 VALUES (2);
GRANT SELECT ON pt2 TO PUBLIC;
CALL login('user_u1', 'p1') ON CLASS db_user;
SELECT a FROM dba.pt2;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 15: a grant made to a NOLOGIN group is still inherited by a loginable member of that group';
CREATE USER role_ro PASSWORD 'pr' NOLOGIN;
CREATE USER user_u3 PASSWORD 'p3' GROUPS role_ro;
CREATE TABLE pt3 (a INT);
INSERT INTO pt3 VALUES (3);
GRANT SELECT ON pt3 TO role_ro;
CALL login('user_u3', 'p3') ON CLASS db_user;
SELECT a FROM dba.pt3;

CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 16: connecting as PUBLIC itself fails while NOLOGIN, succeeds once restored to LOGIN';
CALL login('public', '') ON CLASS db_user;
ALTER USER public LOGIN;
CALL login('public', '') ON CLASS db_user;
SELECT current_user FROM db_root;

CALL login('dba', '') ON CLASS db_user;
ALTER USER public LOGIN;

--+ server-message off

DROP TABLE pt1;
DROP TABLE pt2;
DROP TABLE pt3;
DROP USER user_u1;
DROP USER user_u2;
DROP USER user_u3;
DROP USER group_dbamem;
DROP USER group_dbamem2;
DROP USER role_ro;
DROP USER user_nologin;
DROP USER user_login;

--+ holdcas off;
