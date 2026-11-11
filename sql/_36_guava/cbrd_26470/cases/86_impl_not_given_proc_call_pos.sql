/**
 *  This test case verifies CBRD-26470 (PR #7819): the error position of a procedure call statement
 *  to a package procedure that has no implementation (review round 7, G5).
 *
 *  A call to a specification item without an implementation becomes implNotGiven(), and the
 *  exception is raised at the call. A function call kept its position, but a procedure call
 *  statement (StmtLocalProcCall) did not, so the position of the enclosing statement or of the
 *  whole unit (1,1) was given. After the fix the position of the call statement is given.
 *  Line numbers count from the package body (CREATE OR REPLACE PACKAGE BODY is line 1).
 *  The body is not indented: CTP strips the leading spaces of each line, so the columns would
 *  differ between CTP and csql otherwise.
 *
 *  Coverage:
 *    Case 1: call statement without arguments q();         -> (line 4, column 1)
 *    Case 2: call statement with an argument q2(1); in IF   -> (line 9, column 1)
 *    Case 3: call statement qualified by its own package pn86.q(); -> (line 14, column 1)
 *    Case 4: call of a function without an implementation (correct before the fix too)
 *            -> (line 18, column 8)
 */

--+ server-message on

drop package if exists pn86;

CREATE OR REPLACE PACKAGE pn86 AS
PROCEDURE p1; PROCEDURE p2; PROCEDURE p3; FUNCTION p4 RETURN INT;
PROCEDURE q; PROCEDURE q2(a INT); FUNCTION qf RETURN INT;
END;
CREATE OR REPLACE PACKAGE BODY pn86 AS
PROCEDURE p1 AS
BEGIN
q();
END;
PROCEDURE p2 AS
BEGIN
IF 1 = 1 THEN
q2(1);
END IF;
END;
PROCEDURE p3 AS
BEGIN
pn86.q();
END;
FUNCTION p4 RETURN INT AS
BEGIN
RETURN qf();
END;
END;
CREATE OR REPLACE PROCEDURE c86_1 AS BEGIN pn86.p1(); END;
CREATE OR REPLACE PROCEDURE c86_2 AS BEGIN pn86.p2(); END;
CREATE OR REPLACE PROCEDURE c86_3 AS BEGIN pn86.p3(); END;
CREATE OR REPLACE FUNCTION c86_4 RETURN INT AS BEGIN RETURN pn86.p4(); END;


evaluate 'Case 1: q(); with no argument -> (line 4, column 1) no implementation in the package body';
call c86_1();

evaluate 'Case 2: q2(1); in IF -> (line 9, column 1) no implementation in the package body';
call c86_2();

evaluate 'Case 3: pn86.q(); qualified by its own package -> (line 14, column 1) no implementation in the package body';
call c86_3();

evaluate 'Case 4: qf() in an expression -> (line 18, column 8) no implementation in the package body';
select c86_4() from dual;


drop procedure c86_1, c86_2, c86_3;
drop function c86_4;
drop package if exists pn86;

--+ server-message off
