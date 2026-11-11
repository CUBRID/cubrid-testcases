/**
 *  This test case verifies CBRD-26470: an exception from a function called without parentheses
 *  is caught by the same handler of the caller as with parentheses.
 *
 *  A call with all arguments given, nd31 (), calls the generated Java method directly, so the
 *  NO_DATA_FOUND raised in the callee is caught by WHEN NO_DATA_FOUND of the caller. Before the
 *  fix a call without parentheses, nd31, went through the identifier path that did not set the
 *  target class, so it was always called through the server (?= call nd31()). The exception
 *  became a SQL error: CS caught it in WHEN OTHERS, and SA did not catch it at all and the
 *  statement failed. Now a call without parentheses is also a direct call.
 *
 *  Coverage:
 *    Case 1: nd31 () -> NDF
 *    Case 2: nd31    -> NDF
 *    Case 3: user defined exception: ue31 () and ue31 give the same (WHEN OTHERS, same SQLCODE)
 *    Case 4: normal value: one31 without parentheses called three times in a loop = 3
 */

--+ server-message on

drop table if exists t31;
create table t31 (a int);
create or replace function nd31 return int as n int; begin select a into n from t31 where 1 = 0; return n; end;
create or replace function ue31 return int as e exception; begin raise e; end;
create or replace function one31 return int as begin return 1; end;
create or replace function c31_1 return varchar as begin return nd31 (); exception when no_data_found then return 'NDF'; when others then return 'OTHERS ' || sqlcode; end;
create or replace function c31_2 return varchar as begin return nd31; exception when no_data_found then return 'NDF'; when others then return 'OTHERS ' || sqlcode; end;
create or replace function c31_3a return varchar as begin return ue31 (); exception when no_data_found then return 'NDF'; when others then return 'OTHERS ' || sqlcode; end;
create or replace function c31_3b return varchar as begin return ue31; exception when no_data_found then return 'NDF'; when others then return 'OTHERS ' || sqlcode; end;
create or replace function c31_4 return int as s int := 0; begin for i in 1 .. 3 loop s := s + one31; end loop; return s; end;


evaluate 'Case 1: nd31 () is caught by WHEN NO_DATA_FOUND: NDF';
select c31_1 () from dual;


evaluate 'Case 2: nd31 without parentheses is caught by WHEN NO_DATA_FOUND: NDF';
select c31_2 () from dual;


evaluate 'Case 3: ue31 () and ue31 give the same result (OTHERS with the same SQLCODE)';
select c31_3a (), c31_3b (), case when c31_3a () = c31_3b () then 'same' else 'different' end from dual;


evaluate 'Case 4: one31 without parentheses called in a loop: 3';
select c31_4 () from dual;

drop function c31_1, c31_2, c31_3a, c31_3b, c31_4, nd31, ue31, one31;
drop table t31;

--+ server-message off
