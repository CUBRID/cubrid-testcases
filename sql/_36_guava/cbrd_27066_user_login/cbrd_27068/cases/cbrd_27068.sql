/**
 * This test case verifies CBRD-27068: a non-loginable user - including
 * PUBLIC switched to an internal, unused account, the concrete case the
 * decision names - is not hidden from catalog views, only distinguished
 * by is_loginable, per the decision to keep every DBMS-compared behavior
 * (option A, status quo).
 *
 * Coverage:
 * 1 - a NOLOGIN user and a NOLOGIN PUBLIC both still appear in db_user,
 *     distinguished only by is_loginable
 * 2 - the DBA sees the same thing through _db_user directly
 * 3 - a NOLOGIN user and PUBLIC still appear in db_authorization, same as
 *     a loginable one - every user gets one row regardless of ownership
 * 4 - information_schema.schemata still lists the schema of the NOLOGIN
 *     user, PUBLIC, and a loginable user alike
 */

/* defensive reset: if a previous run aborted before its own cleanup ran,
   this leaves PUBLIC stuck NOLOGIN for every later test sharing this DB */
ALTER USER public LOGIN;

CREATE USER user_cat1 PASSWORD 'p1' NOLOGIN;
CREATE USER user_cat2 PASSWORD 'p2';
ALTER USER public NOLOGIN;

evaluate 'Case 1: a NOLOGIN user and a NOLOGIN PUBLIC both still appear in db_user, distinguished only by is_loginable';
SELECT name, is_loginable FROM db_user WHERE name IN ('USER_CAT1', 'USER_CAT2', 'PUBLIC') ORDER BY name;

evaluate 'Case 2: the DBA sees the same thing through _db_user directly';
SELECT name, is_loginable FROM _db_user WHERE name IN ('USER_CAT1', 'USER_CAT2', 'PUBLIC') ORDER BY name;

evaluate 'Case 3: a NOLOGIN user and PUBLIC still appear in db_authorization, same as a loginable one';
SELECT owner FROM db_authorization WHERE owner IN ('USER_CAT1', 'USER_CAT2', 'PUBLIC') ORDER BY owner;

evaluate 'Case 4: information_schema.schemata still lists the schema of the NOLOGIN user, PUBLIC, and a loginable user alike';
SELECT schema_name FROM information_schema.schemata WHERE schema_name IN ('USER_CAT1', 'USER_CAT2', 'PUBLIC') ORDER BY schema_name;

ALTER USER public LOGIN;
DROP USER user_cat1;
DROP USER user_cat2;
