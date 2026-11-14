/**
 *  This test case verifies CBRD-26470 (PR #7819): the DBMS_OUTPUT routine name in compile error
 *  messages (review round 5, D5).
 *
 *  A call DBMS_OUTPUT.X is turned into the internal name DBMS_OUTPUT$X. After
 *  Misc.detachPkgName() was removed, the three messages below showed the internal name
 *  DBMS_OUTPUT$X, while develop shows X. The fix restores Misc.detachPkgName() for the three
 *  messages. Calls to members of other packages keep the qualified name PK.Q, and calls in the
 *  same package keep Q.
 *
 *  Coverage:
 *    Case 1: s214 (argument type)      -> PUT_LINE, position of the argument
 *    Case 2: s044 (number of arguments) -> PUT_LINE, position of the call
 *    Case 3: s045 (OUT argument)        -> GET_LINE, position of the argument
 *    Case 4: a member of another package keeps its qualified name PK74.Q
 *    Case 5: a member of the same package is Q
 *    Case 6: valid DBMS_OUTPUT calls are created
 */

--+ server-message on

drop package if exists pk74;
drop package if exists pk74b;
drop table if exists tdo74;

CREATE TABLE tdo74 (a INT);
CREATE OR REPLACE PACKAGE pk74 AS PROCEDURE q(x INT); END;
CREATE OR REPLACE PACKAGE BODY pk74 AS PROCEDURE q(x INT) AS BEGIN NULL; END; END;


evaluate 'Case 1: s214 argument type -> argument 1 to the call of PUT_LINE has an incompatible type TDO74%ROWTYPE';
CREATE OR REPLACE PROCEDURE p74a AS r tdo74%ROWTYPE; BEGIN DBMS_OUTPUT.PUT_LINE(r); END;

evaluate 'Case 2: s044 number of arguments -> procedure PUT_LINE';
CREATE OR REPLACE PROCEDURE p74b AS BEGIN DBMS_OUTPUT.PUT_LINE('a', 'b'); END;

evaluate 'Case 3: s045 OUT argument -> the procedure GET_LINE';
CREATE OR REPLACE PROCEDURE p74c AS n INT; BEGIN DBMS_OUTPUT.GET_LINE(1, n); END;

evaluate 'Case 4: a member of another package keeps its qualified name -> the call of PK74.Q';
CREATE OR REPLACE PROCEDURE p74d AS r tdo74%ROWTYPE; BEGIN pk74.q(r); END;

evaluate 'Case 5: a member of the same package -> the call of Q';
CREATE OR REPLACE PACKAGE pk74b AS PROCEDURE a; END;
CREATE OR REPLACE PACKAGE BODY pk74b AS PROCEDURE q(x INT) AS BEGIN NULL; END; PROCEDURE a AS r tdo74%ROWTYPE; BEGIN q(r); END; END;

evaluate 'Case 6: valid DBMS_OUTPUT calls -> created';
CREATE OR REPLACE PROCEDURE p74f AS s VARCHAR; n INT; BEGIN DBMS_OUTPUT.PUT_LINE('a'); DBMS_OUTPUT.GET_LINE(s, n); END;


drop procedure p74f;
drop package if exists pk74;
drop package if exists pk74b;
drop table if exists tdo74;

--+ server-message off
