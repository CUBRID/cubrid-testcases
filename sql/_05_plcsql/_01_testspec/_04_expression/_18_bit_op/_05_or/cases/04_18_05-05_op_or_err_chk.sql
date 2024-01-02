--+ server-message on

-- error caused usage of operator '|'

create or replace procedure t () as
begin
    dbms_output.put_line('''a'' | NULL');
    dbms_output.put_line('a' | NULL);

    dbms_output.put_line('NULL | ''a''');
    dbms_output.put_line(NULL | 'a');
    dbms_output.put_line('run ok without exception');
exception
    when VALUE_ERROR then
    dbms_output.put_line('VALUE_ERROR ouccers');
END;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
