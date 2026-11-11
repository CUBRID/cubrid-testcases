/**
 *  This test case verifies CBRD-26470 (PR #7936): a package routine cannot be the target of
 *  GRANT / REVOKE EXECUTE ON PROCEDURE.
 *
 *  The EXECUTE right on a package routine is managed only per package (ON PACKAGE). Before the
 *  fix, dbms_output.put_line was mapped to public.dbms_output.put_line and granted / revoked
 *  alone, and pkg.p was read only as routine p of user pkg ("does not exist"). Now the name is
 *  read by the same rule as ALTER and change_sp_owner (jsp_find_standalone_routine): a package
 *  routine gives ER_SP_PKG_ROUTINE_NOT_ALLOWED, and <a>.<b> that matches both <user>.<routine>
 *  and <package>.<routine> gives ER_SP_AMBIGUOUS_NAME. A refused statement leaves _db_auth as it was.
 *
 *  Coverage (Case 1 for GRANT, Case 2 for REVOKE):
 *    dbms_output.<routine> is refused, public.dbms_output does not exist, <pkg>.<routine> is
 *    refused, ambiguous <a>.<b> is refused, a list with a package routine is refused,
 *    <user>.<pkg>.<routine> is a syntax error, a missing routine does not exist,
 *    and _db_auth is unchanged (expect 1)
 *    Case 3: GRANT / REVOKE of a standalone routine and of a package work as before
 *            (expect 2 and 1 grants recorded, then _db_auth back to the start: 1)
 */

--+ server-message on

drop table if exists t19_auth;
drop package if exists pk19;
drop package if exists u19amb;

create user u19b;
create user u19amb;
create package pk19 as procedure p; end;
create package body pk19 as procedure p as begin null; end; end;
create package u19amb as procedure q; end;
create package body u19amb as procedure q as begin null; end; end;
create or replace procedure u19amb.q as begin null; end;
create or replace procedure p19_sp1 as begin null; end;
create table t19_auth (n int);
insert into t19_auth select count(*) from _db_auth;


evaluate 'Case 1: GRANT ON PROCEDURE of package routines is refused, _db_auth unchanged (expect 1)';
grant execute on procedure dbms_output.put_line to u19b;
grant execute on procedure public.dbms_output to u19b;
grant execute on procedure pk19.p to u19b;
grant execute on procedure u19amb.q to u19b;
grant execute on procedure p19_sp1, pk19.p to u19b;
grant execute on procedure dba.pk19.p to u19b;
grant execute on procedure u19nouser.nop to u19b;
select count(*) as auth_unchanged from t19_auth where n = (select count(*) from _db_auth);


evaluate 'Case 2: REVOKE ON PROCEDURE of package routines is refused, _db_auth unchanged (expect 1)';
revoke execute on procedure dbms_output.put_line from u19b;
revoke execute on procedure public.dbms_output from u19b;
revoke execute on procedure pk19.p from u19b;
revoke execute on procedure u19amb.q from u19b;
revoke execute on procedure p19_sp1, pk19.p from u19b;
revoke execute on procedure dba.pk19.p from u19b;
revoke execute on procedure u19nouser.nop from u19b;
select count(*) as auth_unchanged from t19_auth where n = (select count(*) from _db_auth);


evaluate 'Case 3: GRANT / REVOKE of a standalone routine and of a package work as before, expect 2, 1, 1';
grant execute on procedure p19_sp1 to u19b;
grant execute on procedure dba.p19_sp1 to u19amb;
select count(*) from _db_auth a, _db_stored_procedure s where a.object_of = s and s.unique_name = 'dba.p19_sp1';
revoke execute on procedure p19_sp1 from u19b;
revoke execute on procedure dba.p19_sp1 from u19amb;
grant execute on package pk19 to u19b;
select count(*) from _db_auth a, _db_package k where a.object_of = k and k.unique_name = 'dba.pk19';
revoke execute on package pk19 from u19b;
select count(*) as auth_back from t19_auth where n = (select count(*) from _db_auth);


drop procedure p19_sp1, u19amb.q;
drop package pk19;
drop package u19amb;
drop table t19_auth;
drop user u19b;
drop user u19amb;

--+ server-message off
