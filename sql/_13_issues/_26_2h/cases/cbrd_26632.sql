/**
 * This test case verifies CBRD-26632: calling login() while a transaction
 * is still open (not committed/rolled back) must not lead to a core dump.
 *
 * Fix: when call login() is invoked, any transaction that is still open
 * is forced to roll back *before* the login switch is processed.
 *
 * Coverage:
 * 1. login() to an uncommitted user rolls back the CREATE USER and fails gracefully.
 * 2. Failed login() (Case 1) does not change the session's current user.
 * 3. login() into an already-committed user succeeds normally.
 * 4. Pending DDL (CREATE TABLE) is force-rolled-back by login().
 * 5. Pending DML (INSERT) is force-rolled-back by login().
 * 6. Mixed pending statements (DDL + DML) are rolled back together.
 * 7. login() to a non-existent user still triggers the rollback of pending work.
 * 8. Self-login (target == current user) triggers the rollback.
 * 9. Pending DROP USER is rolled back, restoring the user.
 * 10. Sequential login() calls independently roll back only their immediate pending work.
 * 11. Control: with auto-commit enabled, login() executes normally.
 * 12. Pending privilege changes (GRANT) are force-rolled-back.
 * 13. Pending REVOKE is force-rolled-back (privilege preserved).
 * 14. State Preservation: login() does not alter the session commit mode.
 */

DROP TABLE IF EXISTS tbl1;
DROP TABLE IF EXISTS tbl2;

CREATE TABLE tbl1(col1 int);

autocommit off;

evaluate 'Case 1. login() into a not-yet-committed user forces a rollback of the pending CREATE USER, so login fails and no core dump occurs afterward';
CREATE USER user1;
CALL login('user1') ON CLASS db_user;
-- Expected: ERROR - user1 no longer exists (forced rollback ran first)

SHOW TABLES;
-- Expected: succeeds immediately after failed login(); no core dump

ROLLBACK;

SELECT name FROM db_user WHERE name = 'USER1';
-- Expected: 0 rows selected


evaluate 'Case 2. A failed login() does not drop existing session privileges';
CREATE USER canary_user;
COMMIT;
SELECT name FROM db_user WHERE name = 'CANARY_USER';
-- Expected: 1 row (Proves DBA is still active)

DROP USER canary_user;
COMMIT;


evaluate 'Case 3. login() to a committed user succeeds';
CREATE USER user2;
COMMIT;

GRANT SELECT, INSERT ON dba.tbl1 TO USER2;
COMMIT;

CALL login('user2') ON CLASS db_user;
SELECT COUNT(*) FROM dba.tbl1;
-- Expected: Succeeds
-- Cases 4-14 reuse user2 created and granted in Case 3.


evaluate 'Case 4. Pending DDL (CREATE TABLE) is force-rolled-back by login()';
CALL login('dba') ON CLASS db_user;
CREATE TABLE tbl2(col1 int);
CALL login('user2') ON CLASS db_user;
-- Expected: succeeds; pending CREATE TABLE above is force-rolled-back

CALL login('dba') ON CLASS db_user;
SELECT * FROM tbl2;
-- Expected: ERROR - tbl2 does not exist (rolled back)


evaluate 'Case 5. Pending DML (INSERT) is force-rolled-back by login()';
CALL login('dba') ON CLASS db_user;
INSERT INTO tbl1 VALUES (1);
CALL login('user2') ON CLASS db_user;
-- Expected: succeeds; pending INSERT above is force-rolled-back
SELECT COUNT(*) FROM dba.tbl1;
-- Expected: COUNT(*) = 0

evaluate 'Case 6. Mixed pending statements (DDL + DML) are rolled back together';
CALL login('dba') ON CLASS db_user;
CREATE USER user3;
INSERT INTO tbl1 VALUES (2);
INSERT INTO tbl1 VALUES (3);
CALL login('user2') ON CLASS db_user;
-- Expected: succeeds; all three pending statements above are force-rolled-back together
SELECT COUNT(*) FROM dba.tbl1;
-- Expected: COUNT(*) = 0
CALL login('dba') ON CLASS db_user;
SELECT name FROM db_user WHERE name = 'USER3';
-- Expected: 0 rows selected


