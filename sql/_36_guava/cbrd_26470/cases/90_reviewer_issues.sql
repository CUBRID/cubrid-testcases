/**
 *  This test case verifies CBRD-26470 (PR #7819): the issues reported by the reviewers
 *  (kangmin5505: K1-K9, childyouth: C1-C6) on the PR. The reproductions are taken from the PR
 *  comments, with object names suffixed by 90.
 *
 *  Coverage:
 *    Case 1:  C1  a package body replaced in the same session is seen by its caller -> 1, then 2
 *    Case 2:  K1  callee gains a DEFAULT parameter, caller not recompiled -> an error with a
 *                 recompile hint, never a wrong value
 *    Case 3:  K2  SQL statement in a package procedure -> 1 row inserted
 *    Case 4:  K4  routine call in a package initializer (moved from a package variable initial
 *                 value while package variables cannot be declared) -> created
 *    Case 5:  K5  initializer failing at run time (moved from a package variable initial value):
 *                 the to_number() message, not 'internal server error'; 1 after the body is fixed
 *    Case 6:  K7  assignment to a field of an IN record parameter -> error, like the scalar case.
 *                 A record type cannot be a parameter type of a public routine, so the
 *                 specification is refused. The body given without a specification is kept as a
 *                 body-only package, hence drop package body if exists.
 *    Case 7:  K6  default values through a direct call: '' -> 'EMPTY len=0' as from SQL
 *                 TO_CHAR(SYS_DATE, 'YYYY') -> the current year, not the literal text
 *    Case 8:  C3  DATE / DATETIME defaults through a direct call -> the same date, no division
 *    Case 9:  C4  OPEN on a SYS_REFCURSOR without a query -> a specific message, not 'internal error'
 *    Case 10: C5  assignment to a serial value -> a specific message, not 'internal error'
 *    Case 11: C6  exception of a package that does not exist -> errors (not compiled silently)
 *    Case 12: K8  messages for missing names and one-dot qualified names
 *    Case 13: K9  dropped callee -> 'does not exist', not 'no authorization'; SQL control
 *    Case 14: K3  as u90 with EXECUTE on dba.peek90: SQL call and direct call -> 42, 42
 *                 (the direct call runs with the callee's rights)
 *    Case 15: C2  joined identifier longer than 255 bytes -> an error, no crash
 */

--+ server-message on

drop package if exists p90_7;
drop package if exists pg90;
drop package if exists ini90_b;
drop package if exists badini90;
drop package if exists pk90_in;
drop package body if exists pk90_in;
drop package if exists pk90_sc;
drop table if exists t90_sec;
drop table if exists t90_7819;
drop table if exists t90_row;
drop serial if exists s90_f4;

-- K3 (kangmin5505): setup for the execution rights case of Case 14
CREATE USER u90;
CREATE TABLE t90_sec(c INT);
INSERT INTO t90_sec VALUES (42);
CREATE OR REPLACE FUNCTION peek90 RETURN INT AS
  v INT;
BEGIN
  SELECT c INTO v FROM t90_sec;
  RETURN v;
END;
GRANT EXECUTE ON PROCEDURE peek90 TO u90;


evaluate 'Case 1: C1 same-session package change is seen -> 1, then 2';
CREATE OR REPLACE PACKAGE p90_7 AS FUNCTION f RETURN INTEGER; END;
CREATE OR REPLACE PACKAGE BODY p90_7 AS
  FUNCTION f RETURN INTEGER AS BEGIN RETURN 1; END;
END;
CREATE OR REPLACE FUNCTION a90_7 RETURN INTEGER AS BEGIN RETURN p90_7.f(); END;
SELECT a90_7();
CREATE OR REPLACE PACKAGE BODY p90_7 AS
  FUNCTION f RETURN INTEGER AS BEGIN RETURN 2; END;
END;
SELECT a90_7();

evaluate 'Case 2: K1 callee signature gains a DEFAULT parameter -> an error, never a wrong value';
CREATE OR REPLACE FUNCTION b90(a INT) RETURN INT AS BEGIN RETURN a; END;
CREATE OR REPLACE FUNCTION a90 RETURN INT AS BEGIN RETURN b90(1); END;
CREATE OR REPLACE FUNCTION b90(a INT, x VARCHAR DEFAULT 'xy') RETURN INT AS BEGIN RETURN a + LENGTH(x); END;
SELECT a90();

