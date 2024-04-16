-- This test case verifies the following issue: CBRD-25290.
-- After giving grants to a user, if that user is deleted, the corresponding grantee in the _db_auth tables remain null.
-- Ensure the core is no longer dumped and the expected query result is returned

CREATE USER user_select;
CREATE USER user_insert;
CREATE USER user_update;
CREATE USER user_delete;
CREATE USER user_alter;
CREATE USER user_index;
CREATE USER user_execute;
CREATE USER user_all_privileges;

DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (a INT);

GRANT SELECT ON tbl to user_select;
GRANT INSERT ON tbl to user_insert;
GRANT UPDATE ON tbl to user_update;
GRANT DELETE ON tbl to user_delete;
GRANT ALTER ON tbl to user_alter;
GRANT INDEX ON tbl to user_index;
GRANT EXECUTE ON tbl to user_execute;
GRANT ALL PRIVILEGES ON tbl to user_all_privileges;

SELECT COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_select;
SELECT 'After deleting user_select', COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_insert;
SELECT 'After deleting user_insert', COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_update;
SELECT 'After deleting user_update', COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_delete;
SELECT 'After deleting user_delete', COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_alter;
SELECT 'After deleting user_alter', COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_index;
SELECT 'After deleting user_index', COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_execute;
SELECT 'After deleting user_execute', COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_all_privileges;
SELECT 'After deleting user_all_privileges', COUNT(*) FROM _db_auth WHERE grantee IS NULL;

SELECT COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP TABLE tbl;