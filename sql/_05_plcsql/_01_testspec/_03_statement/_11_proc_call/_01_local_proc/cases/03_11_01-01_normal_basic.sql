--+ server-message on

-- normal: basic usage of a local procedure call


create or replace procedure t(i int) as
    procedure poo as
    begin
        dbms_output.put_line('poo');
    end;
begin
    poo;
    poo();
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
