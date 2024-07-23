--+ server-message on
-- verified for CBRD-25077

-- check the default procedure
select sp_name, pkg_name, is_system_generated from _db_stored_procedure order by sp_name;

-- drop test
-- ERROR: Dropping system generated stored procedure is not allowed.
drop procedure disable;
drop procedure enable;
drop procedure get_line;
drop procedure get_lines;
drop procedure new_line;
drop procedure put;
drop procedure put_line;

drop function disable;
drop function enable;
drop function get_line;
drop function get_lines;
drop function new_line;
drop function put;
drop function put_line;



create or replace procedure test_proc1() as
begin
    dbms_output.put_line('no parameter');
end;

call test_proc1();
select sp_name, pkg_name, is_system_generated from _db_stored_procedure where is_system_generated=0 order by sp_name;
-- no result, because test_proc1 does not need parameter
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_name;


create or replace procedure test_proc2(a int) as
begin
    dbms_output.put_line('param: ' || a);
end;

call test_proc2(99);
select sp_name, pkg_name, is_system_generated from _db_stored_procedure where is_system_generated=0 order by sp_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_name;


-- will be fix CBRD-25472
create or replace procedure test_proc3(a int := 1 comment 'param comment') as
begin
    dbms_output.put_line('param: ' || a);
end
comment 'procedure comment';

call test_proc3();
select sp_name, pkg_name, is_system_generated, comment from _db_stored_procedure where is_system_generated=0 order by sp_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_name;


drop procedure test_proc1;
drop procedure test_proc2;
drop procedure test_proc3;

-- check to drop
select sp_name, pkg_name, is_system_generated, comment from _db_stored_procedure where is_system_generated=0 order by sp_name;
select * from _db_stored_procedure_args where is_system_generated=0 order by sp_name;



--+ server-message off