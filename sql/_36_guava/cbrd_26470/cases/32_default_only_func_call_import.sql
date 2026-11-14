/**
 *  This test case verifies CBRD-26470: a routine that calls a function only in a parameter
 *  DEFAULT expression is created.
 *
 *  A global function call in a DEFAULT expression is registered in referencedMethods and gets a
 *  slot, so getAuthCheckedDecl () emits a "Method[] method" field. Before the fix
 *  "import java.lang.reflect.Method" was only added when the code of a direct call was actually
 *  generated. When the DEFAULT expression code is not generated (a declaration in a package
 *  spec, a local call with all arguments given) the import was missing and javac failed with
 *  "cannot find symbol ... Method" ("Unable to compile the source"). Now getAuthCheckedDecl ()
 *  adds the import when it emits the Method field.
 *
 *  g32 () = 5.
 *
 *  Coverage:
 *    Case 1: public package function f (a int := g32 ()), called with all arguments f (3), the default is not evaluated
 *    Case 2: private package function h (a int := g32 ()), called with all arguments, the default is not evaluated
 *    Case 3: local function lf (a int := g32 ()) in a standalone function, all arguments, the default is not evaluated
 *    Case 4: local procedure lp (a int := g32 ()) in a standalone function, all arguments, the default is not evaluated
 *    Case 5: local function with the default omitted, lf () gets the value of g32 () (regression)
 */

--+ server-message on

drop package if exists pk32a;
drop package if exists pk32b;
create or replace function g32 return int as begin return 5; end;


evaluate 'Case 1: public member in the spec with a default calling g32, called with all arguments: 3';
create or replace package pk32a as function f (a int := g32 ()) return int; end;
create or replace package body pk32a as function f (a int := g32 ()) return int as begin return a; end; end;
create or replace function w32a return int as begin return pk32a.f (3); end;
select w32a () from dual;


evaluate 'Case 2: private member in the body with a default calling g32, called with all arguments: 4';
create or replace package pk32b as function f return int; end;
create or replace package body pk32b as function h (a int := g32 ()) return int as begin return a; end; function f return int as begin return h (4); end; end;
create or replace function w32b return int as begin return pk32b.f (); end;
select w32b () from dual;


evaluate 'Case 3: local function with a default calling g32, called with all arguments: 6';
create or replace function lh32 return int as function lf (a int := g32 ()) return int as begin return a; end; begin return lf (6); end;
select lh32 () from dual;


evaluate 'Case 4: local procedure with a default calling g32, called with all arguments: 7';
create or replace function lph32 return int as r int; procedure lp (o out int, a int := g32 ()) as begin o := a; end; begin lp (r, 7); return r; end;
select lph32 () from dual;


evaluate 'Case 5: local function, default omitted (regression): 5';
create or replace function ld32 return int as function lf (a int := g32 ()) return int as begin return a; end; begin return lf (); end;
select ld32 () from dual;

drop function w32a, w32b, lh32, lph32, ld32;
drop package pk32a;
drop package pk32b;
drop function g32;

--+ server-message off
