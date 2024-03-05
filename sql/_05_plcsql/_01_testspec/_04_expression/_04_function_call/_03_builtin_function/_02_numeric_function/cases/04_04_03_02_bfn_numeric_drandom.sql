--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(case isnull(DRANDOM()) when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(case isnull(DRANDOM(1)) when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(case isnull(DRANDOM(1.4)) when 0 then 'ok' when 1 then 'nok' end);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