evaluate 'Case 3: K2 SQL statement in a package body -> 1';
CREATE TABLE t90_7819(a INT);
CREATE OR REPLACE PACKAGE pg90 AS PROCEDURE q; END;
CREATE OR REPLACE PACKAGE BODY pg90 AS
  PROCEDURE q IS BEGIN INSERT INTO t90_7819 VALUES (1); END;
END;
CALL pg90.q();
SELECT COUNT(*) FROM t90_7819;

evaluate 'Case 4: K4 routine call in a package initializer -> created';
CREATE OR REPLACE FUNCTION getcfg90 RETURN INT AS BEGIN RETURN 9; END;
CREATE OR REPLACE PACKAGE ini90_b AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY ini90_b AS
  FUNCTION f RETURN INT AS BEGIN RETURN 1; END;
BEGIN
  IF getcfg90() > 0 THEN NULL; END IF;
END;

evaluate 'Case 5: K5 initializer failing at run time -> to_number() message (control and package), then 1 after the fix';
CREATE OR REPLACE PACKAGE badini90 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY badini90 AS
  FUNCTION f RETURN INT AS BEGIN RETURN 1; END;
BEGIN
  IF TO_NUMBER('abc') > 0 THEN NULL; END IF;
END;
CREATE OR REPLACE FUNCTION call90_badini RETURN INT AS BEGIN RETURN badini90.f(); END;
CREATE OR REPLACE FUNCTION alone90_bad RETURN INT AS v INT;
BEGIN v := TO_NUMBER('abc'); RETURN v; END;
SELECT alone90_bad();
SELECT call90_badini();
CREATE OR REPLACE PACKAGE BODY badini90 AS
  FUNCTION f RETURN INT AS BEGIN RETURN 1; END;
BEGIN
  IF TO_NUMBER('5') > 0 THEN NULL; END IF;
END;
SELECT call90_badini();

evaluate 'Case 6: K7 IN record parameter in a package specification -> refused as a parameter type; assignment to an IN scalar parameter -> not updatable';
CREATE TABLE t90_row(a INT, b VARCHAR(10));
CREATE OR REPLACE PACKAGE pk90_in AS PROCEDURE q(x IN t90_row%ROWTYPE); END;
CREATE OR REPLACE PACKAGE BODY pk90_in AS
  PROCEDURE q(x IN t90_row%ROWTYPE) AS BEGIN x.a := 99; END;
END;
CREATE OR REPLACE PACKAGE pk90_sc AS PROCEDURE q(x IN INT); END;
CREATE OR REPLACE PACKAGE BODY pk90_sc AS
  PROCEDURE q(x IN INT) AS BEGIN x := 99; END;
END;

evaluate 'Case 7: K6 default values through a direct call -> EMPTY len=0 twice, then 1 (the current year)';
CREATE OR REPLACE FUNCTION ef90(p VARCHAR DEFAULT '') RETURN VARCHAR AS
BEGIN
  IF p IS NULL THEN RETURN 'NULL'; ELSE RETURN 'EMPTY len=' || LENGTH(p); END IF;
END;
CREATE OR REPLACE FUNCTION ef90_direct RETURN VARCHAR AS BEGIN RETURN ef90(); END;
SELECT ef90_direct();
SELECT ef90();
CREATE OR REPLACE FUNCTION tf90(s VARCHAR DEFAULT TO_CHAR(SYS_DATE, 'YYYY')) RETURN VARCHAR AS
BEGIN RETURN s; END;
CREATE OR REPLACE FUNCTION tf90_direct RETURN VARCHAR AS BEGIN RETURN tf90(); END;
SELECT tf90_direct() = TO_CHAR(SYS_DATE, 'YYYY');

