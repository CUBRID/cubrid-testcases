/**
 *  This test case verifies CBRD-26470 (PR #7819): long unique names of package routines
 *  (review round 6, E4, and the 255-byte boundary).
 *
 *  E4: a package routine whose <package>.<routine> was 223 bytes or longer could not be called
 *      from PL/CSQL ("Neither stored function ... exists"). jsp_user_specified_name() took a
 *      dotted name as <owner>.<name> and limited <name> to less than 223 (255 - 32) bytes, so
 *      <package>.<routine> of the unique name <owner>.<package>.<routine> got that check.
 *      Fix: for a dotted name only the whole size is checked and the name is only lowercased.
 *  Boundary: a unique name of exactly 255 bytes was created (the buffer is
 *      SP_ATTR_UNIQUE_NAME_LEN + 1) but the lookup accepted only names shorter than 255 bytes, so
 *      it could not be called. Fix: creation refuses 255 bytes or longer (-1397, new message).
 *
 *  Coverage:
 *    Case 1: E4 <P>.<R>() (100 + 122 chars, unique name 227 bytes)     -> runs
 *    Case 2: the same routine called as dba.<P>.<R>()                  -> runs
 *    Case 3: unique name of 254 bytes (125 + 124 chars)                -> created, whole name stored
 *    Case 4: package specification whose unique name is 255 bytes (125 + 125 chars)
 *            -> refused: unique name must be shorter than 255 bytes
 *    Case 5: short names pk79.f(), dba.pk79.f()                        -> run
 */

--+ server-message on

drop package if exists p79ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp;
drop package if exists q79qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq;
drop package if exists t79tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt;
drop package if exists pk79;

CREATE OR REPLACE PACKAGE p79ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp AS
  FUNCTION rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY p79ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp AS
  FUNCTION rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr RETURN INT AS
  BEGIN
    RETURN 1;
  END;
END;

CREATE OR REPLACE PACKAGE q79qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq AS
  FUNCTION ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY q79qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq AS
  FUNCTION ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss RETURN INT AS
  BEGIN
    RETURN 254;
  END;
END;

CREATE OR REPLACE PACKAGE pk79 AS
  FUNCTION f RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pk79 AS
  FUNCTION f RETURN INT AS
  BEGIN
    RETURN 5;
  END;
END;

evaluate 'Case 1: E4 <P>.<R>() (unique name 227 bytes) -> 1';
CREATE OR REPLACE FUNCTION w79_1 RETURN INT AS
BEGIN
  RETURN p79ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp.rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr();
END;
select w79_1() from dual;

evaluate 'Case 2: E4 dba.<P>.<R>() -> 1';
CREATE OR REPLACE FUNCTION w79_2 RETURN INT AS
BEGIN
  RETURN dba.p79ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp.rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr();
END;
select w79_2() from dual;

evaluate 'Case 3: unique name 254 bytes -> 254';
CREATE OR REPLACE FUNCTION w79_3 RETURN INT AS
BEGIN
  RETURN q79qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq.ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss();
END;
select w79_3() from dual;

evaluate 'Case 4: unique name 255 bytes -> refused, unique name must be shorter than 255 bytes';
CREATE OR REPLACE PACKAGE t79tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt AS
  FUNCTION uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu RETURN INT;
END;
select count(*) from _db_package where pkg_name = 't79tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt';

evaluate 'Case 5: short names pk79.f(), dba.pk79.f() -> 5, 5';
CREATE OR REPLACE FUNCTION w79_5 RETURN INT AS
BEGIN
  RETURN pk79.f() + 0 * dba.pk79.f();
END;
CREATE OR REPLACE FUNCTION x79_5 RETURN INT AS
BEGIN
  RETURN dba.pk79.f();
END;
select w79_5(), x79_5() from dual;

drop function w79_1, w79_2, w79_3, w79_5, x79_5;
drop package if exists p79ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp;
drop package if exists q79qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq;
drop package if exists t79tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt;
drop package if exists pk79;

--+ server-message off
