--+ server-message on

-- error: arguments type

create or replace procedure t(i int) as
    procedure poo(i int) as
    begin
        null;
    end;
begin
    poo(true);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

--+ server-message off
