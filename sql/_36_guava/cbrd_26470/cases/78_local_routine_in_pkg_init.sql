/**
 *  This test case verifies CBRD-26470 (PR #7819): local routines in a DECLARE block of a package
 *  initializer (review round 6, E3).
 *
 *  A local routine in a DECLARE block of the initializer gave "Package compile error: internal
 *  error" (debug: the assert scopeLevel == DECL_TOP_LEVEL in previsitRoutine_decl(). A routine
 *  stack of size 1 was taken as a top-level routine, but the initializer pushed nothing, so its
 *  local routine became the first item of the stack).
 *  Fix: the initializer is treated like a top-level routine by the loop optimization. It pushes
 *  its own LoopOptimizables and sqlUsesOfTopLevel, finds recursive calls, and declares/closes the
 *  Statements of the SQL reached in loops before/after the body of initPkg().
 *  Each package is initialized when its function is first called through a wrapper function.
 *
 *  Coverage:
 *    Case 1: local procedure without SQL (the E3 example)                 -> runs
 *    Case 2: local procedure with INSERT                                   -> the row is inserted
 *    Case 3: INSERT in a FOR loop of a local procedure                     -> a row per iteration
 *    Case 4: local procedure with INSERT called in a loop of the initializer -> a row per call
 *    Case 5: recursive calls (3 levels) of a local procedure with INSERT   -> a row per level
 *    Case 6: nested local procedure with INSERT called in a loop           -> a row per call
 *    Case 7: INSERT in a FOR loop of the initializer (no local routine)    -> a row per iteration
 *    Case 8: sum of SELECT results in a loop of a local function           -> the sum
 */

--+ server-message on

drop package if exists p78_1;
drop package if exists p78_2;
drop package if exists p78_3;
drop package if exists p78_4;
drop package if exists p78_5;
drop package if exists p78_6;
drop package if exists p78_7;
drop package if exists p78_8;
drop table if exists t78_2;
drop table if exists t78_3;
drop table if exists t78_4;
drop table if exists t78_5;
drop table if exists t78_6;
drop table if exists t78_7;
drop table if exists t78_8;
drop table if exists t78_8r;

CREATE TABLE t78_2 (a INT);
CREATE TABLE t78_3 (a INT);
CREATE TABLE t78_4 (a INT);
CREATE TABLE t78_5 (a INT);
CREATE TABLE t78_6 (a INT);
CREATE TABLE t78_7 (a INT);
CREATE TABLE t78_8 (a INT);
CREATE TABLE t78_8r (a INT);
INSERT INTO t78_8 VALUES (1), (2);

CREATE OR REPLACE PACKAGE p78_1 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p78_1 AS
  FUNCTION f RETURN INT AS
  BEGIN
    RETURN 1;
  END;
BEGIN
  DECLARE
    PROCEDURE lp IS
    BEGIN
      NULL;
    END;
  BEGIN
    lp();
  END;
END;

CREATE OR REPLACE PACKAGE p78_2 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p78_2 AS
  FUNCTION f RETURN INT AS
    n INT;
  BEGIN
    SELECT COUNT(*) INTO n FROM t78_2;
    RETURN n;
  END;
BEGIN
  DECLARE
    PROCEDURE lp IS
    BEGIN
      INSERT INTO t78_2 VALUES (1);
    END;
  BEGIN
    lp();
  END;
END;

CREATE OR REPLACE PACKAGE p78_3 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p78_3 AS
  FUNCTION f RETURN INT AS
    n INT;
  BEGIN
    SELECT COUNT(*) INTO n FROM t78_3;
    RETURN n;
  END;
BEGIN
  DECLARE
    PROCEDURE lp IS
    BEGIN
      FOR i IN 1 .. 3 LOOP
        INSERT INTO t78_3 VALUES (i);
      END LOOP;
    END;
  BEGIN
    lp();
  END;
END;

CREATE OR REPLACE PACKAGE p78_4 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p78_4 AS
  FUNCTION f RETURN INT AS
    n INT;
  BEGIN
    SELECT COUNT(*) INTO n FROM t78_4;
    RETURN n;
  END;
BEGIN
  DECLARE
    PROCEDURE lp(i INT) IS
    BEGIN
      INSERT INTO t78_4 VALUES (i);
    END;
  BEGIN
    FOR i IN 1 .. 3 LOOP
      lp(i);
    END LOOP;
  END;
END;

