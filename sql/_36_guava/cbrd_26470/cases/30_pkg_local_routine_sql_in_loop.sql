/**
 *  This test case verifies CBRD-26470: SQL in a local routine of a package routine, called in a
 *  loop or recursively, compiles and runs.
 *
 *  SQL in a local routine that can run again in a loop or by recursion is generated to refer to
 *  pstmtRef_N[0], declared once outside. A standalone SP wraps its main user code with
 *  wrapWithStmtDeclareAndClose () to make that declaration, but package members
 *  (visitDeclRoutine / tmplDeclRoutine) did not. Before the fix CREATE PACKAGE BODY failed with
 *  "Package compile error: Unable to compile the source" (javac: cannot find symbol pstmtRef_N).
 *
 *  The local function lf (i) is "select count(*) from t30 where a <= i" and t30 = {1, 2, 3}, and
 *  most cases add lf (1), lf (2) and lf (3). Package routines are called through wrapper functions.
 *
 *  Coverage:
 *    Case 1:  local routine called in a FOR loop
 *    Case 2:  in a WHILE loop
 *    Case 3:  in a basic LOOP
 *    Case 4:  in a cursor FOR loop
 *    Case 5:  self recursion
 *    Case 6:  mutual recursion
 *    Case 7:  two members, each with one of the above
 *    Case 8:  private member only in the body
 *    Case 9:  local procedure doing INSERT in a loop
 *    Case 10: mutual recursion between members, f calls a local routine in a loop
 *    Case 11: a local routine calls member g that calls f back
 *    Case 12: member f with a builtin call in its default argument, called without argument in a
 *             loop of another member g
 *    Case 13: the same code in a standalone function (regression)
 *  Each case compiles and returns the sum that its label states.
 */

--+ server-message on

drop table if exists t30;
drop table if exists log30;
drop package if exists pk30_for;
drop package if exists pk30_while;
drop package if exists pk30_loop;
drop package if exists pk30_cur;
drop package if exists pk30_rec;
drop package if exists pk30_mut;
drop package if exists pk30_two;
drop package if exists pk30_priv;
drop package if exists pk30_ins;
drop package if exists pk30_mr;
drop package if exists pk30_cb;
drop package if exists pk30_da;
create table t30 (a int);
insert into t30 values (1), (2), (3);
create table log30 (a int);


evaluate 'Case 1: local routine with SQL called in a FOR loop: 6';
create or replace package pk30_for as function f return int; end;
create or replace package body pk30_for as function f return int as s int := 0; function lf (i int) return int as n int; begin select count(*) into n from t30 where a <= i; return n; end; begin for i in 1 .. 3 loop s := s + lf (i); end loop; return s; end; end;
create or replace function w30_for return int as begin return pk30_for.f (); end;
select w30_for () from dual;


evaluate 'Case 2: in a WHILE loop: 6';
create or replace package pk30_while as function f return int; end;
create or replace package body pk30_while as function f return int as s int := 0; i int := 1; function lf (i int) return int as n int; begin select count(*) into n from t30 where a <= i; return n; end; begin while i <= 3 loop s := s + lf (i); i := i + 1; end loop; return s; end; end;
create or replace function w30_while return int as begin return pk30_while.f (); end;
select w30_while () from dual;


evaluate 'Case 3: in a basic LOOP: 6';
create or replace package pk30_loop as function f return int; end;
create or replace package body pk30_loop as function f return int as s int := 0; i int := 1; function lf (i int) return int as n int; begin select count(*) into n from t30 where a <= i; return n; end; begin loop exit when i > 3; s := s + lf (i); i := i + 1; end loop; return s; end; end;
create or replace function w30_loop return int as begin return pk30_loop.f (); end;
select w30_loop () from dual;


evaluate 'Case 4: in a cursor FOR loop: 6';
create or replace package pk30_cur as function f return int; end;
create or replace package body pk30_cur as function f return int as s int := 0; cursor c is select a from t30; function lf (i int) return int as n int; begin select count(*) into n from t30 where a <= i; return n; end; begin for r in c loop s := s + lf (r.a); end loop; return s; end; end;
create or replace function w30_cur return int as begin return pk30_cur.f (); end;
select w30_cur () from dual;


evaluate 'Case 5: self recursion: 6';
create or replace package pk30_rec as function f return int; end;
create or replace package body pk30_rec as function f return int as function rec (i int) return int as n int; begin if i = 0 then return 0; end if; select count(*) into n from t30 where a <= i; return n + rec (i - 1); end; begin return rec (3); end; end;
create or replace function w30_rec return int as begin return pk30_rec.f (); end;
select w30_rec () from dual;


evaluate 'Case 6: mutual recursion: 6';
create or replace package pk30_mut as function f return int; end;
create or replace package body pk30_mut as function f return int as function od (i int) return int as n int; begin if i = 0 then return 0; end if; select count(*) into n from t30 where a <= i; return n + ev (i - 1); end; function ev (i int) return int as n int; begin if i = 0 then return 0; end if; select count(*) into n from t30 where a <= i; return n + od (i - 1); end; begin return od (3); end; end;
create or replace function w30_mut return int as begin return pk30_mut.f (); end;
select w30_mut () from dual;


