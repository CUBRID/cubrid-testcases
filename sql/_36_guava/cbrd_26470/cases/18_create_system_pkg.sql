/**
 *  This test case verifies CBRD-26470 (PR #7936 review C5): CREATE PACKAGE [BODY] with the name
 *  of the system generated package dbms_output is refused.
 *
 *  Before the fix, quoting the name (public."dbms_output", [public].[dbms_output]) created a
 *  BODY, and the _db_package_code row it left could not be dropped because DROP refused a system
 *  package. Now jsp_create_package() refuses both spec and body with
 *  ER_PKG_CREATE_NOT_ALLOWED_SYSTEM_GENERATED before the savepoint. The unquoted
 *  public.dbms_output is refused as well. The DROP check moved to the same helper
 *  (jsp_is_system_generated_pkg), so the DROP refusal and the life cycle of a user package are
 *  checked too.
 *
 *  Coverage:
 *    Case 1: CREATE [OR REPLACE] PACKAGE [BODY] of a quoted public.dbms_output is refused
 *    Case 2: CREATE PACKAGE BODY public.dbms_output (unquoted) fails
 *    Case 3: no code row left (expect 0), the system package row intact (expect 1),
 *            dbms_output still works (expect the message 'still works')
 *    Case 4: DROP PACKAGE [BODY] public.dbms_output is still refused
 *    Case 5: a user package is created, replaced and dropped as before (expect 0 rows left)
 */

--+ server-message on

drop package if exists pk18;


evaluate 'Case 1: CREATE [OR REPLACE] PACKAGE [BODY] of a quoted public.dbms_output is refused';
create package body public."dbms_output" as procedure zz as begin null; end; end;
create package body [public].[dbms_output] as procedure zz as begin null; end; end;
create or replace package body public."dbms_output" as procedure zz as begin null; end; end;
create package public."dbms_output" as procedure zz; end;
create or replace package public."dbms_output" as procedure zz; end;


evaluate 'Case 2: CREATE PACKAGE BODY public.dbms_output (unquoted) fails';
create package body public.dbms_output as procedure zz as begin null; end; end;


evaluate 'Case 3: no code row left (expect 0), system package row intact (expect 1), dbms_output still works';
select count(*) from _db_package_code where pkg_unique_name = 'public.dbms_output';
select count(*) from _db_package where unique_name = 'public.dbms_output' and flags = 1;
call dbms_output.enable(1000);
call dbms_output.put_line('still works');


evaluate 'Case 4: DROP PACKAGE [BODY] public.dbms_output is still refused';
drop package public.dbms_output;
drop package body public.dbms_output;


evaluate 'Case 5: a user package is created, replaced and dropped as before, expect 0';
create package pk18 as procedure p; end;
create package body pk18 as procedure p as begin null; end; end;
create or replace package pk18 as procedure p; procedure p2; end;
drop package body pk18;
drop package pk18;
select count(*) from _db_package where unique_name = 'dba.pk18';

--+ server-message off
