/**
 * This test case verifies CBRD-27067: LOGIN/NOLOGIN are added as
 * non-reserved keywords, so every existing use of the two words as an
 * identifier, and the pre-existing login() method, keep working.
 *
 * Coverage:
 * 1 - login/nologin as a table name, column name, alias, serial name
 *     and index name
 * 2 - a user actually named login can still have its own login clause
 *     changed without the name colliding with the keyword
 * 3 - the pre-existing login() method on class db_user is unaffected
 */

--+ holdcas on;

DROP TABLE IF EXISTS login;
DROP SERIAL IF EXISTS nologin;

evaluate 'Case 1: login/nologin as table/column/alias/serial/index names';
CREATE TABLE login (login INT, nologin VARCHAR(10));
INSERT INTO login VALUES (1, 'x');
SELECT login AS nologin FROM login login;
CREATE SERIAL nologin START WITH 1;
SELECT nologin.next_value FROM db_root;
CREATE INDEX login ON login(login);

evaluate 'Case 2: a user named login can have its own login clause changed';
CREATE USER login PASSWORD 'plog';
ALTER USER login NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'LOGIN';
ALTER USER login LOGIN;

evaluate 'Case 3: the pre-existing login() method on class db_user is unaffected';
CALL login('dba', '') ON CLASS db_user;
SELECT current_user FROM db_root;

DROP TABLE IF EXISTS login;
DROP SERIAL IF EXISTS nologin;
DROP USER login;

--+ holdcas off;
