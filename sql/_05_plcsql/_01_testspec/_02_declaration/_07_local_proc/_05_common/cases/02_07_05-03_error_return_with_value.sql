--+ server-message on

-- error: local procedure returns with a value

create or replace procedure t(i int) as
    procedure poo as
    begin
        return null;
    end;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

