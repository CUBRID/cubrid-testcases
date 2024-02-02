--+ server-message on

-- normal: no declaration part in a block statement


create or replace procedure t(i int) as
begin
    begin
        dbms_output.put_line('outer i=' || i);
    end;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
