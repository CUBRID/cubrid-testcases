/**
 *  This test case verifies CBRD-26470 (PR #7819): the error for a name that matches both
 *  <user>.<name> and <package>.<name> while compiling PL/CSQL (review round 7, Q1).
 *
 *  Before the fix it was ER_FAILED with a hand-written message (without the final '.').
 *  After the fix it is ER_SP_AMBIGUOUS_NAME (-1401), the message used by ALTER and GRANT.
 *  The user amb87 owns a function q and a procedure p, and dba owns a package amb87 with the
 *  members q and p.
 *
 *  Coverage:
 *    Case 1: function call amb87.q()   -> Ambiguous: 'AMB87.Q' matches both <user>.<name> pattern
 *            and <package>.<name> pattern.
 *    Case 2: procedure call amb87.p(); -> Ambiguous: 'AMB87.P' ...
 */

--+ server-message on

drop package if exists amb87;

CREATE USER amb87;
CREATE OR REPLACE FUNCTION amb87.q RETURN INT AS BEGIN RETURN 1; END;
CREATE OR REPLACE PROCEDURE amb87.p AS BEGIN NULL; END;
CREATE OR REPLACE PACKAGE amb87 AS FUNCTION q RETURN INT; PROCEDURE p; END;
CREATE OR REPLACE PACKAGE BODY amb87 AS
  FUNCTION q RETURN INT AS BEGIN RETURN 2; END;
  PROCEDURE p AS BEGIN NULL; END;
END;


evaluate 'Case 1: function call amb87.q() -> Ambiguous';
CREATE OR REPLACE FUNCTION c87 RETURN INT AS BEGIN RETURN amb87.q(); END;

evaluate 'Case 2: procedure call amb87.p(); -> Ambiguous';
CREATE OR REPLACE PROCEDURE d87 AS BEGIN amb87.p(); END;


drop function amb87.q;
drop procedure amb87.p;
drop package if exists amb87;
drop user amb87;

--+ server-message off
