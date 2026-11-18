/**
 *  This test case verifies CBRD-26470: a grantee of EXECUTE on a package sees the package routines
 *  in the catalog views.
 *
 *  Before the fix db_stored_procedure, db_stored_procedure_args, information_schema.routines and
 *  information_schema.parameters only looked at grants on the routine itself, and
 *  information_schema.routine_privileges only joined grants with object_type PROCEDURE. A package
 *  grantee could call the package routines but did not see them. Now the first four views also
 *  accept an EXECUTE grant on the package of the routine (pkg_of), and routine_privileges shows a
 *  package grant as one row per member routine (system generated routines excluded).
 *
 *  Each check below selects five counts for the package routine pk24.pr1 (one parameter):
 *  db_stored_procedure, db_stored_procedure_args, routines, parameters, routine_privileges.
 *
 *  Coverage:
 *    Case 1: the package grantee can call u24a.pk24.pr1 through a wrapper
 *    Case 2: the package grantee sees pr1 in all five views (and pr2, all members)
 *    Case 3: a member of a grantee group sees it, routine_privileges shows the group
 *    Case 4: a user without privilege sees nothing
 *    Case 5: a grantee of a standalone routine only sees that routine
 *    Case 6: the owner and DBA see the routine and both package grants in routine_privileges
 *    Case 7: a grant on the system generated package dbms_output is not expanded in routine_privileges
 *    Case 8: after REVOKE the grantee sees nothing, the group grant remains
 */

--+ server-message on

create user u24a;
create user u24b;
create user u24c;
create user g24;
create user u24d groups g24;
create user u24e;

call login('u24a','') on class db_user;
drop package if exists pk24;
create package pk24 as procedure pr1(a int); procedure pr2; end;
create package body pk24 as procedure pr1(a int) as begin null; end; procedure pr2 as begin null; end; end;
create or replace procedure sp24(a int) as begin null; end;
grant execute on package pk24 to u24b;
grant execute on package pk24 to g24;
grant execute on procedure sp24 to u24e;


evaluate 'Case 1: u24b creates a wrapper calling u24a.pk24.pr1 and calls it';
call login('u24b','') on class db_user;
create or replace procedure w24 as begin u24a.pk24.pr1(1); end;
call w24();


evaluate 'Case 2: package grantee u24b sees pr1 in all views: 1 1 1 1 1, routine_privileges U24B/pk24.pr1/EXECUTE, pr2 visible, 2 privilege rows';
select (select count(*) from db_stored_procedure where sp_name = 'pr1' and pkg_name = 'pk24') sp,
       (select count(*) from db_stored_procedure_args where sp_name = 'pr1' and pkg_name = 'pk24') args,
       (select count(*) from information_schema.routines where specific_name = 'pk24.pr1') rout,
       (select count(*) from information_schema.parameters where specific_name = 'pk24.pr1') param,
       (select count(*) from information_schema.routine_privileges where specific_name = 'pk24.pr1') priv
from dual;
select grantee || '/' || specific_name || '/' || privilege_type from information_schema.routine_privileges where specific_name = 'pk24.pr1';
select count(*) from db_stored_procedure where sp_name = 'pr2' and pkg_name = 'pk24';
select count(*) from information_schema.routine_privileges where specific_name like 'pk24.%';


evaluate 'Case 3: u24d (member of grantee group g24) sees 1 1 1 1 1, routine_privileges grantee G24';
call login('u24d','') on class db_user;
select (select count(*) from db_stored_procedure where sp_name = 'pr1' and pkg_name = 'pk24') sp,
       (select count(*) from db_stored_procedure_args where sp_name = 'pr1' and pkg_name = 'pk24') args,
       (select count(*) from information_schema.routines where specific_name = 'pk24.pr1') rout,
       (select count(*) from information_schema.parameters where specific_name = 'pk24.pr1') param,
       (select count(*) from information_schema.routine_privileges where specific_name = 'pk24.pr1') priv
from dual;
select grantee from information_schema.routine_privileges where specific_name = 'pk24.pr1';


evaluate 'Case 4: u24c (no privilege) sees 0 0 0 0 0';
call login('u24c','') on class db_user;
select (select count(*) from db_stored_procedure where sp_name = 'pr1' and pkg_name = 'pk24') sp,
       (select count(*) from db_stored_procedure_args where sp_name = 'pr1' and pkg_name = 'pk24') args,
       (select count(*) from information_schema.routines where specific_name = 'pk24.pr1') rout,
       (select count(*) from information_schema.parameters where specific_name = 'pk24.pr1') param,
       (select count(*) from information_schema.routine_privileges where specific_name = 'pk24.pr1') priv
