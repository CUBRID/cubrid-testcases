/**
 * This test case verifies CBRD-27067: CREATE/ALTER USER LOGIN | NOLOGIN
 * syntax, catalog exposure via db_user.is_loginable, and clause ordering.
 *
 * Coverage:
 * 1    CREATE USER with no clause defaults to loginable
 * 2-3  CREATE USER ... LOGIN / NOLOGIN
 * 4-5  ALTER USER ... LOGIN / NOLOGIN, and re-applying the same state (no-op)
 * 6    ALTER USER with no clause at all (unrelated pre-existing error)
 * 7    CREATE combined with PASSWORD, then NOLOGIN, then GROUPS/MEMBERS,
 *      then COMMENT, all four landing on the right clause
 * 8    ALTER combined with PASSWORD, then NOLOGIN, then COMMENT, the new
 *      password actually taking effect, checked as a non-DBA caller
 * 9    NOLOGIN written as two words is a syntax error
 */

--+ holdcas on;

evaluate 'Case 1: CREATE USER with no login clause defaults to loginable';
CREATE USER syn_a1 PASSWORD 'pw';
SELECT name, is_loginable FROM db_user WHERE name = 'SYN_A1';

evaluate 'Case 2-3: CREATE USER ... LOGIN / NOLOGIN';
CREATE USER syn_a2y PASSWORD 'pw' LOGIN;
CREATE USER syn_a2n PASSWORD 'pw' NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name IN ('SYN_A2Y', 'SYN_A2N') ORDER BY name;

evaluate 'Case 4: ALTER USER ... NOLOGIN then LOGIN';
CREATE USER syn_u1 PASSWORD 'pw';
ALTER USER syn_u1 NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'SYN_U1';
ALTER USER syn_u1 LOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'SYN_U1';

evaluate 'Case 5: re-applying the same login state is a no-op success';
ALTER USER syn_u1 LOGIN;
ALTER USER syn_u1 LOGIN;

evaluate 'Case 6: ALTER USER with no clause at all is unrelated pre-existing error';
ALTER USER syn_u1;

evaluate 'Case 7: CREATE USER combined clauses, PASSWORD then NOLOGIN then GROUPS/MEMBERS then COMMENT, each landing on the right clause';
CREATE USER syn_g1;
CREATE USER syn_m1;
CREATE USER syn_a6 PASSWORD 'pw6' NOLOGIN GROUPS syn_g1 MEMBERS syn_m1 COMMENT 'c6';
SELECT name, is_loginable, comment, groups FROM db_user WHERE name = 'SYN_A6';
SELECT groups FROM db_user WHERE name = 'SYN_M1';

evaluate 'Case 8: ALTER USER combined clauses, PASSWORD then NOLOGIN then COMMENT, the new password actually takes effect';
CREATE USER syn_u2 PASSWORD 'pw2';
ALTER USER syn_u2 PASSWORD 'newpw2' NOLOGIN COMMENT 'c8';
SELECT name, is_loginable, comment FROM db_user WHERE name = 'SYN_U2';
ALTER USER syn_u2 LOGIN;
CALL login('syn_u1', 'pw') ON CLASS db_user;
CALL login('syn_u2', 'wrongpw') ON CLASS db_user;
CALL login('syn_u2', 'newpw2') ON CLASS db_user;
SELECT current_user FROM db_root;
CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 9: NOLOGIN written as two words is a syntax error';
ALTER USER syn_u1 NO LOGIN;

DROP USER syn_a1;
DROP USER syn_a2y;
DROP USER syn_a2n;
DROP USER syn_a6;
DROP USER syn_g1;
DROP USER syn_m1;
DROP USER syn_u1;
DROP USER syn_u2;

--+ holdcas off;
