--+ server-message on

-- normal: variables can be declared in a block


create or replace procedure t(i int) as
begin
    declare
        j int := i - 1;
    begin
        dbms_output.put_line('j=' || j);
    end;

    dbms_output.put_line('i=' || i);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
