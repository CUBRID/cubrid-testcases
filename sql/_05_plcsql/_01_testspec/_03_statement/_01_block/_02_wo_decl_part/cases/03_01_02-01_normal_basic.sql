--+ server-message on

-- normal: no declaration part in a block statement


create or replace procedure t(i int) as
begin
    begin
        dbms_output.put_line('outer i=' || i);
    end;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

