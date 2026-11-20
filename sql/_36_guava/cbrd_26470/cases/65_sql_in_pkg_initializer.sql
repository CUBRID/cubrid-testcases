/**
 *  This test case verifies CBRD-26470 (PR #7819): SQL in the initialization block of a package body.
 *
 *  Background:
 *    - Symptom: static SQL, COMMIT and so on in the initialization block gave "Unable to compile
 *      the source". The initialization block becomes a Java static { } block, and sql_rowcount used
 *      by the SQL code was declared only in routine methods.
 *    - Fix: the initialization block template (tmplPkgInit) also declares sql_rowcount.
 *  (Package variables are not implemented yet, so only package routines and local variables of
 *   nested blocks are used.)
 *  Each package is first used through a stored routine w65_N that calls its function f.
 *
 *  Coverage:
 *    Case 1: INSERT in the initializer runs (before the fix a compile error)
 *    Case 2: INSERT and COMMIT run (called with CALL)
 *    Case 3: two rows inserted by EXECUTE IMMEDIATE
 *    Case 4: SQL%ROWCOUNT after UPDATE passed to a body routine
 *    Case 5: INSERT in the exception handler (ZERO_DIVIDE) runs
 *    Case 6: SQL in a package routine called by the initializer runs
 *    Case 7: called twice in a session, initialized once
 *    Case 8: SELECT INTO a local variable of a nested block finds no row
 *            -> "error while initializing the package instance of F: no data found"
 */

--+ server-message on

drop table if exists t65_1, t65_2, t65_3, t65_4, t65_4r, t65_5, t65_6, t65_7, t65_8;
drop package if exists p65_1;
drop package if exists p65_2;
drop package if exists p65_3;
drop package if exists p65_4;
drop package if exists p65_5;
drop package if exists p65_6;
drop package if exists p65_7;
drop package if exists p65_8;

CREATE TABLE t65_1 (a INT);
CREATE TABLE t65_2 (a INT);
CREATE TABLE t65_3 (a INT);
CREATE TABLE t65_4 (a INT);
CREATE TABLE t65_4r (a INT);
CREATE TABLE t65_5 (a INT);
CREATE TABLE t65_6 (a INT);
CREATE TABLE t65_7 (a INT);
CREATE TABLE t65_8 (a INT);
INSERT INTO t65_4 VALUES (1), (2), (3);
CREATE OR REPLACE PACKAGE p65_1 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p65_1 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT COUNT(*) INTO n FROM t65_1; RETURN n; END;
BEGIN
INSERT INTO t65_1 VALUES (1);
END;
CREATE OR REPLACE PACKAGE p65_2 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p65_2 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT COUNT(*) INTO n FROM t65_2; RETURN n; END;
BEGIN
INSERT INTO t65_2 VALUES (2);
COMMIT;
END;
CREATE OR REPLACE PACKAGE p65_3 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p65_3 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT COUNT(*) INTO n FROM t65_3; RETURN n; END;
BEGIN
EXECUTE IMMEDIATE 'insert into t65_3 values (3), (3)';
END;
CREATE OR REPLACE PACKAGE p65_4 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p65_4 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT MAX(a) INTO n FROM t65_4r; RETURN n; END;
PROCEDURE rec (n INT) AS BEGIN INSERT INTO t65_4r VALUES (n); END;
BEGIN
UPDATE t65_4 SET a = a + 1;
rec(SQL%ROWCOUNT);
END;
CREATE OR REPLACE PACKAGE p65_5 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p65_5 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT MAX(a) INTO n FROM t65_5; RETURN n; END;
BEGIN
DECLARE n INT; BEGIN n := 1 / 0; END;
EXCEPTION
WHEN ZERO_DIVIDE THEN INSERT INTO t65_5 VALUES (6);
END;
CREATE OR REPLACE PACKAGE p65_6 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p65_6 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT MAX(a) INTO n FROM t65_6; RETURN n; END;
PROCEDURE init AS BEGIN INSERT INTO t65_6 VALUES (7); END;
BEGIN
init();
END;
CREATE OR REPLACE PACKAGE p65_7 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p65_7 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT COUNT(*) INTO n FROM t65_7; RETURN n; END;
BEGIN
INSERT INTO t65_7 VALUES (1);
END;
CREATE OR REPLACE PACKAGE p65_8 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p65_8 AS
FUNCTION f RETURN INT AS BEGIN RETURN 8; END;
BEGIN
DECLARE n INT; BEGIN SELECT a INTO n FROM t65_8; END;
END;
CREATE OR REPLACE FUNCTION w65_1 RETURN INT AS BEGIN RETURN p65_1.f(); END;
CREATE OR REPLACE PROCEDURE w65_2 AS n INT; BEGIN n := p65_2.f(); END;
CREATE OR REPLACE FUNCTION w65_3 RETURN INT AS BEGIN RETURN p65_3.f(); END;
CREATE OR REPLACE FUNCTION w65_4 RETURN INT AS BEGIN RETURN p65_4.f(); END;
CREATE OR REPLACE FUNCTION w65_5 RETURN INT AS BEGIN RETURN p65_5.f(); END;
CREATE OR REPLACE FUNCTION w65_6 RETURN INT AS BEGIN RETURN p65_6.f(); END;
CREATE OR REPLACE FUNCTION w65_7 RETURN INT AS BEGIN RETURN p65_7.f(); END;
CREATE OR REPLACE FUNCTION w65_8 RETURN INT AS BEGIN RETURN p65_8.f(); END;


evaluate 'Case 1: INSERT in the initializer -> 1';
select w65_1() from dual;

evaluate 'Case 2: INSERT and COMMIT in the initializer -> 1';
call w65_2();
select count(*) from t65_2;

evaluate 'Case 3: EXECUTE IMMEDIATE in the initializer -> 2';
select w65_3() from dual;

evaluate 'Case 4: SQL%ROWCOUNT after UPDATE in the initializer -> 3';
select w65_4() from dual;

evaluate 'Case 5: INSERT in the exception handler of the initializer -> 6';
select w65_5() from dual;

evaluate 'Case 6: SQL in a routine called by the initializer -> 7';
select w65_6() from dual;

evaluate 'Case 7: initialized once in a session -> 1, 1';
select w65_7(), w65_7() from dual;

evaluate 'Case 8: no data found in the initializer -> error while initializing the package instance of F: no data found';
select w65_8() from dual;


drop function w65_1, w65_3, w65_4, w65_5, w65_6, w65_7, w65_8;
drop procedure w65_2;
drop package p65_1;
drop package p65_2;
drop package p65_3;
drop package p65_4;
drop package p65_5;
drop package p65_6;
drop package p65_7;
drop package p65_8;
drop table t65_1, t65_2, t65_3, t65_4, t65_4r, t65_5, t65_6, t65_7, t65_8;

--+ server-message off
