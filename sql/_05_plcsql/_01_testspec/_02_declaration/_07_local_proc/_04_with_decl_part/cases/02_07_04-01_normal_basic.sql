--+ server-message on

-- normal: local procedure with a declaration in its declaration part


create or replace procedure t(i int) as
    procedure poo as
        j int := i;
    begin
        dbms_output.put_line('i=' || i);
    end;
begin
    poo;
    dbms_output.put_line('OK');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

