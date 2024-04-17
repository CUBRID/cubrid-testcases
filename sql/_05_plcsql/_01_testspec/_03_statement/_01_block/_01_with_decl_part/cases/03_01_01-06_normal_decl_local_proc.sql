--+ server-message on

-- normal: local procedure can be declared in a block


create or replace procedure t(i int) as
begin
    declare
        procedure poo as
        begin
            dbms_output.put_line('poo');
        end;
    begin
        poo;
    end;

    dbms_output.put_line('i=' || i);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
