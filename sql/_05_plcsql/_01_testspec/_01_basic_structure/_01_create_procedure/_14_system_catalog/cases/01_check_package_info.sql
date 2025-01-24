--+ server-message on
-- verified for CBRD-25077

-- check the default procedure
select sp_name, pkg_name, is_system_generated from _db_stored_procedure order by sp_name;

-- drop test
-- ERROR: Dropping system generated stored procedure is not allowed.
drop procedure DBMS_OUTPUT.disable;
drop procedure DBMS_OUTPUT.enable;
drop procedure DBMS_OUTPUT.get_line;
drop procedure DBMS_OUTPUT.get_lines;
drop procedure DBMS_OUTPUT.new_line;
drop procedure DBMS_OUTPUT.put;
drop procedure DBMS_OUTPUT.put_line;

drop function DBMS_OUTPUT.disable;
drop function DBMS_OUTPUT.enable;
drop function DBMS_OUTPUT.get_line;
drop function DBMS_OUTPUT.get_lines;
drop function DBMS_OUTPUT.new_line;
drop function DBMS_OUTPUT.put;
drop function DBMS_OUTPUT.put_line;



create or replace procedure test_proc1() as
begin
    dbms_output.put_line('no parameter');
end;

call test_proc1();
select sp_name, pkg_name, is_system_generated from _db_stored_procedure where is_system_generated=0 order by sp_name;
-- no result, because test_proc1 does not need parameter
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_of;


create or replace procedure test_proc2(a int) as
begin
    dbms_output.put_line('param: ' || a);
end;

call test_proc2(99);
select sp_name, pkg_name, is_system_generated from _db_stored_procedure where is_system_generated=0 order by sp_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_of;


-- will be fix CBRD-25472
create or replace procedure test_proc3(a int := 1 comment 'param comment') as
begin
    dbms_output.put_line('param: ' || a);
end
comment 'procedure comment';

call test_proc3();
select sp_name, pkg_name, is_system_generated, comment from _db_stored_procedure where is_system_generated=0 order by sp_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_of, default_value, is_optional, comment;


drop procedure test_proc1;
drop procedure test_proc2;
drop procedure test_proc3;

-- check to drop
select sp_name, pkg_name, is_system_generated, comment from _db_stored_procedure where is_system_generated=0 order by sp_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_of;



--+ server-message off