evaluate 'Case 8: C3 DATE / DATETIME defaults -> 10/15/2008 twice, call succeeds';
CREATE OR REPLACE FUNCTION rd90(d DATE DEFAULT DATE'2008-10-15') RETURN DATE AS BEGIN RETURN d; END;
CREATE OR REPLACE FUNCTION omit90_date     RETURN DATE AS BEGIN RETURN rd90(); END;
CREATE OR REPLACE FUNCTION explicit90_date RETURN DATE AS BEGIN RETURN rd90(DATE'2008-10-15'); END;
SELECT explicit90_date();
SELECT omit90_date();
CREATE OR REPLACE PROCEDURE cd90(d DATETIME DEFAULT DATETIME'2008-10-15 05:40:30') AS BEGIN NULL; END;
CREATE OR REPLACE PROCEDURE call90_cd AS BEGIN cd90(); END;
CALL call90_cd();

evaluate 'Case 9: C4 OPEN on a SYS_REFCURSOR -> a specific message, not internal error';
CREATE OR REPLACE PROCEDURE f90_3 AS
  c SYS_REFCURSOR;
BEGIN
  OPEN c;
END;

evaluate 'Case 10: C5 assigning to a serial value -> a specific message, not internal error';
CREATE SERIAL s90_f4;
CREATE OR REPLACE PROCEDURE f90_4 AS
BEGIN
  s90_f4.NEXTVAL := 1;
END;

evaluate 'Case 11: C6 an exception of a package that does not exist -> errors about the unknown exception';
CREATE OR REPLACE PROCEDURE ff90 AS
BEGIN NULL;
EXCEPTION WHEN OTHERS THEN RAISE nosuchpkg.no_such_exc;
END;
CREATE OR REPLACE PROCEDURE ff90_2 AS
BEGIN RAISE nosuchpkg.no_such_exc; END;

evaluate 'Case 12: K8 messages for missing names and one-dot qualified names';
CREATE OR REPLACE FUNCTION  realf90 RETURN INT AS BEGIN RETURN 1; END;
CREATE OR REPLACE PROCEDURE realp90 AS BEGIN NULL; END;
CREATE OR REPLACE PROCEDURE e90_1 AS BEGIN nosuch();            END;
CREATE OR REPLACE PROCEDURE e90_2 AS BEGIN dba.nosuch();        END;
CREATE OR REPLACE PROCEDURE e90_3 AS BEGIN dba.nopkg.nosuch();  END;
CREATE OR REPLACE PROCEDURE e90_6 AS BEGIN realf90();           END;
CREATE OR REPLACE PROCEDURE e90_4 AS BEGIN dba.realf90();       END;
CREATE OR REPLACE FUNCTION  e90_5 RETURN INT AS BEGIN RETURN dba.realp90(); END;

evaluate 'Case 13: K9 dropped callee -> 7, then does not exist (not no authorization), then the SQL control';
CREATE OR REPLACE FUNCTION cb90 RETURN INT AS BEGIN RETURN 7; END;
CREATE OR REPLACE FUNCTION ca90 RETURN INT AS BEGIN RETURN cb90(); END;
SELECT ca90();
DROP FUNCTION cb90;
SELECT ca90();
SELECT cb90();

evaluate 'Case 14: K3 as u90, SQL call and direct call of dba.peek90 -> 42, 42';
call login('u90', '') on class db_user;
SELECT dba.peek90() FROM db_root;
CREATE OR REPLACE FUNCTION wrap90 RETURN INT AS BEGIN RETURN dba.peek90(); END;
SELECT wrap90() FROM db_root;
call login('dba', '') on class db_user;

evaluate 'Case 15: C2 joined identifier longer than 255 bytes -> an error, no crash';
CREATE OR REPLACE PROCEDURE f90_9 AS
BEGIN
  qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq();
END;


call login('dba', '') on class db_user;
drop function u90.wrap90;
drop function a90, a90_7, alone90_bad, b90, ca90, call90_badini, ef90, ef90_direct, explicit90_date, getcfg90, omit90_date, peek90, rd90, realf90, tf90, tf90_direct;
drop procedure call90_cd, cd90, realp90;
drop package if exists p90_7;
drop package if exists pg90;
drop package if exists ini90_b;
drop package if exists badini90;
drop package if exists pk90_in;
drop package body if exists pk90_in;
drop package if exists pk90_sc;
drop table if exists t90_sec;
drop table if exists t90_7819;
drop table if exists t90_row;
drop serial if exists s90_f4;
drop user u90;

--+ server-message off
