/**
 *  This test case verifies CBRD-26470: a routine of a package body matches the one in the spec
 *  only if their %TYPE parameter and return types are the same.
 *
 *  The spec and body routines are paired (givesBodyOf) during parsing by comparing types with ==.
 *  The type of <t>.<c>%TYPE is filled in only later by a server query
 *  (askServerSemanticQuestions), so it is null at that point. Before the fix two %TYPE types
 *  were always equal (null == null) and the body was created even if the real types differed
 *  (NUMERIC vs VARCHAR). Now if one side is %TYPE the other must be %TYPE with literally the same
 *  <t>.<c> (identifier case is normalized). Otherwise the body is refused with "the header of
 *  <procedure|function> <name> in the package body does not match that in the package
 *  specification".
 *
 *  Cases using package variables are left out while package variable declarations are not
 *  supported.
 *
 *  t34 (a int, b int, s varchar(10))
 *
 *  Coverage:
 *    Case 1: parameter t34.a%TYPE vs t34.s%TYPE: refused
 *    Case 2: return type t34.a%TYPE vs t34.s%TYPE: refused
 *    Case 3: parameter t34.a%TYPE vs t34.b%TYPE (both INT, different text): refused
 *    Case 4: parameter t34.a%TYPE vs int: refused (also before the fix)
 *    Case 5: parameter dba.t34.a%TYPE vs t34.a%TYPE: refused
 *    Case 6: earlier parameter reference (a t34.a%TYPE, b a%TYPE) vs (a t34.a%TYPE, b t34.a%TYPE): refused
 *    Case 7: same %TYPE in parameter, IN OUT parameter and return type, case differs (T34.A vs
 *            t34.a): created, 77
 *    Case 8: plain types without %TYPE (regression): 6
 *    Case 9: the same <id>%TYPE in the spec and the body (earlier parameter, a local variable
 *            referring to <id>%TYPE again): 13. <id>%TYPE in a standalone function: 18 (regression)
 */

--+ server-message on

drop table if exists t34;
drop package if exists pk34_1;
drop package if exists pk34_2;
drop package if exists pk34_3;
drop package if exists pk34_4;
drop package if exists pk34_5;
drop package if exists pk34_9;
drop package if exists pk34_6;
drop package if exists pk34_7;
drop package if exists pk34_11;
create table t34 (a int, b int, s varchar(10));


evaluate 'Case 1: parameter t34.a%TYPE vs t34.s%TYPE: the body is refused';
create or replace package pk34_1 as procedure p (x t34.a%TYPE); end;
create or replace package body pk34_1 as procedure p (x t34.s%TYPE) as begin null; end; end;


evaluate 'Case 2: return type t34.a%TYPE vs t34.s%TYPE: the body is refused';
create or replace package pk34_2 as function f return t34.a%TYPE; end;
create or replace package body pk34_2 as function f return t34.s%TYPE as begin return 'abc'; end; end;


evaluate 'Case 3: parameter t34.a%TYPE vs t34.b%TYPE: the body is refused';
create or replace package pk34_3 as procedure p (x t34.a%TYPE); end;
create or replace package body pk34_3 as procedure p (x t34.b%TYPE) as begin null; end; end;


evaluate 'Case 4: parameter t34.a%TYPE vs int: the body is refused';
create or replace package pk34_4 as procedure p (x t34.a%TYPE); end;
create or replace package body pk34_4 as procedure p (x int) as begin null; end; end;


evaluate 'Case 5: parameter dba.t34.a%TYPE vs t34.a%TYPE: the body is refused';
create or replace package pk34_5 as procedure p (x dba.t34.a%TYPE); end;
create or replace package body pk34_5 as procedure p (x t34.a%TYPE) as begin null; end; end;


evaluate 'Case 6: parameter b a%TYPE vs b t34.a%TYPE (a t34.a%TYPE): the body is refused';
create or replace package pk34_9 as procedure p (a t34.a%TYPE, b a%TYPE); end;
create or replace package body pk34_9 as procedure p (a t34.a%TYPE, b t34.a%TYPE) as begin null; end; end;


-- f (3, 4): y := x + y = 7, return y * 10 = 70, w34_6 = 70 + 7
evaluate 'Case 7: same %TYPE, case differs (T34.A vs t34.a): created, 77';
create or replace package pk34_6 as function f (x T34.A%TYPE, y in out T34.A%TYPE) return T34.A%TYPE; end;
create or replace package body pk34_6 as function f (x t34.a%type, y in out t34.a%type) return t34.a%type as begin y := x + y; return y * 10; end; end;
create or replace function w34_6 return int as y int := 4; r int; begin r := pk34_6.f (3, y); return r + y; end;
select w34_6 () from dual;


evaluate 'Case 8: plain types (regression): 6';
create or replace package pk34_7 as function g (x int) return int; end;
create or replace package body pk34_7 as function g (x int) return int as begin return x + 1; end; end;
create or replace function w34_7 return int as begin return pk34_7.g (5); end;
select w34_7 () from dual;


-- pk34_11.f (1, 2): c = 1 + 2 = 3, d = 10 -> 13; sf34 (5) = 5 + 6 + 7 = 18
evaluate 'Case 9: the same <id>%TYPE in the spec and the body: 13, <id>%TYPE in a standalone function: 18';
create or replace package pk34_11 as function f (a t34.a%TYPE, b a%TYPE) return t34.a%TYPE; end;
create or replace package body pk34_11 as function f (a t34.a%TYPE, b a%TYPE) return t34.a%TYPE as c b%TYPE := a + b; d c%TYPE := 10; begin return c + d; end; end;
create or replace function w34_11 return int as begin return pk34_11.f (1, 2); end;
create or replace function sf34 (a t34.a%TYPE) return int as x a%TYPE := a + 1; y x%TYPE := x + 1; begin return a + x + y; end;
select w34_11 (), sf34 (5) from dual;

drop function w34_6, w34_7, w34_11, sf34;
drop package pk34_1;
drop package pk34_2;
drop package pk34_3;
drop package pk34_4;
drop package pk34_5;
drop package pk34_9;
drop package pk34_6;
drop package pk34_7;
drop package pk34_11;
drop table t34;

--+ server-message off
