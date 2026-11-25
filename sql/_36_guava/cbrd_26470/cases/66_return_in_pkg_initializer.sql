/**
 *  This test case verifies CBRD-26470 (PR #7819): RETURN in the initialization block of a package
 *  body.
 *
 *  Background:
 *    - Symptom: RETURN in the initialization block was refused with "function null must return a
 *      value". Letting a RETURN without a value pass would put return; into the Java static { }
 *      block and give "Unable to compile the source".
 *    - Fix: the routineType of the initialization block is PKG_INIT. RETURN without a value is
 *      allowed and RETURN with a value is refused with s113. The initialization body is generated
 *      as a private static method initPkg() called by static { }.
 *  Each package is first used through a stored function w66_N that calls its function f.
 *
 *  Coverage:
 *    Case 1: RETURN in IF, the INSERT after it does not run
 *    Case 2: RETURN in a nested DECLARE block, the INSERT after the outer block does not run
 *    Case 3: RETURN in the exception handler ends the initialization
 *    Case 4: initialization block without RETURN runs every INSERT (regression)
 *    Case 5: RETURN 3 in the initialization block -> s113
 *    Case 6: RETURN 3 in a nested block -> s113
 *    Case 7: RETURN 1 in a body procedure (regression) -> s031
 *    Case 8: RETURN in a body function (regression) -> s030
 */

--+ server-message on

drop table if exists t66_1, t66_2, t66_3, t66_4;
drop package if exists p66_1;
drop package if exists p66_2;
drop package if exists p66_3;
drop package if exists p66_4;

CREATE TABLE t66_1 (a INT);
CREATE TABLE t66_2 (a INT);
CREATE TABLE t66_3 (a INT);
CREATE TABLE t66_4 (a INT);
CREATE OR REPLACE PACKAGE p66_1 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p66_1 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT COUNT(*) INTO n FROM t66_1; RETURN n; END;
BEGIN
INSERT INTO t66_1 VALUES (1);
IF f() = 1 THEN
RETURN;
END IF;
INSERT INTO t66_1 VALUES (2);
END;
CREATE OR REPLACE PACKAGE p66_2 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p66_2 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT COUNT(*) INTO n FROM t66_2; RETURN n; END;
BEGIN
INSERT INTO t66_2 VALUES (1);
DECLARE
n INT := 0;
BEGIN
IF n = 0 THEN
RETURN;
END IF;
END;
INSERT INTO t66_2 VALUES (2);
END;
CREATE OR REPLACE PACKAGE p66_3 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p66_3 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT COUNT(*) INTO n FROM t66_3; RETURN n; END;
BEGIN
DECLARE n INT; BEGIN n := 1 / 0; END;
INSERT INTO t66_3 VALUES (9);
EXCEPTION
WHEN ZERO_DIVIDE THEN
INSERT INTO t66_3 VALUES (1);
RETURN;
END;
CREATE OR REPLACE PACKAGE p66_4 AS FUNCTION f RETURN INT; END;
CREATE OR REPLACE PACKAGE BODY p66_4 AS
FUNCTION f RETURN INT AS n INT; BEGIN SELECT COUNT(*) INTO n FROM t66_4; RETURN n; END;
BEGIN
INSERT INTO t66_4 VALUES (1);
INSERT INTO t66_4 VALUES (2);
END;
CREATE OR REPLACE FUNCTION w66_1 RETURN INT AS BEGIN RETURN p66_1.f(); END;
CREATE OR REPLACE FUNCTION w66_2 RETURN INT AS BEGIN RETURN p66_2.f(); END;
CREATE OR REPLACE FUNCTION w66_3 RETURN INT AS BEGIN RETURN p66_3.f(); END;
CREATE OR REPLACE FUNCTION w66_4 RETURN INT AS BEGIN RETURN p66_4.f(); END;


evaluate 'Case 1: RETURN in IF -> 1';
select w66_1() from dual;

evaluate 'Case 2: RETURN in a nested block -> 1';
select w66_2() from dual;

evaluate 'Case 3: RETURN in the exception handler -> 1';
select w66_3() from dual;

evaluate 'Case 4: no RETURN -> 2';
select w66_4() from dual;

evaluate 'Case 5: RETURN 3 in the initializer -> package initialization block may not return a value';
create or replace package body p66_4 as
function f return int as begin return 1; end;
begin
return 3;
end;

evaluate 'Case 6: RETURN 3 in a nested block of the initializer -> package initialization block may not return a value';
create or replace package body p66_4 as
function f return int as begin return 1; end;
begin
declare n int; begin return 3; end;
end;

evaluate 'Case 7: RETURN 1 in a body procedure -> procedure Q may not return a value';
create or replace package body p66_4 as
function f return int as begin return 1; end;
procedure q as begin return 1; end;
end;

evaluate 'Case 8: RETURN in a body function -> function F must return a value';
create or replace package body p66_4 as
function f return int as begin return; end;
end;


drop function w66_1, w66_2, w66_3, w66_4;
drop package p66_1;
drop package p66_2;
drop package p66_3;
drop package p66_4;
drop table t66_1, t66_2, t66_3, t66_4;

--+ server-message off
