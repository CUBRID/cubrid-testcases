--+ server-message on

-- error: arguments length

create or replace procedure poo(i int) as
begin
    null;
end;

create or replace procedure t(i int) as
begin
    poo();
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

drop procedure poo;

--+ server-message off
