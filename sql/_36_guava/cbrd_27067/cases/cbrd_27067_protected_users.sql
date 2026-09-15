/**
 * This test case verifies CBRD-27067: DBA, INFORMATION_SCHEMA and the
 * currently active user itself can never have their login capability
 * changed, in either direction, even by a DBA-group member, while
 * PUBLIC is explicitly exempt and its grants keep working once NOLOGIN.
 *
 * Coverage:
 * 1-2 ALTER USER dba NOLOGIN/LOGIN both denied, incl. the no-op direction
 * 3   a DBA-group member cannot target itself
 * 4   INFORMATION_SCHEMA denied both directions; is_loginable stays NO
 * 5   ALTER USER public NOLOGIN is allowed, PUBLIC is not protected
 * 6   a grant to PUBLIC still resolves while PUBLIC itself is NOLOGIN
 */

DROP TABLE IF EXISTS tbl_pub1;
DROP TABLE IF EXISTS tbl_pub2;
CREATE USER user_u1 PASSWORD 'p1';
CREATE USER group_dbamem PASSWORD 'pd' GROUPS dba;

--+ server-message on

evaluate 'Case 1: ALTER USER dba NOLOGIN is denied';
ALTER USER dba NOLOGIN;

evaluate 'Case 2: ALTER USER dba LOGIN is denied the same way, even though dba is already loginable';
ALTER USER dba LOGIN;

evaluate 'Case 3: a DBA-group member cannot target itself, even with DBA-group permission';
CALL login('group_dbamem', 'pd') ON CLASS db_user;
ALTER USER group_dbamem NOLOGIN;
ALTER USER group_dbamem LOGIN;
CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 4: INFORMATION_SCHEMA is denied in both directions and stays NO';
ALTER USER information_schema LOGIN;
ALTER USER information_schema NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'INFORMATION_SCHEMA';

evaluate 'Case 5: ALTER USER public NOLOGIN is allowed -- PUBLIC is not protected';
ALTER USER public NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'PUBLIC';

evaluate 'Case 6: a grant to PUBLIC still resolves for another user while PUBLIC is NOLOGIN, old and newly added alike';
CREATE TABLE tbl_pub1 (col1 INT);
INSERT INTO tbl_pub1 VALUES (1);
GRANT SELECT ON tbl_pub1 TO PUBLIC;
CREATE TABLE tbl_pub2 (col1 INT);
INSERT INTO tbl_pub2 VALUES (2);
GRANT SELECT ON tbl_pub2 TO PUBLIC;
CALL login('user_u1', 'p1') ON CLASS db_user;
SELECT col1 FROM dba.tbl_pub1;
SELECT col1 FROM dba.tbl_pub2;
CALL login('dba', '') ON CLASS db_user;

--+ server-message off

ALTER USER public LOGIN;
DROP TABLE IF EXISTS tbl_pub1;
DROP TABLE IF EXISTS tbl_pub2;
DROP USER user_u1;
DROP USER group_dbamem;
