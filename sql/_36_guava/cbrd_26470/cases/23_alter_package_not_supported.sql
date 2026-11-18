/**
 *  This test case verifies CBRD-26470: ALTER PACKAGE fails with ER_INTERFACE_NOT_SUPPORTED_OPERATION.
 *
 *  An earlier revision of the PR added a new semantic message ("ALTER PACKAGE is not supported
 *  yet.") checked in pt_check_alter_package (). It was reverted: the semantic check is gone and
 *  jsp_alter_package () fails with "The operation is not supported." for every form of
 *  ALTER PACKAGE (COMMENT, OWNER TO, COMPILE), also for a package that does not exist.
 *  The catalog is left as it was and the package keeps working.
 *
 *  Coverage:
 *    Case 1: ALTER PACKAGE COMMENT / OWNER TO / OWNER TO .. COMMENT / COMPILE fail with
 *            "The operation is not supported."
 *    Case 2: the same error for a nonexistent package and for dbms_output
 *    Case 3: owner and comment of the package unchanged, nothing created for the nonexistent one
 *    Case 4: the package routine is still callable (through a PL/CSQL wrapper)
 */

--+ server-message on

drop package if exists pk23;
create user u23;
create package pk23 as procedure p; end;
create package body pk23 as procedure p as begin null; end; end;


evaluate 'Case 1: every form of ALTER PACKAGE fails with: The operation is not supported.';
alter package pk23 comment 'x';
alter package pk23 owner to u23;
alter package pk23 owner to u23 comment 'x';
alter package pk23 compile;


evaluate 'Case 2: nonexistent package and dbms_output give the same error';
alter package no_such_pk23 comment 'x';
alter package dbms_output comment 'x';


evaluate 'Case 3: owner DBA and comment NULL unchanged, no package no_such_pk23';
select owner.name, nvl(comment, 'NULL') from _db_package where unique_name = 'dba.pk23';
select count(*) from _db_package where unique_name = 'dba.no_such_pk23';


evaluate 'Case 4: pk23.p is still callable through a wrapper';
create or replace procedure w23 as begin pk23.p(); end;
call w23();

drop procedure w23;
drop package pk23;
drop user u23;

--+ server-message off
