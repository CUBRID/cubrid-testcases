/**
 *  This test case verifies CBRD-26470: a package body created without its spec is checked for
 *  syntax errors, and a body with a syntax error is refused and leaves no row.
 *
 *  A package body can be created before its spec. Until the spec is created, the body is kept only
 *  as a row of _db_package_code and is compiled together with the spec later. Its syntax is
 *  checked when the body is created, so a body that does not parse fails with a package compile
 *  error.
 *
 *  Coverage:
 *    Case 1: a body without its spec and without errors is created, with one row in _db_package_code
 *    Case 2: a body without its spec and with a syntax error fails, and leaves no row in
 *            _db_package_code and in _db_package
 *    Case 3: CREATE OR REPLACE of the body of Case 1 with a syntax error fails, and the old body
 *            stays as it was
 *    Case 4: after the failure of Case 2, the spec and a correct body of that package are created
 */

--+ server-message on

evaluate 'Case 1: a body without its spec and without errors is created; result = 1';
create package body pk92a as procedure p as begin null; end; end;
select count(*) from _db_package_code where pkg_unique_name = 'dba.pk92a';


evaluate 'Case 2: a body without its spec and with a syntax error fails; result = 0, 0';
create package body pk92b as procedure p as begin null end; end;
select count(*) from _db_package_code where pkg_unique_name = 'dba.pk92b';
select count(*) from _db_package where unique_name = 'dba.pk92b';


evaluate 'Case 3: CREATE OR REPLACE of the body of Case 1 with a syntax error fails, the old body stays';
create or replace package body pk92a as procedure p as begin null end; end;
select pkg_unique_name, scode_spec, scode_body from _db_package_code where pkg_unique_name = 'dba.pk92a';


evaluate 'Case 4: the spec and a correct body of pk92b are created after the failure; result = 1, 1';
create package pk92b as procedure p; end;
create package body pk92b as procedure p as begin null; end; end;
select count(*) from _db_package where unique_name = 'dba.pk92b';
select count(*) from _db_package_code where pkg_unique_name = 'dba.pk92b';


drop package body pk92a;
drop package pk92b;

--+ server-message off