evaluate 'Case 7. login() to a non-existent user still triggers the rollback';
INSERT INTO tbl1 VALUES (99);
CALL login('ghost_user') ON CLASS db_user;
-- Expected: ERROR - user 'ghost_user' does not exist
SELECT COUNT(*) FROM tbl1;
-- Expected: COUNT(*) = 0


evaluate 'Case 8. Self-login triggers the rollback';
CALL login('dba') ON CLASS db_user;
INSERT INTO tbl1 VALUES (100);
CALL login('dba') ON CLASS db_user;
-- Expected: succeeds; pending INSERT above is force-rolled-back even
-- though the target is the already-active user
SELECT COUNT(*) FROM tbl1;
-- Expected: COUNT(*) = 0


evaluate 'Case 9. Pending DROP USER is rolled back (user restored)';
CREATE USER user6;
COMMIT;
DROP USER user6;
CALL login('user2') ON CLASS db_user;
-- Expected: succeeds; pending DROP USER above is force-rolled-back

CALL login('dba') ON CLASS db_user;
SELECT name FROM db_user WHERE name = 'USER6';
-- Expected: 1 row selected (user6 was restored)

DROP USER user6;
COMMIT;


evaluate 'Case 10. Sequential login() calls independently roll back current pending work';
CREATE USER user7;
CALL login('user2') ON CLASS db_user;
-- Expected: succeeds; pending user7 above is force-rolled-back

INSERT INTO dba.tbl1 VALUES (200);
CALL login('dba') ON CLASS db_user;
-- Expected: succeeds; pending INSERT above is force-rolled-back by this second, independent call

SELECT name FROM db_user WHERE name = 'USER7';
-- Expected: 0 rows selected

SELECT COUNT(*) FROM tbl1;
-- Expected: COUNT(*) = 0


autocommit on;
evaluate 'Case 11. Control: with auto-commit enabled, login() executes normally';

CREATE USER user8;
CALL login('user2') ON CLASS db_user;
-- Expected: succeeds; user8 was already committed by autocommit, so it must still exist afterward

CALL login('dba') ON CLASS db_user;
SELECT name FROM db_user WHERE name = 'USER8';
-- Expected: 1 row selected

DROP USER user8;
autocommit off;


evaluate 'Case 12. Pending privilege changes (GRANT) are force-rolled-back';
CREATE USER user9;
COMMIT;

GRANT SELECT ON dba.tbl1 TO user9;
CALL login('user2') ON CLASS db_user;
-- Expected: succeeds; pending GRANT above is force-rolled-back

CALL login('user9') ON CLASS db_user;
SELECT * FROM dba.tbl1;
-- Expected: ERROR - user9 has no SELECT privilege on tbl1

CALL login('dba') ON CLASS db_user;
DROP USER user9;
COMMIT;


evaluate 'Case 13. Pending REVOKE is force-rolled-back (privilege preserved)';
CREATE USER user9;
COMMIT;

GRANT SELECT ON dba.tbl1 TO user9;
COMMIT;

REVOKE SELECT ON dba.tbl1 FROM user9;
CALL login('user2') ON CLASS db_user;
-- Expected: succeeds; pending REVOKE above is force-rolled-back

CALL login('user9') ON CLASS db_user;
SELECT COUNT(*) FROM dba.tbl1;
-- Expected: Succeeds (user9 still has SELECT privilege because REVOKE was rolled back)

CALL login('dba') ON CLASS db_user;
DROP USER user9;
COMMIT;


evaluate 'Case 14. State Preservation: login() does not alter the session commit mode';
CALL login('user2') ON CLASS db_user;
INSERT INTO dba.tbl1 VALUES (300);
SELECT COUNT(*) FROM dba.tbl1;
-- Expected: COUNT(*) = 0 before the rollback check
ROLLBACK;
SELECT COUNT(*) FROM dba.tbl1;
-- Expected: COUNT(*) = 0 same before rollback

CALL login('dba') ON CLASS db_user;


-- Cleanup
autocommit on;
DROP TABLE IF EXISTS tbl1;
DROP TABLE IF EXISTS tbl2;
DROP USER user2;
