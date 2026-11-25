/**
 *  This test case verifies CBRD-26470: DROP USER is refused for the owner of a body-only package.
 *
 *  A package body can be created without its spec. Such a package only has a row in
 *  _db_package_code. Before the fix that table had no owner column, so the owned-object check of
 *  DROP USER did not see it: DROP USER succeeded and the body row was left without an owner.
 *  The fix adds an owner column to _db_package_code, set when the row is created (whether the
 *  spec or the body comes first), and DROP USER checks that table too.
 *
 *  Coverage:
 *    Case 1: a body-only package has an owner, and DROP USER of its owner is refused
 *    Case 2: users whose names look like the name of the owner (prefix, underscore) are not blocked
 *    Case 3: mixed case user name
 *    Case 4: spec then body: owner set, DROP USER refused as before
 *    Case 5: body then spec created by DBA for another user: the owner is that user
 *    Case 6: after dropping the bodies and packages, DROP USER works and no rows are left
 */

--+ server-message on

call login('dba','') on class db_user;
create user ua21;
create user ua211;
create user ua_21;
create user MiXed21;
create user ub21;


evaluate 'Case 1: body-only package of ua21 has owner UA21, DROP USER ua21 is refused';
call login('ua21','') on class db_user;
create package body pk21 as procedure p as begin null; end; end;
call login('dba','') on class db_user;
select count(*) from _db_package_code where pkg_unique_name = 'ua21.pk21' and pkg_of is null;
select owner.name from _db_package_code where pkg_unique_name = 'ua21.pk21';
drop user ua21;
select count(*) from db_user where name = 'UA21';


evaluate 'Case 2: DROP USER ua211 (name has the owner as a prefix) and ua_21 (_ is not a wildcard) work';
drop user ua211;
drop user ua_21;
select count(*) from db_user where name in ('UA211', 'UA_21');


evaluate 'Case 3: body-only package of MiXed21 has owner MIXED21, DROP USER MiXed21 is refused';
call login('mixed21','') on class db_user;
create package body pk21 as procedure p as begin null; end; end;
call login('dba','') on class db_user;
select owner.name from _db_package_code where pkg_unique_name = 'mixed21.pk21';
drop user MiXed21;


evaluate 'Case 4: spec then body of ub21.pk21 has owner UB21, DROP USER ub21 is refused';
call login('ub21','') on class db_user;
create package pk21 as procedure p; end;
create package body pk21 as procedure p as begin null; end; end;
call login('dba','') on class db_user;
select owner.name from _db_package_code where pkg_unique_name = 'ub21.pk21';
drop user ub21;


evaluate 'Case 5: DBA creates the body then the spec of ub21.pk21b, the row has owner UB21 and pkg_of ub21.pk21b';
create package body ub21.pk21b as procedure p as begin null; end; end;
create package ub21.pk21b as procedure p; end;
select owner.name || '/' || nvl(pkg_of.unique_name, '-') from _db_package_code where pkg_unique_name = 'ub21.pk21b';


evaluate 'Case 6: after dropping the bodies and packages, DROP USER works and no rows are left';
call login('ua21','') on class db_user;
drop package body pk21;
call login('dba','') on class db_user;
drop user ua21;
call login('mixed21','') on class db_user;
drop package body pk21;
call login('dba','') on class db_user;
drop user MiXed21;
call login('ub21','') on class db_user;
drop package pk21;
drop package pk21b;
call login('dba','') on class db_user;
drop user ub21;
select count(*) from _db_package_code where pkg_unique_name in ('ua21.pk21', 'mixed21.pk21', 'ub21.pk21', 'ub21.pk21b');
select count(*) from db_user where name in ('UA21', 'MIXED21', 'UB21');

--+ server-message off
