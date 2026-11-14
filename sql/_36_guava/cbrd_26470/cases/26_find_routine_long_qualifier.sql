/**
 *  This test case verifies CBRD-26470: jsp_find_standalone_routine () checks the length of <a> in
 *  a routine name <a>.<b>.
 *
 *  Before the fix <a> was passed to sm_user_specified_name () without a length check. If <a> was
 *  255 bytes or longer, a debug build aborted on an assertion and a release build overran a stack
 *  buffer. change_sp_owner () can be called by any user and its DBA check comes after this lookup,
 *  so a normal user could reach it. Now the length is checked with jsp_check_package_name (); a
 *  name that is too long skips the <package>.<routine> lookup, the <user>.<routine> lookup does
 *  not find it either, and the call fails with "... does not exist".
 *
 *  Coverage:
 *    Case 1: change_sp_owner with <a> of 221, 222, 254, 255, 300 bytes as DBA and as u26a:
 *            "does not exist", no crash
 *    Case 2: <b> of 300 bytes (regression): "does not exist"
 *    Case 3: normal paths (regression): a package routine is refused, a standalone routine
 *            changes its owner, the package routine keeps its owner
 */

--+ server-message on

create user u26a;
create user u26b;
drop package if exists pk26;
create or replace procedure sp26 as begin null; end;
create package pk26 as procedure p; end;
create package body pk26 as procedure p as begin null; end; end;


evaluate 'Case 1: change_sp_owner with a long <a> fails with: does not exist (DBA, then u26a)';
call change_sp_owner (rpad ('a', 221, 'a') || '.p', 'dba') on class db_root;
call change_sp_owner (rpad ('a', 222, 'a') || '.p', 'dba') on class db_root;
call change_sp_owner (rpad ('a', 254, 'a') || '.p', 'dba') on class db_root;
call change_sp_owner (rpad ('a', 255, 'a') || '.p', 'dba') on class db_root;
call change_sp_owner (rpad ('a', 300, 'a') || '.p', 'dba') on class db_root;
call login('u26a','') on class db_user;
call change_sp_owner (rpad ('a', 221, 'a') || '.p', 'dba') on class db_root;
call change_sp_owner (rpad ('a', 222, 'a') || '.p', 'dba') on class db_root;
call change_sp_owner (rpad ('a', 254, 'a') || '.p', 'dba') on class db_root;
call change_sp_owner (rpad ('a', 255, 'a') || '.p', 'dba') on class db_root;
call change_sp_owner (rpad ('a', 300, 'a') || '.p', 'dba') on class db_root;


evaluate 'Case 2: change_sp_owner with <b> of 300 bytes as u26a fails with: does not exist';
call change_sp_owner ('pk26.' || rpad ('b', 300, 'b'), 'dba') on class db_root;


evaluate 'Case 3: package routine refused (cannot be applied to package routine), dba.sp26 owner becomes U26B, pk26.p owner stays DBA';
call login('dba','') on class db_user;
call change_sp_owner ('pk26.p', 'u26b') on class db_root;
call change_sp_owner ('dba.sp26', 'u26b') on class db_root;
select owner.name from _db_stored_procedure where sp_name = 'sp26' and pkg_of is null;
select owner.name from _db_stored_procedure where sp_name = 'p' and pkg_of.unique_name = 'dba.pk26';

drop procedure u26b.sp26;
drop package pk26;
drop user u26a;
drop user u26b;

--+ server-message off
