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
 * 4 - a user actually named nologin: identifier and keyword are the
 *     identical token in the same statement
 * 5 - GROUPS/MEMBERS targets named login/nologin combine with the new
 *     clause on the same CREATE USER statement
 * 6 - login/nologin as a view name and a synonym name
 */

--+ holdcas on;

DROP TABLE IF EXISTS login;
DROP VIEW IF EXISTS login;
DROP SYNONYM IF EXISTS nologin;
DROP SERIAL IF EXISTS nologin;

evaluate 'Case 1: login/nologin as table/column/alias/serial/index names';
CREATE TABLE login (login INT, nologin VARCHAR(10));
INSERT INTO login VALUES (1, 'x');
SELECT login AS nologin FROM login login;
CREATE SERIAL nologin START WITH 1;
SELECT nologin.next_value FROM db_root;
CREATE INDEX login ON login(login);
DROP TABLE login;

evaluate 'Case 2: a user named login can have its own login clause changed';
CREATE USER login PASSWORD 'plog';
ALTER USER login NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'LOGIN';
ALTER USER login LOGIN;

evaluate 'Case 3: the pre-existing login() method on class db_user is unaffected';
CALL login('dba', '') ON CLASS db_user;
SELECT current_user FROM db_root;

evaluate 'Case 4: a user named nologin -- identifier and keyword are the identical token in the same statement';
CREATE USER nologin PASSWORD 'pnolog';
ALTER USER nologin NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'NOLOGIN';
ALTER USER nologin LOGIN;

evaluate 'Case 5: GROUPS/MEMBERS targets named login/nologin combine with the new NOLOGIN clause';
CREATE USER usr_gm NOLOGIN GROUPS login MEMBERS nologin;
SELECT name, is_loginable, groups FROM db_user WHERE name = 'USR_GM';
SELECT groups FROM db_user WHERE name = 'NOLOGIN';

evaluate 'Case 6: login/nologin as a view name and a synonym name';
CREATE VIEW login AS SELECT 1 AS c1 FROM db_root;
SELECT c1 FROM login;
CREATE SYNONYM nologin FOR db_root;
SELECT 1 FROM nologin;

DROP VIEW login;
DROP SYNONYM nologin;
DROP SERIAL nologin;
DROP USER login;
DROP USER nologin;
DROP USER usr_gm;

--+ holdcas off;
