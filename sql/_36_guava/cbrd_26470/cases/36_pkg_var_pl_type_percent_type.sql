/**
 *  This test case verifies CBRD-26470: catalog types of PL-only types in packages and the %TYPE
 *  lookup messages.
 *
 *  Before the fix the return type of a package function returning SYS_REFCURSOR was stored as -1,
 *  so calling it from another SP gave "unsupported type UNKNOWN (code -1)" while a standalone
 *  function (stored as 28, DB_RESULTSET) gave "a function that returns a query result set cannot
 *  be called from PL/CSQL". Now the package function is stored as 28 and gives the same error.
 *  Package variables of PL-only types (BOOLEAN, SYS_REFCURSOR, record) are stored with their own
 *  codes too, but package variable declarations are not supported yet, so those cases are left
 *  out here. A failed %TYPE target lookup on the server now says what was looked for instead of
 *  "Failed to get attribute information".
 *
 *  Coverage:
 *    Case 1: package SYS_REFCURSOR function called from another SP: "a function that returns a
 *            query result set cannot be called from PL/CSQL"
 *    Case 2: table.column%TYPE (regression): 5
 *    Case 3: BOOLEAN return type of a package function (regression): "cannot be used as a return
 *            type of stored functions"
 *    Case 4: nonexistent package variable pkb36.nosuch%TYPE: "is neither a table column nor a
 *            package variable or constant"
 *    Case 5: nonexistent table column t36.nosuch%TYPE: the same message
 */

--+ server-message on

drop table if exists t36;
drop package if exists pkb36;
drop package if exists pk36_7;
create table t36 (a int);
insert into t36 values (1), (2);
create or replace package pkb36 as function rf return sys_refcursor; end;
create or replace package body pkb36 as function rf return sys_refcursor as x sys_refcursor; begin open x for select a from t36; return x; end; end;


evaluate 'Case 1: package SYS_REFCURSOR function called from another SP: a function that returns a query result set cannot be called from PL/CSQL';
create or replace function w36_5 return int as c sys_refcursor; begin c := pkb36.rf (); return 1; end;


evaluate 'Case 2: table.column%TYPE (regression): 5';
create or replace function w36_6 return int as x t36.a%TYPE := 5; begin return x; end;
select w36_6 () from dual;


evaluate 'Case 3: BOOLEAN return type of a package function (regression): cannot be used as a return type of stored functions';
create or replace package pk36_7 as function f return boolean; end;


evaluate 'Case 4: nonexistent package variable pkb36.nosuch%TYPE: is neither a table column nor a package variable or constant';
create or replace function w36_9b return int as x pkb36.nosuch%TYPE; begin return 1; end;


evaluate 'Case 5: nonexistent table column t36.nosuch%TYPE: is neither a table column nor a package variable or constant';
create or replace function w36_9c return int as x t36.nosuch%TYPE; begin return 1; end;

drop function w36_6;
drop package pkb36;
drop table t36;

--+ server-message off
