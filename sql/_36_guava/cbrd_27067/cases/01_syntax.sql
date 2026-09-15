/**
 * This test case verifies CBRD-27067: CREATE/ALTER USER LOGIN | NOLOGIN
 * syntax, catalog exposure via db_user.is_loginable, and clause ordering.
 *
 * Coverage:
 * 1    CREATE USER with no clause defaults to loginable
 * 2-3  CREATE USER ... LOGIN / NOLOGIN
 * 4-5  ALTER USER ... LOGIN / NOLOGIN, and re-applying the same state (no-op)
 * 6    ALTER USER with no clause at all (unrelated pre-existing error)
 * 7-8  combined with other clauses: CREATE (PASSWORD, then GROUPS/MEMBERS,
 *      then COMMENT) and ALTER (PASSWORD, then COMMENT), password itself
 *      unaffected
 * 9    NOLOGIN written as two words is a syntax error
 */

evaluate 'Case 1: CREATE USER with no login clause defaults to loginable';
CREATE USER user_a1 PASSWORD 'pw';
SELECT name, is_loginable FROM db_user WHERE name = 'USER_A1';

evaluate 'Case 2-3: CREATE USER ... LOGIN / NOLOGIN';
CREATE USER user_a2y PASSWORD 'pw' LOGIN;
CREATE USER user_a2n PASSWORD 'pw' NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name IN ('USER_A2Y', 'USER_A2N') ORDER BY name;

evaluate 'Case 4: ALTER USER ... NOLOGIN then LOGIN';
CREATE USER user_u1 PASSWORD 'pw';
ALTER USER user_u1 NOLOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'USER_U1';
ALTER USER user_u1 LOGIN;
SELECT name, is_loginable FROM db_user WHERE name = 'USER_U1';

evaluate 'Case 5: re-applying the same login state is a no-op success';
ALTER USER user_u1 LOGIN;
ALTER USER user_u1 LOGIN;

evaluate 'Case 6: ALTER USER with no clause at all is unrelated pre-existing error';
ALTER USER user_u1;

evaluate 'Case 7: CREATE USER combined clauses -- PASSWORD, then NOLOGIN, then GROUPS/MEMBERS, then COMMENT';
CREATE USER group_g1;
CREATE USER member_m1;
CREATE USER user_a6 PASSWORD 'pw6' NOLOGIN GROUPS group_g1 MEMBERS member_m1 COMMENT 'c6';
SELECT name, is_loginable, comment FROM db_user WHERE name = 'USER_A6';

evaluate 'Case 8: ALTER USER combined clauses, PASSWORD then NOLOGIN then COMMENT, password itself unaffected';
CREATE USER user_u2 PASSWORD 'pw2';
ALTER USER user_u2 PASSWORD 'newpw2' NOLOGIN COMMENT 'c8';
SELECT name, is_loginable, comment FROM db_user WHERE name = 'USER_U2';
ALTER USER user_u2 LOGIN;
CALL login('user_u2', 'newpw2') ON CLASS db_user;
SELECT current_user FROM db_root;
CALL login('dba', '') ON CLASS db_user;

evaluate 'Case 9: NOLOGIN written as two words is a syntax error';
ALTER USER user_u1 NO LOGIN;

DROP USER user_a1;
DROP USER user_a2y;
DROP USER user_a2n;
DROP USER user_a6;
DROP USER group_g1;
DROP USER member_m1;
DROP USER user_u1;
DROP USER user_u2;
