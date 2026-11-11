/**
 *  This test case verifies CBRD-26470 (PR #7819): PARALLEL_ENABLE functions in a package.
 *
 *  Background:
 *    - Once a top-level routine turned parallelEnabled on, it stayed on for the rest of the
 *      package, so the later members, cursor declarations and the initializer were checked by
 *      the PARALLEL_ENABLE rules and refused.
 *    - A PARALLEL_ENABLE function could reach the server through a non-PARALLEL_ENABLE member
 *      of the same package (a same-package call is a plain Java call).
 *    - PARALLEL_ENABLE of a package member was not recorded in the catalog (directive 0x04).
 *    - PARALLEL_ENABLE on a package procedure was accepted (CREATE PROCEDURE refuses it).
 *  Fix:
 *    - parallelEnabled is decided per top-level routine; local routines inherit it.
 *    - A PARALLEL_ENABLE function (and its local routines) may call only PARALLEL_ENABLE
 *      functions of the same package (s444).
 *    - PARALLEL_ENABLE of a package member is recorded in the catalog.
 *    - PARALLEL_ENABLE on a package procedure is refused (s445).
 *    - If the specification has a PARALLEL_ENABLE function, the package initialization is checked
 *      by the same rules (s446): it runs when the package is first used, which may be inside a
 *      PARALLEL_ENABLE function call where server-side SQL is forbidden.
 *  (While package variables/constants/cursors cannot be declared, the checks on their initial
 *   values are done on the initializer block instead, and the spec cursor of case 2 is a local
 *   cursor of a member declared after the PARALLEL_ENABLE function.)
 *  Error positions in a package body are counted from the first line of the body statement.
 *
 *  Coverage:
 *    Case 1-3:   refused before the fix: SQL in another member, a cursor in a later member,
 *                initializer when only a private function is PARALLEL_ENABLE -> created
 *    Case 4:     catalog is_parallel_enabled
 *    Case 5-7:   PARALLEL_ENABLE function calls a non-PARALLEL_ENABLE member (directly, without
 *                parentheses, through a local routine) -> s444
 *    Case 8-9:   allowed calls and their result
 *    Case 10:    PARALLEL_ENABLE package procedure -> s445
 *    Case 11-15: initializer of a package whose spec has a PARALLEL_ENABLE function -> s446
 *                (direct call, non-PARALLEL_ENABLE member, built-in, DBMS_OUTPUT, SQL)
 *    Case 16-17: allowed initializer and its result
 *    Case 18-21: SQL, DBMS_OUTPUT, direct call, direct call in a parameter default inside the
 *                PARALLEL_ENABLE function itself -> refused as before
 *    Case 22-24: PARALLEL_ENABLE stored functions -> same as before
 *    Case 25-26: violation after a variable/constant declaration in a DECLARE of the initializer
 *                -> s446 message (before the fix, the function message was given)
 */

--+ server-message on

drop package if exists pa73;
drop package if exists pb73;
drop package if exists pc73;
drop package if exists pd73;
drop package if exists pe73;
drop package if exists pf73;
drop package if exists pg73;
drop package if exists ph73;
drop package if exists pi73;
drop package if exists pj73;
drop package if exists pk73;
drop package if exists pl73;
drop package if exists pm73;
drop package if exists pn73;
drop package if exists po73;
drop package if exists pq73;
drop package if exists pr73;
drop package if exists ps73;
drop package if exists pmsg73;
drop package if exists pmsg73b;
drop table if exists t73;

CREATE TABLE t73 (a INT);
INSERT INTO t73 VALUES (1), (2);
CREATE OR REPLACE FUNCTION ofn73(x INT) RETURN INT AS BEGIN RETURN x * 10; END;


evaluate 'Case 1: SQL in another member of a package with a PARALLEL_ENABLE function -> created';
CREATE OR REPLACE PACKAGE pa73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE;
  FUNCTION g(x INT) RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pa73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x + 1; END;
  FUNCTION g(x INT) RETURN INT AS n INT; BEGIN SELECT count(*) INTO n FROM t73; RETURN n + x; END;
END;

evaluate 'Case 2: cursor in a member declared after a PARALLEL_ENABLE function -> created';
CREATE OR REPLACE PACKAGE pb73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE;
  FUNCTION h RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pb73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x + 2; END;
  FUNCTION h RETURN INT AS CURSOR c IS SELECT a FROM t73; BEGIN RETURN 0; END;
END;

