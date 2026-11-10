/**
 *  CBRD-27520: an unqualified <table>.<column>%TYPE in the parameter or return type of a
 *  PL/CSQL SP must refer to the object of the SP owner, not of the session user.
 *
 *  cbrd_27520.sql covers plain tables. This file covers the other kinds of %TYPE target,
 *  the remaining parameter modes and identifier spellings, and a session user that is a
 *  DBA group member rather than dba itself.
 *
 *  Case 8 is the one case whose error message has to name the SP owner. The other
 *  negative cases are guards: pt_check_create_stored_procedure () rejects a missing SP
 *  owner and a Java SP before any %TYPE name is resolved, and a name that already
 *  carries an owner never reaches the code this issue fixed. They are here so that a
 *  later change cannot silently reorder those checks. Each case is described by its
 *  evaluate label.
 */

--+ server-message on

call login('dba', '') on class db_user;
drop table if exists cbrd27520_shared;

create user cbrd27520_u1;
create user cbrd27520_u2;
create table cbrd27520_u1.ztbl (i int, s varchar(20));
create table cbrd27520_u2.ytbl (b bigint);
create table cbrd27520_shared (c char(5));
create view cbrd27520_u1.zview as select i, s from cbrd27520_u1.ztbl;
create synonym cbrd27520_u1.zsyn for cbrd27520_u1.ztbl;
create synonym cbrd27520_u1.xsyn for dba.cbrd27520_shared;
grant select on cbrd27520_shared to cbrd27520_u1;

evaluate 'Case 1: view column as the %TYPE target';
create or replace procedure cbrd27520_u1.p_view(i zview.i%type) as begin null; end;

evaluate 'Case 2: synonym as the %TYPE target, pointing to the owner table and to dba.cbrd27520_shared';
create or replace function cbrd27520_u1.f_syn() return zsyn.i%type as begin return 7; end;
create or replace procedure cbrd27520_u1.p_xsyn(c xsyn.c%type) as begin null; end;

evaluate 'Case 3: OUT and INOUT parameters';
create or replace procedure cbrd27520_u1.p_io(o out ztbl.s%type, io inout ztbl.i%type) as begin o := 'z'; io := io + 1; end;

evaluate 'Case 4: quoted and case-varying identifiers. p_q3 is fully qualified and needs no owner to be added; p_q4 takes its owner from a quoted SP name.';
create or replace procedure cbrd27520_u1.p_q1(i "ztbl"."i"%type) as begin null; end;
create or replace procedure cbrd27520_u1.p_q2(i ZTBL.I%type) as begin null; end;
create or replace procedure "cbrd27520_u1"."p_q3"(i "cbrd27520_u1"."ztbl"."i"%type) as begin null; end;
create or replace procedure "cbrd27520_u1"."p_q4"(i ztbl.i%type) as begin null; end;

evaluate 'Case 5: %TYPE in the signature and in the body at once';
create or replace function cbrd27520_u1.f_body(a ztbl.i%type) return ztbl.s%type as v ztbl.s%type; begin v := 'n' || a; return v; end;

evaluate 'Case 6: guard. A system class never gets an owner, on the return path as well as on the parameter path.';
create or replace function cbrd27520_u1.f_sys() return db_class.class_name%type as begin return 'sys'; end;

evaluate 'Case 7: parameter list mixing plain types and %TYPE types';
create or replace function cbrd27520_u1.f_mix(a int, b ztbl.i%type, c varchar, d ztbl.s%type) return ztbl.s%type as begin return c || d; end;

evaluate 'Case 8: ytbl belongs to cbrd27520_u2. The message must name cbrd27520_u1.ytbl, not dba.ytbl.';
create or replace procedure cbrd27520_u1.p_third(b ytbl.b%type) as begin null; end;

evaluate 'Case 9: guard. %TYPE is rejected for a Java SP, in a parameter and in the return type alike.';
create or replace function cbrd27520_u1.f_java(a ztbl.i%type) return ztbl.s%type as language java name 'Foo.bar(int) return java.lang.String';
create or replace function cbrd27520_u1.f_java2(a int) return ztbl.s%type as language java name 'Foo.bar(int) return java.lang.String';

evaluate 'Case 10: guard. AUTHID CALLER is rejected for a PL/CSQL SP.';
create or replace procedure cbrd27520_u1.p_caller(i ztbl.i%type) authid caller as begin null; end;

evaluate 'Case 11: guard. nobody is not a database user, and that is checked before any %TYPE name is resolved.';
create or replace procedure nobody.p_x(i ztbl.i%type) as begin null; end;

evaluate 'Case 12: guard, unrelated to the fix. cbrd27520_u2.ytbl already carries an owner, so it never reaches the code this issue fixed. The first create fails because the SP owner cannot select the table; after the grant the same create succeeds, which is what tells the two apart.';
create or replace procedure cbrd27520_u1.p_nopriv(b cbrd27520_u2.ytbl.b%type) as begin null; end;
grant select on cbrd27520_u2.ytbl to cbrd27520_u1;
create or replace procedure cbrd27520_u1.p_nopriv(b cbrd27520_u2.ytbl.b%type) as begin null; end;

evaluate 'Case 13: the session user is a DBA group member, not dba, and owns a ztbl whose columns have other types. The types of cbrd27520_u1.ztbl must be used.';
create user cbrd27520_adm groups dba;
call login('cbrd27520_adm', '') on class db_user;
create table ztbl (i varchar(10), s double);
create or replace procedure cbrd27520_u1.p_grp(i ztbl.i%type) as begin null; end;
call login('dba', '') on class db_user;

evaluate 'Case 14: call the SPs and check the stored types';
select cbrd27520_u1.f_syn(), cbrd27520_u1.f_body(3),
       cbrd27520_u1.f_sys(), cbrd27520_u1.f_mix(1, 2, 'ab', 'cd');

select sp_name, owner.name, return_type
  from _db_stored_procedure
 where owner.name = 'CBRD27520_U1'
 order by 1;

select sp_of.sp_name, arg_name, data_type, mode
  from _db_stored_procedure_args
 where sp_of.owner.name = 'CBRD27520_U1'
 order by 1, 2;

drop procedure cbrd27520_u1.p_view, cbrd27520_u1.p_xsyn, cbrd27520_u1.p_io;
drop procedure cbrd27520_u1.p_q1, cbrd27520_u1.p_q2, cbrd27520_u1.p_q3, cbrd27520_u1.p_q4;
drop procedure cbrd27520_u1.p_nopriv, cbrd27520_u1.p_grp;
drop function cbrd27520_u1.f_syn, cbrd27520_u1.f_body, cbrd27520_u1.f_sys, cbrd27520_u1.f_mix;
drop synonym cbrd27520_u1.zsyn;
drop synonym cbrd27520_u1.xsyn;
drop view cbrd27520_u1.zview;
drop table cbrd27520_adm.ztbl;
drop table cbrd27520_u1.ztbl;
drop table cbrd27520_u2.ytbl;
drop table cbrd27520_shared;
drop user cbrd27520_adm;
drop user cbrd27520_u1;
drop user cbrd27520_u2;

--+ server-message off
