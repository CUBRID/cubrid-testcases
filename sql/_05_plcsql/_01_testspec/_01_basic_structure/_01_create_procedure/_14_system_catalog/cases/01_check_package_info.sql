/**
 *  This test case verifies CBRD-25077: the catalog rows of the system generated package
 *  dbms_output and of user stored procedures in _db_stored_procedure and
 *  _db_stored_procedure_args. Revised for CBRD-26470, which moved the package of a routine to
 *  the pkg_of column.
 *
 *  Coverage:
 *    Case 1: the system generated dbms_output routines are listed with their package
 *    Case 2: DROP PROCEDURE of a dbms_output routine is refused
 *    Case 3: DROP FUNCTION of a dbms_output routine is refused
 *    Case 4: a procedure without parameters has a routine row and no argument row
 *    Case 5: a procedure with one parameter has a routine row and an argument row
 *    Case 6: the comments of a procedure and of its parameter with a default value are stored
 *            (CBRD-25472)
 *    Case 7: after the drops, no user routine row and no argument row is left
 */

--+ server-message on

evaluate 'Case 1: the system generated dbms_output routines and their package';
select sp_name, pkg_of.pkg_name as pkg_name, is_system_generated from _db_stored_procedure order by unique_name;

evaluate 'Case 2: DROP PROCEDURE of a dbms_output routine is refused; result = an error for each';
drop procedure DBMS_OUTPUT.disable;
drop procedure DBMS_OUTPUT.enable;
drop procedure DBMS_OUTPUT.get_line;
drop procedure DBMS_OUTPUT.get_lines;
drop procedure DBMS_OUTPUT.new_line;
drop procedure DBMS_OUTPUT.put;
drop procedure DBMS_OUTPUT.put_line;

evaluate 'Case 3: DROP FUNCTION of a dbms_output routine is refused; result = an error for each';
drop function DBMS_OUTPUT.disable;
drop function DBMS_OUTPUT.enable;
drop function DBMS_OUTPUT.get_line;
drop function DBMS_OUTPUT.get_lines;
drop function DBMS_OUTPUT.new_line;
drop function DBMS_OUTPUT.put;
drop function DBMS_OUTPUT.put_line;


evaluate 'Case 4: a procedure without parameters; result = one routine row and no argument row';
create or replace procedure test_proc1() as
begin
    dbms_output.put_line('no parameter');
end;

call test_proc1();
select sp_name, pkg_of.pkg_name as pkg_name, is_system_generated from _db_stored_procedure where is_system_generated=0 order by unique_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_of.unique_name;


evaluate 'Case 5: a procedure with one parameter; result = two routine rows and one argument row';
create or replace procedure test_proc2(a int) as
begin
    dbms_output.put_line('param: ' || a);
end;

call test_proc2(99);
select sp_name, pkg_of.pkg_name as pkg_name, is_system_generated from _db_stored_procedure where is_system_generated=0 order by unique_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_of.unique_name;


evaluate 'Case 6: the comments of a procedure and of its parameter with a default value (CBRD-25472)';
create or replace procedure test_proc3(a int := 1 comment 'param comment') as
begin
    dbms_output.put_line('param: ' || a);
end
comment 'procedure comment';

call test_proc3();
select sp_name, pkg_of.pkg_name as pkg_name, is_system_generated, comment from _db_stored_procedure where is_system_generated=0 order by unique_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_of.unique_name, arg_name, default_value, is_optional, comment;


evaluate 'Case 7: after the drops no user routine row and no argument row is left';
drop procedure test_proc1;
drop procedure test_proc2;
drop procedure test_proc3;

select sp_name, pkg_of.pkg_name as pkg_name, is_system_generated, comment from _db_stored_procedure where is_system_generated=0 order by unique_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_of.unique_name;



--+ server-message off
