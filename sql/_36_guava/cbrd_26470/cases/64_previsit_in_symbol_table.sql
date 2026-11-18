/**
 *  This test case verifies CBRD-26470 (PR #7819): the temporary symbol table of the previsit is
 *  removed.
 *
 *  Background:
 *    - The previsit puts declarations into the real symbol table and hides constants, variables
 *      and cursors until the visit (Decl.hidden). The visit takes the Decl made by the previsit,
 *      fills in the initial value only and unhides it.
 *    - The previsit and the visit record name uses separately, and each checks s068 in the order
 *      of the declarations.
 *  (The old case of a spec cursor used in a routine before the cursor definition in the body is left
 *   out while package cursor declarations are blocked. The package body variables/cursors of the
 *   old cases are replaced with local variables/cursors of a stored function; they go through the
 *   same checks.)
 *  The routine bodies are not indented, so that the error positions do not depend on the
 *  indentation.
 *
 *  Coverage:
 *    Case 1:  outer b used, then b declared in the same declaration block (initial value, visit
 *             check) -> s068
 *    Case 2:  bb declared later used in an initial value, no outer bb -> undeclared
 *    Case 3:  y x%TYPE takes the type of the preceding x (NUMERIC(5,2)) -> the value is rounded to its scale
 *    Case 4:  outer t used in a routine parameter t%TYPE, then t declared in the same declaration
 *             block (previsit check) -> s068
 *    Case 5:  outer x used in a cursor SQL, then x declared in the same declaration block
 *             (previsit check) -> s068
 *    Case 6:  mutual recursion of local routines compiles and runs
 *    Case 7:  comment on a local variable -> s101 (previsit check)
 *    Case 8:  comment on a local cursor -> s102 (previsit check)
 *    Case 9:  cursor in a PARALLEL_ENABLE function -> refused (setConnectionRequired of the previsit)
 *    Case 10: local variables of the same name in a declaration block -> s062
 */

--+ server-message on


evaluate 'Case 1: outer b used, then b declared (visit) -> name B has already been used at line 4 and column 10';
create or replace function t64e return int as
b int := 5;
function g return int as
a int := b;
b int := 1;
begin return a; end;
begin return g(); end;

evaluate 'Case 2: bb used before its declaration -> undeclared identifier BB';
create or replace function t64e return int as
a int := bb;
bb int := 1;
begin return a; end;

evaluate 'Case 3: y x%TYPE of NUMERIC(5,2) -> 2.35';
create or replace function t64 return varchar as x numeric(5,2) := 1.234; y x%type := 2.345; begin return y; end;
select t64() from dual;

evaluate 'Case 4: outer t used in a parameter type, then t declared (previsit) -> name T has already been used at line 4 and column 15';
create or replace function t64e return int as
t int := 1;
function g return int as
function f (p t%type) return int as begin return p; end;
t varchar := 'x';
begin return f(3); end;
begin return g(); end;

evaluate 'Case 5: outer x used in a cursor SQL, then x declared (previsit) -> name X has already been used at line 4 and column 13';
create or replace function t64e return int as
x int := 1;
function g return int as
cursor k is select x from dual;
x int := 2;
begin return 0; end;
begin return g(); end;

evaluate 'Case 6: mutual recursion of local routines -> 5';
create or replace function t64 return varchar as
function f1 (n int) return int as begin if n <= 0 then return 0; end if; return f2(n - 1) + 1; end;
function f2 (n int) return int as begin if n <= 0 then return 0; end if; return f1(n - 1) + 1; end;
begin return f1(5); end;
select t64() from dual;

evaluate 'Case 7: comment on a local variable -> only package spec items can have a comment';
create or replace function t64e return int as
w int comment 'w';
begin return 0; end;

evaluate 'Case 8: comment on a local cursor -> only package spec items can have a comment';
create or replace function t64e return int as
cursor c2 return dual%rowtype comment 'c2';
begin return 0; end;

evaluate 'Case 9: cursor in a PARALLEL_ENABLE function -> PARALLEL_ENABLE cannot use a feature that calls DB server';
create or replace function t64e return int parallel_enable as
cursor k is select 1 from dual;
begin return 0; end;

evaluate 'Case 10: local variables of the same name in a declaration block -> V has already been declared in the same scope';
create or replace function t64e return int as
v int;
v varchar;
begin return 0; end;


drop function t64;

--+ server-message off