from dual;


evaluate 'Case 5: u24e (grantee of sp24 only) sees 0 0 0 0 0 for pr1, sp24 visible in db_stored_procedure and routine_privileges';
call login('u24e','') on class db_user;
select (select count(*) from db_stored_procedure where sp_name = 'pr1' and pkg_name = 'pk24') sp,
       (select count(*) from db_stored_procedure_args where sp_name = 'pr1' and pkg_name = 'pk24') args,
       (select count(*) from information_schema.routines where specific_name = 'pk24.pr1') rout,
       (select count(*) from information_schema.parameters where specific_name = 'pk24.pr1') param,
       (select count(*) from information_schema.routine_privileges where specific_name = 'pk24.pr1') priv
from dual;
select count(*) from db_stored_procedure where sp_name = 'sp24';
select count(*) from information_schema.routine_privileges where routine_name = 'sp24';


evaluate 'Case 6: owner u24a and DBA see 1 1 1 1 2 (both grants U24B and G24 in routine_privileges)';
call login('u24a','') on class db_user;
select (select count(*) from db_stored_procedure where sp_name = 'pr1' and pkg_name = 'pk24') sp,
       (select count(*) from db_stored_procedure_args where sp_name = 'pr1' and pkg_name = 'pk24') args,
       (select count(*) from information_schema.routines where specific_name = 'pk24.pr1') rout,
       (select count(*) from information_schema.parameters where specific_name = 'pk24.pr1') param,
       (select count(*) from information_schema.routine_privileges where specific_name = 'pk24.pr1') priv
from dual;
call login('dba','') on class db_user;
select (select count(*) from db_stored_procedure where sp_name = 'pr1' and pkg_name = 'pk24') sp,
       (select count(*) from db_stored_procedure_args where sp_name = 'pr1' and pkg_name = 'pk24') args,
       (select count(*) from information_schema.routines where specific_name = 'pk24.pr1') rout,
       (select count(*) from information_schema.parameters where specific_name = 'pk24.pr1') param,
       (select count(*) from information_schema.routine_privileges where specific_name = 'pk24.pr1') priv
from dual;
select grantee from information_schema.routine_privileges where specific_name = 'pk24.pr1' order by 1;


evaluate 'Case 7: DBA grants EXECUTE on public.dbms_output to u24b: 2 package grants of U24B in _db_auth, no dbms_output row in routine_privileges, put_line hidden from u24b';
grant execute on package public.dbms_output to u24b;
select count(*) from _db_auth where grantee.name = 'U24B' and object_type = 6;
select count(*) from information_schema.routine_privileges where specific_name like 'dbms_output.%' and grantee = 'U24B';
call login('u24b','') on class db_user;
select count(*) from db_stored_procedure where sp_name = 'put_line';


evaluate 'Case 8: after u24a revokes from u24b, u24b sees 0 0 0 0 0 and u24d still sees 1 1 1 1 1';
call login('u24a','') on class db_user;
revoke execute on package pk24 from u24b;
call login('u24b','') on class db_user;
select (select count(*) from db_stored_procedure where sp_name = 'pr1' and pkg_name = 'pk24') sp,
       (select count(*) from db_stored_procedure_args where sp_name = 'pr1' and pkg_name = 'pk24') args,
       (select count(*) from information_schema.routines where specific_name = 'pk24.pr1') rout,
       (select count(*) from information_schema.parameters where specific_name = 'pk24.pr1') param,
       (select count(*) from information_schema.routine_privileges where specific_name = 'pk24.pr1') priv
from dual;
call login('u24d','') on class db_user;
select (select count(*) from db_stored_procedure where sp_name = 'pr1' and pkg_name = 'pk24') sp,
       (select count(*) from db_stored_procedure_args where sp_name = 'pr1' and pkg_name = 'pk24') args,
       (select count(*) from information_schema.routines where specific_name = 'pk24.pr1') rout,
       (select count(*) from information_schema.parameters where specific_name = 'pk24.pr1') param,
       (select count(*) from information_schema.routine_privileges where specific_name = 'pk24.pr1') priv
from dual;

call login('dba','') on class db_user;
drop procedure u24b.w24;
drop procedure u24a.sp24;
drop package u24a.pk24;
drop user u24a;
drop user u24b;
drop user u24c;
drop user u24d;
drop user g24;
drop user u24e;

--+ server-message off
