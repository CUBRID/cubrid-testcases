/**
 *  This test case verifies CBRD-26470 (PR #7936 review C9, C10 and C13): the results of the views
 *  db_stored_procedure, information_schema.routines and db_stored_procedure_args.
 *
 *  Background:
 *    - C9/C10: the join [sp].[code] = [sp_code] on OID made a full scan of
 *      _db_stored_procedure_code. The join is removed, and the source is read through the path
 *      expression [sp].[code].[scode].
 *    - C13: the CAST of pkg_name to VARCHAR(255) is not needed (the column is VARCHAR(255)) and
 *      is removed from both views.
 *    - The results stay the same: the source of a standalone PL/CSQL routine is shown only to DBA
 *      and to the owner, and is NULL for a user who has only the EXECUTE right. The code of a
 *      package routine is NULL.
 *  u22a owns the procedure sp22 and the package pk22 with the procedure p22, and grants EXECUTE on
 *  both to u22b. u22c has no right. The cases check the results only: that the views no longer
 *  scan _db_stored_procedure_code is a property of the plan, which an answer file does not fix.
 *
 *  Coverage:
 *    Case 1:  db_stored_procedure, DBA sees the source of sp22
 *    Case 2:  db_stored_procedure, the owner sees the source of sp22
 *    Case 3:  db_stored_procedure, the grantee sees the row of sp22 with no source
 *    Case 4:  db_stored_procedure, a user without a right does not see the row of sp22
 *    Case 5:  db_stored_procedure, the package routine p22 has no source and its pkg_name is pk22,
 *             and the standalone sp22 has no pkg_name
 *    Case 6:  db_stored_procedure, the system routine put_line is hidden
 *    Case 7:  information_schema.routines, DBA sees the definition of sp22
 *    Case 8:  information_schema.routines, the owner sees the definition of sp22
 *    Case 9:  information_schema.routines, the grantee gets no definition of sp22
 *    Case 10: information_schema.routines, the package routine p22 has no definition
 *    Case 11: db_stored_procedure_args, the argument of p22 has pkg_name pk22
 *    Case 12: pkg_name of db_stored_procedure and db_stored_procedure_args is VARCHAR(255)
 */

create user u22a;
create user u22b;
create user u22c;

call login('u22a', '') on class db_user;
create procedure sp22 as begin null; end;
create package pk22 as procedure p22(a int); end;
create package body pk22 as procedure p22(a int) as begin null; end; end;
grant execute on procedure sp22 to u22b;
grant execute on package pk22 to u22b;
call login('dba', '') on class db_user;


evaluate 'Case 1: db_stored_procedure, DBA sees the source of sp22';
select sp_name, owner, code from db_stored_procedure where sp_name = 'sp22';


evaluate 'Case 2: db_stored_procedure, the owner sees the source of sp22';
call login('u22a', '') on class db_user;
select sp_name, owner, code from db_stored_procedure where sp_name = 'sp22';


evaluate 'Case 3: db_stored_procedure, the grantee sees the row of sp22; result = code NULL';
call login('u22b', '') on class db_user;
select count(*) from db_stored_procedure where sp_name = 'sp22';
select sp_name, owner, code from db_stored_procedure where sp_name = 'sp22';


evaluate 'Case 4: db_stored_procedure, a user without a right does not see sp22; result = 0';
call login('u22c', '') on class db_user;
select count(*) from db_stored_procedure where sp_name = 'sp22';


evaluate 'Case 5: db_stored_procedure, p22 has no source and pkg_name pk22, sp22 has no pkg_name';
call login('dba', '') on class db_user;
select sp_name, pkg_name, code from db_stored_procedure where sp_name in ('sp22', 'p22') order by sp_name;


evaluate 'Case 6: db_stored_procedure, the system routine put_line is hidden; result = 0';
select count(*) from db_stored_procedure where sp_name = 'put_line';


evaluate 'Case 7: information_schema.routines, DBA sees the definition of sp22';
select routine_name, routine_definition from information_schema.routines where routine_name = 'sp22';


evaluate 'Case 8: information_schema.routines, the owner sees the definition of sp22';
call login('u22a', '') on class db_user;
select routine_name, routine_definition from information_schema.routines where routine_name = 'sp22';


evaluate 'Case 9: information_schema.routines, the grantee gets no definition of sp22; result = NULL';
call login('u22b', '') on class db_user;
select routine_name, routine_definition from information_schema.routines where routine_name = 'sp22';


evaluate 'Case 10: information_schema.routines, the package routine p22 has no definition; result = NULL';
call login('dba', '') on class db_user;
select routine_name, routine_definition from information_schema.routines where routine_name = 'p22';


evaluate 'Case 11: db_stored_procedure_args, the argument of p22 has pkg_name pk22';
select sp_name, pkg_name, arg_name from db_stored_procedure_args where sp_name = 'p22';


evaluate 'Case 12: pkg_name of db_stored_procedure and db_stored_procedure_args is VARCHAR(255)';
select class_name, attr_name, data_type, prec from db_attribute where class_name in ('db_stored_procedure', 'db_stored_procedure_args') and attr_name = 'pkg_name' order by class_name;


drop procedure u22a.sp22;
drop package u22a.pk22;
drop user u22a;
drop user u22b;
drop user u22c;
