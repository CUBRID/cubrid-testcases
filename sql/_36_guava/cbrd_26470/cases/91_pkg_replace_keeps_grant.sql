/**
 *  This test case verifies CBRD-26470 (PR #7819): CREATE OR REPLACE PACKAGE keeps the grants on the
 *  package, as CREATE OR REPLACE PROCEDURE/FUNCTION does since CBRD-27720.
 *
 *  The grants on a package refer to the OID of its _db_package row, so the replace overwrites that
 *  row in place and recreates only its other rows (the code row and the member routines).
 *
 *  Coverage:
 *    Case 1:  w91b () (EXECUTE granted to u91b) and w91c () (granted to the group g91 of u91c) run
 *    Case 2:  after a replace of the spec (f, and a new g) and then of the body, in that order as in
 *             a loaddb schema file, the grant rows of U91B and G91 are kept
 *    Case 3:  both grant rows refer to the current _db_package row
 *    Case 4:  the created_time of the package is kept
 *    Case 5:  the package has the 2 member routines of the new spec and 1 code row, no rows of the old spec
 *    Case 6:  w91b () and w91c () run the new code, and u91b can call the new member g
 *    Case 7:  a replace of the spec only, which keeps the body, keeps the grants
 *    Case 8:  a failed replace of the spec keeps the old package and the grants
 *    Case 9:  a replace after a revoke does not bring the grant back, and a new caller of u91b fails
 *             with EXECUTE authorization failure, while G91 keeps its grant
 *    Case 10: DROP PACKAGE and CREATE PACKAGE leave no grant rows
 */

--+ server-message on

drop table if exists t91_ct;

create user u91a;
create user u91b;
create user g91;
create user u91c groups g91;

call login('u91a', '') on class db_user;
create package pk91 as function f return int; end;
create package body pk91 as function f return int as begin return 1; end; end;
grant execute on package pk91 to u91b;
grant execute on package pk91 to g91;

call login('u91b', '') on class db_user;
create function w91b return int as begin return u91a.pk91.f (); end;
call login('u91c', '') on class db_user;
create function w91c return int as begin return u91a.pk91.f (); end;

-- Case 4 compares the created_time of the package with this copy taken before the replace
call login('dba', '') on class db_user;
create table t91_ct as select created_time from _db_package where unique_name = 'u91a.pk91';


evaluate 'Case 1: w91b () and w91c () run; result = 1, 1';
call login('u91b', '') on class db_user;
select w91b () from db_root;
call login('u91c', '') on class db_user;
select w91c () from db_root;


evaluate 'Case 2: replace the spec (f, g) and then the body, the grant rows are kept; result = G91 1, U91B 1';
call login('u91a', '') on class db_user;
create or replace package pk91 as function f return int; function g return int; end;
create or replace package body pk91 as
  function f return int as begin return 2; end;
  function g return int as begin return 20; end;
end;
call login('dba', '') on class db_user;
select grantee.name, count(*) from _db_auth where object_type = 6 and grantee.name in ('U91B', 'G91')
  group by grantee.name order by 1;


-- the package has no grants other than those of U91B and G91
evaluate 'Case 3: both grant rows refer to the current _db_package row; result = 2';
select count(*) from _db_auth a, _db_package p where a.object_of = p and p.unique_name = 'u91a.pk91';


evaluate 'Case 4: the created_time of the package is kept; result = 1';
select count(*) from _db_package p, t91_ct t where p.unique_name = 'u91a.pk91' and p.created_time = t.created_time;


evaluate 'Case 5: the member routines of the new spec and 1 code row; result = f g, 1';
select sp_name from _db_stored_procedure where pkg_of.unique_name = 'u91a.pk91' order by 1;
select count(*) from _db_package_code where pkg_unique_name = 'u91a.pk91';


evaluate 'Case 6: w91b () and w91c () run the new code, u91b calls g; result = 2, 20, 2';
call login('u91b', '') on class db_user;
select w91b () from db_root;
create function w91bg return int as begin return u91a.pk91.g (); end;
select w91bg () from db_root;
call login('u91c', '') on class db_user;
select w91c () from db_root;


-- Cases 7 to 9 replace the package as Case 2 left it
evaluate 'Case 7: replace the spec only, the grants are kept; result = G91 1, U91B 1, 2';
call login('u91a', '') on class db_user;
create or replace package pk91 as function f return int; function g return int; end;
call login('dba', '') on class db_user;
select grantee.name, count(*) from _db_auth where object_type = 6 and grantee.name in ('U91B', 'G91')
  group by grantee.name order by 1;
call login('u91b', '') on class db_user;
select w91b () from db_root;


evaluate 'Case 8: a replace of the spec with an unknown type fails to compile, the old package and the grants stay; result = G91 1, U91B 1, 2';
call login('u91a', '') on class db_user;
create or replace package pk91 as function f return no_such_type; function g return int; end;
call login('dba', '') on class db_user;
select grantee.name, count(*) from _db_auth where object_type = 6 and grantee.name in ('U91B', 'G91')
  group by grantee.name order by 1;
call login('u91b', '') on class db_user;
select w91b () from db_root;


evaluate 'Case 9: a replace after a revoke from u91b keeps only the grant of G91, a new caller of u91b fails with EXECUTE authorization failure; result = G91 1';
call login('u91a', '') on class db_user;
revoke execute on package pk91 from u91b;
create or replace package pk91 as function f return int; function g return int; end;
call login('dba', '') on class db_user;
select grantee.name, count(*) from _db_auth where object_type = 6 and grantee.name in ('U91B', 'G91')
  group by grantee.name order by 1;
call login('u91b', '') on class db_user;
create function w91b2 return int as begin return u91a.pk91.f (); end;


evaluate 'Case 10: DROP PACKAGE and CREATE PACKAGE leave no grant rows; result = 0';
call login('u91a', '') on class db_user;
drop package pk91;
create package pk91 as function f return int; end;
create package body pk91 as function f return int as begin return 3; end; end;
call login('dba', '') on class db_user;
select count(*) from _db_auth where object_type = 6 and grantee.name in ('U91B', 'G91');


call login('dba', '') on class db_user;
drop function u91b.w91b;
drop function u91b.w91bg;
drop function u91c.w91c;
drop package u91a.pk91;
drop table t91_ct;
drop user u91c;
drop user g91;
drop user u91b;
drop user u91a;

--+ server-message off
