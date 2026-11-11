/**
 *  This test case verifies CBRD-26470 (PR #7819): the ER_SP_NOT_EXIST message of a call to a
 *  routine whose owner name is too long gives the name of the routine.
 *
 *  Background:
 *    - jsp_find_stored_procedure () normalizes the name with jsp_check_stored_procedure_name ().
 *      When the owner part is SM_MAX_USER_LENGTH (32) or longer, the name cannot be normalized
 *      and becomes an empty string, and ER_SP_NOT_EXIST was raised with that empty name:
 *      "Stored procedure/function '' does not exist."
 *  Fix:
 *    - The original name is put in the message.
 *
 *  Coverage:
 *    Case 1: PL/CSQL function call <u x 40>.pk40.g ()   -> '<u x 40>.pk40.g' (was '')
 *    Case 2: PL/CSQL procedure call <u x 40>.pk40.p ()  -> '<u x 40>.pk40.p' (was '')
 *    Case 3: SQL CALL <u x 40>.p40 ()                   -> '<u x 40>.p40' (was '')
 *    Case 4: missing package function dba.pk40.nosuch () -> 'dba.pk40.nosuch' (regression)
 *    Case 5: one-dot name with a long first part <u x 40>.g40 ()
 *            -> "Neither stored function ... nor package function ... exists." (regression)
 */

--+ server-message on

drop package if exists pk40;

create or replace package pk40 as function g return int; end;
create or replace package body pk40 as function g return int as begin return 1; end; end;


evaluate 'Case 1: PL/CSQL function call with a too long owner -> the name is in the message';
create or replace function x40_1 return int as begin return uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.pk40.g(); end;


evaluate 'Case 2: PL/CSQL procedure call with a too long owner -> the name is in the message';
create or replace procedure x40_2 as begin uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.pk40.p(); end;


evaluate 'Case 3: SQL CALL with a too long owner -> the name is in the message';
call uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.p40();


evaluate 'Case 4: missing package function (regression) -> dba.pk40.nosuch does not exist';
create or replace function x40_4 return int as begin return dba.pk40.nosuch(); end;


evaluate 'Case 5: one-dot name with a long first part (regression) -> neither stored function nor package function';
create or replace function x40_5 return int as begin return uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu.g40(); end;


drop package pk40;

--+ server-message off
