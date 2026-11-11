/**
 *  This test case verifies CBRD-26470 (PR #7819): a caller that is not recompiled after a DEFAULT
 *  parameter is added to its callee (review round 6, E8).
 *
 *  A caller generates its direct call (reflection) code from the callee header at its own
 *  compilation. When a DEFAULT parameter is added to the callee, the parameter classes of its
 *  method change and reflectMethod() cannot find the method. The root cause, that a caller is
 *  neither invalidated nor recompiled when its callee changes, is handled in a separate issue.
 *  This PR adds to the error message a hint to recompile the caller (the same wording as the
 *  ClassCastException message for a changed return type).
 *
 *  Coverage:
 *    Case 1: a82() before the change -> 1
 *    Case 2: a82() after adding x VARCHAR DEFAULT 'xy' to b82
 *            -> "(line 1, column 59) cannot find method B82 in the executable binary
 *               (hint: try recompiling this stored procedure)"  (59 is 'b82(1)' in a82)
 *    Case 3: a82() after ALTER FUNCTION a82 COMPILE -> 3 (= 1 + LENGTH('xy'))
 *    Case 4: c82() calling the package routine pk82.h, before the change -> 10
 *    Case 5: c82() after adding a DEFAULT parameter to pk82.h -> the same error with the hint,
 *            at 'pk82.h(1)' (line 1, column 59)
 *            (the body is dropped first: with a body, replacing the specification recompiles the
 *            old body and gives a header mismatch error)
 *            c82() is not recompiled and checked: pk82.h(1) would be compiled as a call with
 *            the DEFAULT omitted, which goes through the server, and calling a package routine
 *            from SQL is not supported yet ("Methods require an object as their target",
 *            review round 2 X1, a separate issue CBRD-27526)
 */

--+ server-message on

drop package if exists pk82;

CREATE OR REPLACE FUNCTION b82(a INT) RETURN INT AS BEGIN RETURN a; END;
CREATE OR REPLACE FUNCTION a82 RETURN INT AS BEGIN RETURN b82(1); END;
CREATE OR REPLACE PACKAGE pk82 AS
  FUNCTION h(a INT) RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pk82 AS
  FUNCTION h(a INT) RETURN INT AS BEGIN RETURN a * 10; END;
END;
CREATE OR REPLACE FUNCTION c82 RETURN INT AS BEGIN RETURN pk82.h(1); END;


evaluate 'Case 1: a82() before the change -> 1';
select a82() from dual;

evaluate 'Case 2: a82() after adding a DEFAULT parameter to b82 -> cannot find method B82 ... (hint: try recompiling this stored procedure)';
CREATE OR REPLACE FUNCTION b82(a INT, x VARCHAR DEFAULT 'xy') RETURN INT AS BEGIN RETURN a + LENGTH(x); END;
select a82() from dual;

evaluate 'Case 3: a82() after ALTER FUNCTION a82 COMPILE -> 3';
ALTER FUNCTION a82 COMPILE;
select a82() from dual;

evaluate 'Case 4: c82() before the change -> 10';
select c82() from dual;

evaluate 'Case 5: c82() after adding a DEFAULT parameter to pk82.h -> cannot find method H ... (hint: try recompiling this stored procedure)';
DROP PACKAGE BODY pk82;
CREATE OR REPLACE PACKAGE pk82 AS
  FUNCTION h(a INT, x VARCHAR DEFAULT 'xy') RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pk82 AS
  FUNCTION h(a INT, x VARCHAR DEFAULT 'xy') RETURN INT AS BEGIN RETURN a * 10 + LENGTH(x); END;
END;
select c82() from dual;


drop function a82, b82, c82;
drop package if exists pk82;

--+ server-message off
