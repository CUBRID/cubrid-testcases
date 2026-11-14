/**
 *  This test case verifies CBRD-26470 (PR #7819): record OUT and IN OUT arguments of local and
 *  direct calls (review round 6, E2, and related defects).
 *
 *  A record parameter is allowed only for local routines and private package routines, so these
 *  arguments are always passed by a local or direct call.
 *    E2:  same type OUT -> NullPointerException. The OUT copy of the caller was new T[] { null } and
 *         the callee called o[0].setNull(null). Fix: the callee makes a new record o[0] = new T().
 *    B:   same type IN OUT -> the copy new T[] { o[0] } was the record object of the caller itself, so
 *         the fields changed by the callee stayed in the caller even when the callee ended with an
 *         exception. Fix: copy it with copy() of the record class.
 *    C/D: different (compatible) record type OUT / IN OUT -> assert false in
 *         RecordToRecord.javaCode() during compilation (debug build, "internal error").
 *         Fix: the assert is removed (the generated code already copies into a new object).
 *
 *  Coverage:
 *    Case 1: E2 local procedure, same type OUT                        -> the callee value is returned
 *    Case 2: E2 private package procedure, same type OUT              -> the callee value is returned
 *    Case 3: OUT does not take the value of the caller                -> the field is NULL in the callee
 *    Case 4: B same type IN OUT, field changed, then exception        -> the caller keeps its value
 *    Case 5: same type IN OUT, normal return (o.a := o.a + 7)         -> the new value is written back
 *    Case 6: C different type OUT                                     -> the callee value is returned
 *    Case 7: D different type IN OUT, normal return                   -> the new value is written back
 *    Case 8: D different type IN OUT, field changed, then exception   -> the caller keeps its value
 */

--+ server-message on

drop package if exists pk77;
drop table if exists t_or77;
drop table if exists t_or77b;

CREATE TABLE t_or77 (a INT, b VARCHAR(10));
CREATE TABLE t_or77b (x INT, y VARCHAR(10));

CREATE OR REPLACE FUNCTION r77_1 RETURN INT AS
  r t_or77%ROWTYPE;

  PROCEDURE setr(o OUT t_or77%ROWTYPE) AS
  BEGIN
    o.a := 7;
  END;
BEGIN
  setr(r);
  RETURN r.a;
END;

CREATE OR REPLACE PACKAGE pk77 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pk77 AS
  PROCEDURE setr(o OUT t_or77%ROWTYPE) AS
  BEGIN
    o.a := 7;
  END;

  FUNCTION f RETURN INT AS
    r t_or77%ROWTYPE;
  BEGIN
    setr(r);
    RETURN r.a;
  END;
END;
CREATE OR REPLACE FUNCTION r77_2 RETURN INT AS
BEGIN
  RETURN pk77.f();
END;

CREATE OR REPLACE FUNCTION r77_3 RETURN INT AS
  r t_or77%ROWTYPE;

  PROCEDURE noset(o OUT t_or77%ROWTYPE) AS
  BEGIN
    NULL;
  END;
BEGIN
  r.a := 5;
  noset(r);
  RETURN r.a;
END;

CREATE OR REPLACE FUNCTION r77_4 RETURN INT AS
  r t_or77%ROWTYPE;

  PROCEDURE m(o IN OUT t_or77%ROWTYPE) AS
  BEGIN
    o.a := 99;
    RAISE NO_DATA_FOUND;
  END;
BEGIN
  r.a := 1;
  BEGIN
    m(r);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
  RETURN r.a;
END;

CREATE OR REPLACE FUNCTION r77_5 RETURN INT AS
  r t_or77%ROWTYPE;

  PROCEDURE m(o IN OUT t_or77%ROWTYPE) AS
  BEGIN
    o.a := o.a + 7;
  END;
BEGIN
  r.a := 1;
  m(r);
  RETURN r.a;
END;

CREATE OR REPLACE FUNCTION r77_6 RETURN INT AS
  r t_or77b%ROWTYPE;

  PROCEDURE setr(o OUT t_or77%ROWTYPE) AS
  BEGIN
    o.a := 7;
  END;
BEGIN
  setr(r);
  RETURN r.x;
END;

CREATE OR REPLACE FUNCTION r77_7 RETURN INT AS
  r t_or77b%ROWTYPE;

  PROCEDURE m(o IN OUT t_or77%ROWTYPE) AS
  BEGIN
    o.a := o.a + 7;
  END;
BEGIN
  r.x := 1;
  m(r);
  RETURN r.x;
END;

CREATE OR REPLACE FUNCTION r77_8 RETURN INT AS
  r t_or77b%ROWTYPE;

  PROCEDURE m(o IN OUT t_or77%ROWTYPE) AS
  BEGIN
    o.a := 99;
    RAISE NO_DATA_FOUND;
  END;
BEGIN
  r.x := 1;
  BEGIN
    m(r);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
  RETURN r.x;
END;


evaluate 'Case 1: E2 same type OUT, local -> 7';
select r77_1() from dual;

evaluate 'Case 2: E2 same type OUT, package private -> 7';
select r77_2() from dual;

evaluate 'Case 3: OUT does not take the caller''s value -> NULL';
select r77_3() from dual;

evaluate 'Case 4: B same type IN OUT, exception -> 1';
select r77_4() from dual;

evaluate 'Case 5: same type IN OUT, normal return -> 8';
select r77_5() from dual;

evaluate 'Case 6: C different type OUT -> 7';
select r77_6() from dual;

evaluate 'Case 7: D different type IN OUT, normal return -> 8';
select r77_7() from dual;

evaluate 'Case 8: D different type IN OUT, exception -> 1';
select r77_8() from dual;

drop function r77_1, r77_2, r77_3, r77_4, r77_5, r77_6, r77_7, r77_8;
drop package if exists pk77;
drop table if exists t_or77;
drop table if exists t_or77b;

--+ server-message off
