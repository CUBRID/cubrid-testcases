/**
 *  This test case verifies CBRD-26470 (PR #7819): error positions in a recursion of direct calls
 *  A -> B -> A (review round 6, E7; round 4, D4).
 *
 *  When A -> B -> A was made of direct calls, the error position of the inner A was given as the
 *  call position of the outer A. In a direct call the callee's exception object goes up to the
 *  caller as it is (SpLib.invokeMethod, nestInCaller), so one stack trace, from the first error
 *  point to the bottom, was shared by the catch of every activation. getPlcLineColumn() scanned
 *  that trace from the bottom and picked the first segment of the same class, so the catch of the
 *  inner A also picked the segment of the outer A. Calls through the server (e.g. with default
 *  values omitted) were fine because a new exception is made in the caller.
 *  Fix: each catch stores in the exception the index after the outermost frame of the same-file
 *  segment where it found the position (frameIndex), and an outer catch scans down from that
 *  index and picks the position from the first same-file segment. The trace is not refilled.
 *  A Java exception that is not a PlcsqlRuntimeError (ClassCastException, ...) happens inside
 *  that activation, so the first same-file frame from the top is picked.
 *
 *  Each error message lists the positions from the outermost to the innermost activation.
 *  The routine bodies are not indented: CTP strips the leading spaces of each line, so the
 *  columns would differ between CTP and csql otherwise.
 *
 *  Coverage:
 *    Case 1:  A -> B -> A, division by zero in the inner A
 *             -> (6,8) (3,8) (4,8)  (before the fix the last position was that of the outer A)
 *    Case 2:  A -> B -> A -> B -> A   -> (6,8) (3,8) (6,8) (3,8) (4,8)
 *    Case 3:  across packages pk81a.f -> pk81b.g -> pk81a.h -> (3,8) (4,8) (4,8) (8,8)
 *    Case 4:  error in a local function of the inner A -> (10,8) (3,8) (4,8)
 *    Case 5:  one level without recursion (regression) -> (3,8)
 *    Case 6:  self recursion inside one unit (an internal call, one position) -> (4,8)
 *    Case 7:  deep mutual recursion (A and B 200 times each), then an error: the innermost
 *             position is (4,8) and the message is division by zero (the middle is cut to "...")
 *    Case 8:  A -> B -> A through the server, because of default values (regression)
 *             -> (6,8) (3,8) (4,8)
 *    Case 9:  a Java exception that is not a PlcsqlRuntimeError (ClassCastException) in the
 *             inner A: the return type of the callee cc81 is changed without recompiling its
 *             callers. The last position is that of 'cc81(0) + 1' (4,8) of the inner ta81
 *             (before the fix (6,8) of the outer ta81)
 *    Case 10: the same, two rounds
 *    Case 11: deep mutual recursion (A and B 150 times each), then an error: the frames of the
 *             outer activations are not in the stack trace (only the top 1024 are kept), so the
 *             outermost position is unknown: the first position is (line ?, column ?) and the
 *             last is (4,8) of the inner A
 */

--+ server-message on

drop package if exists pk81a;
drop package if exists pk81b;

CREATE OR REPLACE FUNCTION mr81_b(n INT) RETURN INT AS BEGIN RETURN 0; END;
CREATE OR REPLACE FUNCTION mr81_a(n INT) RETURN INT AS
BEGIN
IF n = 0 THEN
RETURN 10 / n;
END IF;
RETURN mr81_b(n - 1);
END;
CREATE OR REPLACE FUNCTION mr81_b(n INT) RETURN INT AS
BEGIN
RETURN mr81_a(n);
END;

CREATE OR REPLACE PACKAGE pk81a AS
FUNCTION f(n INT) RETURN INT;
FUNCTION h(n INT) RETURN INT;
END;
CREATE OR REPLACE PACKAGE pk81b AS
FUNCTION g(n INT) RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pk81a AS
FUNCTION f(n INT) RETURN INT AS
BEGIN
RETURN pk81b.g(n);
END;
FUNCTION h(n INT) RETURN INT AS
BEGIN
RETURN 10 / n;
END;
END;
CREATE OR REPLACE PACKAGE BODY pk81b AS
FUNCTION g(n INT) RETURN INT AS
BEGIN
RETURN pk81a.h(n);
END;
END;
CREATE OR REPLACE FUNCTION w81_3(n INT) RETURN INT AS
BEGIN
RETURN pk81a.f(n);
END;

