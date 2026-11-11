/**
 *  This test case verifies CBRD-26470 (PR #7819): package items that are not supported yet
 *  (variables, constants, cursors, exceptions declared at the package level) are refused.
 *
 *  NOTE: this refusal is TEMPORARY. The features that use package variables, constants,
 *  cursors and exceptions are not fully implemented yet, so their top-level declarations in a
 *  package specification or body are refused with "declaring a package <kind> is not supported
 *  yet". When a feature is implemented, its refusal is removed and the answer of the
 *  corresponding cases changes (the declaration is then accepted).
 *  Routines are still allowed, and declarations inside member routines, their local routines,
 *  DECLARE blocks of the initializer and stored procedures are not affected.
 *
 *  Coverage:
 *    Case 1-4: variable, constant, cursor, exception in the specification -> refused, the
 *              position is the name of the declaration
 *    Case 5-8: variable, constant, cursor, exception in the body -> refused
 *    Case 9:   the refused specification is not created
 *    Case 10:  declarations in member routines, their local routines and a DECLARE block of the
 *              initializer are allowed, and they work (1+2+3+7 + 10 + 100 + 1000 = 1123)
 *    Case 11:  top-level declarations of a stored function are allowed (1+2+3 + 10 + 100 = 116)
 */

--+ server-message on

drop package if exists ps76;
drop package if exists pb76;
drop package if exists pk76;
drop table if exists tn76;

CREATE TABLE tn76 (a INT);
INSERT INTO tn76 VALUES (1), (2), (3);
CREATE OR REPLACE PACKAGE pb76 AS FUNCTION f RETURN INT; END;


evaluate 'Case 1: variable in the specification -> declaring a package variable is not supported yet';
CREATE OR REPLACE PACKAGE ps76 AS FUNCTION f RETURN INT; v INT := 1; END;

evaluate 'Case 2: constant in the specification -> declaring a package constant is not supported yet';
CREATE OR REPLACE PACKAGE ps76 AS c CONSTANT INT := 1; FUNCTION f RETURN INT; END;

evaluate 'Case 3: cursor in the specification -> declaring a package cursor is not supported yet';
CREATE OR REPLACE PACKAGE ps76 AS CURSOR cr IS SELECT a FROM tn76; FUNCTION f RETURN INT; END;

evaluate 'Case 4: exception in the specification -> declaring a package exception is not supported yet';
CREATE OR REPLACE PACKAGE ps76 AS e EXCEPTION; FUNCTION f RETURN INT; END;

evaluate 'Case 5: variable in the body -> declaring a package variable is not supported yet';
CREATE OR REPLACE PACKAGE BODY pb76 AS v INT := 1; FUNCTION f RETURN INT AS BEGIN RETURN 1; END; END;

evaluate 'Case 6: constant in the body -> declaring a package constant is not supported yet';
CREATE OR REPLACE PACKAGE BODY pb76 AS FUNCTION f RETURN INT AS BEGIN RETURN 1; END; c CONSTANT INT := 1; END;

evaluate 'Case 7: cursor in the body -> declaring a package cursor is not supported yet';
CREATE OR REPLACE PACKAGE BODY pb76 AS CURSOR cr IS SELECT a FROM tn76; FUNCTION f RETURN INT AS BEGIN RETURN 1; END; END;

evaluate 'Case 8: exception in the body -> declaring a package exception is not supported yet';
CREATE OR REPLACE PACKAGE BODY pb76 AS e EXCEPTION; FUNCTION f RETURN INT AS BEGIN RETURN 1; END; END;


evaluate 'Case 9: the refused specification ps76 is not created -> 0';
select count(*) from _db_package where unique_name = 'dba.ps76';

evaluate 'Case 10: declarations in member routines, their local routines and the initializer DECLARE block -> created, 1123';
CREATE OR REPLACE PACKAGE pk76 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY pk76 AS
  FUNCTION f RETURN INT AS
    v INT := 10;
    c CONSTANT INT := 100;
    CURSOR cr IS SELECT a FROM tn76 ORDER BY a;
    e EXCEPTION;
    s INT := 0;
    FUNCTION g RETURN INT AS w INT := 1000; e2 EXCEPTION; BEGIN RAISE e2; EXCEPTION WHEN e2 THEN RETURN w; END;
  BEGIN
    FOR r IN cr LOOP s := s + r.a; END LOOP;
    RAISE e;
  EXCEPTION
    WHEN e THEN RETURN s + v + c + g();
  END;
BEGIN
  DECLARE
    x INT := 7;
    CURSOR ci IS SELECT a FROM tn76;
  BEGIN
    INSERT INTO tn76 VALUES (x);
  END;
END;
CREATE OR REPLACE FUNCTION wk76 RETURN INT AS BEGIN RETURN pk76.f(); END;
select wk76() from dual;

evaluate 'Case 11: top-level declarations of a stored function -> created, 116';
CREATE OR REPLACE FUNCTION sf76 RETURN INT AS
  v INT := 10;
  c CONSTANT INT := 100;
  CURSOR cr IS SELECT a FROM tn76 WHERE a < 4;
  e EXCEPTION;
  s INT := 0;
BEGIN
  FOR r IN cr LOOP s := s + r.a; END LOOP;
  RAISE e;
EXCEPTION
  WHEN e THEN RETURN s + v + c;
END;
select sf76() from dual;

drop function wk76, sf76;
drop package if exists ps76;
drop package if exists pb76;
drop package if exists pk76;
drop table if exists tn76;

--+ server-message off
