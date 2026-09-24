/**
 * This test case verifies CBRD-27067: CREATE/ALTER USER LOGIN | NOLOGIN
 * syntax, catalog exposure via db_user.is_loginable, and clause ordering.
 *
 * Coverage:
 * 1    CREATE USER with no clause defaults to loginable
 * 2    CREATE USER ... LOGIN / NOLOGIN
 * 3    ALTER USER NOLOGIN/LOGIN
 * 4    re-applying the same state (no-op)
 * 5    ALTER USER with no clause at all (unrelated pre-existing error)
 * 6-7  CREATE/ALTER combined with PASSWORD, GROUPS/MEMBERS or COMMENT,
 *      each landing on the right clause, new password taking effect
 * 8    NOLOGIN written as two words is a syntax error
 * 9    LOGIN/NOLOGIN has no slot on ALTER USER ... ADD MEMBERS, only on
 *      the plain ALTER USER form
 */

--+ holdcas on;

evaluate 'Case 1: CREATE USER with no login clause defaults to loginable';
CREATE USER usr1 PASSWORD 'pw';
SELECT name, is_loginable FROM db_user WHERE name = 'USR1';

evaluate 'Case 2: CREATE USER ... LOGIN / NOLOGIN';
CREATE USER usr2 PASSWORD 'pw' LOGIN;
CREATE USER usr3 PASSWORD 'pw' NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name IN ('USR2', 'USR3') ORDER BY name;

evaluate 'Case 3: ALTER USER ... NOLOGIN then LOGIN';
CREATE USER usr4 PASSWORD 'pw';
ALTER USER usr4 NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'USR4';
ALTER USER usr4 LOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'USR4';

evaluate 'Case 4: re-applying the same login state, either direction, is a no-op';
ALTER USER usr4 NOLOGIN;
ALTER USER usr4 NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'USR4';
ALTER USER usr4 LOGIN;
ALTER USER usr4 LOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'USR4';

evaluate 'Case 5: ALTER USER with no clause at all is unrelated pre-existing error';
ALTER USER usr4;

evaluate 'Case 6: CREATE USER combined clauses, PASSWORD then NOLOGIN then GROUPS/MEMBERS then COMMENT, each landing on the right clause';
CREATE USER usr6;
CREATE USER usr7;
CREATE USER usr5 PASSWORD 'pw5' NOLOGIN GROUPS usr6 MEMBERS usr7 COMMENT 'c5';
SELECT name, is_loginable, comment, groups FROM db_user WHERE name = 'USR5';
SELECT groups FROM db_user WHERE name = 'USR7';

evaluate 'Case 7: ALTER USER combined clauses, PASSWORD then NOLOGIN then COMMENT, the new password actually takes effect';
CREATE USER usr8 PASSWORD 'pw8';
ALTER USER usr8 PASSWORD 'newpw8' NOLOGIN COMMENT 'c7';
SELECT name, is_loginable, comment FROM db_user WHERE name = 'USR8';
ALTER USER usr8 LOGIN;
CALL login('usr4', 'pw') ON CLASS db_user;
CALL login('usr8', 'wrongpw') ON CLASS db_user;
CALL login('usr8', 'newpw8') ON CLASS db_user;
SELECT current_user FROM db_root;
CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 8: NOLOGIN written as two words is a syntax error';
ALTER USER usr4 NO LOGIN;

evaluate 'Case 9: LOGIN/NOLOGIN has no slot on ALTER USER ... ADD MEMBERS';
CREATE USER usr9;
CREATE USER usr10;
ALTER USER usr9 ADD MEMBERS usr10 NOLOGIN;

DROP USER usr1;
DROP USER usr2;
DROP USER usr3;
DROP USER usr4;
DROP USER usr5;
DROP USER usr6;
DROP USER usr7;
DROP USER usr8;
DROP USER usr9;
DROP USER usr10;

--+ holdcas off;
