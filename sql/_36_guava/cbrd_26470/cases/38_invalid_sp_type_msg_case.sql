/**
 *  This test case verifies CBRD-26470 (PR #7819): the routine kind in the ER_SP_INVALID_TYPE
 *  message is written in upper case on every path.
 *
 *  Background:
 *    - The same error gave 'procedure'/'function' (lower case) when it was raised while compiling
 *      a PL/CSQL routine (method_callback.cpp), and 'PROCEDURE'/'FUNCTION' (upper case) when it
 *      was raised by DROP/ALTER (jsp_cl.cpp).
 *  Fix:
 *    - The compile-time error is also written in upper case.
 *
 *  Coverage:
 *    Case 1: a procedure called as a function in a PL/CSQL body -> 'PROCEDURE' (was 'procedure')
 *    Case 2: a function called as a procedure in a PL/CSQL body -> 'FUNCTION' (was 'function')
 *    Case 3: DROP FUNCTION on a procedure -> 'PROCEDURE' (regression)
 *    Case 4: DROP PROCEDURE on a function -> 'FUNCTION' (regression)
 */

--+ server-message on

create or replace procedure p38 as begin null; end;
create or replace function realf38 return int as begin return 1; end;


evaluate 'Case 1: procedure called as a function in PL/CSQL -> dba.p38 is the PROCEDURE';
create or replace function f38 return int as begin return p38(); end;


evaluate 'Case 2: function called as a procedure in PL/CSQL -> dba.realf38 is the FUNCTION';
create or replace procedure p38_9 as begin realf38(); end;


evaluate 'Case 3: DROP FUNCTION on a procedure -> dba.p38 is the PROCEDURE';
drop function p38;


evaluate 'Case 4: DROP PROCEDURE on a function -> dba.realf38 is the FUNCTION';
drop procedure realf38;


drop procedure p38;
drop function realf38;

--+ server-message off