evaluate 'Case 3: initializer when only a private function is PARALLEL_ENABLE -> created';
CREATE OR REPLACE PACKAGE pc73 AS
  FUNCTION g RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pc73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x + 3; END;
  FUNCTION g RETURN INT AS BEGIN RETURN pf(0); END;
BEGIN
  IF ofn73(1) > 0 THEN NULL; END IF;
  INSERT INTO t73 VALUES (9);
  DBMS_OUTPUT.put_line('pc');
END;

evaluate 'Case 4: catalog is_parallel_enabled -> g NO, pf YES';
select sp_name, is_parallel_enabled from db_stored_procedure where pkg_name = 'pa73' order by sp_name;

evaluate 'Case 5: PARALLEL_ENABLE function calls a non-PARALLEL_ENABLE function -> s444 at line 2, column 65';
CREATE OR REPLACE PACKAGE pd73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; FUNCTION g(x INT) RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY pd73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN g(x); END;
  FUNCTION g(x INT) RETURN INT AS BEGIN RETURN x; END;
END;

evaluate 'Case 6: PARALLEL_ENABLE function calls a private procedure without parentheses -> s444 at line 2, column 58';
CREATE OR REPLACE PACKAGE pe73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pe73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN pp; RETURN x; END;
  PROCEDURE pp AS BEGIN NULL; END;
END;

evaluate 'Case 7: PARALLEL_ENABLE function calls a non-PARALLEL_ENABLE member through a local routine -> s444 at line 3, column 45';
CREATE OR REPLACE PACKAGE pf73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pf73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS
    FUNCTION loc RETURN INT AS BEGIN RETURN g; END;
  BEGIN RETURN loc(); END;
  FUNCTION g RETURN INT AS BEGIN RETURN 1; END;
END;

