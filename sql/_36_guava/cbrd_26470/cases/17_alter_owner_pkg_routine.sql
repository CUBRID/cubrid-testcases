/**
 *  This test case verifies CBRD-26470 (PR #7936 review C4): owner change and ALTER of a
 *  package routine are refused.
 *
 *  CALL change_sp_owner (dba.pkg.p, ...) used to hit an assertion in a debug build and leave a
 *  partial change in a release build. Now the first argument of change_sp_owner is read by the
 *  same rule as ALTER: a package routine gives ER_SP_PKG_ROUTINE_NOT_ALLOWED, and <a>.<b> that
 *  matches both <user>.<routine> and <package>.<routine> (of the current user) gives
 *  ER_SP_AMBIGUOUS_NAME. A refused statement changes nothing in the catalog.
 *  ALTER PROCEDURE <user>.<pkg>.<routine> stays a syntax error, and the built-in dbms_output
 *  routines are package routines as well. Standalone routines are altered as before.
 *
 *  Coverage:
 *    Case 1: change_sp_owner of a package routine (full name and <pkg>.<routine>) is refused,
 *            the routine row and _db_auth are unchanged
 *    Case 2: change_sp_owner of an ambiguous <a>.<b> is refused, nothing changed
 *    Case 3: change_sp_owner of a built-in package routine is refused
 *    Case 4: change_sp_owner of a standalone routine works, the new owner shows in the catalog
 *    Case 5: ALTER PROCEDURE <pkg>.<routine> OWNER TO / COMMENT and dbms_output.<routine> are refused
 *    Case 6: ALTER PROCEDURE of an ambiguous <a>.<b> is refused
 *    Case 7: ALTER PROCEDURE <user>.<pkg>.<routine> is a syntax error, a missing <a>.<b> does not exist
 *    Case 8: ALTER PROCEDURE of a standalone routine works, the new owner and comment show,
 *            the package routine is unchanged and still runs
 */

--+ server-message on

drop table if exists t17_auth;
drop package if exists pk17;
drop package if exists u17amb;

create user u17b;
create user u17amb;
create package pk17 as procedure p; end;
create package body pk17 as procedure p as begin null; end; end;
create package u17amb as procedure q; end;
create package body u17amb as procedure q as begin null; end; end;
create or replace procedure u17amb.q as begin null; end;
create or replace procedure p17_sp1 as begin null; end;
create or replace procedure p17_sp2 as begin null; end;
grant execute on package pk17 to u17b;
create table t17_auth (n int);
insert into t17_auth select count(*) from _db_auth;


evaluate 'Case 1: change_sp_owner of a package routine is refused, expect dba.pk17.p/DBA and 1 (_db_auth unchanged)';
call change_sp_owner ('dba.pk17.p', 'u17b') on class db_root;
select unique_name || '/' || owner.name from _db_stored_procedure where sp_name = 'p' and pkg_of.unique_name = 'dba.pk17';
select count(*) as auth_unchanged from t17_auth where n = (select count(*) from _db_auth);
call change_sp_owner ('pk17.p', 'u17b') on class db_root;


evaluate 'Case 2: change_sp_owner of an ambiguous <a>.<b> is refused, expect 1';
call change_sp_owner ('u17amb.q', 'u17b') on class db_root;
select count(*) from _db_stored_procedure where sp_name = 'q' and owner.name = 'U17AMB';


evaluate 'Case 3: change_sp_owner of a built-in package routine is refused';
call change_sp_owner ('public.dbms_output.put_line', 'u17b') on class db_root;


evaluate 'Case 4: change_sp_owner of a standalone routine works, expect u17b.p17_sp2/U17B';
call change_sp_owner ('dba.p17_sp2', 'u17b') on class db_root;
select unique_name || '/' || owner.name from _db_stored_procedure where sp_name = 'p17_sp2';


evaluate 'Case 5: ALTER PROCEDURE <pkg>.<routine> OWNER TO / COMMENT and dbms_output.<routine> are refused';
alter procedure pk17.p owner to u17b;
alter procedure pk17.p comment 'x';
alter procedure dbms_output.put_line owner to u17b;


evaluate 'Case 6: ALTER PROCEDURE of an ambiguous <a>.<b> is refused';
alter procedure u17amb.q comment 'x';


evaluate 'Case 7: ALTER PROCEDURE <user>.<pkg>.<routine> is a syntax error, a missing <a>.<b> does not exist';
alter procedure dba.pk17.p owner to u17b;
alter procedure u17nouser.nop comment 'x';


evaluate 'Case 8: ALTER PROCEDURE of a standalone routine works, expect u17b.p17_sp1/U17B/c1, dba.pk17.p/DBA';
alter procedure p17_sp1 comment 'c1';
alter procedure dba.p17_sp1 owner to u17b;
select unique_name || '/' || owner.name || '/' || comment from _db_stored_procedure where sp_name = 'p17_sp1';
select unique_name || '/' || owner.name from _db_stored_procedure where sp_name = 'p' and pkg_of.unique_name = 'dba.pk17';
create or replace procedure p17_callp as begin pk17.p(); end;
call p17_callp();


drop procedure p17_callp;
drop procedure u17b.p17_sp1, u17b.p17_sp2, u17amb.q;
drop package pk17;
drop package u17amb;
drop table t17_auth;
drop user u17b;
drop user u17amb;

--+ server-message off
