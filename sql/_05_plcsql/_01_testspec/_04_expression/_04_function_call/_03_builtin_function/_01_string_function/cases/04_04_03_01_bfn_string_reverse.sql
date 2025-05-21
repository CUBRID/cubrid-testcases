--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(REVERSE(NULL)); -- parse error NULL
    dbms_output.put_line(REVERSE(''));
    dbms_output.put_line(REVERSE('CUBRID'));
    dbms_output.put_line(REVERSE('큐브리드')); -- multibyte korean result error about dbms_output
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
