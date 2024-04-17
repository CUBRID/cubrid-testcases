--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TIME_FORMAT('2011-1-1 13:45:59', '%h%:%i%:%s%:%p'));
    dbms_output.put_line(TIME_FORMAT('2011-3-1 13:45:59', '%T'));
    dbms_output.put_line(TIME_FORMAT('2011-2-1 13:45:59', '%h %i %S'));
    dbms_output.put_line(TIME_FORMAT('2011-2-1 13:5:59.279', '%l %I %s'));
    dbms_output.put_line(TIME_FORMAT('2011-3-1 23:45:59', '%k %I'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
