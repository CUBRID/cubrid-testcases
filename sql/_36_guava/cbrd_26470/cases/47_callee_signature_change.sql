/**
 *  This test case verifies CBRD-26470 (PR #7819): a direct caller compiled before its callee
 *  changes its signature or kind, loses a package member, or has no package body.
 *
 *  Background:
 *    - A direct call is bound by name when it is called. When the generated code first reaches
 *      the call site, it goes through checkExecuteAuthorization () (a missing member gives
 *      "does not exist"), findTargetClass () (a missing Func_/Proc_/Pckg_ class gives "cannot find
 *      executable binary of ... (was it dropped)") and reflectMethod () (getMethod with the
 *      parameter classes known when the caller was compiled gives "cannot find method X in the
 *      executable binary (hint: try recompiling this stored procedure)"), and the return value is
 *      cast to the type known when the caller was compiled (ClassCastException gives "type of a
 *      value does not match the one known at compile time").
 *    - A routine of a package without a body (spec only, or after DROP PACKAGE BODY) throws
 *      IMPL_NOT_GIVEN ("no implementation in the package body"). Once a body exists, a caller
 *      that is not recompiled calls the new body.
 *    - In every case a defined SQL error must be given, not a wrong value or an internal error.
 *  (The original shell test ran each step in a new csql session.)
 *
 *  Coverage:
 *    Case 1:  w47 () calls cal47 () RETURN INT                      -> the value of cal47
 *    Case 2:  cal47 replaced with RETURN VARCHAR                    -> type of a value does not match error
 *    Case 3:  cal47 replaced with cal47 (a INT)                     -> cannot find method error
 *    Case 4:  cal47 restored to RETURN INT, w47 not recompiled      -> the new value of cal47
 *    Case 5:  wct47 () calls ct47 (a INT)                           -> the value of ct47
 *    Case 6:  ct47 replaced with ct47 (a VARCHAR)                   -> cannot find method, caught by the caller
 *    Case 7:  ALTER FUNCTION wct47 COMPILE                          -> the value of the new ct47
 *    Case 8:  ct47 dropped and created again as a procedure         -> cannot find executable binary, caught by the caller
 *    Case 9:  spec-only package pq47, function                      -> no implementation in the package body, caught
 *    Case 10: spec-only package pq47, procedure                     -> error, no implementation in the package body
 *    Case 11: after CREATE PACKAGE BODY, function                   -> the value of the new body
 *    Case 12: after CREATE PACKAGE BODY, procedure                  -> success
 *    Case 13: after DROP PACKAGE BODY, function                     -> same as case 9
 *    Case 14: after DROP PACKAGE BODY, procedure                    -> same as case 10
 *    Case 15: body created again with a + 200                       -> the value of the new body
 *    Case 16: f removed from the package, function                  -> does not exist, caught by the caller
 *             (In SA mode this fails since develop: the error context is left, so the call caught
 *              by WHEN OTHERS becomes a statement error. This SQL test runs in CS mode only.)
 *    Case 17: p removed from the package, procedure                 -> error, does not exist
 */

--+ server-message on

drop package if exists pq47;

create or replace function cal47 return int as begin return 1; end;
create or replace function w47 return int as begin return cal47(); end;
create or replace function ct47 (a int) return varchar as begin return 'int:' || a; end;
create or replace function wct47 return varchar as begin return ct47(5);
exception when others then return 'caught: ' || sqlerrm; end;
create or replace package pq47 as function f (a int) return int; procedure p; end;
create or replace function wq47 return varchar as begin return 'r=' || pq47.f(1);
exception when others then return 'caught: ' || sqlerrm; end;
create or replace procedure csp47 as begin pq47.p(); end;


evaluate 'Case 1: w47 () calls cal47 () RETURN INT -> 1';
select w47() from db_root;


evaluate 'Case 2: cal47 replaced with RETURN VARCHAR -> type of a value does not match the one known at compile time';
create or replace function cal47 return varchar as begin return 'abc'; end;
select w47() from db_root;


evaluate 'Case 3: cal47 replaced with cal47 (a INT) -> cannot find method CAL47 in the executable binary';
create or replace function cal47 (a int) return int as begin return a; end;
select w47() from db_root;


evaluate 'Case 4: cal47 restored to RETURN INT, w47 not recompiled -> 5';
create or replace function cal47 return int as begin return 5; end;
select w47() from db_root;


evaluate 'Case 5: wct47 () calls ct47 (a INT) -> int:5';
select wct47() from db_root;


evaluate 'Case 6: ct47 replaced with ct47 (a VARCHAR) -> caught: cannot find method CT47 in the executable binary';
create or replace function ct47 (a varchar) return varchar as begin return 'vc:' || a; end;
select wct47() from db_root;


evaluate 'Case 7: ALTER FUNCTION wct47 COMPILE -> vc:5';
alter function wct47 compile;
select wct47() from db_root;


evaluate 'Case 8: ct47 dropped and created again as a procedure -> caught: cannot find executable binary of dba.ct47 (was it dropped?)';
drop function ct47;
create or replace procedure ct47 (a int) as begin null; end;
select wct47() from db_root;


evaluate 'Case 9: spec-only package, function -> caught: Stored procedure execute error: no implementation in the package body';
select wq47() from db_root;


evaluate 'Case 10: spec-only package, procedure -> error: no implementation in the package body';
call csp47();


evaluate 'Case 11: after CREATE PACKAGE BODY, function -> r=101';
create or replace package body pq47 as
  function f (a int) return int as begin return a + 100; end;
  procedure p as begin null; end;
end;
select wq47() from db_root;


evaluate 'Case 12: after CREATE PACKAGE BODY, procedure -> success';
call csp47();


evaluate 'Case 13: after DROP PACKAGE BODY, function -> caught: Stored procedure execute error: no implementation in the package body';
drop package body pq47;
select wq47() from db_root;


evaluate 'Case 14: after DROP PACKAGE BODY, procedure -> error: no implementation in the package body';
call csp47();


evaluate 'Case 15: body created again with a + 200 -> r=201';
create or replace package body pq47 as
  function f (a int) return int as begin return a + 200; end;
  procedure p as begin null; end;
end;
select wq47() from db_root;


evaluate 'Case 16: f removed from the package, function -> caught: Stored procedure/function dba.pq47.f does not exist';
create or replace package pq47 as function g return int; end;
create or replace package body pq47 as function g return int as begin return 0; end; end;
select wq47() from db_root;


evaluate 'Case 17: p removed from the package, procedure -> Stored procedure/function dba.pq47.p does not exist';
call csp47();


drop function cal47;
drop function w47;
drop procedure ct47;
drop function wct47;
drop function wq47;
drop procedure csp47;
drop package pq47;

--+ server-message off
