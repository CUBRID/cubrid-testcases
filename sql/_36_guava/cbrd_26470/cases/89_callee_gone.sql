/**
 *  This test case verifies CBRD-26470 (PR #7819): a direct call tells a dropped callee from a
 *  callee that the caller is not allowed to execute (review K9).
 *
 *  Before the fix both were reported as "no authorization to execute <name>".
 *
 *  Coverage:
 *    Case 1: ca89() calling cb89() directly -> 7
 *    Case 2: after DROP FUNCTION cb89, ca89() -> "does not exist" error, not "no authorization"
 *    Case 3: control: cb89() from SQL -> "Function cb89 is undefined" (the SQL path was always right)
 *    Case 4: as u89 holding EXECUTE on dba.peek89, wrap89() calling dba.peek89() -> 42
 *    Case 5: after REVOKE EXECUTE, wrap89() as u89 -> an authorization error, distinct from
 *            "does not exist"
 */

--+ server-message on

drop table if exists t89_sec;

evaluate 'Case 1: ca89() calls cb89() -> 7';
CREATE OR REPLACE FUNCTION cb89 RETURN INT AS BEGIN RETURN 7; END;
CREATE OR REPLACE FUNCTION ca89 RETURN INT AS BEGIN RETURN cb89(); END;
SELECT ca89();


evaluate 'Case 2: ca89() after DROP FUNCTION cb89 -> does not exist, not no authorization';
DROP FUNCTION cb89;
SELECT ca89();

evaluate 'Case 3: control: cb89() from SQL -> undefined';
SELECT cb89();


CREATE USER u89;
CREATE TABLE t89_sec (c INT);
INSERT INTO t89_sec VALUES (42);
CREATE OR REPLACE FUNCTION peek89 RETURN INT AS
  v INT;
BEGIN
  SELECT c INTO v FROM t89_sec;
  RETURN v;
END;
GRANT EXECUTE ON PROCEDURE peek89 TO u89;

evaluate 'Case 4: wrap89() of u89 calls dba.peek89() while the grant holds -> 42';
call login('u89', '') on class db_user;
CREATE OR REPLACE FUNCTION wrap89 RETURN INT AS BEGIN RETURN dba.peek89(); END;
SELECT wrap89();

call login('dba', '') on class db_user;
REVOKE EXECUTE ON PROCEDURE peek89 FROM u89;


evaluate 'Case 5: wrap89() of u89 after REVOKE -> authorization error, not does not exist';
call login('u89', '') on class db_user;
SELECT wrap89();


call login('dba', '') on class db_user;
drop function u89.wrap89;
drop function ca89, peek89;
drop table if exists t89_sec;
drop user u89;

--+ server-message off
