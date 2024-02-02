--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(MAKETIME(NULL, NULL, NULL));
    dbms_output.put_line(MAKETIME(NULL, NULL, 1));
    dbms_output.put_line(MAKETIME(NULL, 1, 1));
    dbms_output.put_line(MAKETIME(1, 1, 1));
    dbms_output.put_line(MAKETIME(1, NULL, 1));
    dbms_output.put_line(MAKETIME(1, 1, NULL));
    dbms_output.put_line(MAKETIME(23, 59, 59));
    dbms_output.put_line(MAKETIME('23', '59', '59'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
