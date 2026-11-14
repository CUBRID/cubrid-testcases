/**
 *  This test case verifies CBRD-26470 (PR #7819): a direct call in a PARALLEL_ENABLE function is
 *  refused (as cbrd_27299_plcsql Case 6).
 *
 *  Background:
 *    - Before the fix, a call decided to be a direct call did not call setConnectionRequired, so it
 *      passed the PARALLEL_ENABLE check. A direct call also calls the server while it runs
 *      (EXECUTE authorization check, switching the execution rights).
 *    - After the fix, the two places in askServerSemanticQuestions that decide a direct call
 *      (procedure, function) and a function call without parentheses in visitIdentifier give the
 *      "calls DB server" error in a PARALLEL_ENABLE function (rejectIfParallelEnabled).
 *
 *  Coverage:
 *    Case 1:    function direct call                     k_pure62(n)
 *    Case 2:    owner-qualified function direct call     dba.k_pure62(n)
 *    Case 3:    procedure direct call                    e_proc62(n)
 *    Case 4:    owner-qualified procedure direct call    dba.e_proc62(n)
 *    Case 5:    function direct call without parentheses k_zero62
 *    Case 6:    package member function direct call      pq62.k_pkg(n)
 *    Case 7:    call omitting a default (through the server, regression)  k_def62(n)
 *    Case 8:    regression: a local function call in a PARALLEL_ENABLE function is allowed
 *    Case 9:    regression: direct calls in a function that is not PARALLEL_ENABLE are allowed
 *    Case 10:   only the functions created in Cases 8 and 9 and e_proc62 exist among e_%62,
 *               the refused ones were not created
 */

--+ server-message on

drop package if exists pq62;

create or replace function k_pure62 (n int) return int parallel_enable as begin return n + 1; end;
create or replace function k_zero62 return int parallel_enable as begin return 0; end;
create or replace function k_def62 (n int, d int := 0) return int parallel_enable as begin return n + d; end;
create or replace procedure e_proc62 (n int) as begin null; end;
create or replace package pq62 as
function k_pkg (n int) return int;
end;
create or replace package body pq62 as
function k_pkg (n int) return int as begin return n; end;
end;


evaluate 'Case 1: function direct call -> PARALLEL_ENABLE cannot use a feature that calls DB server';
create or replace function e_glob62 (n int) return int parallel_enable as begin return k_pure62(n); end;

evaluate 'Case 2: owner-qualified function direct call -> refused';
create or replace function e_own62 (n int) return int parallel_enable as begin return dba.k_pure62(n); end;

evaluate 'Case 3: procedure direct call -> refused';
create or replace function e_pcall62 (n int) return int parallel_enable as begin e_proc62(n); return n; end;

evaluate 'Case 4: owner-qualified procedure direct call -> refused';
create or replace function e_pcallown62 (n int) return int parallel_enable as begin dba.e_proc62(n); return n; end;

evaluate 'Case 5: function direct call without parentheses -> refused';
create or replace function e_nopar062 (n int) return int parallel_enable as begin return k_zero62; end;

evaluate 'Case 6: package member function direct call -> refused';
create or replace function e_pkg62 (n int) return int parallel_enable as begin return pq62.k_pkg(n); end;

evaluate 'Case 7: call omitting a default (through the server) -> refused';
create or replace function e_def62 (n int) return int parallel_enable as begin return k_def62(n); end;

evaluate 'Case 8: local function call in a PARALLEL_ENABLE function -> created';
create or replace function e_local62 (n int) return int parallel_enable as function l (m int) return int as begin return m; end; begin return l(n); end;

evaluate 'Case 9: direct calls in a function not PARALLEL_ENABLE -> created';
create or replace function e_nopar62 (n int) return int as begin return k_pure62(n) + k_zero62; end;

evaluate 'Case 10: e_%62 routines -> e_local62, e_nopar62, e_proc62';
select sp_name from db_stored_procedure where sp_name like 'e\_%62' escape '\' order by sp_name;


drop function e_local62, e_nopar62, k_pure62, k_zero62, k_def62;
drop procedure e_proc62;
drop package pq62;

--+ server-message off
