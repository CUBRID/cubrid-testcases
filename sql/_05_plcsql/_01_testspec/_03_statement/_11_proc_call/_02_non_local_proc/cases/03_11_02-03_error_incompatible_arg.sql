--+ server-message on

-- error: arguments type

create or replace procedure poo(i int) as
begin
    null;
end;

create or replace procedure t(i int) as
begin
    poo(true);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

drop procedure poo;
