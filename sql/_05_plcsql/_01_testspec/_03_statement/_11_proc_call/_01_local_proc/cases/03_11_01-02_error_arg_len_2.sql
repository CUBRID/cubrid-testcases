--+ server-message on

-- error: arguments length

create or replace procedure t(i int) as
    procedure poo(i int) as
    begin
        null;
    end;
begin
    poo(7, 77);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