CREATE OR REPLACE FUNCTION lc81_b(n INT) RETURN INT AS BEGIN RETURN 0; END;
CREATE OR REPLACE FUNCTION lc81_a(n INT) RETURN INT AS
FUNCTION loc(m INT) RETURN INT AS
BEGIN
RETURN 10 / m;
END;
BEGIN
IF n = 0 THEN
RETURN loc(n);
END IF;
RETURN lc81_b(n - 1);
END;
CREATE OR REPLACE FUNCTION lc81_b(n INT) RETURN INT AS
BEGIN
RETURN lc81_a(n);
END;

CREATE OR REPLACE FUNCTION f81_5(n INT) RETURN INT AS
BEGIN
RETURN 10 / n;
END;
CREATE OR REPLACE FUNCTION r81_5(n INT) RETURN INT AS
BEGIN
IF n = 0 THEN
RETURN 10 / n;
END IF;
RETURN r81_5(n - 1);
END;

CREATE OR REPLACE FUNCTION sv81_b(n INT, d INT := 0) RETURN INT AS BEGIN RETURN 0; END;
CREATE OR REPLACE FUNCTION sv81_a(n INT, d INT := 0) RETURN INT AS
BEGIN
IF n = 0 THEN
RETURN 10 / n;
END IF;
RETURN sv81_b(n - 1);
END;
CREATE OR REPLACE FUNCTION sv81_b(n INT, d INT := 0) RETURN INT AS
BEGIN
RETURN sv81_a(n);
END;

CREATE OR REPLACE FUNCTION cc81(n INT) RETURN INT AS BEGIN RETURN 1; END;
CREATE OR REPLACE FUNCTION tb81(n INT) RETURN INT AS BEGIN RETURN 0; END;
CREATE OR REPLACE FUNCTION ta81(n INT) RETURN INT AS
BEGIN
IF n = 0 THEN
RETURN cc81(0) + 1;
END IF;
RETURN tb81(n - 1);
END;
CREATE OR REPLACE FUNCTION tb81(n INT) RETURN INT AS
BEGIN
RETURN ta81(n);
END;
CREATE OR REPLACE FUNCTION cc81(n INT) RETURN VARCHAR AS BEGIN RETURN 'x'; END;


evaluate 'Case 1: A -> B -> A -> (6,8) (3,8) (4,8) division by zero';
select mr81_a(1) from dual;

evaluate 'Case 2: A -> B -> A -> B -> A -> (6,8) (3,8) (6,8) (3,8) (4,8) division by zero';
select mr81_a(2) from dual;

evaluate 'Case 3: pk81a.f -> pk81b.g -> pk81a.h -> (3,8) (4,8) (4,8) (8,8) division by zero';
select w81_3(0) from dual;

evaluate 'Case 4: local function in the inner A -> (10,8) (3,8) (4,8) division by zero';
select lc81_a(1) from dual;

evaluate 'Case 5: one level -> (3,8) division by zero';
select f81_5(0) from dual;

evaluate 'Case 6: self recursion in a unit -> (4,8) division by zero';
select r81_5(2) from dual;

evaluate 'Case 7: deep mutual recursion -> innermost (4,8) division by zero';
select mr81_a(200) from dual;

evaluate 'Case 8: through the server -> (6,8) (3,8) (4,8) division by zero';
select sv81_a(1) from dual;

evaluate 'Case 9: Java exception in the inner A -> (6,8) (3,8) (4,8) type of a value does not match';
select ta81(1) from dual;

evaluate 'Case 10: Java exception, two rounds -> (6,8) (3,8) (6,8) (3,8) (4,8) type of a value does not match';
select ta81(2) from dual;

evaluate 'Case 11: outermost position unknown -> first (line ?, column ?), last (4,8) division by zero';
select mr81_a(150) from dual;


drop function mr81_a, mr81_b, w81_3, lc81_a, lc81_b, f81_5, r81_5, sv81_a, sv81_b, cc81, ta81, tb81;
drop package if exists pk81a;
drop package if exists pk81b;

--+ server-message off
