/**
 * This test case verifies CBRD-27068: a non-loginable user is not hidden
 * from catalog views -- it is only distinguished by is_loginable, per the
 * decision to keep every DBMS-compared behavior (option A, status quo).
 *
 * Coverage:
 * 1 - a NOLOGIN user still appears in db_user, distinguished only by
 *     is_loginable
 * 2 - the DBA can see it the same way through _db_user directly
 * 3 - a NOLOGIN user that owns a class still appears in db_authorization
 * 4 - information_schema.schemata still lists the NOLOGIN user's schema
 */

CREATE USER user_cat1 PASSWORD 'p1' NOLOGIN;
CREATE USER user_cat2 PASSWORD 'p2';
CREATE TABLE user_cat1.tbl_cat (col1 INT);

evaluate 'Case 1: a NOLOGIN user still appears in db_user, distinguished only by is_loginable';
SELECT name, is_loginable FROM db_user WHERE name IN ('USER_CAT1', 'USER_CAT2') ORDER BY name;

evaluate 'Case 2: the DBA sees the same thing through _db_user directly';
SELECT name, is_loginable FROM _db_user WHERE name IN ('USER_CAT1', 'USER_CAT2') ORDER BY name;

evaluate 'Case 3: a NOLOGIN user that owns a class still appears in db_authorization';
SELECT owner FROM db_authorization WHERE owner = 'USER_CAT1';

evaluate 'Case 4: information_schema.schemata still lists the NOLOGIN user schema';
SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'USER_CAT1';

DROP TABLE user_cat1.tbl_cat;
DROP USER user_cat1;
DROP USER user_cat2;
