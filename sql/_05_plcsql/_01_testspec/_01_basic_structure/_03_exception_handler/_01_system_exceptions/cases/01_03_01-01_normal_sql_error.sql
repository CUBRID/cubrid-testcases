--+ server-message on

-- normal: using system exceptions in when clauses


create or replace procedure t(i int) as
begin
    raise sql_error;
exception
when case_not_found then
    dbms_output.put_line('case_not_found');
    raise;
when cursor_already_open then
    dbms_output.put_line('cursor_already_open');
    raise;
when invalid_cursor then
    dbms_output.put_line('invalid_cursor');
    raise;
when no_data_found then
    dbms_output.put_line('no_data_found');
    raise;
when program_error then
    dbms_output.put_line('program_error');
    raise;
when storage_error then
    dbms_output.put_line('storage_error');
    raise;
when sql_error then
    dbms_output.put_line('sql_error');
    raise;
when too_many_rows then
    dbms_output.put_line('too_many_rows');
    raise;
when value_error then
    dbms_output.put_line('value_error');
    raise;
when zero_divide then
    dbms_output.put_line('zero_divide');
    raise;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off
