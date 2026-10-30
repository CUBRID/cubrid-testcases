/**
 *  CBRD-27520: an unqualified <table>.<column>%TYPE in the parameter or return type of a
 *  PL/CSQL SP must refer to the object of the SP owner, not of the session user.
 *
 *  cbrd_27520.sql covers plain tables. This file covers the other kinds of %TYPE target,
 *  the remaining parameter modes and identifier spellings, and the negative paths whose
 *  error message must name the SP owner. Each case is described by its evaluate label.
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

evaluate 'Case 4: quoted and case-varying identifiers. The fully qualified one needs no owner to be added.';
create or replace procedure cbrd27520_u1.p_q1(i "ztbl"."i"%type) as begin null; end;
create or replace procedure cbrd27520_u1.p_q2(i ZTBL.I%type) as begin null; end;
create or replace procedure "cbrd27520_u1"."p_q3"(i "cbrd27520_u1"."ztbl"."i"%type) as begin null; end;

evaluate 'Case 5: %TYPE in the signature and in the body at once';
create or replace function cbrd27520_u1.f_body(a ztbl.i%type) return ztbl.s%type as v ztbl.s%type; begin v := 'n' || a; return v; end;

evaluate 'Case 6: system class in the return type. No owner is added to a system class.';
create or replace function cbrd27520_u1.f_sys() return db_class.class_name%type as begin return 'sys'; end;

evaluate 'Case 7: parameter list mixing plain types and %TYPE types';
create or replace function cbrd27520_u1.f_mix(a int, b ztbl.i%type, c varchar, d ztbl.s%type) return ztbl.s%type as begin return c || d; end;

evaluate 'Case 8: ytbl belongs to cbrd27520_u2. The message must name cbrd27520_u1.ytbl, not dba.ytbl.';
create or replace procedure cbrd27520_u1.p_third(b ytbl.b%type) as begin null; end;

evaluate 'Case 9: %TYPE is allowed only for PL/CSQL, not for a Java SP';
create or replace function cbrd27520_u1.f_java(a ztbl.i%type) return ztbl.s%type as language java name 'Foo.bar(int) return java.lang.String';

evaluate 'Case 10: AUTHID CALLER is rejected for a PL/CSQL SP';
create or replace procedure cbrd27520_u1.p_caller(i ztbl.i%type) authid caller as begin null; end;

evaluate 'Case 11: nobody is not a database user';
create or replace procedure nobody.p_x(i ztbl.i%type) as begin null; end;

evaluate 'Case 12: the owner has no SELECT on cbrd27520_u2.ytbl. The SP owner rights apply, though dba is the session user.';
create or replace procedure cbrd27520_u1.p_nopriv(b cbrd27520_u2.ytbl.b%type) as begin null; end;

evaluate 'Case 13: call the SPs and check the stored types';
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
drop procedure cbrd27520_u1.p_q1, cbrd27520_u1.p_q2, cbrd27520_u1.p_q3;
drop function cbrd27520_u1.f_syn, cbrd27520_u1.f_body, cbrd27520_u1.f_sys, cbrd27520_u1.f_mix;
drop synonym cbrd27520_u1.zsyn;
drop synonym cbrd27520_u1.xsyn;
drop view cbrd27520_u1.zview;
drop table cbrd27520_u1.ztbl;
drop table cbrd27520_u2.ytbl;
drop table cbrd27520_shared;
drop user cbrd27520_u1;
drop user cbrd27520_u2;

--+ server-message off
