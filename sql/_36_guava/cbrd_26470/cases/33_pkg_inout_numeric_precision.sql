/**
 *  This test case verifies CBRD-26470: a public package procedure checks the precision of an
 *  IN OUT NUMERIC argument.
 *
 *  A top-level SP checks an IN OUT NUMERIC parameter (checkPrecision) in the main user code of the
 *  callee, because a call from another SP does not convert the value at the call site (the server
 *  signature has no precision). Before the fix the generated package member (visitDeclRoutine)
 *  had no such check, so a public member accepted an out of range value. Now a public member is
 *  checked with the same template as a top-level SP (tmplMainUserCode). A private member or a
 *  local routine is only called locally with known parameter types, so the conversion at the call
 *  site checks it.
 *
 *  The parameter is t33.a%TYPE = NUMERIC(5,1) and the caller variable is NUMERIC(10,3):
 *  12345.678 gives an error (ERR) and 12.345 gives 12.3 (rounded).
 *
 *  Coverage:
 *    Case 1: public package procedure called from another SP
 *    Case 2: private package procedure called from a public function of the same package
 *    Case 3: top-level procedure (regression)
 *    Case 4: local procedure (regression)
 */

--+ server-message on

drop table if exists t33;
drop package if exists pk33;
create table t33 (a numeric(5,1));
create or replace package pk33 as procedure p (x in out t33.a%TYPE); function viapriv (v numeric) return varchar; end;
create or replace package body pk33 as procedure p (x in out t33.a%TYPE) as begin null; end; procedure hp (x in out t33.a%TYPE) as begin null; end; function viapriv (v numeric) return varchar as w numeric(10,3) := v; begin hp (w); return to_char (w); exception when others then return 'ERR'; end; end;
create or replace function c33_1 (v numeric) return varchar as w numeric(10,3) := v; begin pk33.p (w); return to_char (w); exception when others then return 'ERR'; end;
create or replace function c33_2 (v numeric) return varchar as begin return pk33.viapriv (v); end;
create or replace procedure sp33 (x in out t33.a%TYPE) as begin null; end;
create or replace function c33_3 (v numeric) return varchar as w numeric(10,3) := v; begin sp33 (w); return to_char (w); exception when others then return 'ERR'; end;
create or replace function c33_4 (v numeric) return varchar as w numeric(10,3) := v; procedure lp (x in out t33.a%TYPE) as begin null; end; begin lp (w); return to_char (w); exception when others then return 'ERR'; end;


evaluate 'Case 1: public package procedure: 12345.678 -> ERR, 12.345 -> 12.3';
select c33_1 (12345.678), c33_1 (12.345) from dual;


evaluate 'Case 2: private package procedure: 12345.678 -> ERR, 12.345 -> 12.3';
select c33_2 (12345.678), c33_2 (12.345) from dual;


evaluate 'Case 3: top-level procedure: 12345.678 -> ERR, 12.345 -> 12.3';
select c33_3 (12345.678), c33_3 (12.345) from dual;


evaluate 'Case 4: local procedure: 12345.678 -> ERR, 12.345 -> 12.3';
select c33_4 (12345.678), c33_4 (12.345) from dual;

drop function c33_1, c33_2, c33_3, c33_4;
drop procedure sp33;
drop package pk33;
drop table t33;

--+ server-message off