evaluate 'Case 8: allowed calls (PARALLEL_ENABLE private, local routine, self recursion, the other direction) -> created';
CREATE OR REPLACE PACKAGE pg73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE;
  FUNCTION g(x INT) RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pg73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS
    FUNCTION loc(y INT) RETURN INT AS BEGIN RETURN pp(y) * 2; END;
  BEGIN
    IF x = 0 THEN RETURN 0; END IF;
    RETURN loc(x) + pf(x - 1);
  END;
  FUNCTION pp(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x + 1; END;
  FUNCTION g(x INT) RETURN INT AS BEGIN RETURN pf(x) + pp(100); END;
END;
CREATE OR REPLACE FUNCTION wg73(x INT) RETURN INT AS BEGIN RETURN pg73.pf(x) * 1000 + pg73.g(x); END;

evaluate 'Case 9: run: pf(3) = (4 + 3 + 2) * 2 = 18, g(3) = 18 + 101 -> 18119';
select wg73(3) from dual;

evaluate 'Case 10: PARALLEL_ENABLE package procedure -> s445 at line 1, column 48';
CREATE OR REPLACE PACKAGE ph73 AS PROCEDURE pp PARALLEL_ENABLE; END;

evaluate 'Case 11: initializer: direct call -> s446 (calls DB server) at line 3, column 6';
CREATE OR REPLACE PACKAGE pi73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pi73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x; END;
BEGIN
  IF ofn73(1) > 0 THEN NULL; END IF;
END;

evaluate 'Case 12: initializer: non-PARALLEL_ENABLE member -> s446 (s444 text) at line 5, column 6';
CREATE OR REPLACE PACKAGE pj73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; FUNCTION g RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY pj73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x; END;
  FUNCTION g RETURN INT AS BEGIN RETURN 1; END;
BEGIN
  IF g() > 0 THEN NULL; END IF;
END;

evaluate 'Case 13: initializer: built-in function -> s446 (calls DB server) at line 3, column 6';
CREATE OR REPLACE PACKAGE pk73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pk73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x; END;
BEGIN
  IF SYSDATE IS NOT NULL THEN NULL; END IF;
END;

evaluate 'Case 14: initializer: DBMS_OUTPUT -> s446 (DBMS_OUTPUT) at line 4, column 3';
CREATE OR REPLACE PACKAGE pl73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pl73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x; END;
BEGIN
  DBMS_OUTPUT.put_line('pl');
END;

evaluate 'Case 15: initializer: SQL -> s446 (calls DB server) at line 4, column 3';
CREATE OR REPLACE PACKAGE pm73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pm73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x; END;
BEGIN
  INSERT INTO t73 VALUES (1);
END;

evaluate 'Case 16: allowed initializer (constant expression, PARALLEL_ENABLE member call) -> created';
CREATE OR REPLACE PACKAGE pn73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE;
END;
CREATE OR REPLACE PACKAGE BODY pn73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN x + 1; END;
BEGIN
  IF 10 * 2 = 20 AND pf(100) > 0 THEN NULL; END IF;
END;
CREATE OR REPLACE FUNCTION wn73 RETURN INT AS BEGIN RETURN pn73.pf(0); END;

evaluate 'Case 17: run: the initializer ends without error and pf is called -> 1';
select wn73() from dual;

evaluate 'Case 18: SQL in the PARALLEL_ENABLE function -> refused at line 2, column 65';
CREATE OR REPLACE PACKAGE po73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY po73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS n INT; BEGIN SELECT count(*) INTO n FROM t73; RETURN n; END;
END;

evaluate 'Case 19: DBMS_OUTPUT in the PARALLEL_ENABLE function -> refused at line 2, column 58';
CREATE OR REPLACE PACKAGE pq73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pq73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN DBMS_OUTPUT.put_line('x'); RETURN x; END;
END;

evaluate 'Case 20: direct call in the PARALLEL_ENABLE function -> refused at line 2, column 65';
CREATE OR REPLACE PACKAGE pr73 AS FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pr73 AS
  FUNCTION pf(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN ofn73(x); END;
END;

evaluate 'Case 21: direct call in a parameter default -> refused at line 1, column 61';
CREATE OR REPLACE PACKAGE ps73 AS FUNCTION pf(x INT DEFAULT ofn73(1)) RETURN INT PARALLEL_ENABLE; END;

evaluate 'Case 22: PARALLEL_ENABLE stored function: SQL in a local routine -> refused at line 2, column 43';
CREATE OR REPLACE FUNCTION sp73a(x INT) RETURN INT PARALLEL_ENABLE AS
  FUNCTION loc RETURN INT AS n INT; BEGIN SELECT count(*) INTO n FROM t73; RETURN n; END;
BEGIN
  RETURN loc();
END;

evaluate 'Case 23: PARALLEL_ENABLE stored function: local routine and recursion -> created';
CREATE OR REPLACE FUNCTION sp73b(x INT) RETURN INT PARALLEL_ENABLE AS
  FUNCTION loc(y INT) RETURN INT AS BEGIN RETURN y + 1; END;
BEGIN
  IF x = 0 THEN RETURN 0; END IF;
  RETURN loc(x) + sp73b(x - 1);
END;

evaluate 'Case 24: PARALLEL_ENABLE stored function: direct call -> refused at line 1, column 84';
CREATE OR REPLACE FUNCTION sp73c(x INT) RETURN INT PARALLEL_ENABLE AS BEGIN RETURN ofn73(x); END;

evaluate 'Case 25: initializer: DBMS_OUTPUT after a variable declaration in DECLARE -> s446 (DBMS_OUTPUT) at line 7, column 5';
CREATE OR REPLACE PACKAGE pmsg73 AS FUNCTION pf RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pmsg73 AS
  FUNCTION pf RETURN INT PARALLEL_ENABLE AS BEGIN RETURN 1; END;
BEGIN
  DECLARE
    x INT := 1;
  BEGIN
    DBMS_OUTPUT.PUT_LINE(x);
  END;
END;

evaluate 'Case 26: initializer: SQL after a constant declaration in DECLARE -> s446 (calls DB server) at line 7, column 5';
CREATE OR REPLACE PACKAGE pmsg73b AS FUNCTION pf RETURN INT PARALLEL_ENABLE; END;
CREATE OR REPLACE PACKAGE BODY pmsg73b AS
  FUNCTION pf RETURN INT PARALLEL_ENABLE AS BEGIN RETURN 1; END;
BEGIN
  DECLARE
    c CONSTANT INT := 2;
  BEGIN
    INSERT INTO t73 VALUES (c);
  END;
END;


drop package if exists pa73;
drop package if exists pb73;
drop package if exists pc73;
drop package if exists pd73;
drop package if exists pe73;
drop package if exists pf73;
drop package if exists pg73;
drop package if exists ph73;
drop package if exists pi73;
drop package if exists pj73;
drop package if exists pk73;
drop package if exists pl73;
drop package if exists pm73;
drop package if exists pn73;
drop package if exists po73;
drop package if exists pq73;
drop package if exists pr73;
drop package if exists ps73;
drop package if exists pmsg73;
drop package if exists pmsg73b;
drop function ofn73, wg73, wn73, sp73b;
drop table if exists t73;

--+ server-message off
