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
GRANT SELECT ON tbl to user_insert;
GRANT SELECT ON tbl to user_update;
GRANT SELECT ON tbl to user_delete;
GRANT SELECT ON tbl to user_alter;
GRANT SELECT ON tbl to user_index;
GRANT SELECT ON tbl to user_execute;
GRANT SELECT ON tbl to user_all_privileges;

SELECT COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP USER user_select;
DROP USER user_insert;
DROP USER user_update;
DROP USER user_delete;
DROP USER user_alter;
DROP USER user_index;
DROP USER user_execute;
DROP USER user_all_privileges;

SELECT COUNT(*) FROM _db_auth WHERE grantee IS NULL;

DROP TABLE tbl;