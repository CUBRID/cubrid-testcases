/**
 *  This test case verifies CBRD-26470 (PR #7819): qualified calls in local routines and qualified
 *  calls in parameter defaults.
 *
 *  Background:
 *    - Symptom 1: in a local routine, a call qualified with the package name or the owner called
 *      the local routine of the same name. Java picked the method of the same name in the
 *      innermost class (Decl_of_<block>).
 *      Fix: package members and the SP being defined are static members of the unit class, so
 *      they are called with the class name.
 *    - Symptom 2: a qualified call pk.g() in a parameter DEFAULT gave "no such function" (s110).
 *      DEFAULT expressions were converted during the previsit, when the members were in the
 *      previsit table, not in the package scope (level 2).
 *      Fix: DEFAULT expressions are converted in the visit. The previsit only records whether
 *      there is a default.
 *  Each value is returned by a stored function t63w that calls the case's routine.
 *
 *  Coverage:
 *    Case 1: pk63.f() in a local function                      -> 'pkg' (before the fix 'local')
 *    Case 2: pk63.p in a local procedure                       -> 'pkg' (before the fix 'local')
 *    Case 3: dba.fr63(0) in a local function of the SP         -> 'top' (before the fix 'local')
 *    Case 4: DEFAULT pk63.g() in the spec and the body, call omitting it -> 14
 *    Case 5: DEFAULT pk63.pv() calling a private body member   -> 15
 *    Case 6: DEFAULT pk63.later() calling a member declared later -> 16
 *    Case 7: package initializer calls package routines (before the fix a Java compile error) -> 17
 *    Case 8: a local routine parameter without a default after one with a default -> s095
 */

--+ server-message on

drop package if exists pk63;

create or replace package pk63 as
function f return varchar;
procedure p (r out varchar);
function g return int;
function d1 (a int default pk63.g()) return int;
function d3 (a int default pk63.later()) return int;
function later return int;
function q1 return varchar;
function q2 return varchar;
function k1 return int;
function k2 return int;
function k3 return int;
function init_val return int;
end;
create or replace package body pk63 as
function f return varchar as begin return 'pkg'; end;
procedure p (r out varchar) as begin r := 'pkg'; end;
function g return int as begin return 14; end;
function d1 (a int default pk63.g()) return int as begin return a; end;
function pv return int as begin return 15; end;
function d2 (a int default pk63.pv()) return int as begin return a; end;
function d3 (a int default pk63.later()) return int as begin return a; end;
function later return int as begin return 16; end;
function q1 return varchar as
function f return varchar as begin return 'local'; end;
function h return varchar as begin return pk63.f(); end;
begin
return h();
end;
function q2 return varchar as
procedure p (r out varchar) as begin r := 'local'; end;
function h return varchar as r varchar; begin pk63.p(r); return r; end;
begin
return h();
end;
function k1 return int as begin return d1(); end;
function k2 return int as begin return d2(); end;
function k3 return int as begin return d3(); end;
function init_val return int as begin return 17; end;
begin
if f() = 'pkg' and init_val() = 17 then
null;
end if;
end;
create or replace function fr63 (n int) return varchar as
function fr63 (n int) return varchar as begin return 'local'; end;
function h return varchar as begin return dba.fr63(0); end;
begin
if n = 0 then return 'top'; end if;
return h();
end;


evaluate 'Case 1: pk63.f() in a local function -> pkg';
create or replace function t63w return varchar as begin return pk63.q1(); end;
select t63w() from dual;

evaluate 'Case 2: pk63.p in a local procedure -> pkg';
create or replace function t63w return varchar as begin return pk63.q2(); end;
select t63w() from dual;

evaluate 'Case 3: dba.fr63(0) in a local function of the SP -> top';
create or replace function t63w return varchar as begin return fr63(1); end;
select t63w() from dual;

evaluate 'Case 4: default pk63.g() omitted -> 14';
create or replace function t63w return varchar as begin return pk63.k1(); end;
select t63w() from dual;

evaluate 'Case 5: default pk63.pv() (body private) omitted -> 15';
create or replace function t63w return varchar as begin return pk63.k2(); end;
select t63w() from dual;

evaluate 'Case 6: default pk63.later() (declared after) omitted -> 16';
create or replace function t63w return varchar as begin return pk63.k3(); end;
select t63w() from dual;

evaluate 'Case 7: package initializer calls package routines -> 17';
create or replace function t63w return varchar as begin return pk63.init_val(); end;
select t63w() from dual;

evaluate 'Case 8: local routine parameter without a default after one with a default -> parameter B must have a default value';
create or replace function t63b return int as
function l (a int default 1, b int) return int as begin return a + b; end;
begin return l(1, 2); end;


drop function t63w, fr63;
drop package pk63;

--+ server-message off