-- f: FOR loop, g: self recursion
evaluate 'Case 7: two members, each with one: 12';
create or replace package pk30_two as function f return int; function g return int; end;
create or replace package body pk30_two as function f return int as s int := 0; function lf (i int) return int as n int; begin select count(*) into n from t30 where a <= i; return n; end; begin for i in 1 .. 3 loop s := s + lf (i); end loop; return s; end; function g return int as function rec (i int) return int as n int; begin if i = 0 then return 0; end if; select count(*) into n from t30 where a <= i; return n + rec (i - 1); end; begin return rec (3); end; end;
create or replace function w30_two return int as begin return pk30_two.f () + pk30_two.g (); end;
select w30_two () from dual;


evaluate 'Case 8: private member: 6';
create or replace package pk30_priv as function f return int; end;
create or replace package body pk30_priv as function hidden return int as s int := 0; function lf (i int) return int as n int; begin select count(*) into n from t30 where a <= i; return n; end; begin for i in 1 .. 3 loop s := s + lf (i); end loop; return s; end; function f return int as begin return hidden (); end; end;
create or replace function w30_priv return int as begin return pk30_priv.f (); end;
select w30_priv () from dual;


-- the local procedure inserts, f returns the number of inserted rows
evaluate 'Case 9: local procedure with INSERT in a loop: 3';
create or replace package pk30_ins as function f return int; end;
create or replace package body pk30_ins as function f return int as n int; procedure lp (i int) as begin insert into log30 values (i); end; begin delete from log30; for i in 1 .. 3 loop lp (i); end loop; select count(*) into n from log30; return n; end; end;
create or replace function w30_ins return int as begin return pk30_ins.f (); end;
select w30_ins () from dual;


-- f (n) adds lf (1) to lf (3) to g (n - 1), g (n) = f (n - 1), f (0) = g (0) = 0
evaluate 'Case 10: mutual recursion between members: 12';
create or replace package pk30_mr as function f (n int) return int; function g (n int) return int; end;
create or replace package body pk30_mr as function f (n int) return int as s int := 0; function lf (i int) return int as n int; begin select count(*) into n from t30 where a <= i; return n; end; begin if n = 0 then return 0; end if; for i in 1 .. 3 loop s := s + lf (i); end loop; return s + g (n - 1); end; function g (n int) return int as begin if n = 0 then return 0; end if; return f (n - 1); end; end;
create or replace function w30_mr return int as begin return pk30_mr.f (3); end;
select w30_mr () from dual;


-- lf2 (i, n) = count(a <= i) + (n > 0 ? g (n - 1) : 0), g (m) = f (m)
evaluate 'Case 11: local routine calls a member that calls back: 24';
create or replace package pk30_cb as function f (n int) return int; function g (n int) return int; end;
create or replace package body pk30_cb as function f (n int) return int as s int := 0; function lf2 (i int, n int) return int as c int; begin select count(*) into c from t30 where a <= i; if n > 0 then c := c + g (n - 1); end if; return c; end; begin for i in 1 .. 3 loop s := s + lf2 (i, n); end loop; return s; end; function g (n int) return int as begin return f (n); end; end;
create or replace function w30_cb return int as begin return pk30_cb.f (1); end;
select w30_cb () from dual;


-- g calls f () twice, each time with the default argument
evaluate 'Case 12: default argument with a builtin call, used in another member loop: 14';
create or replace package pk30_da as function f (a int := to_number('7')) return int; function g return int; end;
create or replace package body pk30_da as function f (a int := to_number('7')) return int as begin return a; end; function g return int as s int := 0; begin for i in 1 .. 2 loop s := s + f (); end loop; return s; end; end;
create or replace function w30_da return int as begin return pk30_da.g (); end;
select w30_da () from dual;


evaluate 'Case 13: the same code in a standalone function (regression): 6';
create or replace function f30_sa return int as s int := 0; function lf (i int) return int as n int; begin select count(*) into n from t30 where a <= i; return n; end; begin for i in 1 .. 3 loop s := s + lf (i); end loop; return s; end;
select f30_sa () from dual;

drop function w30_for, w30_while, w30_loop, w30_cur, w30_rec, w30_mut, w30_two, w30_priv, w30_ins, w30_mr, w30_cb, w30_da, f30_sa;
drop package pk30_for;
drop package pk30_while;
drop package pk30_loop;
drop package pk30_cur;
drop package pk30_rec;
drop package pk30_mut;
drop package pk30_two;
drop package pk30_priv;
drop package pk30_ins;
drop package pk30_mr;
drop package pk30_cb;
drop package pk30_da;
drop table t30;
drop table log30;

--+ server-message off