CREATE OR REPLACE PACKAGE p78_5 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p78_5 AS
  FUNCTION f RETURN INT AS
    n INT;
  BEGIN
    SELECT COUNT(*) INTO n FROM t78_5;
    RETURN n;
  END;
BEGIN
  DECLARE
    PROCEDURE lp(i INT) IS
    BEGIN
      IF i > 0 THEN
        INSERT INTO t78_5 VALUES (i);
        lp(i - 1);
      END IF;
    END;
  BEGIN
    lp(3);
  END;
END;

CREATE OR REPLACE PACKAGE p78_6 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p78_6 AS
  FUNCTION f RETURN INT AS
    n INT;
  BEGIN
    SELECT COUNT(*) INTO n FROM t78_6;
    RETURN n;
  END;
BEGIN
  DECLARE
    PROCEDURE lp IS
      PROCEDURE lq(i INT) IS
      BEGIN
        INSERT INTO t78_6 VALUES (i);
      END;
    BEGIN
      FOR i IN 1 .. 3 LOOP
        lq(i);
      END LOOP;
    END;
  BEGIN
    lp();
  END;
END;

CREATE OR REPLACE PACKAGE p78_7 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p78_7 AS
  FUNCTION f RETURN INT AS
    n INT;
  BEGIN
    SELECT COUNT(*) INTO n FROM t78_7;
    RETURN n;
  END;
BEGIN
  FOR i IN 1 .. 3 LOOP
    INSERT INTO t78_7 VALUES (i);
  END LOOP;
END;

CREATE OR REPLACE PACKAGE p78_8 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p78_8 AS
  FUNCTION f RETURN INT AS
    n INT;
  BEGIN
    SELECT MAX(a) INTO n FROM t78_8r;
    RETURN n;
  END;
BEGIN
  DECLARE
    FUNCTION lf RETURN INT IS
      n INT;
      t INT := 0;
    BEGIN
      FOR i IN 1 .. 2 LOOP
        SELECT SUM(a) INTO n FROM t78_8;
        t := t + n;
      END LOOP;
      RETURN t;
    END;
    v INT;
  BEGIN
    v := lf();
    INSERT INTO t78_8r VALUES (v);
  END;
END;

CREATE OR REPLACE FUNCTION w78_1 RETURN INT AS BEGIN RETURN p78_1.f(); END;
CREATE OR REPLACE FUNCTION w78_2 RETURN INT AS BEGIN RETURN p78_2.f(); END;
CREATE OR REPLACE FUNCTION w78_3 RETURN INT AS BEGIN RETURN p78_3.f(); END;
CREATE OR REPLACE FUNCTION w78_4 RETURN INT AS BEGIN RETURN p78_4.f(); END;
CREATE OR REPLACE FUNCTION w78_5 RETURN INT AS BEGIN RETURN p78_5.f(); END;
CREATE OR REPLACE FUNCTION w78_6 RETURN INT AS BEGIN RETURN p78_6.f(); END;
CREATE OR REPLACE FUNCTION w78_7 RETURN INT AS BEGIN RETURN p78_7.f(); END;
CREATE OR REPLACE FUNCTION w78_8 RETURN INT AS BEGIN RETURN p78_8.f(); END;


evaluate 'Case 1: local procedure without SQL -> 1';
select w78_1() from dual;

evaluate 'Case 2: local procedure with INSERT -> 1';
select w78_2() from dual;

evaluate 'Case 3: INSERT in a loop of a local procedure -> 3';
select w78_3() from dual;

evaluate 'Case 4: local procedure called in a loop of the initializer -> 3';
select w78_4() from dual;

evaluate 'Case 5: recursive local procedure with INSERT -> 3';
select w78_5() from dual;

evaluate 'Case 6: nested local procedure called in a loop -> 3';
select w78_6() from dual;

evaluate 'Case 7: INSERT in a loop of the initializer -> 3';
select w78_7() from dual;

evaluate 'Case 8: SELECT in a loop of a local function -> 6';
select w78_8() from dual;

drop function w78_1, w78_2, w78_3, w78_4, w78_5, w78_6, w78_7, w78_8;
drop package if exists p78_1;
drop package if exists p78_2;
drop package if exists p78_3;
drop package if exists p78_4;
drop package if exists p78_5;
drop package if exists p78_6;
drop package if exists p78_7;
drop package if exists p78_8;
drop table if exists t78_2;
drop table if exists t78_3;
drop table if exists t78_4;
drop table if exists t78_5;
drop table if exists t78_6;
drop table if exists t78_7;
drop table if exists t78_8;
drop table if exists t78_8r;

--+ server-message off
